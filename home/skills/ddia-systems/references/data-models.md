# Data Models and Query Languages

Choosing a data model is the most consequential architectural decision in an application. The data model shapes not only how data is stored, but how you think about the problem domain, what queries are natural, and how the system evolves over time.

## The Relational Model

### When Relational Excels

The relational model, formalized by Edgar Codd in 1970, represents data as tables (relations) of rows (tuples) with typed columns (attributes). Its strength lies in:

- **Many-to-many relationships:** Foreign keys and joins make it natural to represent complex relationships without data duplication
- **Ad-hoc queries:** SQL's declarative nature lets you ask any question without pre-planned access paths
- **Referential integrity:** Foreign key constraints enforce that references point to existing records
- **Transaction support:** ACID transactions with mature isolation levels are standard
- **Schema enforcement (schema-on-write):** The database rejects data that doesn't conform to the schema, catching errors early

### Relational Anti-Patterns

The relational model struggles with:

- **Object-relational impedance mismatch:** Application objects don't map cleanly to flat tables; ORMs paper over this but add complexity
- **Deeply nested or tree-structured data:** Representing a resume with multiple jobs, each with multiple projects, each with multiple technologies requires many joins
- **Schema rigidity:** Adding a column to a table with billions of rows can be operationally expensive (though many databases now support instant `ADD COLUMN`)
- **Horizontal scaling:** Distributing joins across nodes is fundamentally hard

### SQL as a Query Language

SQL is declarative: you specify what you want, not how to get it. The optimizer chooses the execution plan, which means:

- Query performance can improve without changing application code (when the optimizer or indexes improve)
- Complex queries are concise compared to imperative alternatives
- The optimizer can parallelize, reorder joins, and choose index strategies

```sql
-- Find all users who placed an order in the last 30 days
-- and have a shipping address in California
SELECT DISTINCT u.name, u.email
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN addresses a ON u.id = a.user_id
WHERE o.created_at > NOW() - INTERVAL '30 days'
  AND a.state = 'CA'
  AND a.type = 'shipping';
```

This query would require nested loops, hash maps, and set operations in imperative code. SQL expresses the intent in six lines.

---

## The Document Model

### When Document Excels

Document databases (MongoDB, CouchDB, Firestore) store data as self-contained documents, typically JSON or BSON:

- **One-to-many relationships:** When a parent entity contains a list of child entities that are always accessed together, a document model avoids joins entirely
- **Data locality:** Reading a single document retrieves all related data in one disk seek, improving read performance for aggregate access
- **Schema flexibility (schema-on-read):** Each document can have a different structure; the application interprets the schema at read time
- **Natural fit for aggregates:** Domain-driven design aggregates map directly to documents

### Document Example

```json
{
  "user_id": "u-4829",
  "name": "Alice Chen",
  "email": "alice@example.com",
  "addresses": [
    {"type": "home", "city": "San Francisco", "state": "CA"},
    {"type": "work", "city": "Palo Alto", "state": "CA"}
  ],
  "orders": [
    {
      "order_id": "o-1001",
      "items": [
        {"product": "Keyboard", "qty": 1, "price": 89.99},
        {"product": "Mouse", "qty": 2, "price": 29.99}
      ],
      "total": 149.97
    }
  ]
}
```

Everything about a user is in one document. No joins needed for the common access pattern of "show me everything about this user."

### Document Anti-Patterns

- **Many-to-many relationships:** Without joins, you must denormalize (duplicate data) or perform multiple queries and join in application code
- **Cross-document references:** If order items reference a shared product catalog, updating a product name requires updating every document that embeds it
- **Large documents:** Documents that grow unboundedly (e.g., an array of all user events) cause write amplification because the entire document must be rewritten
- **Deep nesting:** Querying deeply nested fields is possible but awkward; updating nested fields requires careful path expressions

---

## The Graph Model

### When Graph Excels

Graph databases (Neo4j, Amazon Neptune, JanusGraph) represent data as nodes (entities) and edges (relationships):

- **Highly interconnected data:** Social networks, knowledge graphs, fraud detection, recommendation engines
- **Recursive traversals:** "Find all people within 3 degrees of connection" is natural in graph query languages but requires recursive CTEs or multiple joins in SQL
- **Heterogeneous data:** Nodes and edges can have different types and properties without schema changes
- **Path analysis:** Shortest path, centrality, community detection algorithms are built into graph engines

### Graph Query Example (Cypher)

```cypher
// Find mutual friends who live in the same city
MATCH (alice:Person {name: 'Alice'})-[:FRIENDS_WITH]->(mutual)<-[:FRIENDS_WITH]-(bob:Person {name: 'Bob'})
WHERE mutual.city = alice.city
RETURN mutual.name, mutual.city
```

The equivalent SQL query would require self-joins and subqueries that obscure the intent.

### Graph Anti-Patterns

- **Simple CRUD operations:** Graph databases add overhead for straightforward create/read/update/delete without relationship traversals
- **Aggregation-heavy analytics:** Summing, counting, and grouping are more natural in SQL or column stores
- **Write-heavy workloads:** Graph index structures can be slower for bulk ingestion compared to LSM-tree stores

---

