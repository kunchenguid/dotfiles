# Capacity Planning

Capacity planning is the discipline of understanding how much load your system can handle, what breaks first, and how to scale before users experience degradation. It is not a one-time exercise -- it is a continuous practice that evolves as your system, traffic patterns, and infrastructure change.

## Performance Testing Taxonomy

Not all performance tests are equal. Each type answers a different question.

### Test Types

| Test Type | Question It Answers | Duration | Load Profile |
|-----------|-------------------|----------|-------------|
| **Load test** | Can the system handle expected peak traffic? | 30-60 minutes | Ramp to expected peak, hold steady |
| **Stress test** | Where does the system break? | Until failure | Ramp beyond expected peak until degradation or failure |
| **Soak test** | Does the system degrade over time? | 24-72 hours | Sustained load at 70-80% of capacity |
| **Spike test** | How does the system handle sudden bursts? | 15-30 minutes | Sudden jump from baseline to peak, then back |
| **Scalability test** | Does adding resources improve throughput linearly? | Variable | Measure throughput at different resource levels |

### Load Test Design

A good load test simulates real user behavior, not synthetic happy paths.

**Essential elements:**
- **Realistic user journeys:** Mix of browse, search, add to cart, checkout -- not just one endpoint
- **Think time:** Users do not fire requests as fast as possible; include realistic pauses between actions
- **Data variation:** Different users, different products, different search terms -- not the same request repeated
- **Ramp-up period:** Gradually increase load to avoid a cold-start stampede
- **Steady state period:** Hold at target load long enough to observe stabilization (minimum 15 minutes)
- **Ramp-down period:** Gradually decrease load to observe resource release

### Stress Test Design

The goal is to find the breaking point -- not to prove the system works under normal load.

**Key principles:**
- Increase load incrementally (e.g., 10% every 5 minutes) until you observe degradation
- Monitor all resources: CPU, memory, disk I/O, network, thread pools, connection pools, queue depths
- Record the exact load level when each metric crosses its threshold
- Document the failure mode: does the system degrade gracefully (latency increases, then errors) or fail catastrophically (crash, hang, data corruption)?
- Run the stress test multiple times to verify consistency

### Soak Test Design

Soak tests reveal problems that only manifest over time.

**What soak tests catch:**

| Problem | Mechanism | Detection |
|---------|-----------|-----------|
| **Memory leaks** | Gradual memory growth from unreleased objects | Memory usage trends upward over hours |
| **Connection leaks** | Connections borrowed from pool but never returned | Pool exhaustion after hours of operation |
| **File handle leaks** | Files opened but never closed | "Too many open files" errors after prolonged operation |
| **Log file growth** | Disk fills over extended operation | Disk utilization climbs throughout test |
| **Cache bloat** | Cache grows without eviction under sustained load | Memory or disk consumption increases monotonically |
| **Database bloat** | Temp tables, uncommitted transactions accumulate | Database performance degrades over test duration |

**Soak test requirements:**
- Run at 70-80% of measured capacity (not full stress -- you are testing endurance, not peak)
- Duration: minimum 24 hours, ideally 72 hours
- Monitor resource trends, not just snapshots -- a flat graph is healthy, a rising trend is a leak
- Compare start-of-test and end-of-test resource consumption

---

## Resource Pool Management

Resource pools -- thread pools, connection pools, object pools -- are finite and shared. Mismanaging them is one of the most common causes of production failures.

### Connection Pool Sizing

The most common question: "How many connections do I need?"

**Formula:**
```
pool_size = peak_concurrent_requests × avg_hold_time / avg_request_time
```

**But in practice:**
- Measure actual concurrent active connections under peak load
- Set pool size to measured p99 concurrency + 20-30% headroom
- Set a maximum that protects the downstream resource (databases have their own connection limits)
- Too many connections: each consumes memory on both client and server; database performance degrades with too many connections
- Too few connections: requests queue waiting for a connection; latency increases; pool exhaustion looks like a database outage

### Connection Pool Configuration

