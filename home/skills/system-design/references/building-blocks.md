# Building Blocks of Scalable Systems

The core components used to assemble distributed systems. Each block solves a specific problem; knowing when and why to introduce each one is the foundation of system design.

## DNS (Domain Name System)

### What It Does

Translates human-readable domain names (example.com) into IP addresses (93.184.216.34). It is the first step in every web request.

### Key Concepts

- **A record:** Maps domain to IPv4 address
- **AAAA record:** Maps domain to IPv6 address
- **CNAME record:** Maps domain to another domain (aliasing)
- **NS record:** Delegates a subdomain to a nameserver
- **TTL (Time to Live):** How long DNS resolvers cache the result

### Design Implications

- DNS-based load balancing: return different IPs for the same domain (round-robin DNS)
- GeoDNS: return different IPs based on the client's geographic location
- Low TTL enables faster failover but increases DNS query load
- DNS propagation delay (minutes to hours) affects failover speed

---

## CDN (Content Delivery Network)

### What It Does

Caches static and semi-static content at edge servers geographically close to users. Reduces latency and offloads origin servers.

### Types

| Type | What It Caches | Best For |
|------|---------------|----------|
| **Push CDN** | Content is uploaded proactively by origin | Small, rarely changing content (assets, firmware) |
| **Pull CDN** | Content is fetched from origin on first request, then cached | Large, frequently accessed content (images, videos, CSS/JS) |

### What to Put on a CDN

- Static assets: CSS, JavaScript, fonts, images, videos
- Semi-static content: user profile images, product images
- Pre-rendered pages: landing pages, marketing content
- API responses (with appropriate Cache-Control headers)

### What NOT to Put on a CDN

- Personalized content (user-specific data)
- Real-time data (stock prices, live scores)
- Content that changes every request

### Cache Invalidation

- **TTL-based:** Set expiration time; simple but content can be stale until TTL expires
- **Versioned URLs:** `style.v2.css` or `style.css?v=abc123`; instant invalidation, cache-friendly
- **Purge API:** Explicitly invalidate specific URLs; fast but requires operational tooling

---

## Load Balancers

### What They Do

Distribute incoming network traffic across multiple servers to ensure no single server is overwhelmed.

### L4 vs L7 Load Balancing

| Feature | L4 (Transport Layer) | L7 (Application Layer) |
|---------|---------------------|----------------------|
| **Operates on** | TCP/UDP packets | HTTP/HTTPS requests |
| **Speed** | Faster (less processing) | Slower (inspects content) |
| **Routing decisions** | IP address, port | URL path, headers, cookies, body |
| **SSL termination** | No (pass-through) | Yes (can decrypt and re-encrypt) |
| **Use cases** | High-throughput TCP services | Web apps, API routing, A/B testing |

### Load Balancing Algorithms

| Algorithm | How It Works | Best For |
|-----------|-------------|----------|
| **Round robin** | Rotate through servers sequentially | Homogeneous servers, even request complexity |
| **Weighted round robin** | Rotate with weights per server | Servers with different capacities |
| **Least connections** | Route to server with fewest active connections | Varying request durations |
| **IP hash** | Hash client IP to pick server | Session stickiness without cookies |
| **Consistent hashing** | Minimal redistribution when servers change | Cache servers, stateful routing |

### Health Checks

- **Active health checks:** Load balancer periodically pings each server (HTTP GET /health)
- **Passive health checks:** Monitor real traffic for errors (5xx responses, timeouts)
- **Unhealthy threshold:** Remove server after N consecutive failures
- **Recovery threshold:** Re-add server after M consecutive successes

---

## Reverse Proxy

### What It Does

Sits in front of web servers and forwards client requests. Provides a single entry point while hiding backend complexity.

### Benefits

- **Security:** Hides backend server IPs, terminates SSL, filters malicious requests
- **Caching:** Caches responses to reduce backend load
- **Compression:** Compresses responses before sending to clients
- **Rate limiting:** Controls request rate per client
- **SSL termination:** Handles HTTPS, backends communicate over HTTP internally

### Common Tools

- Nginx (most popular, also serves as load balancer)
- HAProxy (high-performance TCP/HTTP proxy)
- Envoy (modern, designed for microservices and service mesh)
- Traefik (auto-discovery, container-native)

---

## Caching

### Cache Layers

Caching can exist at every layer of the stack:

| Layer | What Is Cached | Tools | Latency |
|-------|---------------|-------|---------|
| **Client** | HTML, CSS, JS, images | Browser cache, local storage | ~0 ms |
| **CDN** | Static assets, pre-rendered pages | CloudFront, Cloudflare, Akamai | 5-50 ms |
| **Web server** | Full page responses | Nginx cache, Varnish | 1-5 ms |
| **Application** | Computed results, DB query results | Redis, Memcached | 1-5 ms |
| **Database** | Query plans, buffer pool | Built-in query cache | Varies |

### Cache Strategies

| Strategy | How It Works | Pros | Cons | Best For |
|----------|-------------|------|------|----------|
| **Cache-aside** | App checks cache; on miss, reads DB, writes to cache | Simple, app controls | Cache miss = two calls, possible stale data | General purpose, read-heavy |
| **Read-through** | Cache checks DB on miss automatically | Simpler app code | Cache library dependency | Read-heavy, standard lookups |
| **Write-through** | Write goes to cache AND DB synchronously | Cache always consistent | Write latency increased | Data that must be fresh |
| **Write-behind** | Write goes to cache; cache writes to DB asynchronously | Fast writes | Data loss risk if cache fails | High write throughput |
| **Refresh-ahead** | Cache proactively refreshes before TTL expires | Reduces cache miss latency | Wasted refreshes for unpopular keys | Frequently accessed hot data |

