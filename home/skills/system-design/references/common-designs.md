# Common System Designs

Brief overviews of frequently encountered system designs. Each section covers the core requirements, key components, design decisions, and critical tradeoffs. Use these as starting templates that you adapt to specific requirements.

---

## URL Shortener

### Requirements
- Given a long URL, generate a short unique URL
- Given a short URL, redirect to the original URL
- Optional: custom short URLs, expiration, analytics

### Key Components
- **API service:** Accepts long URL, returns short URL; accepts short URL, returns redirect
- **ID generator:** Creates unique short codes (base62-encoded auto-increment or hash)
- **Key-value store:** Maps short code to long URL (Redis, DynamoDB, or Cassandra)
- **Analytics service:** Logs redirects for click tracking (async via message queue)

### Design Decisions

| Decision | Options | Recommendation |
|----------|---------|----------------|
| **ID generation** | Auto-increment + base62, hash (MD5/SHA), pre-generated IDs | Auto-increment + base62 for simplicity; pre-generated ranges for distributed |
| **Redirect type** | 301 (permanent) vs 302 (temporary) | 302 if you need analytics (browser doesn't cache); 301 for maximum performance |
| **Storage** | SQL vs NoSQL | NoSQL key-value (simple lookup, massive scale) |
| **Read optimization** | Cache layer | Cache-aside with Redis; short URLs follow power-law (few URLs get most traffic) |

### Scale Calculations (100M DAU)
- Write QPS: ~116 (10M new URLs/day)
- Read QPS: ~5,800 (500M redirects/day), peak ~29K
- Storage: ~1.1 TB/year (300 bytes per record, 10M/day, 10-year retention)

---

## Rate Limiter

### Requirements
- Limit the number of requests a client can send in a time window
- Return 429 (Too Many Requests) when limit exceeded
- Must be low-latency (add minimal overhead to each request)

### Key Components
- **Rate limiter middleware:** Checks request against limits before routing to backend
- **Counter store:** Redis for atomic increment and TTL-based expiration
- **Configuration service:** Defines rules (100 requests/minute per API key)

### Algorithms

| Algorithm | How It Works | Pros | Cons |
|-----------|-------------|------|------|
| **Token bucket** | Bucket holds tokens; each request consumes one; bucket refills at fixed rate | Smooth, allows bursts up to bucket size | Requires per-client state |
| **Leaky bucket** | Requests enter a queue; processed at fixed rate | Very smooth output | Doesn't handle bursts well |
| **Fixed window** | Count requests in fixed time windows (e.g., each minute) | Simple | Spike at window boundary (2x burst) |
| **Sliding window log** | Store timestamp of each request; count within sliding window | Accurate | Memory-intensive (stores every timestamp) |
| **Sliding window counter** | Weighted combination of current and previous window | Good accuracy, low memory | Approximate (but close enough) |

### Design Decisions

| Decision | Options | Recommendation |
|----------|---------|----------------|
| **Where to rate-limit** | Client-side, API gateway, middleware, server-side | API gateway or middleware (centralized, before business logic) |
| **Counter storage** | Local memory, Redis, database | Redis (atomic operations, TTL, shared across servers) |
| **Distributed coordination** | Single Redis, Redis Cluster, local + sync | Redis Cluster for high availability |
| **Rate limit headers** | X-RateLimit-Remaining, X-RateLimit-Limit, Retry-After | Include all three; Retry-After is most important |

### Handling Exceeded Limits
- Return HTTP 429 with `Retry-After` header
- Optionally queue excess requests instead of rejecting
- Log rate-limited requests for monitoring (detect abuse patterns)

---

## Notification System

### Requirements
- Send push notifications, SMS, and email
- Support millions of users with different preferences
- Handle retry for failed deliveries

### Key Components
- **Notification service:** API to receive notification requests
- **User preference store:** Which channels each user has enabled
- **Template service:** Render notification content from templates
- **Delivery workers:** Per-channel workers (push, SMS, email)
- **Message queues:** One queue per channel for decoupling and retry
- **Delivery log:** Track sent, delivered, read status

### Design Decisions
- **Decouple with queues:** Separate queue per channel allows independent scaling and retry
- **Retry with exponential backoff:** Failed deliveries retry with increasing delay (1s, 2s, 4s, 8s...)
- **Rate limiting per user:** Prevent notification fatigue (max N notifications per hour)
- **Priority levels:** Urgent (password reset) vs normal (marketing) vs low (weekly digest)
- **Deduplication:** Idempotency key prevents sending the same notification twice

---

## News Feed (Social Feed)

### Requirements
- Users follow other users
- When a user posts, followers see the post in their feed
- Feed is ordered by recency (or ranked by algorithm)

### Key Components
- **Post service:** Stores posts
- **Follow graph:** Stores who follows whom
- **Feed generation service:** Assembles personalized feeds
- **Feed cache:** Pre-computed feeds per user (Redis sorted sets)
- **Notification service:** Alerts followers of new posts

### The Core Tradeoff: Fanout Strategy

| Strategy | How It Works | Pros | Cons |
|----------|-------------|------|------|
| **Fanout-on-write (push)** | When user posts, write to every follower's feed cache | Fast reads (feed is pre-built) | Slow writes for celebrities, wastes storage for inactive users |
| **Fanout-on-read (pull)** | When user reads feed, fetch posts from all followed accounts | Fast writes, no wasted storage | Slow reads (must merge N sources), high read-time computation |
| **Hybrid** | Push for normal users, pull for celebrities | Balanced | More complex code |

### Hybrid Design (Recommended)
- Users with < 10K followers: fanout-on-write (pre-push to follower feeds)
- Users with > 10K followers: fanout-on-read (merge at read time)
- Feed cache: Redis sorted set per user, scored by timestamp, capped at ~1,000 entries
- Celebrity posts: fetch at read time and merge into the cached feed

---

## Chat System

### Requirements
- 1:1 and group messaging
- Real-time delivery (< 1 second latency)
- Message persistence and history
- Online/offline status (presence)

### Key Components
- **Connection service:** Manages WebSocket connections (stateful)
- **Message service:** Stores and retrieves messages
- **Presence service:** Tracks online/offline status
- **Notification service:** Push notifications for offline users
- **Group service:** Manages group membership and routing

### Design Decisions

| Decision | Options | Recommendation |
|----------|---------|----------------|
| **Protocol** | HTTP polling, long polling, WebSocket, SSE | WebSocket for bidirectional real-time |
| **Message storage** | SQL, NoSQL, wide-column | Wide-column (Cassandra/HBase) for write-heavy, time-series access |
| **Message ordering** | Timestamp, sequence number, hybrid | Monotonic ID per conversation (timestamp + sequence) |
| **Presence** | Heartbeat, connection-based | Heartbeat every 30s; mark offline after 3 missed beats |
| **Group message routing** | Fan-out to members, pull on read | Fan-out via message queue for groups up to ~500 members |

### Message Flow (1:1)
1. Sender sends message via WebSocket to connection service
2. Connection service publishes to message queue
3. Message service persists to database
4. If recipient is online: deliver via their WebSocket connection
5. If recipient is offline: send push notification, store for later delivery

---

## Search Autocomplete

### Requirements
- As user types, suggest top completions
- Latency under 100ms
- Suggestions ranked by frequency/relevance

### Key Components
- **Trie (prefix tree):** Data structure optimized for prefix matching
- **Aggregation service:** Collects search queries and computes frequencies
- **Cache layer:** Top-k results for popular prefixes (Redis)
- **Data collection service:** Logs queries for frequency analysis

### Design Decisions
- **Trie structure:** Each node stores a character; leaf or internal nodes store top-k completions
- **Pre-computation:** Compute top-k for each prefix offline (daily/hourly job), store in trie
- **Caching:** Cache results for popular prefixes (top 20% of prefixes serve 80% of queries)
- **Sharding:** Shard trie by first character or first two characters
- **Update frequency:** Rebuild trie hourly or daily from query logs (real-time updates are rarely needed)

---

## Web Crawler

### Requirements
- Crawl billions of web pages
- Respect robots.txt and rate limits
- Handle duplicates, broken links, and dynamic content

### Key Components
- **URL frontier:** Priority queue of URLs to crawl (BFS order)
- **Fetcher:** Downloads page content (HTTP client with timeout and retry)
- **DNS resolver:** Cached DNS lookups to avoid repeated resolution
- **Content parser:** Extracts links, text, and metadata from HTML
- **Deduplication:** Content hash (MD5/SHA) to detect duplicate pages
- **URL filter:** Removes unwanted URLs (file types, domains, robots.txt exclusions)
- **Storage:** Blob store for raw content, database for metadata and links

### Design Decisions
- **Politeness:** One connection per domain at a time; respect `Crawl-delay` in robots.txt
- **Priority:** Rank URLs by PageRank, freshness, or domain importance
- **Deduplication:** URL dedup (seen this URL?) + content dedup (seen this content at another URL?)
- **Trap avoidance:** Detect infinite loops (calendar pages, query parameter variations), set max URL depth
- **Recrawl:** Schedule recrawl based on page change frequency (detect via Last-Modified, ETag)

---

## Unique ID Generator

### Requirements
- Generate globally unique IDs at high throughput
- IDs should be roughly sortable by time
- 64-bit (fits in a long integer)

### Approaches

| Approach | Format | Pros | Cons |
|----------|--------|------|------|
| **UUID** | 128-bit random | Simple, no coordination | 128-bit (too large), not sortable |
| **Auto-increment (single DB)** | Sequential integer | Simple, sortable | Single point of failure, doesn't scale |
| **Auto-increment (multi DB)** | Even/odd or ranges per DB | Scales writes | Gaps in sequence, coordination for ranges |
| **Snowflake** | 64-bit: timestamp + datacenter + machine + sequence | Time-sortable, distributed, 64-bit | Clock sync dependency |
| **ULID** | 128-bit: timestamp + random | Sortable, simple | 128-bit |

### Snowflake ID Structure (Recommended for Most Systems)

```
| 1 bit unused | 41 bits timestamp | 5 bits datacenter | 5 bits machine | 12 bits sequence |
```

- **41-bit timestamp:** Milliseconds since custom epoch; ~69 years of IDs
- **5-bit datacenter ID:** Up to 32 datacenters
- **5-bit machine ID:** Up to 32 machines per datacenter
- **12-bit sequence:** Up to 4,096 IDs per millisecond per machine
- **Total capacity:** 4,096 x 32 x 32 = ~4 million IDs/second system-wide

### Design Decisions
- **Clock sync:** Use NTP; if clock goes backward, wait or reject (never generate duplicate)
- **Custom epoch:** Start from your launch date, not Unix epoch (maximizes timestamp range)
- **Machine ID assignment:** Use ZooKeeper, etcd, or config to assign unique machine IDs
- **Sequence overflow:** If 4,096 exhausted in one millisecond, wait for next millisecond

---

## Design Pattern Summary

| System | Key Pattern | Key Tradeoff |
|--------|------------|-------------|
| URL shortener | Base62 encoding + key-value store | 301 vs 302 redirect |
| Rate limiter | Token bucket + Redis counters | Accuracy vs memory |
| Notification | Per-channel queues + retry | Reliability vs latency |
| News feed | Hybrid fanout (push + pull) | Write amplification vs read latency |
| Chat | WebSocket + message queue | Connection statefulness vs scalability |
| Autocomplete | Trie + top-k precomputation | Freshness vs latency |
| Web crawler | BFS frontier + politeness | Crawl speed vs politeness |
| ID generator | Snowflake (time + machine + sequence) | Coordination vs simplicity |
