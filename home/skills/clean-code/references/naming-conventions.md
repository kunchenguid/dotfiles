# Naming Conventions

Comprehensive guide to choosing names that reveal intent, avoid disinformation, and make code read like well-written prose. Based on Robert C. Martin's *Clean Code*, Chapter 2.

## The Golden Rule

**A name should tell you why it exists, what it does, and how it is used.** If a name requires a comment to explain it, the name does not reveal its intent.

---

## Intention-Revealing Names

The name of a variable, function, or class should answer three questions:
1. Why does it exist?
2. What does it do?
3. How is it used?

### Before and After

| Before | After | Why it's better |
|--------|-------|-----------------|
| `d` | `elapsedTimeInDays` | Reveals what the number represents |
| `list` | `flaggedAccounts` | Describes *which* list and *why* it exists |
| `hp` | `isHighPriority` | Self-documents its boolean nature and meaning |
| `temp` | `unprocessedBatchItems` | Communicates purpose, not temporary status |
| `x`, `y` | `latitude`, `longitude` | Domain language replaces abstract math symbols |
| `val` | `discountPercentage` | Specifies what value and its unit |
| `data` | `customerOrderHistory` | Names the specific data, not the generic concept |
| `info` | `shippingTrackingDetails` | Adds specificity to a meaningless suffix |

### Code Example

```python
# BAD: What does this do?
def get_them(the_list):
    result = []
    for x in the_list:
        if x[0] == 4:
            result.append(x)
    return result

# GOOD: Intention is revealed
def get_flagged_cells(game_board):
    flagged_cells = []
    for cell in game_board:
        if cell.is_flagged():
            flagged_cells.append(cell)
    return flagged_cells
```

---

## Avoiding Disinformation

Disinformation means using names that imply something different from the actual meaning.

**Rules:**
- Don't use `accountList` unless it is actually a `List` type -- use `accounts` or `accountGroup`
- Don't use names that vary in small ways: `XYZControllerForEfficientHandlingOfStrings` vs `XYZControllerForEfficientStorageOfStrings`
- Don't use lowercase `L` or uppercase `O` as variable names (look like `1` and `0`)
- Don't use names of other well-known entities: `hp`, `aix`, `sco` are Unix platform names

### Common Disinformation Patterns

| Disinformation | Problem | Fix |
|----------------|---------|-----|
| `accountList` when it's a `Set` | Implies ordered, duplicates allowed | Use `accounts` |
| `name1`, `name2` | Implies ordering or relationship that doesn't exist | Use meaningful distinction: `firstName`, `lastName` |
| `strName` | Hungarian notation; type may change | Just use `name` |
| `theAccount` vs `account` | No meaningful distinction | Pick one, use it consistently |

---

## Meaningful Distinctions

If names must be different, they should mean something different.

**Noise words are meaningless distinctions:**
- `Product` vs `ProductInfo` vs `ProductData` -- what's the difference?
- `getAccount()` vs `getAccountInfo()` vs `getAccountData()` -- indistinguishable
- `name` vs `nameString` -- is `name` a floating-point number?

**The test:** If you cannot tell what two similarly named things do without reading their implementations, the names fail.

### How to Make Meaningful Distinctions

| Instead of | Use | Rationale |
|------------|-----|-----------|
| `copyChars(a1, a2)` | `copyChars(source, destination)` | Arguments reveal their role |
| `moneyAmount` vs `money` | Just `money` | Amount is implied by the context |
| `theMessage` vs `message` | Just `message` | The article adds no information |
| `accountData` vs `account` | Just `account` | Data is inherent -- what else would it be? |

---

## Pronounceable Names

If you cannot pronounce a name, you cannot discuss it without sounding foolish.

| Unpronounceable | Pronounceable |
|-----------------|---------------|
| `genymdhms` | `generationTimestamp` |
| `modymdhms` | `modificationTimestamp` |
| `pszqint` | `formattedQuantity` |
| `cstmrAddr` | `customerAddress` |

**Why it matters:** Programming is a social activity. You discuss code in reviews, pairing, design meetings, and stand-ups. Names you cannot say out loud create communication barriers.

---

## Searchable Names

Single-letter names and numeric constants are impossible to search for in a large codebase.

**Rule of thumb:** The length of a name should correspond to the size of its scope.

| Scope | Name length | Example |
|-------|-------------|---------|
| Single-line lambda | 1 character acceptable | `items.map(x => x.id)` |
| Loop body (3-5 lines) | 1-2 characters acceptable | `for i in range(len(items))` |
| Method scope | Descriptive word(s) | `retryCount`, `matchingUser` |
| Class scope | Fully descriptive phrase | `maximumQueueCapacity` |
| Module/global scope | Complete, searchable phrase | `DEFAULT_CONNECTION_TIMEOUT_MS` |

### Constants Must Be Named

```javascript
// BAD: What does 5 mean? What does 7 mean?
if (retries > 5) { ... }
setTimeout(fn, 7 * 86400000);

// GOOD: Self-documenting
const MAX_RETRY_ATTEMPTS = 5;
const CACHE_EXPIRY_DAYS = 7;
const MS_PER_DAY = 86400000;

if (retries > MAX_RETRY_ATTEMPTS) { ... }
setTimeout(fn, CACHE_EXPIRY_DAYS * MS_PER_DAY);
```

---

## Class Names vs. Method Names

### Class Names: Nouns and Noun Phrases

Classes represent things. Their names should be nouns or noun phrases.

| Good | Bad | Why |
|------|-----|-----|
| `Customer` | `CustomerManager` | Manager is vague -- what does it manage? |
| `WikiPage` | `WebPage` | More specific to the domain |
| `AddressParser` | `ParseAddress` | Noun phrase, not a verb |
| `InvoiceRepository` | `InvoiceProcessor` | Processor is vague -- what processing? |
| `Account` | `AccountData` | Data suffix is noise |

