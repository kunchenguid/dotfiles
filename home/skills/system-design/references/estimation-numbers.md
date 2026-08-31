# Back-of-the-Envelope Estimation

Essential numbers, formulas, and worked examples for estimating system capacity. The goal is order of magnitude, not precision -- being within 10x is success; being within 2x is excellent.

## Powers of Two

Every engineer should know these instantly:

| Power | Exact Value | Approximate |
|-------|-------------|-------------|
| 2^10 | 1,024 | 1 thousand (1 KB) |
| 2^20 | 1,048,576 | 1 million (1 MB) |
| 2^30 | 1,073,741,824 | 1 billion (1 GB) |
| 2^40 | 1,099,511,627,776 | 1 trillion (1 TB) |
| 2^50 | ~1.13 x 10^15 | 1 quadrillion (1 PB) |

**Quick conversions:**
- 1 KB = 10^3 bytes
- 1 MB = 10^6 bytes
- 1 GB = 10^9 bytes
- 1 TB = 10^12 bytes
- 1 PB = 10^15 bytes

**Useful round numbers:**
- 1 million seconds = ~11.5 days
- 1 billion seconds = ~31.7 years
- 86,400 seconds in a day (~10^5)
- 2.5 million seconds in a month (~2.5 x 10^6)
- 31.5 million seconds in a year (~3 x 10^7)

---

## Latency Numbers Every Programmer Should Know

These numbers, originally compiled by Jeff Dean, define the performance landscape:

| Operation | Latency | Notes |
|-----------|---------|-------|
| L1 cache reference | 0.5 ns | |
| Branch mispredict | 5 ns | |
| L2 cache reference | 7 ns | |
| Mutex lock/unlock | 25 ns | |
| Main memory reference | 100 ns | |
| Compress 1 KB with Snappy | 3 us | |
| Send 1 KB over 1 Gbps network | 10 us | |
| Read 4 KB randomly from SSD | 150 us | |
| Read 1 MB sequentially from memory | 250 us | |
| Round trip within same datacenter | 500 us | |
| Read 1 MB sequentially from SSD | 1 ms | |
| HDD disk seek | 10 ms | |
| Read 1 MB sequentially from HDD | 20 ms | |
| Send packet CA -> Netherlands -> CA | 150 ms | |

### Key Takeaways

1. **Memory is fast, disk is slow.** Memory access (~100 ns) is 100,000x faster than disk seek (~10 ms).
2. **SSD is much faster than HDD.** SSD random read (~150 us) is ~67x faster than HDD seek (~10 ms).
3. **Sequential reads are fast everywhere.** Sequential 1 MB from memory (250 us) vs SSD (1 ms) vs HDD (20 ms).
4. **Network within a datacenter is fast.** Round trip ~0.5 ms. Cross-continent is ~150 ms (300x slower).
5. **Compression is cheap.** Compressing 1 KB takes ~3 us -- almost always worth doing for network transfer.

### Design Implications

| Latency Requirement | Design Strategy |
|--------------------|-----------------|
| < 1 ms | Must be in memory (cache, in-process) |
| < 10 ms | Can hit SSD or local cache |
| < 100 ms | Can hit database (with indexes) or remote cache |
| < 500 ms | Can make 1-2 network calls within datacenter |
| < 1 second | Can make multiple datacenter calls or one cross-region call |
| > 1 second | Must be async, show loading state to user |

---

## Availability Nines

| Availability | Downtime/Year | Downtime/Month | Downtime/Week |
|-------------|---------------|----------------|---------------|
| 99% (two nines) | 3.65 days | 7.31 hours | 1.68 hours |
| 99.9% (three nines) | 8.77 hours | 43.83 minutes | 10.08 minutes |
| 99.95% | 4.38 hours | 21.92 minutes | 5.04 minutes |
| 99.99% (four nines) | 52.60 minutes | 4.38 minutes | 1.01 minutes |
| 99.999% (five nines) | 5.26 minutes | 26.30 seconds | 6.05 seconds |

### SLA Composition

When services depend on each other, availabilities multiply:

- Service A: 99.9%, Service B: 99.9%
- Combined (A depends on B): 99.9% x 99.9% = 99.8%

This means:
- A chain of 3 services at 99.9% each = 99.7% combined
- A chain of 5 services at 99.9% each = 99.5% combined

**Implication:** To achieve 99.99% end-to-end, each component must be significantly better than 99.99% individually, or you need redundancy (parallel paths) to improve overall availability.

**Parallel redundancy:**
- Two instances of a service, each at 99%: 1 - (0.01 x 0.01) = 99.99%
- Both must fail simultaneously for the system to be unavailable

---

## QPS Estimation

### Formula

```
Average QPS = DAU x average_actions_per_user / 86,400
Peak QPS    = Average QPS x peak_factor (typically 2-5x)
```

### Worked Examples

**Twitter-like service:**
- DAU: 300 million
- Tweets per user per day: 2 (average)
- Tweet reads per user per day: 100
- Write QPS: 300M x 2 / 86,400 = ~7,000 QPS
- Peak write QPS: 7,000 x 3 = ~21,000 QPS
- Read QPS: 300M x 100 / 86,400 = ~350,000 QPS
- Peak read QPS: 350,000 x 3 = ~1,050,000 QPS
- Read:write ratio = 50:1

