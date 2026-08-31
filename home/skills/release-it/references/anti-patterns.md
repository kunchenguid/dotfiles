# Stability Anti-Patterns

Production systems do not fail because of bugs found in unit tests. They fail because of emergent behaviors that arise when systems interact under real-world conditions -- load spikes, network partitions, slow dependencies, and data growth that exceeds every assumption made during development.

Michael Nygard identifies a recurring set of anti-patterns that cause the vast majority of production outages. Recognizing these patterns is the first step toward building resilient systems.

## 1. Integration Points: The Number-One Killer

Every integration point -- every socket connection, HTTP call, database query, message queue interaction, or third-party API call -- is a potential failure point. Integration points are the number-one killer of production systems because they introduce failure modes that do not exist in isolated testing.

### How Integration Points Fail

| Failure Mode | Description | Consequence |
|-------------|-------------|-------------|
| **Connection refused** | Remote host rejects the connection | Fast failure; relatively benign |
| **Connection timeout** | Remote host does not respond to SYN | Thread blocked for 30-120 seconds (OS default) |
| **Read timeout** | Connection established but response never arrives | Thread blocked indefinitely without explicit timeout |
| **Partial response** | Connection drops mid-response | Corrupted data; parser exceptions |
| **Slow response** | Response eventually arrives but takes minutes | Threads accumulate; pool exhaustion; cascading failure |
| **Protocol violation** | Remote returns unexpected content type or format | Unhandled exceptions; crash |

### Defense Strategy

Every integration point needs a defense-in-depth strategy:

1. **Timeouts** on every connection and read operation -- never use defaults
2. **Circuit breakers** to stop calling a failing dependency
3. **Bulkheads** to isolate the failure from other parts of the system
4. **Fallbacks** to degrade gracefully when the dependency is unavailable
5. **Monitoring** to detect degradation before users notice

### Real-World Example

A retail application calls an inventory service to check stock levels. The inventory service's database enters a long garbage collection pause. The inventory service stops responding but does not close connections. The retail application's thread pool fills with threads waiting for inventory responses. The retail application can no longer serve any requests -- including requests that do not need inventory data. The entire site goes down because one dependency slowed down.

**Root cause:** No read timeout on the inventory service call. No bulkhead isolating inventory calls from other request handling.

---

## 2. Cascading Failures

A cascading failure occurs when a failure in one system causes failures in the systems that depend on it, which in turn cause failures in the systems that depend on them, and so on. The defining characteristic of a cascading failure is that the damage spreads far beyond the original failure.

### Cascade Mechanics

```
Service A (database overloaded)
    → Service B (calls A, threads block waiting)
        → Service C (calls B, threads block waiting)
            → Service D (calls C, threads block waiting)
                → User-facing application (completely unresponsive)
```

### Why Cascading Failures Are Devastating

- The original failure may be minor (one database query slow)
- The cascade amplifies the failure geometrically
- Each layer adds more blocked threads, more resource consumption
- By the time the cascade is visible, every system in the chain is degraded
- Recovery requires coordinated action across all affected systems

### Breaking the Cascade

| Pattern | How It Breaks the Cascade |
|---------|--------------------------|
| **Circuit Breaker** | Stops calling the failing service; returns error immediately |
| **Timeout** | Limits how long a caller waits; frees threads to handle other work |
| **Bulkhead** | Isolates the failing dependency's impact to a limited set of resources |
| **Fallback** | Provides degraded but functional response when dependency fails |
| **Fail Fast** | Rejects requests immediately when system knows it cannot fulfill them |

### Prevention Checklist

- [ ] Every service-to-service call has a timeout
- [ ] Circuit breakers protect against sustained failures
- [ ] Failure in one dependency does not affect unrelated features
- [ ] Fallback behavior is defined for every critical dependency
- [ ] Cascading failure scenarios are included in chaos experiments

---

## 3. Users as a Source of Load

Users are not gentle with your system. They do not arrive in an orderly queue at predictable intervals. Real user behavior generates load patterns that are fundamentally different from what synthetic tests produce.

### Unexpected User Behaviors

