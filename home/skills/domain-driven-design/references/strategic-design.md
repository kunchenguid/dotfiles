# Strategic Design and Distillation

Strategic design is the practice of identifying which parts of a system matter most and allocating design effort accordingly. Not all code is created equal. Some code is the reason the business exists; other code is necessary plumbing. Domain distillation is the process of separating the essential from the incidental, so that the core of the domain model receives the deepest thought and the best talent.

## The Three Types of Subdomains

Eric Evans classifies every part of a system into one of three subdomain types. This classification drives every major design and investment decision.

### Core Domain

The Core Domain is the part of the system that provides competitive advantage. It is the reason the business exists and what differentiates it from competitors. Without it, the business has no unique value proposition.

**Characteristics:**
- Contains the most complex and nuanced business rules
- Is the source of competitive advantage
- Changes frequently as the business evolves its strategy
- Cannot be outsourced without losing differentiation
- Requires the deepest domain expertise

**Examples:**

| Business | Core Domain | Why It Is Core |
|----------|-------------|----------------|
| Amazon | Recommendation engine, marketplace matching, logistics optimization | These are the algorithms that make Amazon uniquely effective |
| Stripe | Payment processing, fraud detection, developer experience | These are what make Stripe better than alternatives |
| Netflix | Content recommendation, streaming optimization | These keep subscribers engaged and differentiators from competitors |
| Insurance company | Risk assessment, claims adjudication, actuarial modeling | These determine profitability and pricing accuracy |
| Trading firm | Signal generation, execution algorithms, risk management | These are the source of alpha |

**Investment rule:** Put your best developers here. Apply the deepest modeling techniques. This is where DDD patterns earn their complexity cost.

### Supporting Subdomain

A Supporting Subdomain is necessary for the business to function but does not provide competitive advantage. It supports the Core Domain. You build it because off-the-shelf solutions do not fit your specific needs, but you do not need to over-engineer it.

**Characteristics:**
- Custom-built because available solutions do not quite fit
- Important but not differentiating
- Moderately complex; business-specific but not competitively critical
- Can be built by competent developers without deep domain modeling

**Examples:**

| Business | Supporting Subdomain | Why It Is Supporting |
|----------|---------------------|---------------------|
| E-commerce platform | Order management, inventory tracking | Necessary for operations but not what makes this e-commerce site unique |
| Insurance company | Policy administration, document generation | Must work correctly but is not a competitive differentiator |
| Trading firm | Position reporting, compliance reporting | Regulatory requirement, not a source of trading advantage |
| SaaS product | Tenant management, billing integration | Needed but not what customers buy the product for |

**Investment rule:** Build it, but keep it simple. Use straightforward designs. Do not apply deep DDD modeling patterns unless the complexity warrants it.

### Generic Subdomain

A Generic Subdomain is functionality that is common across many businesses and has no business specificity. It is commodity software that you should buy, use open-source, or outsource.

**Characteristics:**
- Not specific to your business; every company needs it
- Well-solved problems with mature solutions available
- Building it yourself is a waste of your best developers' time
- Off-the-shelf solutions are often better than what you would build

**Examples:**

| Generic Subdomain | Buy/Use Instead |
|-------------------|----------------|
| Authentication and authorization | Auth0, Okta, Keycloak, Clerk |
| Email sending | SendGrid, Amazon SES, Postmark |
| Payment processing (if not your core) | Stripe, Braintree, Adyen |
| File storage | Amazon S3, Google Cloud Storage |
| Search indexing | Elasticsearch, Algolia, Typesense |
| Monitoring and alerting | Datadog, Grafana, PagerDuty |
| CMS / Content management | WordPress, Contentful, Sanity |

**Investment rule:** Do not build this. Buy it, use open-source, or outsource it. Every hour your best developer spends building a custom email sender is an hour stolen from the Core Domain.

## Identifying Your Core Domain

### The Differentiation Test

For each part of the system, ask: "If a competitor had exactly the same implementation of this, would we lose our competitive advantage?"

