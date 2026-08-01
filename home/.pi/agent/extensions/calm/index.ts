// Pi Calm - a standalone conversation-presentation toggle for Pi.
//
// Adapted from the Firstmate project's Calm implementation.
// Copyright (c) 2026 Kun Chen. MIT License - see the LICENSE file in this directory.
//
// Verified against Pi 0.82.0, which exports its shared tool-row component,
// session_start replacement reasons, agent_start
// and agent_settled, ExtensionUIContext.setToolsExpanded(), setWorkingVisible(),
// setWidget() with a disposable component factory, and setHiddenThinkingLabel().
// ./lib/working-ship.ts owns the animated working presentation this file
// installs. ./lib/preference.ts owns the local state file. The collapsed-thinking
// presentation adapter probes the exact public API seam it patches and degrades
// independently with one clear diagnostic (see installCalmPresentationAdapter
// below) if a future Pi removes it. The shared tool-row adapter is limited to
// Pi's seven known built-in names, so generic custom tools and unsupported
// transcript classes deliberately stay visible.
//
// Calm changes presentation only. It never intercepts, transforms, reroutes,
// removes, or reorders semantic input, tool execution, model context, session
// storage, or export data; /export and /share render the complete stock
// transcript.
import { type ExtensionAPI, type ExtensionUIContext } from "@earendil-works/pi-coding-agent";
import { getKeybindings } from "@earendil-works/pi-tui";
import { installCalmBuiltInToolShellLayout } from "./lib/built-in-tool-shells.ts";
import { installCalmCollapsedThinkingLayout } from "./lib/collapsed-thinking.ts";
import { loadCalmPreference, persistCalmPreference } from "./lib/preference.ts";
import {
  calmPresentationIsActive,
  setCalmPresentation,
  setCalmStockExportRendering,
} from "./lib/visibility.ts";
import {
  CALM_WORKING_SHIP_WIDGET_KEY,
  createCalmWorkingShipAnimation,
  createCalmWorkingShipWidget,
} from "./lib/working-ship.ts";

// Each presentation adapter probes the exact Pi API it patches. If a future Pi
// removes that API, only the affected adapter degrades; the rest of Calm keeps
// working.
function installCalmPresentationAdapter(name: string, install: () => void): void {
  try {
    install();
  } catch (error) {
    const reason = error instanceof Error ? error.message : String(error);
    console.error(`Pi Calm: ${name} presentation adapter unavailable, skipping. ${reason}`);
  }
}

export default function (pi: ExtensionAPI) {
  installCalmPresentationAdapter("collapsed-thinking", installCalmCollapsedThinkingLayout);
  installCalmPresentationAdapter("built-in-tool-shells", installCalmBuiltInToolShellLayout);

  let removeTerminalInputHandler: (() => void) | undefined;
  // One logical agent run, tracked from agent_start through agent_settled rather
  // than from turns or tool calls, so the boat never flickers between tool calls,
  // automatic continuations, retries, or compaction that stay inside the same run.
  let agentRunActive = false;
  let workingShipShown = false;
  // One animation instance per extension lifetime. Hiding the working widget
  // freezes this state; the next working period resumes it. session_start resets
  // it so a fresh Pi session starts at the normal initial position. Never
  // module-global.
  const workingShipAnimation = createCalmWorkingShipAnimation();

  // Single owner of Calm's working-row presentation choice. The widget is only
  // created or removed on a real transition, so repeated starts cannot duplicate
  // its timer.
  const applyWorkingPresentation = (
    ui: ExtensionUIContext,
    forceStockVisibility = false,
  ): void => {
    const showShip = agentRunActive && calmPresentationIsActive();
    if (showShip !== workingShipShown) {
      workingShipShown = showShip;
      ui.setWidget(
        CALM_WORKING_SHIP_WIDGET_KEY,
        showShip
          ? (tui) => createCalmWorkingShipWidget(tui, workingShipAnimation)
          : undefined,
      );
      ui.setWorkingVisible(!showShip);
    } else if (forceStockVisibility && !showShip) {
      ui.setWorkingVisible(true);
    }
  };

  pi.on("session_start", (_event, ctx) => {
    setCalmPresentation(loadCalmPreference());
    setCalmStockExportRendering(false);
    agentRunActive = false;
    workingShipShown = false;
    // A genuine new session lifetime starts the boat at the normal initial position.
    workingShipAnimation.reset();
    applyWorkingPresentation(ctx.ui, true);
    ctx.ui.setHiddenThinkingLabel(calmPresentationIsActive() ? "" : undefined);
    removeTerminalInputHandler?.();
    removeTerminalInputHandler = ctx.ui.onTerminalInput((data) => {
      if (!getKeybindings().matches(data, "tui.input.submit")) return;

      const input = ctx.ui.getEditorText().trim();
      if (
        input !== "/share" &&
        input !== "/export" &&
        !input.startsWith("/export ")
      ) {
        return;
      }

      // /export and /share render through the same tool renderers the transcript
      // uses, so force stock output for the duration of the command. Session and
      // export data are never filtered; this only concerns the visual components.
      setCalmStockExportRendering(true);
      setTimeout(() => {
        setCalmStockExportRendering(false);
        const expanded = ctx.ui.getToolsExpanded();
        ctx.ui.setToolsExpanded(!expanded);
        ctx.ui.setToolsExpanded(expanded);
      }, 0);
    });
  });

  pi.on("agent_start", (_event, ctx) => {
    agentRunActive = true;
    applyWorkingPresentation(ctx.ui);
  });

  // agent_settled is emitted from a finally block, so it also covers abort and failure.
  pi.on("agent_settled", (_event, ctx) => {
    agentRunActive = false;
    applyWorkingPresentation(ctx.ui);
  });

  pi.on("session_shutdown", (_event, ctx) => {
    agentRunActive = false;
    applyWorkingPresentation(ctx.ui);
  });

  pi.registerCommand("calm", {
    description: "Toggle Calm: hide collapsed thinking and built-in tool shells from the transcript (presentation only).",
    handler: async (_args, ctx) => {
      const active = !calmPresentationIsActive();
      // Persist first: if the state file cannot be written, the toggle fails
      // with a clear error instead of silently reverting on the next restart.
      persistCalmPreference(active);
      setCalmPresentation(active);
      applyWorkingPresentation(ctx.ui, true);
      ctx.ui.setHiddenThinkingLabel(active ? "" : undefined);

      // Flip expansion twice to force a transcript redraw while preserving the
      // user's exact Ctrl+O tools-expanded state.
      const expanded = ctx.ui.getToolsExpanded();
      ctx.ui.setToolsExpanded(!expanded);
      ctx.ui.setToolsExpanded(expanded);
    },
  });
}