| Behavior | Load Impact | Example |
|----------|------------|---------|
| **Refresh storms** | Multiplies load when pages are slow | Users hit F5 repeatedly when checkout is slow |
| **Bot traffic** | Can exceed human traffic by 10-100x | Scrapers, search engines, monitoring tools |
| **Flash crowds** | Sudden, massive traffic spikes | Hacker News front page, TV mention, viral tweet |
| **Abandoned sessions** | Resource consumption without completion | Users open carts, leave; sessions consume server memory |
| **Power users** | Disproportionate resource consumption | One user with 50,000 items in a list; API consumers with no rate limit |

### Defense Strategy

- Rate limiting per user, per IP, and per API key
- Session limits and timeouts to reclaim abandoned resources
- Bot detection and separate handling (different rate limits, caching strategies)
- Graceful degradation under load (serve cached content, disable non-essential features)
- Load shedding: deliberately reject some requests to preserve service for others

---

## 4. Blocked Threads

Blocked threads are the silent killer. Unlike a crash (which is loud and obvious), blocked threads produce no errors, no exceptions, and no log entries. The system simply stops processing requests.

### Common Causes of Blocked Threads

| Cause | How It Blocks | Detection |
|-------|--------------|-----------|
| **Missing timeouts** | Thread waits indefinitely for a response | Thread dump shows threads in WAITING/TIMED_WAITING |
| **Deadlocks** | Two threads each hold a lock the other needs | Thread dump shows circular lock dependencies |
| **Synchronized access** | All threads queue for a single lock | Throughput drops to single-threaded speed |
| **DNS resolution** | DNS lookup blocks the calling thread | Threads stuck in `InetAddress.getByName()` |
| **Log file I/O** | Synchronous logging blocks application threads | Threads stuck in file write; especially during disk pressure |

### Detection and Prevention

**Detection:**
- Thread dump analysis (scheduled periodic dumps, not just during incidents)
- Thread pool utilization metrics (active/idle/max)
- Request latency distribution (sudden latency spike = possible thread starvation)
- Health checks that verify thread pool availability

**Prevention:**
- Explicit timeouts on all blocking operations
- Asynchronous I/O where possible
- Bounded queues with rejection policies (not unbounded queues that grow forever)
- Thread pool sizing based on measured workload, not defaults

---

## 5. Self-Denial Attacks

A self-denial attack is when your own system, marketing, or business operations generate load that overwhelms your infrastructure. The irony is that these are "success disasters" -- everything is working as intended, but the system cannot handle its own success.

### Common Self-Denial Scenarios

| Scenario | Mechanism | Prevention |
|----------|-----------|------------|
| **Marketing email blast** | 500,000 emails sent simultaneously, 10% click through in 5 minutes | Stagger sends over hours; pre-scale infrastructure |
| **Coupon code launch** | Viral sharing of limited coupon creates stampede | Queue-based redemption; rate limit per user |
| **Product launch countdown** | Users refresh at exactly midnight | Serve static page at launch time; queue for access |
| **Social media viral moment** | CEO's tweet goes viral, floods landing page | CDN caching; static page fallback |
| **Cron job stampede** | Every server runs cleanup job at midnight | Randomize cron schedules; use distributed job scheduling |

### Defense Strategy

- Coordinate marketing events with engineering capacity planning
- Use CDN and static page caching for high-traffic landing pages
- Implement queue-based access for limited-resource events
- Stagger scheduled jobs with random jitter
- Pre-scale infrastructure before planned events

---

## 6. Scaling Effects

Patterns that work at small scale break at large scale. A design that performs well with 10 servers may collapse at 100 servers. Scaling effects are the emergent behaviors that appear only when the system grows.

### Examples of Scaling Effects

| Pattern | Works at Small Scale | Breaks at Large Scale |
|---------|---------------------|----------------------|
| **Point-to-point connections** | 5 services = 20 connections | 50 services = 2,450 connections |
| **Broadcast messages** | 10 subscribers = manageable | 1,000 subscribers = message storm |
| **Shared database** | 5 services share one DB | 50 services = connection pool exhaustion |
| **Health check polling** | Load balancer checks 5 servers | Load balancer checks 500 servers = significant traffic |
| **Distributed locks** | Low contention with few nodes | High contention with many nodes |

### Mitigation

- Replace point-to-point with message buses or service meshes
- Use fan-out patterns with controlled concurrency
- Give each service its own data store (or at minimum, its own connection pool limits)
- Use push-based health checks or sampling strategies at scale
- Avoid distributed locks; use optimistic concurrency or partitioning instead

