# Transactions and Consistency

Transactions are an abstraction layer that simplifies the programming model for applications accessing a database. They bundle multiple reads and writes into a single logical operation that either succeeds completely (commit) or fails completely (abort), with no partial results visible to other operations.

## ACID Properties

### Atomicity

**All or nothing.** If a transaction makes five writes and the system crashes after the third, atomicity guarantees that the first three are rolled back. The database is never left in a half-finished state.

Atomicity is not about concurrency (that is isolation). Atomicity is about what happens when a fault occurs during a multi-step operation.

### Consistency

**Application invariants are preserved.** If your application requires that a credit and debit always sum to zero, consistency means the database won't allow a transaction that violates this rule.

Note: Consistency is primarily an application-level property, not a database guarantee. The database can enforce certain invariants (foreign keys, unique constraints, check constraints), but most business rules must be maintained by application code.

### Isolation

**Concurrent transactions don't interfere.** Each transaction executes as if it were the only transaction running. The degree to which this is actually true depends on the isolation level.

### Durability

**Committed data is not lost.** Once a transaction commits, the data persists even if the system crashes, the power goes out, or disks fail. Implemented through write-ahead logs (WAL), replication, and backups.

**Caveat:** No durability guarantee is absolute. Multiple disk failures, correlated software bugs, or accidental deletion can still cause data loss. Durability is a spectrum, not a binary property.

---

## Isolation Levels

Isolation levels define which concurrency anomalies the database prevents. Higher isolation levels prevent more anomalies but reduce concurrency and performance.

### Read Uncommitted

**Prevents:** Nothing meaningful.
**Allows:** Dirty reads (reading data written by an uncommitted transaction).

Almost never used in practice. A transaction can read another transaction's in-progress, possibly-to-be-rolled-back writes.

### Read Committed

**Prevents:** Dirty reads, dirty writes.
**Allows:** Non-repeatable reads (reading the same row twice in one transaction yields different values because another transaction committed between the two reads).

**How it works:** Reads see only committed data. Writes only overwrite committed data. Implemented with row-level locks for writes and returning the old committed value for reads.

**Default in:** PostgreSQL, Oracle, SQL Server.

```sql
-- Transaction 1                    -- Transaction 2
BEGIN;                              BEGIN;
SELECT balance FROM accounts
  WHERE id = 1;  -- returns 100
                                    UPDATE accounts SET balance = 200
                                      WHERE id = 1;
                                    COMMIT;
SELECT balance FROM accounts
  WHERE id = 1;  -- returns 200 (non-repeatable read!)
COMMIT;
```

### Snapshot Isolation (Repeatable Read)

**Prevents:** Dirty reads, dirty writes, non-repeatable reads.
**Allows:** Write skew, phantoms.

**How it works:** Each transaction sees a consistent snapshot of the database as of the transaction's start time. Implemented with Multi-Version Concurrency Control (MVCC): the database maintains multiple versions of each row, and each transaction sees the version that was committed before the transaction started.

**Default in:** MySQL (InnoDB calls it "repeatable read"), PostgreSQL (as "repeatable read", which is actually snapshot isolation).

```sql
-- Transaction 1 sees a frozen snapshot
BEGIN;
SELECT balance FROM accounts WHERE id = 1;  -- returns 100
-- Even if another transaction changes balance to 200 and commits,
-- Transaction 1 still sees 100 for the rest of its lifetime
SELECT balance FROM accounts WHERE id = 1;  -- still returns 100
COMMIT;
```

**Key benefit:** Long-running reads (analytics, backups) don't block writes, and writes don't block reads.

### Serializable

**Prevents:** All concurrency anomalies.
**Guarantees:** Transactions execute as if they ran one after another, in some serial order.

Three implementation approaches:

#### Actual Serial Execution

Run all transactions on a single CPU core, one at a time.

