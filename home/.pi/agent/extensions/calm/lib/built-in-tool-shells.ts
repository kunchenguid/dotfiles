// Pi Calm - gapless built-in tool-shell presentation adapter.
//
// Adapted from the Firstmate project's Calm implementation.
// Copyright (c) 2026 Kun Chen. MIT License - see the LICENSE file in this directory.
//
// Verified against Pi 0.82.0, which exports AgentSession and
// ToolExecutionComponent. The source-aware lookup returns Pi's active definition
// unchanged and the adapter changes only its final TUI row layout. Execution,
// settings, SDK overrides, extension collisions, and stored results remain
// owned by Pi. Image results remain visible without their call/result shell,
// and custom tools or tools outside Pi's seven built-ins render unchanged.
import {
  AgentSession,
  ToolExecutionComponent,
  type ToolDefinition,
} from "@earendil-works/pi-coding-agent";
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
  toolDefinition?: ToolDefinition;
  imageComponents: Component[];
  imageSpacers: Component[];
};

type AgentSessionPresentationState = {
  _baseToolsOverride?: Record<string, unknown>;
};

type CalmBuiltInToolShellPatch = {
  hidesShell: () => boolean;
  builtInDefinitions: WeakSet<ToolDefinition>;
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
  if (installed?.builtInDefinitions) {
    installed.hidesShell = hidesShell;
    return;
  }

  const originalGetToolDefinition = AgentSession.prototype.getToolDefinition;
  if (typeof originalGetToolDefinition !== "function") {
    throw new Error("Pi Calm requires Pi AgentSession.getToolDefinition");
  }
  if (typeof ToolExecutionComponent !== "function") {
    throw new Error("Pi Calm requires Pi ToolExecutionComponent");
  }
  const originalRender = ToolExecutionComponent.prototype.render;
  if (typeof originalRender !== "function") {
    throw new Error("Pi Calm requires Pi ToolExecutionComponent.render");
  }

  if (installed) installed.hidesShell = () => false;

  const patch: CalmBuiltInToolShellPatch = {
    hidesShell,
    builtInDefinitions: new WeakSet(),
  };
  AgentSession.prototype.getToolDefinition = function (
    name: string,
  ): ToolDefinition | undefined {
    const definition = originalGetToolDefinition.call(this, name);
    const source = this.getAllTools().find((tool) => tool.name === name)?.sourceInfo.source;
    if (definition) {
      const session = this as unknown as AgentSessionPresentationState;
      const isSdkBaseOverride = Object.hasOwn(session._baseToolsOverride ?? {}, name);
      if (source === "builtin" && !isSdkBaseOverride) {
        patch.builtInDefinitions.add(definition);
      } else {
        patch.builtInDefinitions.delete(definition);
      }
    }
    return definition;
  };

  ToolExecutionComponent.prototype.render = function (width: number): string[] {
    const state = this as unknown as ToolRowPresentationState;
    const isKnownBuiltIn =
      CALM_BUILT_IN_TOOL_NAMES.has(state.toolName) &&
      state.toolDefinition !== undefined &&
      patch.builtInDefinitions.has(state.toolDefinition);
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