---

## 7. Unbalanced Capacities

When upstream and downstream systems have different capacity limits, the faster system can overwhelm the slower one. This is particularly dangerous when a frontend tier can generate more requests than a backend tier can handle.

### Common Imbalances

- Web tier: 100 servers; backend API: 10 servers
- Batch job produces 10,000 records/sec; downstream consumer processes 500/sec
- Marketing campaign drives 10x normal traffic to a service scaled for 1x

### Defense Strategy

- Back-pressure: slow producers when consumers are overwhelmed
- Queue-based buffering between tiers with different throughput
- Rate limiting at the boundary between tiers
- Capacity modeling that considers the full request chain, not individual services in isolation
- Autoscaling policies that scale the entire chain, not just the entry point

---

## 8. Dogpile / Thundering Herd

A dogpile (also called thundering herd) occurs when many threads or processes simultaneously attempt the same expensive operation, typically after a cache expires or a service recovers.

### Common Dogpile Scenarios

| Scenario | Mechanism | Impact |
|----------|-----------|--------|
| **Cache expiration** | Popular cache key expires; 1,000 threads hit the database simultaneously | Database overwhelmed; slow response; more cache misses |
| **Service recovery** | Circuit breaker half-opens; all waiting requests flood the recovering service | Service fails again immediately |
| **Cron overlap** | Slow job still running when next execution triggers | Double resource consumption; data corruption |
| **Lock release** | Mutex released; all waiting threads resume simultaneously | Resource spike; possible re-contention |

### Prevention

- **Cache stampede prevention:** Use probabilistic early expiration, lock-based recomputation (only one thread refreshes), or serve stale + refresh in background
- **Circuit breaker recovery:** Half-open state allows only a small number of test requests through
- **Cron jobs:** Use distributed locks or leader election to ensure only one instance runs
- **Gradual ramp-up:** When recovering, slowly increase traffic rather than allowing full load immediately

---

## 9. Slow Responses (Worse Than No Response)

A fast failure is annoying. A slow failure is catastrophic. When a system responds slowly instead of failing fast, it creates a chain reaction of blocked resources throughout the calling stack.

### Why Slow Is Worse Than Down

| Fast Failure | Slow Failure |
|-------------|-------------|
| Circuit breaker trips immediately | Circuit breaker does not trip (still getting responses) |
| Thread released after milliseconds | Thread blocked for seconds or minutes |
| Error is visible and actionable | Problem is invisible until pool exhaustion |
| Users see error, retry once, move on | Users see spinner, refresh, multiply load |
| Affects one request | Blocks a thread, affecting all subsequent requests |

### Detection

- Monitor latency at p99 and p999, not just p50
- Alert on latency shifts, not just absolute thresholds
- Track thread pool utilization -- rising active threads with flat throughput indicates blocking
- Trace slow requests across service boundaries to find the bottleneck

### Prevention

- Set aggressive read timeouts (seconds, not minutes)
- Implement deadline propagation: if the user's request has 5 seconds left, do not start a 10-second operation
- Use asynchronous processing for long operations
- Implement load shedding: reject requests when response time exceeds SLO

---

## 10. Unbounded Result Sets

A query that returns 10 rows in development returns 10 million rows in production. Unbounded result sets are a time bomb that detonates when data grows beyond test assumptions.

### Common Manifestations

| Query Pattern | Development | Production |
|--------------|-------------|------------|
| `SELECT * FROM orders WHERE user_id = ?` | 3 orders | 50,000 orders (power user) |
| `SELECT * FROM events WHERE date > ?` | 100 events | 2 million events (6 months of data) |
| `SELECT * FROM logs` | 500 rows | Out of memory |
| API response with nested objects | Small JSON | 200MB JSON response |

### Prevention

- **Always paginate:** Every list query must have a `LIMIT` and `OFFSET` (or cursor-based pagination)
- **Cap result sizes:** Enforce maximum result count at the API layer, even if the caller does not request it
- **Stream large results:** Use cursors or streaming for batch operations rather than loading everything into memory
- **Monitor query performance:** Track query execution time and result set sizes in production
- **Test with production-scale data:** Use anonymized production data volumes in performance testing

### Rule of Thumb

If your code ever does `results = query.getAll()` without a limit, it is a production incident waiting to happen. Every query, every API response, every list operation must have an upper bound.
