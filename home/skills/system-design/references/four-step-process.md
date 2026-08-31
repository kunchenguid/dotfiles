# The Four-Step System Design Process

A structured framework for approaching any system design problem. Each step has a clear purpose, time allocation, and set of deliverables.

## Overview

```
Step 1: Understand the Problem & Establish Design Scope  (~5-10 min)
Step 2: Propose High-Level Design & Get Buy-In           (~15-20 min)
Step 3: Design Deep Dive                                  (~15-20 min)
Step 4: Wrap Up                                           (~5 min)
```

Total: ~45-60 minutes for a complete design session. Adjust proportionally for shorter or longer sessions.

---

## Step 1: Understand the Problem & Establish Design Scope

### Purpose

Ensure you and your audience agree on what the system needs to do, how big it needs to be, and what constraints apply. Ambiguity here cascades into wasted effort later.

### What to Do

**Ask clarifying questions.** Never assume. The difference between a system that serves 1,000 users and one that serves 100 million users is fundamental, not incremental.

### Functional Requirements

Define what the system does:

- What are the core features?
- Who are the users? (end users, internal services, third-party integrations)
- What are the key use cases? Walk through the most important user flows.
- What are the inputs and outputs?
- Are there any features explicitly out of scope?

**Example questions for a URL shortener:**
- Can users create custom short URLs or only auto-generated ones?
- Do short URLs expire?
- Do we need analytics (click count, referrer, geo)?
- Do we need to support URL deletion or editing?

### Non-Functional Requirements

Define how the system behaves:

| Requirement | Questions to Ask |
|-------------|-----------------|
| **Scale** | How many DAU? How many requests per day? Peak vs average? |
| **Latency** | What is the acceptable response time? P50, P95, P99? |
| **Availability** | What SLA? 99.9%? 99.99%? |
| **Consistency** | Strong consistency required or eventual consistency acceptable? |
| **Durability** | Can we lose data? What is the acceptable RPO? |
| **Security** | Authentication? Authorization? Encryption at rest/in transit? |

### Back-of-the-Envelope Estimates

Establish order-of-magnitude numbers:

- **QPS:** DAU x actions-per-user / 86,400
- **Peak QPS:** Average QPS x 2-5 (depends on traffic pattern)
- **Storage:** Records-per-day x record-size x retention-period
- **Bandwidth:** QPS x average-response-size

### Deliverables from Step 1

- Written list of functional requirements (3-5 bullet points)
- Written list of non-functional requirements (scale, latency, availability)
- Back-of-the-envelope estimates (QPS, storage, bandwidth)
- Explicit out-of-scope items

### Common Mistakes in Step 1

| Mistake | Consequence | Fix |
|---------|------------|-----|
| Skipping clarification | Solving the wrong problem | Ask at least 5 clarifying questions |
| Assuming scale | Over-engineering or under-engineering | Get explicit DAU and QPS numbers |
| Ignoring non-functional requirements | System works but is too slow/unreliable | Always ask about latency, availability, consistency |
| Spending too long | Not enough time for design | Timebox to 10 minutes maximum |

---

## Step 2: Propose High-Level Design & Get Buy-In

### Purpose

Create a blueprint that shows the major components, their responsibilities, and how data flows between them. This is the "skeleton" that Step 3 will flesh out.

### What to Do

**Draw a diagram.** Include:

1. **Clients:** Web, mobile, API consumers
2. **API Gateway / Load Balancer:** Entry point for requests
3. **Application Services:** The business logic layer, broken into services if appropriate
4. **Data Stores:** Databases, caches, blob storage, search indices
5. **Supporting Infrastructure:** Message queues, CDN, notification services
6. **Data Flow Arrows:** Show the direction and nature of communication (sync HTTP, async queue, etc.)

### API Design

Define the key API endpoints:

```
POST /api/v1/urls        # Create short URL
GET  /api/v1/urls/{id}   # Redirect to original URL
GET  /api/v1/urls/{id}/stats  # Get analytics
```

For each endpoint, specify:
- HTTP method and path
- Request parameters / body
- Response format
- Error codes

### Data Model

Define the core entities and their relationships:

```
URL:
  id: bigint (primary key)
  short_code: varchar(7) (unique index)
  original_url: text
  user_id: bigint (foreign key)
  created_at: timestamp
  expires_at: timestamp (nullable)
  click_count: bigint (default 0)
```

Choose the storage technology:
- Relational (PostgreSQL, MySQL) for structured data with complex queries
- Key-value (Redis, DynamoDB) for simple lookups at massive scale
- Document (MongoDB) for flexible schema
- Wide-column (Cassandra, HBase) for high write throughput with time-series data

### Get Buy-In

