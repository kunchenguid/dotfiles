# The Dependency Rule and Concentric Circles

The Dependency Rule is the single most important concept in Clean Architecture. It states that source code dependencies can only point inward. Nothing in an inner circle can know anything at all about something in an outer circle. This includes names -- functions, classes, variables, data formats, or any other named software entity declared in an outer circle must not be mentioned by code in an inner circle.

This reference covers the concentric circles model, how data crosses boundaries, why direction matters, how frameworks violate the rule, and how to keep the inner circle pure.

## The Concentric Circles

Clean Architecture organizes code into concentric circles, each representing a different level of abstraction and policy. The innermost circles contain the highest-level, most general policies. The outermost circles contain the lowest-level, most concrete details.

### Circle 1: Entities (Innermost)

Entities encapsulate enterprise-wide business rules. These are the most general, most stable rules in the system. They are the least likely to change when something external changes -- a page navigation change, a security policy change, or a database migration should not affect entities.

**Characteristics of well-designed entities:**
- They can be simple objects with methods, or they can be a set of data structures and functions
- They encapsulate the most critical business rules
- They have no dependency on anything in the outer circles
- They would exist even if no software system existed (the rules are inherent to the business)
- They are the most reusable elements across different applications in the enterprise

**Example:**

```python
class LoanApplication:
    def __init__(self, applicant_income: float, requested_amount: float, credit_score: int):
        self.applicant_income = applicant_income
        self.requested_amount = requested_amount
        self.credit_score = credit_score

    def debt_to_income_ratio(self) -> float:
        return self.requested_amount / (self.applicant_income * 12)

    def is_creditworthy(self) -> bool:
        return self.credit_score >= 680 and self.debt_to_income_ratio() < 0.43
```

This entity knows nothing about databases, HTTP, or frameworks. It encapsulates the business rule that determines creditworthiness.

### Circle 2: Use Cases

Use Cases contain application-specific business rules. They orchestrate the flow of data to and from entities and direct those entities to use their enterprise-wide business rules to achieve the goals of the use case.

**Characteristics:**
- They define and implement input and output port interfaces
- They manipulate entities to achieve application goals
- Changes to use cases do not affect entities
- Changes to external layers (database, UI) do not affect use cases

### Circle 3: Interface Adapters

This circle contains adapters that convert data between the format most convenient for the use cases and entities and the format most convenient for some external agency such as the database or the web.

**Contains:**
- Controllers (translate inbound requests to use case input)
- Presenters (translate use case output to external format)
- Gateways (implement repository interfaces using specific technologies)

### Circle 4: Frameworks and Drivers (Outermost)

The outermost layer is composed of frameworks and tools -- the database, the web framework, the messaging system. This is where all the details go. The web is a detail. The database is a detail. We keep these things on the outside where they can do little harm.

**Contains:**
- Web framework (Express, Spring, Django, Rails)
- Database engine and ORM
- External service clients
- Device drivers and I/O

## The Direction of Dependencies

The arrow of dependency is not the same as the arrow of control flow. Control flow can go in any direction across a boundary. Source code dependencies, however, must always point inward.

### How Control Flow Opposes Dependency Direction

Consider this scenario: a controller needs to call a use case, and the use case needs to call a presenter. The control flows outward (from use case to presenter), but the dependency must point inward (presenter depends on use case, not the other way around).

The mechanism is Dependency Inversion:

```
Controller --> [Use Case Input Port] <-- Use Case Interactor --> [Use Case Output Port] <-- Presenter
```

The Use Case defines both the Input Port (which the Controller calls) and the Output Port (which the Presenter implements). The Use Case never knows about the Controller or the Presenter directly. It only knows about the interfaces it defines.

```python
# Defined in the Use Case circle
class PlaceOrderOutputPort(ABC):
    @abstractmethod
    def present_success(self, response: OrderResponse) -> None:
        pass

    @abstractmethod
    def present_failure(self, error: str) -> None:
        pass

# Defined in the Use Case circle
class PlaceOrderInteractor:
    def __init__(self, order_repo: OrderRepository, presenter: PlaceOrderOutputPort):
        self.order_repo = order_repo
        self.presenter = presenter

    def execute(self, request: PlaceOrderRequest) -> None:
        order = Order.create(request.items, request.customer_id)
        self.order_repo.save(order)
        self.presenter.present_success(OrderResponse(order.id, order.total))

# Defined in the Adapters circle -- implements the Use Case's interface
class JsonOrderPresenter(PlaceOrderOutputPort):
    def present_success(self, response: OrderResponse) -> None:
        self.view_model = {"order_id": response.id, "total": str(response.total)}

    def present_failure(self, error: str) -> None:
        self.view_model = {"error": error}
```

The Interactor defines `PlaceOrderOutputPort`. The `JsonOrderPresenter` in the outer circle implements it. The dependency points inward even though control flows outward.

## Data Crossing Boundaries

When data crosses a boundary, it is always in the form that is most convenient for the inner circle. The outer circle must adapt its data into the form expected by the inner circle.

### Principle: Inner Circle Dictates Data Format

**Wrong -- outer circle format leaking inward:**

```python
# Use Case receives a Django request object (framework dependency)
class CreateUserInteractor:
    def execute(self, request: HttpRequest):  # VIOLATION: knows about Django
        data = json.loads(request.body)
        user = User(name=data['name'])
```

**Right -- inner circle defines its own data structure:**

```python
# Use Case defines its own request model
@dataclass
class CreateUserRequest:
    name: str
    email: str

class CreateUserInteractor:
    def execute(self, request: CreateUserRequest):  # Pure data structure
        user = User(name=request.name, email=request.email)
```

