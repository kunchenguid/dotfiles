# Storage Engines

A storage engine is the component of a database that handles how data is written to and read from disk (or memory). Understanding storage engine internals is essential for predicting performance, choosing appropriate indexes, and avoiding pathological workloads.

## Two Families of Storage Engines

All storage engines face a fundamental trade-off: optimizing for write performance or read performance. The two dominant approaches are log-structured engines (optimized for writes) and page-oriented engines (balanced reads and writes).

---

## Log-Structured Engines: LSM Trees and SSTables

### How LSM Trees Work

LSM (Log-Structured Merge) trees use a multi-level structure:

1. **Memtable:** An in-memory balanced tree (typically a red-black tree or skip list) that receives all writes
2. **Flush to SSTable:** When the memtable reaches a size threshold (typically 64MB-256MB), it is written to disk as a Sorted String Table (SSTable) -- a file of key-value pairs sorted by key
3. **Compaction:** Background processes merge multiple SSTables into fewer, larger SSTables, removing deleted keys and resolving duplicates

### Write Path

```
Client Write
    |
    v
Write-Ahead Log (WAL) -- sequential append for durability
    |
    v
Memtable (in-memory sorted structure)
    |
    v  (when full)
SSTable on disk (sorted, immutable file)
    |
    v  (background)
Compaction: merge SSTables into larger, consolidated files
```

### Read Path

```
Client Read
    |
    v
Check Memtable (most recent writes)
    |  (miss)
    v
Check Bloom Filters for each SSTable level
    |  (possible match)
    v
Binary search within SSTable
    |
    v
Return value (or not found)
```

### Compaction Strategies

| Strategy | How It Works | Trade-off |
|----------|-------------|-----------|
| **Size-tiered** | SSTables of similar size are merged together | Better write throughput; more space amplification |
| **Leveled** | SSTables are organized into levels of increasing size; each level is non-overlapping | Better read performance and space efficiency; higher write amplification |

- **Cassandra** defaults to size-tiered compaction
- **RocksDB** and **LevelDB** use leveled compaction
- Choice depends on read/write ratio and disk space constraints

### LSM Tree Strengths

- **Sequential writes:** All disk writes are sequential appends, which is much faster than random I/O on both HDDs and SSDs
- **High write throughput:** Buffering in memory and batch-flushing to disk minimizes disk operations per write
- **Compression:** Sorted SSTables compress well, reducing storage costs
- **No fragmentation:** Compaction produces fresh, defragmented files

### LSM Tree Weaknesses

- **Read amplification:** A point read may need to check the memtable plus multiple SSTables at different levels
- **Write amplification:** A single logical write may be written and rewritten multiple times through compaction (typical: 10-30x)
- **Compaction interference:** Background compaction consumes CPU and I/O bandwidth, causing latency spikes if not tuned
- **Space amplification:** During compaction, both old and new SSTables exist temporarily, requiring 2x space

### Databases Using LSM Trees

- Cassandra, ScyllaDB, HBase (size-tiered)
- RocksDB, LevelDB (leveled)
- CockroachDB, TiKV (RocksDB-based)

---

## Page-Oriented Engines: B-Trees

### How B-Trees Work

B-trees organize data in fixed-size pages (typically 4KB-16KB) arranged in a balanced tree structure:

1. **Root page:** Contains keys and pointers to child pages
2. **Internal pages:** Contains keys that split the key space and pointers to child pages
3. **Leaf pages:** Contains the actual key-value pairs (or pointers to heap file rows)

A B-tree with a branching factor of 500 and 4 levels can store up to 256TB of data (500^4 pages).

### Write Path

```
Client Write
    |
    v
Write-Ahead Log (WAL) -- for crash recovery
    |
    v
Traverse B-tree from root to leaf
    |
    v
Update the leaf page in place
    |  (if page is full)
    v
Split page: create two half-full pages, update parent pointer
```

### Read Path

```
Client Read
    |
    v
Start at root page
    |
    v
Binary search within page for correct child pointer
    |
    v
Follow pointer to next level
    |  (repeat log(n) times)
    v
Reach leaf page, binary search for key
    |
    v
Return value
```

### B-Tree Strengths

- **Predictable read latency:** Every lookup follows the same number of page accesses (tree depth), typically 3-4 for practical databases
- **Efficient point lookups:** O(log n) with small constants due to high branching factor
- **Mature and battle-tested:** 40+ years of optimization, well-understood behavior
- **Good range scan performance:** Leaf pages are often linked, allowing sequential scanning

### B-Tree Weaknesses

- **Write amplification:** Even a small update requires rewriting an entire page (typically 4KB-16KB)
- **Page splits:** When a page is full, it splits into two, requiring parent page updates (can cascade)
- **Fragmentation:** Over time, pages become partially full, wasting space
- **Concurrency control:** In-place updates require careful locking (latches) to prevent torn reads

### Databases Using B-Trees

- PostgreSQL, MySQL/InnoDB, Oracle, SQL Server
- SQLite
- Most traditional relational databases

---

## LSM Trees vs. B-Trees: Decision Guide