| Parameter | Purpose | Typical Value |
|-----------|---------|---------------|
| **Minimum pool size** | Connections maintained even when idle | 5-10 |
| **Maximum pool size** | Hard upper limit on connections | Based on measurement |
| **Checkout timeout** | How long to wait for a connection from the pool | 500ms - 2s |
| **Idle timeout** | How long an unused connection stays in the pool | 5-10 minutes |
| **Max lifetime** | Maximum age of a connection before forced recycling | 30-60 minutes |
| **Validation query** | Query to verify connection health before use | `SELECT 1` |
| **Validation interval** | How often idle connections are validated | 30-60 seconds |

### Connection Pool Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| **No checkout timeout** | Thread waits forever for a connection | Set checkout timeout to 1-2 seconds |
| **No max lifetime** | Stale connections cause intermittent errors | Recycle connections every 30-60 minutes |
| **Pool size = DB max connections** | Leaves no connections for admin, monitoring, or other services | Pool size = (DB max - reserved) / number of application instances |
| **Ignoring connection leaks** | Pool slowly drains until exhaustion | Monitor borrowed-vs-returned; log leaked connections |
| **Default pool size** | Either wastes resources or causes starvation | Size based on measured concurrency |

---

## Thread Pool Management

Thread pools control the concurrency of your application. Getting them right is critical for both throughput and stability.

### Thread Pool Sizing

**CPU-bound workloads:**
```
threads = number_of_cores
```

**I/O-bound workloads (most web applications):**
```
threads = number_of_cores × (1 + wait_time / service_time)
```

Example: 8 cores, requests spend 80% of time waiting on I/O:
```
threads = 8 × (1 + 80/20) = 8 × 5 = 40 threads
```

### Thread Pool Configuration

| Parameter | Purpose | Consideration |
|-----------|---------|---------------|
| **Core pool size** | Threads always kept alive | Handles normal load without thread creation overhead |
| **Maximum pool size** | Hard upper limit | Handles burst load; too high causes context-switching overhead |
| **Queue capacity** | Work queue between core and max | Bounded queue with rejection policy; never unbounded |
| **Keep-alive time** | How long excess threads survive when idle | 30-60 seconds; balances responsiveness and resource usage |
| **Rejection policy** | What happens when pool and queue are both full | Reject immediately (fail fast) or caller-runs (back-pressure) |

### Thread Pool Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| **Unbounded queue** | Memory grows until OOM; latency climbs invisibly | Use bounded queue; fail fast when full |
| **Single shared pool** | One slow operation starves all others | Separate pools per workload type |
| **Too many threads** | Context-switching overhead exceeds throughput gain | Measure throughput at different pool sizes; find the plateau |
| **No monitoring** | Thread starvation goes undetected until outage | Monitor active/idle/queued counts; alert on pool saturation |

---

## The Universal Scalability Law

The Universal Scalability Law (USL), developed by Neil Gunther, models how system throughput changes as you add resources (servers, threads, cores).

### The Model

```
C(N) = N / (1 + σ(N-1) + κN(N-1))
```

Where:
- **N** = number of processors/servers/threads
- **σ** (sigma) = contention parameter: fraction of work that must be serialized
- **κ** (kappa) = coherence parameter: cost of keeping shared state consistent
- **C(N)** = relative capacity at N resources

### Key Insights

| Parameter | Effect | Example |
|-----------|--------|---------|
| **σ = 0, κ = 0** | Linear scalability (ideal but impossible) | Adding 10 servers = 10x throughput |
| **σ > 0, κ = 0** | Amdahl's Law: diminishing returns | Shared lock limits parallelism |
| **σ > 0, κ > 0** | Retrograde scalability: adding resources decreases throughput | Distributed cache coherence overhead exceeds throughput gain |

### Practical Application

1. **Measure throughput** at 1, 2, 4, 8, 16 resources
2. **Fit the USL curve** to find σ and κ
3. **Predict the scalability ceiling:** the point where adding more resources stops helping (or hurts)
4. **Identify the bottleneck:** high σ means contention (locks, serialization); high κ means coherence costs (cache invalidation, distributed consensus)

---

## Capacity Modeling

A capacity model documents the relationship between load, resources, and performance for each service in your system.

### Capacity Model Template

For each service, document:

