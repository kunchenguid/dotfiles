# Replication

Replication means keeping a copy of the same data on multiple machines connected via a network. The reasons for replication are: keeping data geographically close to users (reduce latency), allowing the system to continue working even if some machines fail (increase availability), and scaling out the number of machines that can serve read queries (increase read throughput).

## Single-Leader Replication

### How It Works

One node is designated the leader (primary, master). All writes go to the leader, which writes data to its local storage and sends the change to all followers (replicas, secondaries) via a replication log. Followers apply the changes in the same order.

```
Client Writes --> Leader --> Replication Log --> Follower 1
                                            --> Follower 2
                                            --> Follower 3

Client Reads  --> Leader OR any Follower
```

### Synchronous vs. Asynchronous Replication

| Mode | Behavior | Trade-off |
|------|----------|-----------|
| **Synchronous** | Leader waits for follower confirmation before acknowledging write to client | Guaranteed durability on follower; higher write latency; follower outage blocks writes |
| **Asynchronous** | Leader acknowledges write immediately after local write; replicates in background | Lower write latency; leader failure can lose confirmed writes; follower may be stale |
| **Semi-synchronous** | One follower is synchronous, rest are asynchronous | Guarantees data exists on at least two nodes; practical compromise |

PostgreSQL, MySQL, and MongoDB all default to asynchronous replication. This means a write that the leader confirms can be lost if the leader crashes before replicating it.

### Leader Failover

When the leader fails, a follower must be promoted:

1. **Detect failure:** Typically via heartbeat timeouts (e.g., no response for 30 seconds)
2. **Choose new leader:** Consensus among remaining nodes, or human intervention
3. **Reconfigure system:** Clients must send writes to the new leader; old leader must become a follower when it recovers