| Factor | LSM Trees | B-Trees |
|--------|-----------|---------|
| **Write throughput** | Higher (sequential writes) | Lower (random in-place updates) |
| **Read latency** | Less predictable (multiple levels) | More predictable (fixed tree depth) |
| **Space efficiency** | Better (compaction removes dead entries) | Worse (fragmentation, partial pages) |
| **Write amplification** | Higher (compaction rewrites) | Lower per write, but each write is a full page |
| **Compression** | Better (sorted data compresses well) | Moderate |
| **Concurrency** | No in-place updates, simpler | Requires page-level latching |
| **Maturity** | Newer, less predictable edge cases | Decades of production hardening |
| **Best for** | Write-heavy, append-heavy workloads | Mixed read/write OLTP |

### Rules of Thumb

- **Write-heavy with few reads:** LSM tree (Cassandra, RocksDB)
- **Read-heavy with indexed lookups:** B-tree (PostgreSQL, MySQL)
- **Mixed OLTP:** B-tree, unless write throughput is the bottleneck
- **Time-series ingestion:** LSM tree (high sequential write rate)
- **When in doubt:** Start with B-tree (PostgreSQL); it handles most workloads well

---

## Column-Oriented Storage

### The Problem with Row Storage for Analytics

Analytical queries typically access a few columns across millions or billions of rows:

```sql
SELECT product_category, SUM(revenue), COUNT(*)
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY product_category;
```

In a row-oriented store, this query reads entire rows (all columns) even though it only needs three columns. With 100 columns and 1 billion rows, you read 100x more data than necessary.

### How Column Storage Works

Column-oriented storage stores each column separately:

```
Row store:          Column store:
[id, name, age]     ids:   [1, 2, 3, ...]
[1, Alice, 30]      names: [Alice, Bob, Carol, ...]
[2, Bob, 25]        ages:  [30, 25, 28, ...]
[3, Carol, 28]
```

### Column Storage Benefits

- **I/O reduction:** Only read the columns your query needs
- **Compression:** Values in a single column have similar data types and distributions, enabling excellent compression (often 10:1)
- **Vectorized processing:** Modern CPUs process arrays of same-typed values much faster than individual rows (SIMD instructions)
- **Bitmap indexes:** Column values can be efficiently indexed with bitmaps for fast filtering

### Column Storage Implementations

| Database | Type | Key Feature |
|----------|------|-------------|
| **ClickHouse** | Column OLAP | MergeTree engine, real-time aggregation |
| **Apache Parquet** | File format | Columnar storage for Hadoop/Spark/data lakes |
| **Apache ORC** | File format | Optimized for Hive, predicate pushdown |
| **BigQuery** | Cloud OLAP | Serverless, automatic optimization |
| **Redshift** | Cloud OLAP | Zone maps, sort keys for pruning |
| **DuckDB** | Embedded OLAP | In-process, Parquet-native |

---

## In-Memory Databases

### Why In-Memory is Fast

The performance advantage of in-memory databases is not simply "RAM is faster than disk." RAM-based systems are fast because they avoid the overhead of encoding data into disk-friendly formats. In-memory data structures (hash tables, skip lists, trees) can be used directly without serialization.

### In-Memory Database Types

| Database | Model | Persistence | Use Case |
|----------|-------|-------------|----------|
| **Redis** | Key-value, data structures | Optional (RDB snapshots, AOF log) | Caching, sessions, rate limiting, queues |
| **Memcached** | Key-value | None | Simple caching |
| **VoltDB** | Relational | Durable (WAL + replication) | High-throughput OLTP with serializability |
| **SAP HANA** | Relational + column | Durable | Mixed OLTP/OLAP |

### Anti-Heap: Persistence for In-Memory Databases

In-memory databases that need durability use several techniques:

- **Write-ahead log (WAL):** Append every write to disk sequentially; on crash, replay the log
- **Periodic snapshots:** Write the entire in-memory state to disk at intervals
- **Replication:** Keep copies on other machines; if one crashes, another has the data
- **Battery-backed RAM:** Hardware guarantee that RAM contents survive power loss

The WAL approach means writes are actually written to disk, but reads never touch disk. The disk serves only as a durability mechanism, not as a primary data structure.

---

## Choosing a Storage Engine: Decision Framework

### Step 1: Classify Your Workload

| Question | Answer Determines |
|----------|-------------------|
| What is your read:write ratio? | LSM (write-heavy) vs. B-tree (balanced/read-heavy) |
| Do you need point lookups or range scans? | Hash index (point) vs. B-tree/LSM (range) |
| Is your data mostly queried by row or by column? | Row store (OLTP) vs. column store (OLAP) |
| Does your data fit in memory? | In-memory store for sub-millisecond latency |
| What latency percentile matters (p50 vs. p99)? | B-tree for predictable p99; LSM for better p50 |

### Step 2: Consider Operational Factors

- **Team expertise:** Use what your team knows unless there is a compelling reason to switch
- **Ecosystem:** Consider drivers, ORMs, monitoring tools, and backup solutions
- **Managed services:** Cloud-managed databases reduce operational burden significantly
- **Vendor lock-in:** Open-source engines provide more flexibility

### Step 3: Test With Your Actual Workload

Benchmarks from the internet are misleading. They test different hardware, different data sizes, different access patterns, and different configurations. The only benchmark that matters is one that uses your data, your queries, and your expected concurrency.

Tools for benchmarking:
- **YCSB (Yahoo Cloud Serving Benchmark):** Standard workload generator for key-value stores
- **TPC-C:** Standard OLTP benchmark
- **TPC-H:** Standard OLAP benchmark
- **pgbench:** PostgreSQL-specific benchmark
- **sysbench:** MySQL-specific benchmark
