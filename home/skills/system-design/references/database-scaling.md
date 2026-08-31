# Database Design and Scaling

How to choose, design, and scale databases for distributed systems. The database is usually the first bottleneck -- understanding scaling strategies lets you plan growth deliberately.

## SQL vs NoSQL Decision Framework

### When to Choose SQL (Relational)

Choose relational databases (PostgreSQL, MySQL, Oracle) when:

- **ACID transactions** are required (financial data, inventory, bookings)
- **Complex joins** across multiple tables are common
- **Schema is well-defined** and unlikely to change dramatically
- **Data integrity** via foreign keys and constraints is critical
- **Reporting and ad-hoc queries** are needed (SQL is incredibly expressive)

### When to Choose NoSQL

Choose NoSQL when the access pattern matches a specific NoSQL model:

| NoSQL Type | Best For | Examples | When to Use |
|-----------|----------|---------|-------------|
| **Key-Value** | Simple lookups by key | Redis, DynamoDB, Riak | Session storage, caching, user preferences |
| **Document** | Flexible schema, nested data | MongoDB, CouchDB, Firestore | Product catalogs, content management, user profiles |
| **Wide-Column** | High write throughput, time-series | Cassandra, HBase, ScyllaDB | IoT data, event logs, messaging history |
| **Graph** | Highly connected data | Neo4j, Amazon Neptune, JanusGraph | Social networks, recommendation engines, fraud detection |

### The Decision Checklist

| Question | If Yes: SQL | If Yes: NoSQL |
|----------|-------------|---------------|
| Need ACID transactions? | SQL | |
| Need complex joins? | SQL | |
| Schema is stable? | SQL | |
| Schema evolves rapidly? | | Document DB |
| Need horizontal write scaling? | | Wide-column or Key-value |
| Access pattern is simple key lookup? | | Key-value |
| Data is highly connected (graph)? | | Graph DB |
| Need full-text search? | | Consider Elasticsearch alongside primary DB |

**Important:** Many real systems use multiple databases (polyglot persistence). A social app might use PostgreSQL for user accounts, Redis for sessions, Cassandra for the activity feed, and Elasticsearch for search.

---

## Vertical Scaling (Scale Up)

### What It Means

Make a single server more powerful: more CPU, more RAM, faster disks, more network bandwidth.

### Advantages

- Simple -- no code changes required
- No distributed systems complexity
- Strong consistency is easy (single node)
- No need for sharding logic

### Limitations

- Hard ceiling -- you can't buy an infinitely powerful machine
- Single point of failure -- one server, one failure domain
- Cost increases non-linearly -- a 2x more powerful server costs more than 2x the price
- Downtime during upgrade -- usually requires restart

### When to Use

- Early-stage products where simplicity matters more than scale
- When vertical limits haven't been reached (modern servers can handle significant load)
- When strong consistency requirements make horizontal scaling very difficult

**Rule of thumb:** Start vertical. A single PostgreSQL server with 64 cores and 256 GB RAM handles more than most applications need. Move to horizontal when you actually hit the limits.

---

## Replication

### Leader-Follower (Master-Slave)

The most common replication pattern:

```
Writes -> Leader (Primary)
Reads  -> Leader or Followers (Replicas)
```

**How it works:**
1. All writes go to the leader
2. Leader writes to its write-ahead log (WAL)
3. Followers replicate the WAL and apply changes
4. Reads can go to any node (leader or follower)

**Advantages:**
- Scales reads horizontally (add more followers)
- Provides redundancy (promote a follower if leader fails)
- Simple mental model

**Challenges:**

| Challenge | Description | Mitigation |
|-----------|------------|------------|
| **Replication lag** | Followers may be seconds behind leader | Read-your-writes: route user's reads to leader after they write |
| **Failover complexity** | Promoting a follower requires coordination | Automated failover with consensus (e.g., Patroni for PostgreSQL) |
| **Write bottleneck** | All writes still go to one node | See sharding section below |

### Multi-Leader (Master-Master)

Multiple nodes accept writes:

```
Region A writes -> Leader A -> replicates to -> Leader B
Region B writes -> Leader B -> replicates to -> Leader A
```

**When to use:**
- Multi-region deployments where each region needs local writes
- Offline-capable applications (each device is a "leader")

**The hard problem: write conflicts.** When two leaders modify the same row:

| Strategy | How It Works | Tradeoff |
|----------|-------------|----------|
| **Last-write-wins (LWW)** | Timestamp-based, latest wins | Simple but can lose data |
| **Application-level merge** | App defines custom merge logic | Correct but complex |
| **CRDTs** | Conflict-free data structures | Automatic merge but limited data types |
| **Conflict avoidance** | Route same data to same leader | Simple but limits flexibility |

### Leaderless Replication

All nodes are equal; reads and writes go to multiple nodes:

- Write to W nodes, read from R nodes
- If W + R > N (total nodes), reads are guaranteed to see latest write
- Used by Cassandra and DynamoDB

**Advantages:** No single point of failure, high availability
**Disadvantages:** Complex consistency model, conflict resolution needed

---

## Sharding (Horizontal Partitioning)

### What It Means

Split data across multiple database servers (shards), each holding a subset of the data. Each shard is a fully independent database.

### When to Shard