- **Yes, we would lose advantage:** Core Domain
- **No, but we would be inconvenienced:** Supporting Subdomain
- **No, and we could swap it easily:** Generic Subdomain

### The Outsourcing Test

Ask: "Could we outsource this to a competent contractor or replace it with a SaaS product without damaging our competitive position?"

- **No, absolutely not -- this is our secret sauce:** Core Domain
- **Maybe, but it would need customization:** Supporting Subdomain
- **Yes, easily:** Generic Subdomain

### The Talent Test

Ask: "Does working on this require deep expertise in our specific business domain?"

- **Yes -- only people who deeply understand our industry can get this right:** Core Domain
- **Somewhat -- general software skills with some domain knowledge:** Supporting Subdomain
- **No -- any competent developer could implement this:** Generic Subdomain

### Common Misclassification Errors

| Error | Reality | Consequence |
|-------|---------|-------------|
| "Everything is core" | Most things are supporting or generic | Best talent spread thin; nothing gets deep modeling |
| "Our custom CRM is core" | CRM is generic; your customer relationships are core | Team spent years building what Salesforce does better |
| "Authentication is core" | Authentication is generic (unless you are Auth0) | Security expertise wasted on commodity functionality |
| "Infrastructure is core" | Infrastructure is generic (unless you are AWS) | Platform team grows while product team starves |
| "Our billing system is core" | Billing is usually supporting or generic | Over-engineered billing while the actual product suffered |

## Domain Distillation

Distillation is the process of extracting and clarifying the Core Domain from the rest of the system. It makes the most important parts of the model explicit, visible, and well-understood.

### The Domain Vision Statement

A Domain Vision Statement is a short document (one page or less) that describes the Core Domain's value proposition and its most important aspects. It serves as a north star for the team.

**What it contains:**
- What makes this domain unique and valuable
- What distinguishes the Core Domain from everything else in the system
- What the domain model must capture to deliver competitive advantage
- What the team should focus on and what they should explicitly not focus on

**Example for an insurance company:**

> Our competitive advantage is our ability to accurately assess risk in real-time for commercial property insurance. Our core domain model must capture the nuanced relationships between property characteristics, geographic risk factors, historical claims data, and market conditions. The model must support rapid repricing as conditions change. Everything else -- policy administration, document generation, payment processing -- is supporting infrastructure that must work correctly but does not differentiate us.

### The Highlighted Core

The Highlighted Core is a technique for making the Core Domain visually obvious in the codebase and in documentation.

**In documentation:**
- Create a document that marks which modules, classes, and interactions constitute the Core Domain
- Use diagrams that distinguish core from supporting from generic
- Keep this document updated as the model evolves

**In code:**
- Organize the codebase so that Core Domain modules are clearly separated: `domain/core/`, `domain/supporting/`, `infrastructure/`
- Use naming conventions that signal importance: a module called `pricing-engine` conveys more importance than `util-helpers`
- Code review standards can be higher for core domain code (require domain expert sign-off)

### Distillation Techniques

#### Segregated Core

Physically separate the Core Domain from the rest of the codebase. The core should have no dependencies on supporting or generic subdomains -- only the other way around.

```
src/
    core/                           # Core Domain -- deepest modeling
        risk-assessment/
            RiskModel.py
            RiskFactor.py
            UnderwritingRules.py
        pricing/
            PricingEngine.py
            RateTable.py
    supporting/                     # Supporting -- necessary, simpler design
        policy-admin/
            PolicyRepository.py
            PolicyDocument.py
        notifications/
            NotificationService.py
    generic/                        # Generic -- thin wrappers around external services
        email/
            EmailGateway.py
        storage/
            FileStorage.py
        auth/
            AuthenticationAdapter.py
```

#### Abstract Core

Create a distilled model that captures the essential abstractions of the Core Domain without the implementation details. This abstract model serves as a communication tool and a guide for detailed implementation.

The Abstract Core is like an executive summary of the domain model: it captures the key concepts, their relationships, and the most important business rules, without the full detail of every attribute and method.

## Build vs. Buy vs. Outsource

### Decision Framework

