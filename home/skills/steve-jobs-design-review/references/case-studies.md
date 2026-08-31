# Case Studies: Jobs-Style Reviews in Action

Documented episodes from Apple history, each read as a design-review lesson: what the situation was, what standard was applied, and what a reviewer should extract for their own products.

## Contents

- [How to use these cases](#how-to-use-these-cases)
- [The 1997 product line massacre — focus](#the-1997-product-line-massacre--focus)
- [The original iMac — opinionated subtraction](#the-original-imac--opinionated-subtraction)
- [The original Mac's circuit board — back of the fence](#the-original-macs-circuit-board--back-of-the-fence)
- [iDVD and the Burn button — simplicity as spec](#idvd-and-the-burn-button--simplicity-as-spec)
- [The iPod — steps-to-value and the missing switch](#the-ipod--steps-to-value-and-the-missing-switch)
- [The iPhone keyboard — demos discover the real product](#the-iphone-keyboard--demos-discover-the-real-product)
- [Apple Stores — owning a touchpoint everyone outsourced](#apple-stores--owning-a-touchpoint-everyone-outsourced)
- [MobileMe — the failure review](#mobileme--the-failure-review)
- [Antenna-gate — when the standard meets reality](#antenna-gate--when-the-standard-meets-reality)
- [The cautionary side of the legend](#the-cautionary-side-of-the-legend)
- [Pattern summary for reviewers](#pattern-summary-for-reviewers)

## How to use these cases

In a review, cases function as precedents: when a team resists a verdict ("we can't cut that," "users will learn it," "nobody sees that screen"), the right case shows the standard applied under harsher stakes than theirs. Quote the case, then return to their product. Don't let the discussion stay in Apple nostalgia — every case below ends with the transferable question to ask about *your* product.

## The 1997 product line massacre — focus

**What happened.** Jobs returned to an Apple weeks from bankruptcy, selling dozens of overlapping Macs (Performa 5200, 6200, 6300…), printers, the Newton. Reviewing the product roadmap, he found that even insiders couldn't explain which computer a friend should buy. He killed roughly 70% of the line and replaced the catalog with a 2×2 grid: consumer/pro × desktop/portable. Four great products. Apple returned to profitability within a year, and the focus freed the engineering talent that built the iMac and, later, the iPod.

**The review standard.** A product catalog is itself a design that must pass the one-sentence test. Confusion at the catalog level can't be fixed at the product level.

**Transferable question.** *Could a team member tell a friend, in one sentence each, which of your products/plans/tiers to choose? If not, the review's first fix list item is the lineup, not the UI.*

## The original iMac — opinionated subtraction

**What happened.** The 1998 iMac shipped without a floppy drive — universal at the time — betting on the internet and CDs. It dropped legacy ports for USB only. The industry called it reckless; customers called it the easiest computer to set up, and the translucent all-in-one design re-established Apple as a consumer brand. The pattern repeated for two decades: optical drives, Flash, headphone jacks — Apple's reviews treated *removal of the dying-but-comfortable* as a product feature.

**The review standard.** Subtraction is allowed to be ahead of user requests. Users ask for compatibility with their present; great reviews judge against the product's future. The bet must be on something genuinely replacing the removed thing — the iMac removed the floppy *because* networks and CDs could carry the load.

**Transferable question.** *What is your product still carrying because removal feels scary rather than because the need persists? What's the floppy drive in this UI?*

## The original Mac's circuit board — back of the fence

**What happened.** During the original Macintosh's development, Jobs reviewed the printed circuit board — a component no customer would ever see — and objected to how the lines and chips were laid out: "That part's really pretty… But look at the memory chips. That's ugly." When an engineer protested that nobody would see it, Jobs replied that *he* would see it, and invoked his father's standard: a great carpenter doesn't use plywood on the back of a cabinet. The team also signed their names on the inside of the case, "because real artists sign their work."

The standard came from Paul Jobs' fence: building it as a boy, Steve asked why the back had to be as well-made as the front, and his father said the back mattered even if no one saw it — *you* would know. Jobs retold this story for decades as the root of his quality doctrine.

**The review standard.** Quality is a property of the whole artifact, not of its visible surfaces. Teams that allow plywood where "nobody looks" are training themselves in corner-cutting that inevitably migrates to visible surfaces. And someone always looks: engineers, integrators, auditors, the next maintainer.

**Transferable question.** *What's your circuit board — the codebase, the API responses, the admin tools, the log messages? Open one in the review. Would the team sign it?*

## iDVD and the Burn button — simplicity as spec

**What happened.** Mike Evangelist, preparing to pitch DVD-burning software to Jobs, built pages of careful mockups for the planned interface. Jobs walked in, ignored the deck, drew a single window on the whiteboard and said: *"Here's the new application. It's got one window. You drag your video into the window. Then you click the button that says 'Burn.' That's it. That's what we're going to make."*

**The review standard.** The simplest articulation of the product *is* the spec; complexity must justify itself against that baseline, not the other way around. Most products are designed forward from capabilities ("what can we expose?"); Jobs designed backward from the user's sentence ("I want this video on a DVD").

**Transferable question.** *Write the whiteboard version of your feature — one window, one verb. Now list every element in the actual design that the whiteboard version lacks. Each one defends itself, or dies.*

## The iPod — steps-to-value and the missing switch

**What happened.** The iPod's defining review constraint was navigational: Jobs demanded users reach any song in about three presses, which forced the scroll wheel + menu hierarchy that defined the product. The device also shipped with no on/off switch — sleep and instant wake made the need disappear. The marketing sentence ("1,000 songs in your pocket") matched the product's actual one-thing with unusual honesty. Meanwhile the engineering reality (a Toshiba drive, a PortalPlayer platform) was invisible — customers experienced only the conquered complexity.

Two review moments are worth keeping: Jobs testing volume and song-access latency obsessively, and the (likely embellished, but instructive) tale of executives demanding a smaller prototype by dropping it in a fish tank and pointing at the escaping air bubbles. The durable truth under the legend: the review pressure was always on *experienced* size, speed, and steps — never on the component list.

**The review standard.** Set numeric experience constraints in the review (three presses, one second, one screen) and let them force the design. Constraints are generative: the scroll wheel exists because "three presses to any of 1,000 songs" is impossible with buttons.

**Transferable question.** *What are your product's three-press constraints? If the review hasn't set any, the design has nothing to push against.*

## The iPhone keyboard — demos discover the real product

**What happened.** Typing on glass was the iPhone's scariest open problem. Instead of a spec, the team ran a derby: every engineer built a complete working keyboard, leadership typed on all of them, and Ken Kocienda's design won — multi-letter keys backed by a dictionary algorithm that guessed the intended word. Iteration later returned the layout to familiar single letters, but kept the derby's real discovery: the autocorrect engine. The visible thing everyone argued about (key layout) turned out to be secondary to an invisible thing only working demos could surface (correction quality). Full story and derby rules: [demo-culture.md](demo-culture.md).

**The review standard.** When argument stalls, stop reviewing opinions and start reviewing artifacts. And expect the demo to relocate the problem — the artifact knows things the debate doesn't.

**Transferable question.** *What's your team's longest-running design argument? What would a one-week, two-entry demo derby cost compared to another month of that meeting?*

## Apple Stores — owning a touchpoint everyone outsourced

**What happened.** In 2000, computers were sold through big-box retailers: commission-driven, indifferent, brutal to a premium brand's story. Rather than accept the industry's seam, Apple designed the touchpoint itself: stores conceived like products, with a full-size prototype store built in secret for iteration (and famously reorganized late, when Ron Johnson convinced Jobs the layout should follow what people *do* — music, photos, movies — rather than what Apple sells). The Genius Bar redesigned the support touchpoint the same way: a named, designed, human face on failure. Analysts predicted the stores would die in two years; they became the highest revenue-per-square-foot retail in the world.

**The review standard.** The end-to-end audit ([end-to-end-experience.md](end-to-end-experience.md)) is allowed to conclude: *this touchpoint is too important to leave to whoever owns it now.* Sometimes the fix list item is "take ownership of the channel," not "polish our part of it." Note also the meta-lesson: the store itself went through demo culture — a prototype built, reviewed, and substantially reworked before launch.

**Transferable question.** *Which touchpoint in your journey is currently rented out to someone whose incentives aren't your customer's experience — an app store page, a reseller, an outsourced support desk, a third-party checkout? What would owning it look like?*

## MobileMe — the failure review

**What happened.** MobileMe, Apple's 2008 cloud sync service, launched broken: lost emails, failed syncs, weeks of public embarrassment. Jobs assembled the team in a town hall and asked: *"Can anyone tell me what MobileMe is supposed to do?"* When someone gave the right answer, he replied: *"So why the f— doesn't it do that?"* He told the team they had tarnished Apple's reputation and "should hate each other for having let each other down," and replaced the group's leadership on the spot, putting Eddy Cue in charge.

**The review standard.** Three parts. First, the reviewing logic: products are judged against their own public promise — state the promise, test it, the gap is the review. Second, launch reviews exist precisely to run this test *before* customers do; MobileMe is what skipping the cold-run launch review costs. Third, accountability is real: a failed launch review has consequences, or the standard is theater.

**The boundary.** The public shaming is the part *not* to import. The promise-gap logic works delivered with respect; the humiliation is separable and corrosive (see [The cautionary side](#the-cautionary-side-of-the-legend)).

**Transferable question.** *Take your marketing page's top three claims. Run each one, today, as a new customer. Do you pass your own MobileMe question?*

## Antenna-gate — when the standard meets reality

**What happened.** The iPhone 4's beautiful stainless-steel band doubled as the antenna — an integration triumph that attenuated signal when gripped at a corner. The design review had, by external accounts, favored form in a tradeoff that physics ultimately surfaced for everyone. Apple's response mixed defensiveness ("you're holding it wrong" became the public caricature of Jobs' initial framing) with a competent recovery: data-driven press conference, free bumper cases.

**The review standard.** This case is the check on the others: "design is how it works" outranks "design is how it looks" *even when the looks are extraordinary*. A review culture strong enough to override the founder's aesthetic preference would have weighed the attenuation finding more heavily. Reviews need a mechanism for bad news to beat beautiful work.

**Transferable question.** *In your last contentious review, did the inconvenient measurement lose to the beautiful artifact? Who in the room is structurally empowered to make the measurement win?*

## The cautionary side of the legend

Honesty about the source material keeps this skill usable. The documented record also shows: public berating, credit appropriation, binary people-sorting ("geniuses" and "bozos") that wrote off recoverable work, and review brutality that some teams metabolized and others were damaged by. Several practices worked *despite* these behaviors, not because of them — Kocienda's account is notable for showing the demo loop functioning with deciders (Lamiraux, Forstall) who were demanding without being cruel.

For reviewers, the separation is clean:

- **Import:** the customer-first cold run, the promise test, binary verdicts, specificity, subtraction pressure, back-of-fence standards, demo-or-nothing, one decider.
- **Leave behind:** humiliation, people-grading, verdicts about worth rather than work. Not for niceness — because fear suppresses early demos and honest bad news, which are the raw inputs the whole loop runs on.

## Pattern summary for reviewers

| Case | Principle | One-line reviewer takeaway |
|---|---|---|
| 1997 line cut | Focus | Review the catalog before the products |
| iMac (no floppy) | Subtraction | Removal can lead users, if a replacement is real |
| Mac circuit board | Back of the fence | Open an invisible surface in every review |
| iDVD "Burn" | Simplicity as spec | The whiteboard sentence is the baseline; complexity defends itself |
| iPod three presses | Constraints | Set numeric experience budgets; they generate design |
| iPhone keyboard | Demo culture | Stalled arguments become derbies; artifacts relocate problems |
| Apple Stores | Whole experience | A fix list may say "own the touchpoint" |
| MobileMe | Promise test | Run the marketing page against the product before customers do |
| Antenna-gate | How it works > looks | Bad news needs structural power over beautiful work |