### Cache Invalidation Approaches

| Approach | How It Works | Tradeoff |
|----------|-------------|----------|
| **TTL (Time to Live)** | Entry expires after a set time | Simple but data can be stale |
| **Event-driven invalidation** | Write to DB triggers cache delete | Fresh data but coupling between writer and cache |
| **Version-based** | Cache key includes version number | Clean but requires version tracking |
| **Write-invalidate** | On write, delete the cache entry (next read re-populates) | Simple, avoids stale reads |
| **Write-update** | On write, update the cache entry with new value | Faster reads but more complex writes |

### Cache Eviction Policies

- **LRU (Least Recently Used):** Evict the entry not accessed for the longest time (most common)
- **LFU (Least Frequently Used):** Evict the entry accessed the fewest times
- **FIFO (First In, First Out):** Evict the oldest entry
- **Random:** Evict a random entry (surprisingly effective)

### Common Caching Problems

| Problem | Description | Solution |
|---------|------------|----------|
| **Cache stampede** | Many threads simultaneously miss cache and hit DB | Locking (only one thread fetches), request coalescing |
| **Hot key** | One key gets massive traffic | Replicate hot keys across multiple cache nodes |
| **Cache penetration** | Queries for non-existent data always miss | Cache null results with short TTL, use Bloom filter |
| **Cache warming** | Cold cache after restart causes DB overload | Pre-load popular keys at startup |

---

## Message Queues

### What They Do

Decouple producers (senders) from consumers (processors) by placing an intermediary buffer between them. Producers write messages to the queue; consumers read and process them independently.

### Why Use Them

- **Decoupling:** Producer and consumer don't need to know about each other
- **Buffering:** Absorb traffic spikes without dropping requests
- **Async processing:** Return response to user immediately, process in background
- **Retry and dead-letter:** Failed messages can be retried or moved to a dead-letter queue
- **Fan-out:** One message can be consumed by multiple subscribers

### Queue vs Pub/Sub

| Feature | Queue (Point-to-Point) | Pub/Sub (Broadcast) |
|---------|----------------------|---------------------|
| **Consumers** | One consumer per message | All subscribers get every message |
| **Use case** | Task processing, job queues | Event notification, real-time feeds |
| **Examples** | SQS, RabbitMQ (queue mode) | SNS, Kafka (topics), Redis Pub/Sub |

### Common Tools

| Tool | Model | Strengths |
|------|-------|-----------|
| **Apache Kafka** | Distributed log, pub/sub | High throughput, message replay, ordering within partitions |
| **RabbitMQ** | AMQP broker, queue + pub/sub | Flexible routing, mature, good for complex workflows |
| **Amazon SQS** | Managed queue | Zero ops, scales automatically, at-least-once delivery |
| **Redis Streams** | In-memory stream | Very fast, consumer groups, simpler than Kafka |

### Message Delivery Guarantees

| Guarantee | Meaning | Tradeoff |
|-----------|---------|----------|
| **At-most-once** | Message delivered 0 or 1 times | Fast but messages can be lost |
| **At-least-once** | Message delivered 1 or more times | Reliable but consumers must handle duplicates |
| **Exactly-once** | Message delivered exactly 1 time | Ideal but expensive (requires idempotency or transactions) |

---

## Consistent Hashing

### The Problem

Simple hash-based partitioning (key % N) breaks badly when N changes: almost all keys need to be remapped.

### How Consistent Hashing Works

1. Imagine a circular ring of hash values (0 to 2^32 - 1)
2. Each server is hashed to a point on the ring
3. Each key is hashed to a point on the ring
4. A key is assigned to the first server encountered clockwise from its position

### Why It Works

- When a server is added, only the keys between the new server and its predecessor need to move (~1/N of all keys)
- When a server is removed, only its keys need to be reassigned to the next server
- This is dramatically better than simple hashing where ~all keys move

### Virtual Nodes

Problem: with few servers, distribution can be very uneven.
Solution: map each physical server to multiple virtual nodes on the ring.

- Server A might be at positions 10, 90, 170, 250 on the ring
- Server B might be at positions 50, 130, 210, 290
- More virtual nodes = more even distribution (typically 100-200 per server)

### Applications

| Use Case | Why Consistent Hashing |
|----------|----------------------|
| **Distributed cache (Memcached, Redis cluster)** | Add/remove nodes without invalidating most cached data |
| **Database sharding** | Rebalance with minimal data movement |
| **CDN routing** | Route requests to nearest/appropriate edge server |
| **Load balancing** | Sticky sessions without storing session maps |

---

## Putting It All Together

A typical web-scale architecture layers these blocks:

```
Client -> DNS -> CDN (static) -> Load Balancer (L7)
  -> Web Servers -> Application Servers
    -> Cache (Redis) -> Database (Primary + Replicas)
    -> Message Queue -> Worker Servers
```

**Design principle:** Start simple. Add each building block only when you hit the specific problem it solves:
1. Single server handles everything
2. Separate database from application server
3. Add load balancer and multiple app servers
4. Add cache for read-heavy paths
5. Add CDN for static assets
6. Add message queue for async processing
7. Add database replicas for read scaling
8. Shard database for write scaling
9. Add multiple datacenters for geographic distribution
