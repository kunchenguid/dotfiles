# Partitioning

Partitioning (also called sharding) divides a large dataset into smaller subsets called partitions, each stored on a different node. The goal is to spread data and query load evenly across machines, enabling horizontal scaling beyond the capacity of a single node.

## Why Partition?

A single database node has hard limits:
- **Storage capacity:** A single disk or SSD has a maximum size
- **Write throughput:** A single CPU can process a limited number of writes per second
- **Read throughput:** Even with caching, a single node can serve a limited number of concurrent reads

Partitioning breaks through all three limits by distributing data across multiple nodes. Each node handles a fraction of the total workload.

---

## Key-Range Partitioning

### How It Works

Assign a continuous range of keys to each partition, similar to volumes of an encyclopedia:

```
Partition 1: keys A-E
Partition 2: keys F-J
Partition 3: keys K-O
Partition 4: keys P-T
Partition 5: keys U-Z
```

The ranges are not necessarily evenly spaced -- they are chosen to distribute data evenly based on the actual key distribution.

### Strengths

- **Efficient range queries:** All keys in a range are on the same partition, so range scans are local and fast
- **Natural ordering:** Data is stored in sorted order within each partition, supporting ORDER BY queries
- **Good for time-series:** Partitioning by time range keeps recent data together

### Weaknesses

- **Hotspots on sequential keys:** If the partition key is a timestamp, all writes go to the partition for the current time period, creating a write hotspot
- **Uneven distribution:** Key ranges that looked balanced at partition creation may become skewed as data grows
- **Manual or complex rebalancing:** Range boundaries may need adjustment as data distribution changes

### Avoiding Time-Series Hotspots

Instead of partitioning by timestamp alone, use a composite key:

```
Partition key: (sensor_id, date)

Sensor 1, 2024-01-01 -> Partition A
Sensor 2, 2024-01-01 -> Partition B
Sensor 1, 2024-01-02 -> Partition A
Sensor 3, 2024-01-01 -> Partition C
```

This distributes writes across partitions (different sensors go to different partitions) while preserving the ability to scan one sensor's data in time order.

### Databases Using Key-Range Partitioning

- HBase (row key ranges)
- Bigtable (row key ranges)
- MongoDB (range-based sharding option)

---

## Hash Partitioning

### How It Works

Apply a hash function to the partition key and assign hash ranges to partitions:

```
hash(key) mod N = partition number

hash("user_123") = 0x7A3F... -> Partition 3
hash("user_456") = 0x1B2C... -> Partition 1
hash("user_789") = 0xE4D1... -> Partition 5
```

### Consistent Hashing

Standard `hash mod N` is problematic when adding or removing nodes because it reassigns most keys. Consistent hashing solves this by mapping both keys and nodes onto a ring:

```
Ring positions: 0 ... 2^32

Nodes:  A at position 1000, B at position 5000, C at position 9000
Key:    hash("user_123") = 3500 -> assigned to Node B (next node clockwise)
```

When a node is added or removed, only the keys between adjacent nodes are reassigned, minimizing data movement.

### Virtual Nodes (Vnodes)

Each physical node is assigned multiple positions (virtual nodes) on the ring, typically 256 per node. This:
- Distributes data more evenly (random positions may cluster otherwise)
- Enables proportional assignment (a more powerful node gets more virtual nodes)
- Smooths rebalancing (adding a node moves small chunks from many existing nodes)

### Strengths

- **Even distribution:** Hash functions distribute keys uniformly, avoiding hotspots from key distribution skew
- **Simple assignment:** Given the key, you can compute the partition without a lookup table

### Weaknesses