**Failover dangers:**
- **Split-brain:** Two nodes both believe they are the leader; both accept writes, causing data divergence
- **Lost writes:** If the old leader had unreplicated writes, they are lost (or conflict with new leader's writes)
- **Stale routing:** Clients with cached leader addresses continue writing to the old leader

---

## Replication Lag Problems

Asynchronous replication introduces a delay between a write on the leader and its appearance on followers. This lag causes several anomalies.

### Read-Your-Own-Writes Violation

**Problem:** A user writes data (to the leader), then immediately reads it (from a follower that hasn't received the write yet). The user sees stale data and thinks their write was lost.

**Solutions:**
- Read from the leader for data the user has recently modified (e.g., always read your own profile from the leader)
- Track the timestamp of the user's last write; only read from followers that are caught up to that timestamp
- Client remembers the position in the replication log of its last write and waits for the follower to reach that position

### Monotonic Reads Violation

**Problem:** A user makes two reads in sequence and sees time go backward -- the second read returns older data than the first because it hit a different, more-lagged follower.

**Solutions:**
- Pin each user to a specific follower (session affinity) so consecutive reads go to the same replica
- Track the most recent read timestamp and ensure subsequent reads go to followers at least that current

### Consistent Prefix Reads Violation

**Problem:** Causally related writes appear out of order. A database stores a question and its answer; a reader sees the answer before the question because different partitions have different replication lag.

**Solutions:**
- Ensure causally related writes go to the same partition
- Use causal consistency tracking (vector clocks or Lamport timestamps)

---

## Multi-Leader Replication

### Use Cases

Multi-leader (active-active) replication allows writes at multiple data centers:

- **Multi-datacenter operation:** Each data center has its own leader; writes are fast locally and replicated asynchronously to other data centers
- **Offline-capable clients:** A mobile app with a local database acts as a leader; syncs with server when online (CouchDB, PouchDB model)
- **Collaborative editing:** Each user's local state acts as a leader; changes are merged asynchronously

### Conflict Resolution

When two leaders accept conflicting writes to the same record, the conflict must be resolved:

| Strategy | How It Works | Trade-off |
|----------|-------------|-----------|
| **Last writer wins (LWW)** | Assign a timestamp to each write; highest timestamp wins | Simple but discards concurrent writes; data loss is possible |
| **Merge values** | Combine conflicting values (e.g., union of sets) | Preserves data but only works for certain data types |
| **Application-level resolution** | Store all conflicting versions; let application code resolve | Most flexible but pushes complexity to the application |
| **CRDTs** | Use data structures mathematically guaranteed to converge | Automatic convergence; limited to specific data types (counters, sets, registers) |

### Conflict Example

```
Leader A: UPDATE users SET name = 'Alice Chen' WHERE id = 42;
Leader B: UPDATE users SET name = 'Alice Wang' WHERE id = 42;

LWW result: One name wins (other is silently lost)
Merge result: Not meaningful for names
CRDT (LWW-Register): Last timestamp wins, but the conflict is detected
Application resolution: Show user both versions, ask which is correct
```

---

## Leaderless Replication

### How It Works

In leaderless replication (used by Dynamo, Cassandra, Riak, Voldemort), there is no leader. Clients send writes to multiple replicas directly (or via a coordinator node). Reads also query multiple replicas and reconcile differences.

### Quorum Reads and Writes

Given `n` replicas, a write succeeds if acknowledged by `w` replicas, and a read succeeds if it reads from `r` replicas. As long as `w + r > n`, at least one of the read replicas will have the latest write.

**Common configurations:**
- `n=3, w=2, r=2`: Tolerates 1 unavailable node for both reads and writes
- `n=3, w=3, r=1`: Fastest reads (only need one node), but writes require all nodes
- `n=3, w=1, r=3`: Fastest writes, but reads must query all nodes
- `n=5, w=3, r=3`: Tolerates 2 unavailable nodes

### Sloppy Quorums and Hinted Handoff

When a node is unavailable, a strict quorum would reject the write. A sloppy quorum instead writes to a different node temporarily. When the original node recovers, the temporary node forwards the data (hinted handoff).

This improves write availability but weakens consistency guarantees -- `w + r > n` no longer guarantees reading the latest write because the writes may be on nodes outside the usual `n`.

### Read Repair and Anti-Entropy

Stale replicas need to be updated:

- **Read repair:** When a read query detects a stale replica (by comparing versions), the client writes the latest value back to the stale replica
- **Anti-entropy process:** A background process continuously compares data between replicas and copies missing data. Unlike replication logs, this does not preserve ordering.

---

## CRDTs: Conflict-Free Replicated Data Types

### What CRDTs Are

CRDTs are data structures that can be replicated across multiple nodes, where replicas can be updated independently and concurrently without coordination, and which mathematically guarantee eventual convergence.

### Common CRDT Types

| CRDT | Use Case | How It Works |
|------|----------|-------------|
| **G-Counter** | Counting (only increment) | Each node maintains its own counter; total = sum of all node counters |
| **PN-Counter** | Counting (increment and decrement) | Two G-Counters: one for increments, one for decrements; value = P - N |
| **G-Set** | Set (only add) | Union of all elements across all replicas |
| **OR-Set** | Set (add and remove) | Each element has unique tags; remove deletes specific tags |
| **LWW-Register** | Single value | Last write (by timestamp) wins |
| **MV-Register** | Single value | Keeps all concurrent versions; application resolves |

### CRDT Example: Collaborative Counter

```
Node A starts: count = 0
Node B starts: count = 0

Node A: increment -> local count_A = 1
Node B: increment -> local count_B = 1
Node B: increment -> local count_B = 2

After sync:
Both nodes: total = count_A + count_B = 1 + 2 = 3
```

No conflicts, no coordination, mathematically correct.

### CRDT Limitations

- Only work for specific data types (not arbitrary business logic)
- Can grow in memory over time (tombstones, version vectors)
- Eventual consistency only -- no guarantee of when convergence happens
- Complex to implement correctly from scratch; use libraries (Automerge, Yjs, delta-state CRDTs)

---

## Replication Topology Patterns

### Single-Leader Topologies

```
Star:     Leader --> F1, F2, F3, F4    (all followers connect to leader)
Chain:    Leader --> F1 --> F2 --> F3   (each follower replicates to next)
```

Star is simpler; chain reduces load on the leader but increases replication delay.

### Multi-Leader Topologies

```
All-to-All:   A <--> B <--> C, A <--> C    (every leader replicates to every other)
Star:          A <--> B, A <--> C            (one central leader relays)
Circular:      A --> B --> C --> A            (each sends to the next in a ring)
```

All-to-all is most fault-tolerant but creates more replication traffic. Circular and star topologies have single points of failure.

---

## Practical Replication Configurations

### PostgreSQL Streaming Replication

```
Primary (leader) --> Streaming Replication --> Standby 1 (sync)
                                           --> Standby 2 (async)
                                           --> Standby 3 (async)
```

- Write to primary; read from standbys for scaling
- Synchronous standby guarantees zero data loss on failover
- Asynchronous standbys may lag behind by seconds

### Cassandra (Leaderless)

```
Client --> Coordinator Node --> Replica 1 (write)
                            --> Replica 2 (write)
                            --> Replica 3 (write)

Read: Query 2 of 3 replicas (QUORUM), return most recent
```

- Replication factor (n) set per keyspace
- Consistency level (w, r) set per query
- Tunable consistency: `ONE` for speed, `QUORUM` for safety, `ALL` for strong consistency

### Redis Sentinel (Single-Leader with Automatic Failover)

```
Master --> Replica 1
       --> Replica 2

Sentinel 1, Sentinel 2, Sentinel 3 (monitor master, vote on failover)
```

- Sentinels detect master failure via heartbeats
- Majority of sentinels must agree before promoting a replica
- Client library queries sentinel for current master address