Before diving deeper:
- "Does this high-level approach make sense?"
- "Are there any major concerns with this direction?"
- "Should we focus the deep dive on [component A] or [component B]?"

### Deliverables from Step 2

- High-level architecture diagram with labeled components and data flow arrows
- API contract for the core endpoints
- Data model for the primary entities
- Storage technology choice with brief justification
- Agreement on which components deserve a deep dive

---

## Step 3: Design Deep Dive

### Purpose

Take the 2-3 most critical or complex components from the high-level design and design them in detail. This is where you demonstrate depth of knowledge.

### Choosing What to Deep Dive

Pick components that are:
- **Hardest to scale:** The database, the real-time messaging layer, the search index
- **Most critical for correctness:** The payment processor, the consistency model, the rate limiter
- **Most novel or unique:** Whatever makes this system different from a textbook example

### How to Deep Dive

For each component:

**1. State the specific challenge**
"The news feed service needs to assemble a personalized feed from thousands of followed accounts within 200ms."

**2. Explore design options**
Present at least two approaches with tradeoffs:

| Approach | Pros | Cons |
|----------|------|------|
| Fanout-on-write | Fast read, pre-computed | Expensive for celebrity accounts, wastes storage |
| Fanout-on-read | Cheap writes, fresh data | Slow reads, high read-time computation |
| Hybrid | Balanced for most cases | More complex, two code paths |

**3. Choose and justify**
"We choose the hybrid approach because 99% of accounts have < 10K followers (fanout-on-write is cheap), and the 1% celebrity accounts use fanout-on-read to avoid write amplification."

**4. Detail the implementation**
- Data structures and algorithms
- Database schema additions
- Caching strategy
- Error handling and edge cases

### Deep Dive Examples

**URL shortener -- ID generation deep dive:**
- Option A: Auto-increment ID + base62 encoding (simple, sequential, single-point bottleneck)
- Option B: Pre-generated ID ranges per server (distributed, no coordination, slight complexity)
- Option C: Hash of original URL (deterministic, possible collisions, needs collision handling)
- Choice: Option B for scalability with Option C as a fallback for deduplication

**Chat system -- message delivery deep dive:**
- WebSocket connection management at scale
- Message ordering guarantees (per-conversation monotonic IDs)
- Offline message storage and delivery on reconnect
- Read receipts and presence (heartbeat-based, eventual consistency acceptable)

### Deliverables from Step 3

- Detailed design of 2-3 critical components
- Tradeoff analysis for each design decision
- Data structures, schemas, or algorithms where relevant
- Edge case handling

---

## Step 4: Wrap Up

### Purpose

Summarize the design, acknowledge its limitations, and suggest future improvements. This demonstrates maturity and self-awareness.

### What to Cover

**1. Summary of the design**
One-paragraph overview of how the system works end-to-end.

**2. Tradeoffs acknowledged**
- "We chose eventual consistency for the news feed, which means a post may take 1-2 seconds to appear in all followers' feeds."
- "Sharding by user_id means cross-user queries (e.g., trending topics) require scatter-gather."

**3. Bottlenecks identified**
- "The database write path will be the first bottleneck at 50K QPS."
- "Hot users with millions of followers will stress the fanout service."

**4. Future improvements**
- "Add a CDN for frequently accessed short URLs."
- "Implement rate limiting per API key to prevent abuse."
- "Add a circuit breaker for downstream service calls."

**5. Error handling and edge cases**
- What happens when the database is down?
- What happens when the cache is full?
- How do we handle duplicate requests?
- How do we handle schema migrations?

### Deliverables from Step 4

- One-paragraph design summary
- List of acknowledged tradeoffs
- Identified bottlenecks and scaling triggers
- Suggested future improvements

---

## Tips for Each Step

### General Tips

- **Think out loud.** The process is as important as the result.
- **Use numbers.** "A lot of traffic" is vague; "50K QPS" is actionable.
- **Draw diagrams.** Visual communication is clearer than verbal descriptions.
- **Name your tradeoffs.** Every decision has a cost; acknowledging it shows depth.

### Step 1 Tips

- Ask open-ended questions first, then narrow down
- Write down assumptions explicitly -- don't keep them in your head
- If given incomplete information, state your assumption and move on

### Step 2 Tips

- Start with the simplest design that could work, then add complexity
- Label every arrow in the diagram (HTTP, gRPC, async message, etc.)
- Don't design microservices for a system that could be a monolith

### Step 3 Tips

- Go deep on 2-3 things rather than shallow on everything
- Compare at least two approaches before choosing
- Address failure modes: what happens when this component goes down?

### Step 4 Tips

- Be honest about what you didn't cover
- Propose monitoring and alerting for the bottlenecks you identified
- Mention operational concerns: deployment, data migration, feature flags