- **No range queries:** Hash destroys sort order, so range scans require querying all partitions (scatter-gather)
- **Hot keys still possible:** If one key receives disproportionate traffic (e.g., a celebrity's user ID), hashing doesn't help

### Databases Using Hash Partitioning

- Cassandra (default partitioner: Murmur3)
- DynamoDB (hash of partition key)
- Riak (consistent hashing)
- MongoDB (hash-based sharding option)

---

## Secondary Index Partitioning

When you need to query data by something other than the partition key, you need secondary indexes. There are two approaches to partitioning secondary indexes.

### Local Secondary Indexes (Document-Partitioned)

Each partition maintains its own secondary index covering only the data in that partition:

```
Partition 1: primary data A-M, local index on "color"
Partition 2: primary data N-Z, local index on "color"

Query: SELECT * WHERE color = 'red'
  -> Must query BOTH partitions (scatter-gather)
  -> Each checks its local index
  -> Results are merged
```

**Strengths:**
- Writes are local: updating the secondary index only affects one partition
- Simple to maintain: each partition is self-contained

**Weaknesses:**
- Reads require scatter-gather across all partitions
- Latency is determined by the slowest partition (tail latency)

**Used by:** MongoDB, Cassandra, Elasticsearch, SolrCloud

### Global Secondary Indexes (Term-Partitioned)

The secondary index is itself partitioned, but independently of the primary data:

```
Primary data: partitioned by user_id
Global index on "color": partitioned by color value
  Index partition 1: color A-M (all reds across all primary partitions)
  Index partition 2: color N-Z

Query: SELECT * WHERE color = 'red'
  -> Query index partition 1 only
  -> Get list of document IDs
  -> Fetch documents from their primary partitions
```

**Strengths:**
- Reads are efficient: query only the relevant index partition
- No scatter-gather for indexed queries

**Weaknesses:**
- Writes require updating a remote partition (cross-partition write)
- Index updates are often asynchronous, meaning the index may be stale
- More complex distributed transaction requirements

**Used by:** DynamoDB (global secondary indexes), Amazon Aurora

---

## Rebalancing Strategies

As data grows or nodes are added/removed, partitions must be rebalanced.

### Strategy 1: Fixed Number of Partitions

Create many more partitions than nodes (e.g., 1000 partitions for 10 nodes). Each node hosts multiple partitions. When a node is added, some partitions move from existing nodes to the new node.

```
Before: 3 nodes, 12 partitions (4 per node)
After adding node 4: 4 nodes, 12 partitions (3 per node)
Move 1 partition from each existing node to the new node
```

**Strengths:** Simple, no re-partitioning needed, proportional load balancing
**Weaknesses:** Must choose partition count upfront; too few means large partitions, too many means overhead

**Used by:** Elasticsearch, Riak, Couchbase, Voldemort

### Strategy 2: Dynamic Partitioning

Start with one partition. When a partition grows beyond a threshold (e.g., 10GB), split it in half. When it shrinks below a threshold, merge it with a neighbor.

**Strengths:** Adapts to data size automatically; no upfront sizing decisions
**Weaknesses:** Single partition at start means single-node bottleneck until first split; can cause split storms under rapid growth

**Used by:** HBase, RethinkDB, MongoDB (with key-range sharding)

### Strategy 3: Proportional to Nodes

Keep a fixed number of partitions per node. When a node is added, it splits some existing partitions; when removed, its partitions are merged into others.

**Strengths:** Partition count grows with cluster size; each partition stays manageable
**Weaknesses:** Splitting introduces brief unavailability for the affected partition

**Used by:** Cassandra (with vnodes)

---

## Request Routing

How does a client know which node holds the partition for a given key?

### Approach 1: Client-Side Routing

The client knows the partition assignment and connects directly to the correct node:

```
Client: hash("user_123") -> Partition 3 -> Node B
Client connects directly to Node B
```

Requires the client to maintain a copy of the partition map. Used by Cassandra drivers.

### Approach 2: Routing Tier (Proxy)

A separate routing tier receives all requests and forwards them to the correct node:

```
Client -> Proxy -> determines partition -> forwards to correct Node
```

Used by: MongoDB (mongos router), Twemproxy (for Redis/Memcached)

### Approach 3: Any-Node Contact

Client contacts any node; that node forwards the request if it doesn't own the partition:

```
Client -> Node A -> "Not my partition" -> forwards to Node B
```

Used by: Cassandra (coordinator pattern), CockroachDB

### Service Discovery

All approaches need to know the current partition-to-node mapping. Options:

- **ZooKeeper/etcd:** Centralized configuration service that tracks which partitions are on which nodes; nodes register themselves; routing layer watches for changes
- **Gossip protocol:** Nodes gossip partition assignments to each other; eventually consistent but no central point of failure
- **DNS-based:** Simple but slow to update; suitable only for coarse-grained routing

---

## Handling Hotspots

### Why Hotspots Occur

Even with perfect hash distribution, application-level access patterns create hotspots:

- **Celebrity problem:** A single user or entity receives vastly more traffic than others
- **Temporal hotspots:** Events cause sudden spikes on specific keys (product launch, breaking news)
- **Sequential keys:** Auto-incrementing IDs or timestamps concentrate writes

### Mitigation Strategies

| Strategy | How It Works | Trade-off |
|----------|-------------|-----------|
| **Key splitting** | Append random suffix (0-9) to hot keys; read from all 10 sub-keys and merge | 10x fan-out on reads; application complexity |
| **Write buffering** | Buffer writes to hot keys in memory; flush periodically | Eventual consistency; risk of data loss if buffer crashes |
| **Caching layer** | Cache hot reads in Redis/Memcached in front of the database | Stale data; cache invalidation complexity |
| **Rate limiting** | Limit requests to hot keys per client | Degrades user experience for hot content |
| **Application-level sharding** | Route hot entities to dedicated, scaled infrastructure | Operational complexity; special-case architecture |

### Detecting Hotspots

Monitor per-partition metrics:
- **Request rate per partition:** Compare against average; alert on 10x deviation
- **Latency per partition:** Hot partitions show higher p99 latency
- **CPU/IO utilization per node:** Uneven utilization signals partition skew
- **Key-level access counting:** Sample or log the most-accessed keys (most databases provide slow query logs or key-access statistics)

### Automatic Hotspot Detection

Some systems detect and mitigate hotspots automatically:
- **DynamoDB Adaptive Capacity:** Automatically isolates hot partitions onto dedicated throughput
- **Spanner:** Splits hot partitions when load exceeds threshold
- **CockroachDB:** Automatic range splitting and lease rebalancing based on load
