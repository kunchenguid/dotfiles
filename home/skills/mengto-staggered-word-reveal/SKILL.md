---
name: staggered-word-reveal
description: Create subtle editorial word-by-word text reveal animations where each word fades and rises into place once it enters the viewport. Use for premium portfolio headlines, hero copy, section intros, and short marketing text that needs a cinematic staggered reveal with IntersectionObserver or in-view detection.
---

# Staggered Word Reveal

## Use When
- A short headline, intro, or pull quote should reveal word by word.
- The motion should feel editorial, premium, and restrained.
- The reveal should trigger only once when the text enters the viewport.
- The project does not need heavy GSAP SplitText behavior.

## Motion Defaults
- Initial state: `opacity: 0`, `transform: translateY(20px)`.
- Final state: `opacity: 1`, `transform: translateY(0)`.
- Duration: `0.8s`.
- Ease: `cubic-bezier(0.16, 1, 0.3, 1)`.
- Stagger: `0.06s` to `0.08s` per word. Default to `0.07s`.
- Trigger: start around `20%` visible, with a slight lower viewport bias.
- Replay: once only.

## HTML

```html
<h1 class="word-reveal" data-word-reveal>
  Build interfaces that feel calm, cinematic, and alive.
</h1>
```

## CSS

Keep no-JS content visible. Hide only after JavaScript is active and before the text has been split.

```css
.word-reveal {
  visibility: visible;
}

html.js .word-reveal[data-word-reveal]:not(.is-ready) {
  opacity: 0;
}

.word-reveal__word {
  display: inline-block;
  opacity: 0;
  transform: translate3d(0, 20px, 0);
  transition:
    opacity 0.8s cubic-bezier(0.16, 1, 0.3, 1),
    transform 0.8s cubic-bezier(0.16, 1, 0.3, 1);
  transition-delay: calc(var(--word-index) * 0.07s);
  will-change: opacity, transform;
}

.word-reveal.is-visible .word-reveal__word {
  opacity: 1;
  transform: translate3d(0, 0, 0);
}

@media (prefers-reduced-motion: reduce) {
  html.js .word-reveal[data-word-reveal]:not(.is-ready),
  .word-reveal__word {
    opacity: 1;
    transform: none;
    transition: none;
  }
}
```

## JavaScript

This splitter preserves spaces, avoids `innerHTML`, exposes the original sentence to screen readers, and unobserves after the first reveal.

```js
document.documentElement.classList.add("js");

function splitWordReveal(element) {
  if (element.dataset.wordRevealReady === "true") return;

  const text = element.textContent || "";
  const parts = text.split(/(\s+)/);
  let wordIndex = 0;

  element.textContent = "";
  element.setAttribute("aria-label", text.trim());

  parts.forEach((part) => {
    if (!part.trim()) {
      element.appendChild(document.createTextNode(part));
      return;
    }

    const word = document.createElement("span");
    word.className = "word-reveal__word";
    word.setAttribute("aria-hidden", "true");
    word.style.setProperty("--word-index", wordIndex);
    word.textContent = part;

    element.appendChild(word);
    wordIndex += 1;
  });

  element.dataset.wordRevealReady = "true";
  element.classList.add("is-ready");
}

function initWordReveals(selector = "[data-word-reveal]") {
  const elements = Array.from(document.querySelectorAll(selector));
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  if (reduceMotion || !("IntersectionObserver" in window)) {
    elements.forEach((element) => {
      element.classList.add("is-ready", "is-visible");
    });
    return;
  }

  const observer = new IntersectionObserver(
    (entries, io) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;

        entry.target.classList.add("is-visible");
        io.unobserve(entry.target);
      });
    },
    {
      threshold: 0.2,
      rootMargin: "0px 0px -10% 0px",
    }
  );

  elements.forEach((element) => {
    splitWordReveal(element);
    observer.observe(element);
  });
}

document.addEventListener("DOMContentLoaded", () => {
  initWordReveals();
});
```

## Framework Notes
- React/Vue/Svelte: run the splitter after mount, then clean up observer instances on route changes.
- Framer Motion: keep the same tokens: `y: 20`, `opacity: 0`, duration `0.8`, ease `[0.16, 1, 0.3, 1]`, stagger `0.06` to `0.08`, `once: true`.
- GSAP: use `fromTo(words, { y: 20, opacity: 0 }, { y: 0, opacity: 1, duration: 0.8, ease: "expo.out", stagger: 0.07 })`.

## Taste Rules
- Use on short text: headlines, subheads, labels, and quotes. Avoid long paragraphs.
- Stagger words, not letters, for a calmer premium feel.
- Keep the offset subtle. Do not add bounce, rotation, or large blur.
- Animate `transform` and `opacity` only.
- Do not split text containing links, buttons, or meaningful inline markup.
- If wrapping is important, initialize after web fonts are ready.

## Quick Checks
- Text is visible when JavaScript is disabled.
- Words begin at `translateY(20px)` and `opacity: 0`.
- Each word reveals once with a `0.06s` to `0.08s` delay.
- Repeated scrolling does not replay the animation.
- Reduced-motion users see static readable text.