**URL shortener:**
- DAU: 100 million
- URLs created per user per day: 0.1 (most users only read)
- URL redirects per user per day: 5
- Write QPS: 100M x 0.1 / 86,400 = ~116 QPS
- Read QPS: 100M x 5 / 86,400 = ~5,800 QPS
- Peak read QPS: 5,800 x 5 = ~29,000 QPS

**Chat application:**
- DAU: 50 million
- Messages per user per day: 40
- Message QPS: 50M x 40 / 86,400 = ~23,000 QPS
- Peak QPS: 23,000 x 5 = ~115,000 QPS

---

## Storage Estimation

### Formula

```
Daily storage  = records_per_day x average_record_size
Yearly storage = daily_storage x 365
Total storage  = yearly_storage x retention_years
```

### Worked Examples

**Twitter-like service (5-year retention):**
- Tweets per day: 300M users x 2 tweets = 600M tweets
- Average tweet size: tweet_id (8 bytes) + user_id (8 bytes) + text (280 chars = 280 bytes) + timestamp (8 bytes) + metadata (100 bytes) = ~400 bytes
- Daily storage: 600M x 400 bytes = 240 GB/day
- Yearly storage: 240 GB x 365 = ~88 TB/year
- 5-year storage: 88 TB x 5 = ~440 TB
- With media (images, videos): multiply by 10-50x

**URL shortener (10-year retention):**
- New URLs per day: 100M x 0.1 = 10M URLs
- Average record size: short_code (7 bytes) + original_url (200 bytes) + metadata (50 bytes) = ~257 bytes, round to 300 bytes
- Daily storage: 10M x 300 bytes = 3 GB/day
- Yearly storage: 3 GB x 365 = ~1.1 TB/year
- 10-year storage: 1.1 TB x 10 = ~11 TB

**Chat application (indefinite retention):**
- Messages per day: 50M users x 40 messages = 2 billion messages
- Average message size: 200 bytes (text) + 100 bytes (metadata) = 300 bytes
- Daily storage: 2B x 300 bytes = 600 GB/day
- Yearly storage: 600 GB x 365 = ~219 TB/year

---

## Bandwidth Estimation

### Formula

```
Incoming bandwidth = write_QPS x average_request_size
Outgoing bandwidth = read_QPS x average_response_size
```

### Worked Examples

**URL shortener:**
- Write: 116 QPS x 300 bytes = ~35 KB/s (negligible)
- Read: 5,800 QPS x 500 bytes (redirect response) = ~2.9 MB/s
- Peak read: 29,000 QPS x 500 bytes = ~14.5 MB/s

**Image hosting service:**
- Upload: 100 QPS x 2 MB = 200 MB/s incoming
- Download: 10,000 QPS x 500 KB (average image) = 5 GB/s outgoing
- This immediately tells you: CDN is mandatory

---

## Server Count Estimation

### Rule of Thumb

- A single web server handles ~1,000-10,000 QPS (depends on workload complexity)
- A single database server handles ~5,000-10,000 QPS for simple queries
- A single cache server (Redis) handles ~100,000 QPS for simple GET/SET
- A single message queue node handles ~10,000-100,000 messages/second

### Formula

```
Server count = Peak QPS / QPS per server
Add redundancy factor (typically 2-3x for fault tolerance)
```

### Worked Example

**URL shortener:**
- Peak read QPS: 29,000
- QPS per web server: ~5,000 (lightweight redirect)
- Minimum web servers: 29,000 / 5,000 = ~6
- With redundancy: 6 x 2 = 12 web servers
- Cache QPS: 29,000 (cache all reads)
- Redis nodes: 29,000 / 100,000 = 1 (with a replica for failover)

---

## Estimation Quick Reference

| What to Estimate | Formula | Typical Inputs |
|-----------------|---------|----------------|
| Average QPS | DAU x actions / 86,400 | DAU, actions per user |
| Peak QPS | Avg QPS x 2-5 | Traffic pattern |
| Daily storage | Records/day x record size | Record count, schema |
| Yearly storage | Daily x 365 | Daily storage |
| Bandwidth | QPS x response size | QPS, payload size |
| Server count | Peak QPS / capacity per server x 2 | Peak QPS |
| Cache size | Working set x record size | Hot records, record size |

---

## Common Estimation Mistakes

| Mistake | Why It Matters | Fix |
|---------|---------------|-----|
| Forgetting peak vs average | Average is fine, but peak causes outages | Always multiply by 2-5x for peak |
| Ignoring media storage | Text is tiny; images and video dominate | Account for media separately |
| Precise calculation | 3,472 QPS is false precision | Round to 3,500 or "about 3K-4K" |
| Forgetting replication | Storage and bandwidth multiply with replicas | Multiply by replication factor (typically 3x) |
| Ignoring metadata | Indexes, logs, and overhead add up | Add 30-50% overhead to raw data size |
| Using current numbers only | Systems grow | Apply expected growth rate (typically 2-3x/year) |