**Strengths:** No concurrency bugs possible; simple implementation.
**Weaknesses:** Limited to single-core throughput; transactions must be short; no multi-statement interactive transactions.
**Used by:** VoltDB, Redis (single-threaded command execution).

#### Two-Phase Locking (2PL)

Readers block writers, and writers block readers. A transaction acquires locks as it reads and writes; it releases all locks only at commit or abort.

**Strengths:** Provides true serializability.
**Weaknesses:** Poor performance under contention; deadlocks are possible and require detection/resolution; can severely limit concurrency.
**Used by:** MySQL (InnoDB serializable mode), DB2.

```
Transaction A: Acquires shared lock on row X (for reading)
Transaction B: Wants exclusive lock on row X (for writing) -> BLOCKED
Transaction A: Commits -> releases lock
Transaction B: Acquires exclusive lock, proceeds
```

**Deadlock example:**
```
Transaction A: Lock row 1, then wants to lock row 2
Transaction B: Lock row 2, then wants to lock row 1
-> Deadlock! Database must abort one transaction.
```

#### Serializable Snapshot Isolation (SSI)

An optimistic approach: transactions execute without blocking, and the database checks for conflicts at commit time. If a conflict is detected, one transaction is aborted and retried.

**Strengths:** No blocking; reads never block writes; good performance under low contention.
**Weaknesses:** Under high contention, many transactions are aborted and retried, wasting work.
**Used by:** PostgreSQL (serializable mode since 9.1), CockroachDB.

---

## Write Skew and Phantoms

### Write Skew

Write skew occurs when two transactions read the same data, make decisions based on it, and write to different records. No single row is written by both transactions, so row-level locks don't prevent it.

**Classic example: On-call doctors**

```sql
-- Rule: At least one doctor must be on call at all times
-- Currently: Alice and Bob are both on call

-- Alice's transaction                  -- Bob's transaction
BEGIN;                                  BEGIN;
SELECT count(*) FROM doctors            SELECT count(*) FROM doctors
  WHERE on_call = true;                   WHERE on_call = true;
-- count = 2, safe to remove one        -- count = 2, safe to remove one
UPDATE doctors SET on_call = false      UPDATE doctors SET on_call = false
  WHERE name = 'Alice';                   WHERE name = 'Bob';
COMMIT;                                 COMMIT;

-- Result: NO doctors on call! Invariant violated.
```

Both transactions read count=2, both decided it was safe to go off-call, both committed. Neither wrote to the same row, so no row-level conflict was detected.

### Phantoms

A phantom occurs when a transaction's write changes the result set of another transaction's query. The write creates or removes rows that match the other transaction's WHERE clause.

**Example: Meeting room booking**

```sql
-- Transaction A                       -- Transaction B
BEGIN;                                  BEGIN;
SELECT count(*) FROM bookings           SELECT count(*) FROM bookings
  WHERE room = 101                        WHERE room = 101
  AND time = '2pm';                       AND time = '2pm';
-- count = 0, room is free              -- count = 0, room is free
INSERT INTO bookings                    INSERT INTO bookings
  (room, time, user)                      (room, time, user)
  VALUES (101, '2pm', 'Alice');           VALUES (101, '2pm', 'Bob');
COMMIT;                                 COMMIT;
-- Double booking!
```

### Preventing Write Skew

