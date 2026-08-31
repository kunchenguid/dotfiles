# Collaborative Design in Lean UX

Lean UX replaces the lone-designer model with cross-functional collaboration. Design is not a phase or a department; it is a team activity. The goal is shared understanding, not comprehensive documentation. When the whole team participates in design, handoff waste disappears and learning velocity increases.

## The Design Studio Method

The Design Studio is the signature collaborative design technique in Lean UX. It is a structured, time-boxed workshop where the entire cross-functional team generates, critiques, and refines design solutions together.

### Design Studio Structure

| Phase | Duration | Activity | Output |
|-------|----------|----------|--------|
| **Problem statement** | 5 min | Facilitator presents the hypothesis and constraints | Shared understanding of the problem |
| **Individual sketching (diverge)** | 10 min | Each participant sketches 6-8 ideas on paper (6-up template) | Many diverse ideas from diverse perspectives |
| **Present and critique** | 3 min per person | Each person presents sketches; team asks questions and gives feedback | Highlighted strong ideas, identified gaps |
| **Pair sketching (converge)** | 10 min | Pairs combine the best ideas into refined concepts | Stronger, cross-pollinated concepts |
| **Present and critique round 2** | 3 min per pair | Pairs present refined concepts; team evaluates | Top 2-3 concepts to prototype |
| **Team converge** | 10 min | Team selects elements from the best concepts for a unified direction | One direction to prototype and test |

**Total time:** 60-90 minutes.

### Facilitation Tips

- **Enforce time boxes strictly.** Divergent thinking needs pressure. If you give people 30 minutes to sketch, they will agonize over one idea. Give them 5 minutes and they produce six ideas because they cannot overthink.
- **No laptops during sketching.** Paper and markers only. Digital tools slow divergent thinking and encourage premature refinement.
- **Everyone sketches.** Engineers, product managers, data analysts, stakeholders. Bad drawing is fine. The goal is ideas, not art.
- **Critique the idea, not the person.** Frame feedback as "I like how this concept solves X" and "I wonder if Y would be a challenge" rather than "This is wrong."
- **Dot voting to prioritize.** Give each participant 3 dots to place on their favorite ideas. This surfaces the team's collective intuition quickly.
- **Capture decisions on camera.** Photograph the whiteboard or sketches. This is your documentation. No one needs to write a spec after a Design Studio.

### The 6-Up Template

Each participant receives a sheet of paper divided into 6 panels. In 5 minutes, they sketch one idea per panel. This forces breadth over depth.

```
+----------+----------+----------+
|          |          |          |
| Idea 1   | Idea 2   | Idea 3   |
|          |          |          |
+----------+----------+----------+
|          |          |          |
| Idea 4   | Idea 5   | Idea 6   |
|          |          |          |
+----------+----------+----------+
```

**Rules:**
- One idea per box
- No erasing; move to the next box
- Labels and annotations are encouraged
- Stick figures and boxes are valid UI sketches
- Star your own favorite at the end

## Collaborative Sketching Sessions

Beyond the formal Design Studio, Lean UX teams use shorter collaborative sketching sessions throughout the sprint.

### Quick Sketch Formats

| Format | Duration | When to Use |
|--------|----------|-------------|
| **Crazy 8s** | 8 minutes (1 minute per sketch) | Rapid ideation for a specific screen or interaction |
| **Solution sketch** | 15 minutes (one refined idea per person) | When the team has already narrowed the problem space |
| **Storyboard** | 20 minutes (6-panel story per person) | When the hypothesis involves a multi-step user journey |
| **How Might We brainstorm** | 15 minutes | Reframing the problem before sketching solutions |

### Integrating Sketching into Standups

In a Lean UX team, the daily standup can include a 5-minute sketch round when the team encounters a design question. Instead of saying "let's schedule a meeting with the designer," anyone can grab a marker and say "here's what I'm thinking" on a whiteboard.

