// Pi Calm - gapless collapsed-thinking presentation adapter.
//
// Adapted from the Firstmate project's Calm implementation.
// Copyright (c) 2026 Kun Chen. MIT License - see the LICENSE file in this directory.
//
// Verified against Pi 0.82.0, which exports AssistantMessageComponent with an
// updateContent method. installCalmCollapsedThinkingLayout() probes that exact
// public seam and throws if it is missing; index.ts catches that and skips only
// this adapter with one clear diagnostic instead of blocking Calm or Pi.
//
// How it works: Pi renders a hidden thinking block as one static label row.
// Calm sets that label to the empty string and this adapter filters thinking
// blocks out of the message handed to the stock renderer, so a collapsed
// thinking block occupies zero rows instead of one blank one. The unfiltered
// message is kept on lastMessage so expanding thinking (Ctrl+T) and turning
// Calm off both restore the original reasoning content byte-for-byte. Only
// collapsed thinking is affected: expanded reasoning, assistant text, and tool
// calls render exactly as Pi renders them.
import type { AssistantMessageComponent as PiAssistantMessageComponent } from "@earendil-works/pi-coding-agent";
import * as PiCodingAgent from "@earendil-works/pi-coding-agent";
import { calmHidesTranscriptChrome } from "./visibility.ts";

type AssistantMessage = Parameters<PiAssistantMessageComponent["updateContent"]>[0];

type AssistantMessagePresentationState = {
  hiddenThinkingLabel: string;
  hideThinkingBlock: boolean;
  lastMessage?: AssistantMessage;
};

type CalmCollapsedThinkingPatch = {
  hidesThinking: () => boolean;
};

// Keep the introduction-version symbol stable so a compatible upgrade cannot
// double-patch a live process.
const CALM_COLLAPSED_THINKING_PATCH = Symbol.for(
  "pi-calm:collapsed-thinking-layout:pi-0.82.0",
);

export function installCalmCollapsedThinkingLayout(): void {
  const registry = globalThis as typeof globalThis & {
    [key: symbol]: CalmCollapsedThinkingPatch | undefined;
  };
  const hidesThinking = (): boolean => calmHidesTranscriptChrome();
  const installed = registry[CALM_COLLAPSED_THINKING_PATCH];
  if (installed) {
    installed.hidesThinking = hidesThinking;
    return;
  }

  const patch: CalmCollapsedThinkingPatch = { hidesThinking };
  const AssistantMessageComponent = PiCodingAgent.AssistantMessageComponent;
  if (typeof AssistantMessageComponent !== "function") {
    throw new Error("Pi Calm requires Pi AssistantMessageComponent");
  }
  const originalUpdateContent = AssistantMessageComponent.prototype.updateContent;
  if (typeof originalUpdateContent !== "function") {
    throw new Error("Pi Calm requires Pi AssistantMessageComponent.updateContent");
  }

  AssistantMessageComponent.prototype.updateContent = function (
    message: AssistantMessage,
  ): void {
    const state = this as unknown as AssistantMessagePresentationState;
    const hideThinking =
      state.hiddenThinkingLabel === "" &&
      state.hideThinkingBlock &&
      patch.hidesThinking();
    const presentationMessage = hideThinking
      ? {
          ...message,
          content: message.content.filter((block) => block.type !== "thinking"),
        }
      : message;

    originalUpdateContent.call(this, presentationMessage);
    if (presentationMessage !== message) state.lastMessage = message;
  };

  registry[CALM_COLLAPSED_THINKING_PATCH] = patch;
}