| Dimension | Current Value | Limit | Action at Limit |
|-----------|--------------|-------|-----------------|
| **Requests/sec** | 500 RPS | 2,000 RPS | Scale horizontally |
| **CPU** | 40% avg, 70% peak | 80% sustained | Add instances |
| **Memory** | 2.5 GB / 4 GB | 3.5 GB | Increase instance size or optimize |
| **DB connections** | 30 active / 50 max | 45 active | Increase pool or add read replicas |
| **Disk I/O** | 200 IOPS | 3,000 IOPS (provisioned) | Upgrade storage tier |
| **Network** | 500 Mbps | 10 Gbps | Unlikely bottleneck |

### Bottleneck Resource

Every service has a bottleneck resource -- the resource that runs out first as load increases. The capacity of the service equals the capacity of its bottleneck.

**Finding the bottleneck:**
1. Run a stress test, increasing load gradually
2. Monitor all resources simultaneously
3. The first resource to hit its limit is the bottleneck
4. All capacity planning focuses on this resource

**Common bottlenecks by service type:**

| Service Type | Typical Bottleneck |
|-------------|-------------------|
| API services | Thread pool or connection pool |
| Data-heavy services | Database connections or query throughput |
| Compute-heavy services | CPU |
| File processing | Disk I/O or memory |
| Real-time services | Network bandwidth or connection count |

---

## Capacity Myths

### Myth 1: "The Cloud Is Infinitely Scalable"

Reality:
- Auto-scaling has lag time (1-5 minutes to provision and start new instances)
- Cold starts add latency to the first requests on new instances
- Cloud providers have account-level limits (instance count, API rate limits)
- Some resources do not scale horizontally (relational databases, stateful services)
- Scaling costs money -- infinite scale means infinite cost

### Myth 2: "We'll Just Add More Servers"

Reality:
- Adding servers only helps if the bottleneck is CPU or memory on the application tier
- If the bottleneck is the database, adding application servers makes it worse (more connections, more load on the same database)
- Network hops, serialization overhead, and coordination costs increase with more servers
- Horizontal scaling requires stateless design -- session affinity, local caches, and local file storage break horizontal scaling

### Myth 3: "Our Load Tests Pass, So We're Fine"

Reality:
- Load tests with synthetic data miss hot spots in production data
- Load tests rarely simulate realistic user behavior (think times, session patterns, edge cases)
- Load test environments rarely match production topology, network latency, or data volume
- Load tests find throughput limits but not endurance problems (need soak tests)
- Passing a load test at 2x expected peak does not protect against 10x flash crowds

### Myth 4: "We Don't Need Capacity Planning -- We Have Auto-Scaling"

Reality:
- Auto-scaling reacts to load after it arrives; capacity planning anticipates load before it arrives
- Auto-scaling cannot protect against instant traffic spikes (Black Friday, viral events)
- Auto-scaling policies themselves need testing -- misconfigured policies can scale in the wrong direction or oscillate
- Cost management requires understanding baseline and peak capacity needs

---

## Performance Anti-Patterns

### Resource Contention

Multiple threads competing for the same resource (lock, connection, CPU core). Throughput plateaus or decreases as concurrency increases.

**Detection:** Throughput does not increase when adding threads/instances. CPU utilization is low despite high load. Thread dumps show threads waiting on locks.

**Fix:** Reduce lock scope. Use lock-free data structures. Partition data to reduce contention. Use read-write locks instead of exclusive locks.

### The Coordinated Omission Problem

Load testing tools that wait for a response before sending the next request undercount latency at high load. When the server slows down, the tool also slows down, making the measured throughput look stable while actually masking massive latency increases.

**Detection:** Load test shows consistent throughput even as the system degrades. Real users report much worse latency than load tests measure.

**Fix:** Use load testing tools that support coordinated omission correction (e.g., wrk2, Gatling with constant throughput mode). Measure latency independently of throughput. Use open-loop load generators that send requests at a fixed rate regardless of response time.

### N+1 Query Problem

Fetching a list of N items, then making one additional query for each item. Total queries = N + 1 instead of 1 or 2.

**Detection:** Database query count scales linearly with result set size. Response time increases linearly with page size.

**Fix:** Use eager loading / JOIN queries. Batch queries (`WHERE id IN (...)`). Implement DataLoader pattern for GraphQL.