**Key principle:** The cost of a bad sketch is near zero. The cost of a bad specification is a wasted sprint.

## Cross-Functional Design

### Who Participates and Why

| Role | What They Bring | Why It Matters |
|------|----------------|----------------|
| **Designer** | Visual and interaction expertise, user empathy | Synthesizes input into coherent experiences |
| **Developer** | Technical feasibility, implementation awareness | Prevents designing things that are impossible or expensive to build |
| **Product Manager** | Business context, priorities, constraints | Ensures designs serve business goals and user needs |
| **Data Analyst** | Usage patterns, metrics, quantitative evidence | Grounds design decisions in data, not assumptions |
| **QA Engineer** | Edge cases, error states, system thinking | Catches problems before they become bugs |
| **Stakeholder** | Domain expertise, organizational context | Reduces approval delays; builds buy-in through participation |

### Making Cross-Functional Design Work

**Establish ground rules:**
- No seniority in the sketching room. The intern's idea gets the same critique as the VP's.
- "Yes, and" over "No, but." Build on ideas before criticizing them.
- The designer is the synthesizer, not the dictator. They combine the best elements into a coherent design.
- Decisions are based on the hypothesis, not personal preference. "Will this test our hypothesis?" is the only valid design criterion during a Design Studio.

**Common resistance and how to address it:**

| Resistance | Response |
|-----------|----------|
| "I can't draw." | "We're sketching ideas, not art. Boxes and arrows are perfect." |
| "This isn't my job." | "The team that designs together builds faster and with fewer misunderstandings." |
| "Just tell me what to build." | "We'll all be faster if we understand why we're building it. Your perspective catches things we miss." |
| "We'll design by committee." | "The designer synthesizes. The team contributes perspectives, not pixels." |

## Reducing Waste in UX Deliverables

Traditional UX produces documents that no one reads: 60-page wireframe decks, annotated mockups with 200 footnotes, user flow diagrams that are outdated by the time they are printed. Lean UX reduces deliverables to the minimum needed for shared understanding.

### The Deliverable Spectrum

| Traditional Deliverable | Lean UX Replacement | Why It's Better |
|------------------------|--------------------|-----------------|
| 60-page wireframe deck | Whiteboard photo from Design Studio | Team was in the room; they remember the context |
| Annotated mockup with spec notes | Figma prototype with developer in the room during design | Developer can ask questions in real time |
| Persona document (20 pages) | Proto-persona on a single page | Updated weekly as team learns; not a shelf document |
| User journey map (poster-sized) | Storyboard sketch from collaborative session | Created by the team, reflects current understanding |
| Usability test report (30 pages) | 5-minute video highlight reel + 3 bullet findings | Team watches video together; shared empathy, not a report |

### The "Just Enough" Documentation Test

Before creating a deliverable, ask:
1. **Who needs this information?** If the answer is "the team I sit with," a conversation replaces a document.
2. **Will this be read?** If the document will sit in a folder, replace it with a shared session.
3. **What is the minimum artifact that conveys the decision?** A photo of a whiteboard, a 3-bullet Slack message, or a Loom video often suffices.
4. **Is this for communication or for approval?** Approval artifacts may need more formality, but only as much as the approval process requires.

## Shared Understanding Over Documentation

Shared understanding is the state where every team member has the same mental model of what is being built, why it is being built, and how success will be measured. It is the primary output of collaborative design.

### How to Build Shared Understanding

| Technique | How It Works |
|-----------|-------------|
| **Co-located design sessions** | Team sketches together; understanding is built through the act of creating |
| **Pair designing** | Designer and developer (or PM) work side by side on the same problem |
| **Research observation** | The whole team watches at least 2 usability test sessions per sprint |
| **Shared walls** | Physical or virtual walls displaying current hypotheses, experiment results, and design directions |
| **Sprint demos with context** | Demo includes not just "what we built" but "what we learned and what we are testing next" |