The Controller in the outer circle is responsible for translating the HTTP request into the `CreateUserRequest`.

### Crossing Data Patterns

| Pattern | When to Use | Example |
|---------|-------------|---------|
| **Request/Response DTOs** | Standard use case boundaries | `CreateOrderRequest` and `CreateOrderResponse` as plain data classes |
| **Primitives** | Simple boundaries with few parameters | `get_user(user_id: str) -> UserResponse` |
| **Domain events** | Communicating between bounded contexts | `OrderPlaced(order_id, timestamp)` emitted by inner circle |
| **Data maps (dicts)** | Crossing boundaries where type safety is less critical | Acceptable in dynamic languages; prefer typed DTOs in static ones |

### What Must Not Cross Boundaries

- **ORM entities or database rows**: These are outer circle artifacts. Never pass an ActiveRecord model into a Use Case.
- **Framework request/response objects**: `HttpRequest`, `HttpResponse`, `Request`, `Response` -- all belong in the outer circle.
- **Third-party library types**: If your Use Case accepts an `AwsS3Object`, you've coupled business logic to AWS.

## How Frameworks Violate the Dependency Rule

Frameworks want to be the center of your universe. They ask you to subclass their base classes, decorate your code with their annotations, and structure your project according to their conventions. Every such demand is a dependency pointing outward-to-inward -- a violation.

### Common Framework Violations

| Framework Pattern | Violation | Fix |
|-------------------|-----------|-----|
| **ORM annotations on entities** | Entity depends on database framework | Separate domain entity from ORM model; map between them |
| **Controller base classes** | Business logic inherits framework code | Use composition: controller holds a reference to the interactor |
| **Framework-specific return types** | Use Case returns `ResponseEntity` or `JsonResponse` | Return plain DTOs; let the adapter format the response |
| **Dependency injection via framework** | Inner circle annotated with `@Inject`, `@Autowired` | Use constructor injection with plain interfaces; wire in Main |
| **Validation annotations** | Business validation tied to framework | Validate in the use case using plain code or a domain validator |

### Keeping Frameworks at Arm's Length

The key insight is to treat the framework as a plugin, not as your architecture:

1. **Don't derive from framework base classes** in your business logic. If the framework requires inheritance, create a thin adapter that inherits from the framework class and delegates to your clean inner code.

2. **Don't scatter framework annotations** throughout your domain. If you must use annotations for ORM mapping, do so on a separate persistence model that maps to and from your domain entity.

3. **Structure your project by business capability**, not by framework convention. Instead of `controllers/`, `models/`, `services/` (framework-driven), use `orders/`, `payments/`, `shipping/` (domain-driven), each with its own layers inside.

## Keeping the Inner Circle Pure

The inner circle is the most valuable part of the system because it contains the rules that make the business money. Protecting it from contamination requires vigilance.

### Purity Checklist

- **No imports from outer circles**: Grep your entity and use case code for imports of framework, database, or infrastructure packages. There should be none.
- **No I/O**: Inner circle code never reads from a file, queries a database, or makes an HTTP call directly. It calls an interface, and the outer circle provides the implementation.
- **No global state or singletons** that come from outer circles: If a use case accesses `Settings.DATABASE_URL`, it depends on infrastructure.
- **No concurrency primitives** from the framework: Threads, async runtime, and event loops are outer circle concerns. Use cases should be synchronous-looking; the adapter handles async mechanics.
- **Testable in isolation**: If you cannot instantiate a use case with mock implementations and run it without starting any server, database, or framework, the inner circle is not pure.

### Enforcement Strategies

| Strategy | How It Works | Tools |
|----------|-------------|-------|
| **Architecture tests** | Automated tests that verify import rules | ArchUnit (Java), Dependency Cruiser (JS/TS), import-linter (Python) |
| **Module boundaries** | Language-level visibility (packages, modules) | Java modules, Go internal packages, Rust `pub(crate)` |
| **Build system separation** | Inner and outer circles are separate build targets | Separate Gradle modules, npm packages, or Python packages |
| **Code review rules** | Manual review for dependency direction violations | PR checklist: "Do any new imports in the domain cross outward?" |

### The Four-Step Inversion Process

When you discover an outward dependency in an inner circle:

1. **Identify the dependency**: What concrete outer-circle class is being referenced?
2. **Define an interface in the inner circle** that describes what the inner circle needs (not what the outer circle provides).
3. **Move the concrete implementation to the outer circle**, implementing the inner circle's interface.
4. **Wire the dependency in Main** (the composition root), injecting the concrete implementation into the inner circle at startup.

This process always works. It may feel like ceremony, but it's the mechanism that keeps the most valuable code in your system independent of the most volatile.

## The Dependency Rule in Practice: A Complete Example

Consider an e-commerce system handling order placement:

```
[HTTP Layer]                     [Use Case Layer]              [Entity Layer]
Express Route Handler  -->  PlaceOrderInteractor  -->  Order.create()
                             |                          Order.calculateTotal()
                             v
                        OrderRepository (interface)
                             ^
                             |
[Persistence Layer]
PostgresOrderRepository (implements OrderRepository)
```

Dependencies:
- Express Route Handler depends on PlaceOrderInteractor (inward) -- correct
- PlaceOrderInteractor depends on Order (inward) -- correct
- PlaceOrderInteractor depends on OrderRepository interface (same circle) -- correct
- PostgresOrderRepository depends on OrderRepository interface (inward) -- correct
- Express Route Handler does NOT appear in any inner circle -- correct
- PostgreSQL does NOT appear in any inner circle -- correct

The Dependency Rule is satisfied. The business rules (Order, PlaceOrderInteractor) know nothing about Express or PostgreSQL. You could swap both without changing a single line of business logic.