**Avoid:** `Manager`, `Processor`, `Data`, `Info` -- these are weasel words that indicate the class has no clear responsibility.

### Method Names: Verbs and Verb Phrases

Methods represent actions. Their names should be verbs or verb phrases.

| Good | Bad | Why |
|------|-----|-----|
| `save()` | `doSave()` | `do` prefix is noise |
| `calculateTax()` | `tax()` | Verb clarifies it computes, not stores |
| `isValid()` | `checkValid()` | Boolean accessor follows `is`/`has`/`can` convention |
| `fromJson(str)` | `parse(str)` | Static factory name describes transformation |
| `deleteExpiredSessions()` | `cleanup()` | Specific about what gets cleaned |

### Accessor, Mutator, and Predicate Conventions

```java
// Accessors: get + property
String getName()
int getAge()

// Mutators: set + property
void setName(String name)
void setAge(int age)

// Predicates: is/has/can + condition
boolean isEmpty()
boolean hasPermission(Role role)
boolean canExecute()
```

---

## Naming Conventions by Language

### Python
- `snake_case` for functions and variables: `calculate_total`, `user_count`
- `PascalCase` for classes: `UserAccount`, `OrderProcessor`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRIES`, `DEFAULT_TIMEOUT`
- `_leading_underscore` for private: `_internal_cache`
- `__dunder__` for magic methods: `__init__`, `__str__`

### JavaScript/TypeScript
- `camelCase` for functions and variables: `calculateTotal`, `userCount`
- `PascalCase` for classes and components: `UserAccount`, `OrderList`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRIES`, `API_BASE_URL`
- `#privateField` for private class fields (ES2022+)

### Java
- `camelCase` for methods and variables: `calculateTotal()`, `userCount`
- `PascalCase` for classes: `UserAccount`, `OrderService`
- `UPPER_SNAKE_CASE` for constants: `MAX_RETRIES`
- Packages: `com.company.project.module`

### Go
- `PascalCase` for exported (public): `CalculateTotal`, `UserCount`
- `camelCase` for unexported (private): `calculateTotal`, `userCount`
- Short names acceptable for small scopes: `r` for reader, `w` for writer
- Acronyms stay uppercase: `HTTPClient`, `XMLParser`, `userID`

### Rust
- `snake_case` for functions and variables: `calculate_total`, `user_count`
- `PascalCase` for types and traits: `UserAccount`, `Serialize`
- `UPPER_SNAKE_CASE` for constants and statics: `MAX_RETRIES`
- Lifetime names: short lowercase `'a`, `'b` or descriptive `'input`, `'output`

---

## The Pick-One-Word-Per-Concept Rule

Using different words for the same abstract concept is confusing.

| Inconsistent | Consistent | Rule |
|-------------|------------|------|
| `fetch` / `retrieve` / `get` | Pick `get` everywhere | One word for the read operation |
| `controller` / `manager` / `driver` | Pick `controller` everywhere | One word for the coordination role |
| `create` / `make` / `build` / `new` | Pick `create` for API, `build` for complex assembly | Differentiate only if semantics differ |
| `remove` / `delete` / `destroy` | `delete` for permanent, `remove` for detach | Different words when semantics differ |

---

## Solution Domain vs. Problem Domain Names

**Use solution domain names** when the concept is a well-known computer science term:
- `Queue`, `Stack`, `HashMap`, `Factory`, `Visitor`, `Iterator`
- Fellow programmers will recognize these instantly

**Use problem domain names** when the concept belongs to the business:
- `Invoice`, `Shipment`, `PolicyHolder`, `ClaimAdjuster`
- Domain experts and future maintainers will understand these

**The priority:** Problem domain names first, solution domain names second. Code that reads in business terms is easier for the whole team -- developers, testers, product managers -- to discuss and verify.

---

## Common Anti-Patterns

### Names to Avoid

| Anti-pattern | Example | Problem |
|-------------|---------|---------|
| **Single letter** | `a`, `b`, `t` | Meaningless outside tiny loops |
| **Abbreviation** | `acct`, `mgr`, `btn`, `usr` | Saves milliseconds, costs hours |
| **Generic suffix** | `DataObject`, `InfoManager` | Adds nothing; signals unclear responsibility |
| **Type encoding** | `sName`, `iCount`, `bFlag` | IDE shows types; encoding is obsolete and misleading |
| **Numbered series** | `arg1`, `arg2`, `arg3` | Provides no information about each argument's role |
| **Mental mapping** | `r` means URL (in the author's head) | Forces readers to maintain a mental translation table |
| **Puns** | `add` meaning both "concatenate" and "insert" | Same word, different semantics creates confusion |

---

## Renaming Checklist

When renaming a variable, function, or class, follow this checklist to ensure the change improves clarity:

1. **Does the new name reveal intent?** The reader should understand purpose without reading the implementation.
2. **Is it pronounceable?** Can you say it in a code review without spelling it out?
3. **Is it searchable?** Can you find all occurrences with a simple text search?
4. **Does it avoid disinformation?** The name should not imply something the code does not do.
5. **Is it consistent with the codebase?** Use the same word for the same concept everywhere.
6. **Is the length proportional to scope?** Short names for tiny scopes, long names for large scopes.
7. **Does it use domain language?** Prefer business terminology over generic programming terms.

**Remember:** Renaming is one of the most powerful refactorings. Modern IDEs make it safe and fast. Never hesitate to rename something that is unclear -- your future self and your teammates will thank you.
