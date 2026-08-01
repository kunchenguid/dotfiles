// Pi Calm - gapless built-in tool-shell presentation adapter.
//
// Adapted from the Firstmate project's Calm implementation.
// Copyright (c) 2026 Kun Chen. MIT License - see the LICENSE file in this directory.
//
// Verified against Pi 0.82.0, which exports ToolExecutionComponent. This
// adapter changes only the final TUI row layout. Active tool definitions,
// execution, settings, SDK overrides, extension collisions, and stored results
// remain owned by Pi. Image results remain visible without their call/result
// shell, and tools outside Pi's seven known built-in names render unchanged.
import { ToolExecutionComponent } from "@earendil-works/pi-coding-agent";
import type { Component } from "@earendil-works/pi-tui";
import { calmHidesTranscriptChrome } from "./visibility.ts";

const CALM_BUILT_IN_TOOL_NAMES = new Set([
  "read",
  "bash",
  "edit",
  "write",
  "grep",
  "find",
  "ls",
]);

type ToolRowPresentationState = {
  toolName: string;
  builtInToolDefinition?: object;
  imageComponents: Component[];
  imageSpacers: Component[];
};

type CalmBuiltInToolShellPatch = {
  hidesShell: () => boolean;
};

const CALM_BUILT_IN_TOOL_SHELL_PATCH = Symbol.for(
  "pi-calm:built-in-tool-shell-layout:pi-0.82.0",
);

export function installCalmBuiltInToolShellLayout(): void {
  const registry = globalThis as typeof globalThis & {
    [key: symbol]: CalmBuiltInToolShellPatch | undefined;
  };
  const hidesShell = (): boolean => calmHidesTranscriptChrome();
  const installed = registry[CALM_BUILT_IN_TOOL_SHELL_PATCH];
  if (installed) {
    installed.hidesShell = hidesShell;
    return;
  }

  if (typeof ToolExecutionComponent !== "function") {
    throw new Error("Pi Calm requires Pi ToolExecutionComponent");
  }
  const originalRender = ToolExecutionComponent.prototype.render;
  if (typeof originalRender !== "function") {
    throw new Error("Pi Calm requires Pi ToolExecutionComponent.render");
  }

  const patch: CalmBuiltInToolShellPatch = { hidesShell };
  ToolExecutionComponent.prototype.render = function (width: number): string[] {
    const state = this as unknown as ToolRowPresentationState;
    const isKnownBuiltIn =
      CALM_BUILT_IN_TOOL_NAMES.has(state.toolName) &&
      state.builtInToolDefinition !== undefined;
    if (!isKnownBuiltIn || !patch.hidesShell()) {
      return originalRender.call(this, width);
    }

    const lines: string[] = [];
    for (let index = 0; index < state.imageComponents.length; index += 1) {
      const spacer = state.imageSpacers[index];
      if (spacer) lines.push(...spacer.render(width));
      const image = state.imageComponents[index];
      if (image) lines.push(...image.render(width));
    }
    return lines;
  };

  registry[CALM_BUILT_IN_TOOL_SHELL_PATCH] = patch;
}