Shard only when you have exhausted simpler options:
1. Vertical scaling (bigger server)
2. Read replicas (for read-heavy workloads)
3. Caching (for hot data)
4. Query optimization (indexes, query rewriting)
5. **Then** shard (for write-heavy workloads or data too large for one server)

### Sharding Strategies

#### Hash-Based Sharding

```
shard_number = hash(shard_key) % number_of_shards
```

| Pros | Cons |
|------|------|
| Even data distribution | Adding/removing shards requires data redistribution |
| Simple implementation | Range queries across shards are difficult |
| No hotspots (if hash is good) | Re-sharding is expensive |

**Mitigation for redistribution:** Use consistent hashing instead of simple modulo.

#### Range-Based Sharding

```
Shard 1: user_id 1 - 1,000,000
Shard 2: user_id 1,000,001 - 2,000,000
```

| Pros | Cons |
|------|------|
| Efficient range queries | Uneven distribution (hotspots) |
| Natural data locality | New data may overwhelm one shard |
| Simple to understand | Requires manual range management |

**Best for:** Time-series data (shard by month), geographic data (shard by region).

#### Directory-Based Sharding

A lookup service maps each key to its shard:

```
Lookup table:
  user_123 -> shard_3
  user_456 -> shard_1
```

| Pros | Cons |
|------|------|
| Flexible, any key-to-shard mapping | Lookup service is a single point of failure |
| Easy rebalancing | Extra network hop for every query |
| Can handle hotspots by moving individual keys | Directory itself needs to be highly available |

### Choosing a Shard Key

The shard key determines everything about your sharding strategy. Choose carefully:

| Criteria | Why It Matters |
|----------|---------------|
| **High cardinality** | More distinct values = more even distribution |
| **Even distribution** | Avoid hotspots where one shard gets disproportionate traffic |
| **Query patterns** | Most queries should hit a single shard (avoid scatter-gather) |
| **Growth stability** | Key shouldn't cause imbalance as data grows |

**Common shard keys:**
- `user_id` -- good for user-centric applications (each user's data on one shard)
- `tenant_id` -- good for multi-tenant SaaS (each tenant isolated)
- `geo_region` -- good for location-based services
- `created_at` -- good for time-series (but recent shard gets all writes)

### The Celebrity/Hotspot Problem

Even with good hash-based sharding, a single popular entity can overwhelm one shard.

**Example:** A celebrity with 100 million followers. Any action on their account generates massive read/write traffic on the shard that holds their data.

**Solutions:**
1. **Dedicated shard:** Move the hot entity to its own shard
2. **Secondary partition:** Split the hot entity's data further (e.g., partition followers into sub-groups)
3. **Caching:** Put a cache in front of the hot shard
4. **Application-level routing:** Detect hot keys and handle them differently

### Cross-Shard Operations

The biggest challenge with sharding: operations that span multiple shards.

| Operation | Challenge | Solution |
|-----------|----------|----------|
| **Joins** | Can't join across shards efficiently | Denormalize, or join at application level |
| **Aggregations** | Must scatter query to all shards and gather results | Pre-compute aggregates, use a separate analytics DB |
| **Transactions** | Distributed transactions are slow and complex | Design for single-shard transactions, use sagas for cross-shard |
| **Unique constraints** | Can't enforce uniqueness across shards | Use a global sequence service, or accept probabilistic uniqueness |

---

## Denormalization

### What It Means

Duplicate data across tables or documents to avoid expensive joins at read time.

### When to Denormalize

| Indicator | Example |
|-----------|---------|
| Read-heavy workload (100:1 read:write ratio) | News feed, product catalog |
| Joins are too slow | Dashboard aggregating data from 5+ tables |
| Data changes infrequently | User profile data embedded in every post |
| Scale requires sharding (joins across shards are impractical) | Any sharded system |

### Denormalization Patterns

| Pattern | How It Works | Example |
|---------|-------------|---------|
| **Embed related data** | Store related data in same row/document | Store author name in each post (not just author_id) |
| **Materialized view** | Pre-compute and store query results | Nightly job that joins orders + products into a summary table |
| **Counter cache** | Store computed counts alongside parent | `posts_count` column on user table, incremented on new post |
| **Summary table** | Aggregate data into a summary | Daily revenue summary table updated by background job |

### Tradeoffs

| Benefit | Cost |
|---------|------|
| Faster reads (no joins) | Slower writes (update multiple places) |
| Simpler queries | Data inconsistency risk |
| Works with sharding | More storage used |
| Reduced database load | Application must maintain consistency |

---

## Database Selection Guide

Quick reference for choosing the right database:

| Requirement | Recommended | Examples |
|-------------|------------|---------|
| General-purpose web app | Relational | PostgreSQL, MySQL |
| Simple key-value lookups at massive scale | Key-value | Redis, DynamoDB |
| Flexible schema, document-oriented | Document | MongoDB, Firestore |
| High write throughput, time-series | Wide-column | Cassandra, ScyllaDB |
| Graph relationships | Graph | Neo4j, Neptune |
| Full-text search | Search engine | Elasticsearch, OpenSearch |
| Analytics and OLAP | Columnar | ClickHouse, BigQuery, Redshift |
| Caching layer | In-memory | Redis, Memcached |
| Message/event storage | Distributed log | Apache Kafka |

**Remember:** Most systems use 2-3 databases for different access patterns. This is polyglot persistence and it is normal at scale.