| Approach | How It Works | Limitation |
|----------|-------------|------------|
| **Serializable isolation** | Database detects and prevents all conflicts | Performance overhead |
| **SELECT FOR UPDATE** | Locks the rows that the decision is based on | Only works if there are existing rows to lock (doesn't prevent phantoms on non-existent rows) |
| **Materializing conflicts** | Pre-create rows that can be locked (e.g., create booking slots for every room-time combination) | Ugly, application-specific, error-prone |
| **Application-level locks** | Use an external lock service (Redis, ZooKeeper) | Moves complexity out of the database; risk of lock contention |
| **Unique constraints** | Database-enforced uniqueness prevents phantom inserts | Only works for simple cases |

---

## Distributed Transactions

### Two-Phase Commit (2PC)

2PC coordinates a transaction across multiple nodes (or databases):

**Phase 1 - Prepare:**
```
Coordinator -> Node A: "Prepare to commit transaction T"
Coordinator -> Node B: "Prepare to commit transaction T"
Node A -> Coordinator: "Yes, I can commit"
Node B -> Coordinator: "Yes, I can commit"
```

**Phase 2 - Commit:**
```
Coordinator -> Node A: "Commit transaction T"
Coordinator -> Node B: "Commit transaction T"
```

If any node votes "no" in phase 1, the coordinator sends "abort" to all nodes.

### 2PC Problems

- **Blocking:** If the coordinator crashes after sending "prepare" but before sending "commit/abort," participants are stuck holding locks, unable to commit or abort, potentially forever
- **Performance:** Two network round-trips plus lock holding time; 10-100x slower than single-node transactions
- **Single point of failure:** The coordinator is a critical dependency; its failure blocks all participants
- **In-doubt transactions:** Participants that voted "yes" in phase 1 cannot safely commit or abort without hearing from the coordinator

### Alternatives to Distributed Transactions

| Alternative | How It Works | Trade-off |
|-------------|-------------|-----------|
| **Saga pattern** | Break transaction into a sequence of local transactions; each step has a compensating transaction for rollback | No atomicity guarantee; compensating actions can be complex; eventual consistency |
| **Outbox pattern** | Write to the local database and an outbox table atomically; a separate process reads the outbox and publishes events | At-least-once delivery; consumers must be idempotent |
| **Event sourcing** | Store events as the source of truth; derive state from event log | Different programming model; eventual consistency for derived views |
| **Single-partition design** | Design your data model so that related data lives on the same partition | Constrains data model; may not work for all use cases |

---

## Consensus and Distributed Agreement

### The Consensus Problem

Multiple nodes must agree on a value (e.g., who is the leader, whether a transaction should commit). Consensus must satisfy:

- **Agreement:** All nodes decide the same value
- **Validity:** The decided value was proposed by some node
- **Termination:** All non-faulty nodes eventually decide
- **Integrity:** Each node decides at most once

### Consensus Algorithms

| Algorithm | Used By | Key Feature |
|-----------|---------|-------------|
| **Paxos** | Google (Chubby, Spanner) | Mathematically proven; notoriously hard to implement correctly |
| **Raft** | etcd, CockroachDB, TiKV | Designed for understandability; leader-based with log replication |
| **Zab** | ZooKeeper | Similar to Paxos; used for ZooKeeper's atomic broadcast |
| **Viewstamped Replication** | Academic | Predecessor to Raft; similar approach |

### Practical Consensus: What You Actually Use

Most applications don't implement consensus directly. Instead, they use consensus-based services:

- **ZooKeeper/etcd:** Distributed key-value store with strong consistency; used for service discovery, leader election, distributed locks, configuration management
- **Consul:** Service mesh with consensus-based service catalog
- **Google Spanner:** Globally distributed database with external consistency (linearizability + serializable isolation) using TrueTime and Paxos

### CAP Theorem in Practice

The CAP theorem states that in the presence of a network partition (P), a system must choose between consistency (C) and availability (A). In practice:

- **CP systems:** Sacrifice availability during partitions; refuse to serve requests if they can't guarantee consistency (e.g., ZooKeeper, HBase, Spanner)
- **AP systems:** Sacrifice consistency during partitions; continue serving requests with potentially stale data (e.g., Cassandra, DynamoDB, CouchDB)

**Important nuance:** CAP is about the behavior during a network partition, which is a rare event. During normal operation, you can have both consistency and availability. The question is: what happens when the network fails?

Most real-world systems are not purely CP or AP. They offer tunable consistency, where the application can choose per-operation whether to prioritize consistency or availability.