### Measuring Shared Understanding

A simple test: ask each team member independently to answer these three questions:
1. What are we building this sprint?
2. Why are we building it? (What hypothesis are we testing?)
3. How will we know if it worked?

If answers diverge, shared understanding is low. Run a collaborative session to realign.

## Style Guides as Living Documents

In Lean UX, style guides and design systems are not static reference PDFs. They are living, evolving artifacts maintained collaboratively by designers and developers.

### Living Style Guide Principles

| Principle | What It Means | Anti-Pattern |
|-----------|-------------|--------------|
| **Code is the source of truth** | The style guide is a running code library, not a PDF | Designer updates Figma but not the code; they diverge |
| **Joint ownership** | Designers and developers maintain the guide together | Only the design team updates the guide; engineers ignore it |
| **Evolve with the product** | New patterns are added as they are built and validated | Style guide is a one-time project that becomes outdated |
| **Low ceremony** | Adding a new component should take minutes, not days | New component requires a 3-meeting approval process |

### Style Guide Workflow

1. **Design exploration:** Designer sketches a new pattern during a Design Studio or individually.
2. **Collaborative refinement:** Designer and developer discuss feasibility and implementation.
3. **Build and document:** Developer implements the component; designer reviews.
4. **Add to the guide:** Component is added to the living style guide with usage guidelines.
5. **Iterate:** As the team learns from experiments, components evolve.

### Style Guide Content

A minimal living style guide includes:

| Section | Contents |
|---------|----------|
| **Colors** | Primary, secondary, semantic colors (success, error, warning) with hex and variable names |
| **Typography** | Font families, sizes, weights, line heights for headings, body, captions |
| **Spacing** | Base unit and scale (4px, 8px, 16px, 24px, 32px, 48px) |
| **Components** | Buttons, inputs, cards, modals, navigation, tables with states and variants |
| **Patterns** | Common layouts, form patterns, empty states, loading states, error states |
| **Voice and tone** | Writing style, vocabulary, microcopy patterns |

## Remote Collaborative Design

Distributed teams can run all collaborative design activities virtually with some adjustments.

### Virtual Design Studio Setup

| Element | Tool Options | Tips |
|---------|-------------|------|
| **Sketching canvas** | FigJam, Miro, Mural | Pre-create sections for each participant |
| **Video** | Zoom, Google Meet | Cameras on; body language matters during critique |
| **Timer** | Built-in timer in FigJam/Miro | Visible to all participants; auto-alerts on time |
| **Voting** | Dot voting in FigJam/Miro | Anonymous voting reduces bias |
| **Capture** | Screenshot + paste into Confluence/Notion | Assign one person to capture decisions and photos |

### Remote Facilitation Adjustments

- **Add 50% more time** for each phase compared to in-person (communication overhead)
- **Use breakout rooms** for pair sketching instead of "turn to your neighbor"
- **Explicit speaking order** during critique rounds to prevent talking over each other
- **Async pre-work:** Share the hypothesis and context 24 hours before the session so participants arrive prepared
- **Post-session summary:** Send a 3-bullet recap within 1 hour. In remote settings, the shared wall does not exist passively; you must actively push information.

## Anti-Patterns in Collaborative Design

| Anti-Pattern | Symptom | Fix |
|-------------|---------|-----|
| **HiPPO dominance** | Highest-paid person's opinion wins every critique | Anonymous voting; data-driven critique ("does this test our hypothesis?") |
| **Design by committee** | Every critique point becomes a mandatory change | Designer synthesizes; critique informs but does not dictate |
| **Sketch theater** | People sketch to impress, not to explore | Enforce time pressure; praise quantity over quality |
| **No follow-through** | Great ideas from the session are never prototyped | Assign action items at end of session; track in sprint backlog |
| **Excluding developers** | Engineers see designs for the first time in sprint planning | Developers attend every Design Studio; pair design weekly |