| Question | Core Domain | Supporting Subdomain | Generic Subdomain |
|----------|-------------|---------------------|-------------------|
| Should we build it in-house? | **Yes, always** | Yes, if no good fit exists | **No** |
| Should we buy/use SaaS? | **No** -- too important to delegate | Only if it fits well | **Yes, always** |
| Should we outsource development? | **No** -- requires deep domain expertise | Possible with good specs | **Yes** -- or better yet, buy |
| Should we use open-source? | Only as a foundation to build on | Yes, if it fits | **Yes** |
| What quality standard? | Highest -- deep modeling, extensive testing, expert review | Good -- solid engineering, adequate testing | Adequate -- it just needs to work |

### The Opportunity Cost Lens

Every hour spent on non-core work is an hour not spent on the Core Domain. Frame build-vs-buy decisions as opportunity costs:

- "We could build our own email service in 3 months." That is 3 months your best developers are not improving the Core Domain. Use SendGrid.
- "We could build a custom monitoring dashboard in 6 weeks." That is 6 weeks not spent on the pricing engine. Use Grafana.
- "We could build our own authentication system in 2 months." That is 2 months of security engineering not applied to fraud detection. Use Auth0.

### When "Buy" Becomes "Core"

Sometimes a generic subdomain becomes core as the business evolves:

- Stripe started as a payment processor (generic for most businesses) but made payments their Core Domain
- Amazon started as a bookstore; logistics (supporting for most retailers) became a Core Domain that turned into AWS
- Netflix treated content recommendation as core from the beginning, while most video platforms treated it as supporting

**Revisit classifications regularly.** What is generic today may become core tomorrow if the business strategy shifts. Annual or quarterly reviews of subdomain classifications prevent stale assumptions.

## Applying Strategic Design to Team Structure

### Team Allocation by Subdomain Type

| Subdomain Type | Team Characteristics | Practices |
|---------------|---------------------|-----------|
| Core Domain | Senior engineers, domain experts embedded in team, smallest and most skilled team | Deep modeling, event storming, pair programming with domain experts, extensive testing |
| Supporting Subdomain | Mid-level engineers, domain knowledge acquired through documentation | Standard engineering practices, adequate testing, clear interfaces |
| Generic Subdomain | Junior engineers or no team at all (use external service) | Integration work, adapter implementation, vendor management |

### Conway's Law Application

Design team boundaries to match desired bounded context boundaries:

- One team per bounded context (or small number of contexts)
- Core Domain teams should be co-located or closely collaborating
- Supporting Subdomain teams can be more independent
- Generic Subdomain work can be distributed or handled by a platform team

### Investment Over Time

As the system matures, investment should shift:

| Phase | Core Domain Investment | Supporting Investment | Generic Investment |
|-------|----------------------|----------------------|-------------------|
| Early (MVP) | 70% | 20% | 10% (buy everything) |
| Growth | 60% | 25% | 15% (integrate more) |
| Mature | 50% | 30% | 20% (optimize and replace) |

The Core Domain always receives the plurality of investment. If it drops below 50%, the team is likely over-engineering supporting functionality or building generic functionality that should be bought.

## Strategic Design Anti-Patterns

| Anti-Pattern | Signal | Fix |
|-------------|--------|-----|
| "Golden hammer" -- applying Core Domain rigor to everything | Every module has aggregates, repositories, domain events, factories | Classify subdomains; simplify supporting and generic code |
| "Platform first" -- building infrastructure before product | Months spent on logging, monitoring, and deployment before a single domain feature | Use off-the-shelf infrastructure; build Core Domain features first |
| "Resume-driven development" -- choosing technology for novelty | Core Domain uses experimental framework because it is interesting | Choose boring technology for production; innovate in modeling, not infrastructure |
| "Outsourced core" -- contracting out the competitive advantage | Core Domain built by offshore team with no domain expertise | Bring core development in-house; invest in domain expert access |
| "Everyone is equal" -- same standards and investment everywhere | No distinction between a pricing algorithm and a CRUD admin panel | Apply deep modeling only where it pays off; keep the rest simple |