## Schema-on-Write vs. Schema-on-Read

| Aspect | Schema-on-Write (Relational) | Schema-on-Read (Document) |
|--------|------------------------------|---------------------------|
| **When schema is enforced** | At write time by the database | At read time by application code |
| **Error detection** | Immediate: bad data is rejected | Delayed: bad data is stored, fails at read |
| **Schema evolution** | ALTER TABLE (can be expensive) | Just start writing new fields |
| **Data quality** | Higher: database enforces constraints | Lower: application must validate |
| **Flexibility** | Lower: must define schema upfront | Higher: can iterate quickly |
| **Best for** | Structured data with known schema | Semi-structured data with evolving schema |

### Practical Guidance

Use schema-on-write when:
- Data integrity is critical (financial, medical, legal)
- Multiple applications share the same database
- You need complex queries across the dataset

Use schema-on-read when:
- The schema is evolving rapidly (early-stage product)
- Data comes from external sources with varying structure
- Each record type is accessed as a self-contained unit

---

## Query Languages Compared

### SQL (Relational)

Strengths: Mature, standardized, powerful optimizer, excellent tooling.
Weaknesses: Verbose for hierarchical data, recursive queries are awkward.

### MongoDB Query Language (Document)

```javascript
db.users.find({
  "addresses.state": "CA",
  "orders.created_at": { $gte: ISODate("2024-01-01") }
})
```

Strengths: Natural for document traversal, aggregation pipeline is powerful.
Weaknesses: No joins (until v3.2 $lookup, still limited), complex aggregations are hard to read.

### Cypher (Graph)

Strengths: Pattern matching for relationships, readable path expressions.
Weaknesses: Limited ecosystem, fewer tools and integrations.

### MapReduce (Batch)

```javascript
// Word count in MapReduce
map: function() { this.text.split(" ").forEach(w => emit(w, 1)); }
reduce: function(key, values) { return Array.sum(values); }
```

Strengths: Horizontally scalable, handles massive datasets.
Weaknesses: Low-level, hard to compose, high latency.

---

## Data Model Evolution

### Adding Fields

- **Relational:** `ALTER TABLE users ADD COLUMN phone VARCHAR(20);` -- all rows get NULL until updated
- **Document:** Just start including `phone` in new documents; old documents simply lack the field
- **Graph:** Add a new property to nodes; existing nodes are unaffected

### Changing Relationships

- **Relational:** Add a junction table for many-to-many; migrate data
- **Document:** Restructure documents; may require a migration script for existing data
- **Graph:** Add new edge types between existing nodes

### Breaking Changes

In all models, renaming or removing fields requires backward-compatible migration:

1. **Expand:** Add new field alongside old
2. **Migrate:** Backfill new field from old
3. **Contract:** Remove old field once all readers use new field

This expand-migrate-contract pattern works regardless of data model.

---

## Polyglot Persistence

Most real-world systems benefit from using multiple data stores, each chosen for its strengths:

| Use Case | Data Store | Reason |
|----------|-----------|--------|
| **Transactional records** | PostgreSQL | ACID, joins, referential integrity |
| **User sessions** | Redis | Sub-millisecond reads, TTL expiration |
| **Full-text search** | Elasticsearch | Inverted indexes, relevance scoring |
| **Activity feed** | Cassandra | High write throughput, time-series partitioning |
| **Recommendation graph** | Neo4j | Relationship traversal, path algorithms |
| **File/blob storage** | S3 | Unlimited capacity, durability |
| **Analytics** | ClickHouse/BigQuery | Column-oriented, fast aggregation |

### Polyglot Challenges

- **Data consistency:** How do you keep PostgreSQL and Elasticsearch in sync? Change data capture (CDC) is the standard answer
- **Operational complexity:** Each store requires monitoring, backup, and expertise
- **Query routing:** Application must know which store to query for which use case

### When to Stay Monoglot

Use a single database when:
- Your team is small and operational complexity is a bigger risk than suboptimal performance
- Your data fits comfortably in one model (most CRUD apps)
- Your query patterns are uniform (all point lookups, or all analytical scans)

Add a second store only when you have measured evidence that the current store cannot serve a specific access pattern.

---

## Data Model Migration Patterns

### Relational to Document

Common when an application starts with a relational database but finds that most queries fetch entire aggregate objects (user profiles, product listings) rather than joining across tables. The migration pattern:

1. Identify aggregates that are always fetched together
2. Denormalize related tables into nested document structures
3. Accept data duplication for fields that are shared across aggregates (e.g., category names stored in both the category table and embedded in product documents)
4. Maintain a relational database for data that genuinely requires joins and referential integrity

### Document to Relational

Common when an application starts with a document database but discovers increasing need for cross-document queries, reporting, or referential integrity. Warning signs include frequent application-level joins, growing inconsistency from denormalized data, and complex aggregation queries that fight the document model.

### Adding a Graph Layer

When relationships between entities become a first-class concept (recommendations, fraud detection, knowledge graphs), adding a graph database alongside existing stores is often more practical than migrating. The graph database handles traversal queries while the primary store handles CRUD operations. Data synchronization between the stores is typically handled through CDC or periodic ETL jobs.
