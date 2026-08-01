#!/usr/bin/env bash
# Deterministic rendering, lifecycle, persistence, and interactive TUI checks
# for the standalone Pi Calm extension (home/.pi/agent/extensions/calm).
#
# Adapted from the Firstmate project's Calm test suite.
# Copyright (c) 2026 Kun Chen. MIT License - see home/.pi/agent/extensions/calm/LICENSE.
#
# Coverage:
# - zero coupling: no forbidden identifiers anywhere in the shipped source,
#   tests, or docs, and the runtime state file is never tracked or managed;
# - static wiring: Home Manager auto-load, TypeScript typecheck, JS syntax;
# - preference: off by default, persisted toggle, malformed/unwritable state;
# - filtering: the seven built-in tool shells hide gaplessly while custom tools
#   and unsupported transcript classes stay visible, /export and /share render
#   stock HTML, session data is untouched;
# - collapsed thinking: gapless hiding, expansion restore, isolated adapter
#   degradation with one clear diagnostic;
# - working ship: geometry, cadence, colors, resize, narrow fallback,
#   freeze/resume, timer disposal, extension lifecycle;
# - real Pi 0.82 TUI proofs in tmux without credentials or provider calls.
set -u

# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

TMP_ROOT=$(dotfiles_test_tmproot pi-calm)
CALM_DIR="$ROOT/home/.pi/agent/extensions/calm"
PI_PACKAGE_DIR=${PI_CALM_TEST_PACKAGE_DIR:-"$(npm root -g 2>/dev/null)/@earendil-works/pi-coding-agent"}
TMUX_SOCKET="pi-calm-test-$$"
TMUX_SESSION="pi-calm-e2e"

cleanup() {
  if command -v tmux >/dev/null 2>&1; then
    tmux -L "$TMUX_SOCKET" kill-server 2>/dev/null || true
  fi
  if [ "${KEEP_TMP:-}" = 1 ]; then
    printf 'kept disposable Pi Calm evidence: %s\n' "$TMP_ROOT" >&2
    return
  fi
  dotfiles_test_cleanup
}
trap cleanup EXIT

wait_for_text() {
  local file=$1 text=$2 i=0
  while [ "$i" -lt 120 ]; do
    # Include recent scrollback: expanding a long restored transcript can move
    # the asserted tool output above the current viewport while the footer and
    # editor remain visible.
    tmux -L "$TMUX_SOCKET" capture-pane -p -t "$TMUX_SESSION" -S -600 >"$file" 2>/dev/null || true
    grep -Fq "$text" "$file" 2>/dev/null && return 0
    sleep 0.05
    i=$((i + 1))
  done
  return 1
}

find_chrome() {
  local candidate
  if [ -n "${PI_CALM_TEST_CHROME_BIN:-}" ] && [ -x "$PI_CALM_TEST_CHROME_BIN" ]; then
    printf '%s\n' "$PI_CALM_TEST_CHROME_BIN"
    return 0
  fi
  for candidate in \
    google-chrome \
    google-chrome-stable \
    chromium \
    chromium-browser \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  do
    if command -v "$candidate" >/dev/null 2>&1; then
      command -v "$candidate"
      return 0
    fi
  done
  return 1
}

# Copy the shipped extension into a fixture layout with resolvable node_modules.
# Echoes the fixture root. Requires $1 = fixture directory.
build_node_fixture() {
  local fixture=$1
  mkdir -p "$fixture/calm" "$fixture/node_modules/@earendil-works"
  cp -R "$CALM_DIR/index.ts" "$CALM_DIR/lib" "$fixture/calm/"
  ln -s "$PI_PACKAGE_DIR" "$fixture/node_modules/@earendil-works/pi-coding-agent"
  ln -s "$PI_PACKAGE_DIR/node_modules/@earendil-works/pi-tui" "$fixture/node_modules/@earendil-works/pi-tui"
  ln -s "$PI_PACKAGE_DIR/node_modules/typebox" "$fixture/node_modules/typebox"
  printf '%s\n' '{"type":"module"}' >"$fixture/package.json"
}

have_pi_package() {
  [ -f "$PI_PACKAGE_DIR/package.json" ]
}

test_zero_coupling_and_state_file() {
  local source_files license_hits file separator
  source_files=$(find "$CALM_DIR" -type f | sort)
  [ -n "$source_files" ] || fail "Pi Calm extension files are missing"
  # U+2063 (invisible separator) without embedding the literal in this file.
  separator=$(printf '\xe2\x81\xa3')
  # Forbidden patterns are concatenated so this checker never matches itself.
  local pat_fm_home="FM_""HOME" pat_fm_root="FM_""ROOT" pat_config="config/""calm"
  local pat_watch="fm_""watch_arm_pi" pat_op="FIRSTMATE""_OP" pat_dash="fm-""calm"

  # The operational marker and upstream runtime surfaces must not exist anywhere.
  for file in $source_files "$ROOT/tests/pi-calm.test.sh" "$ROOT/tests/lib.sh" "$ROOT/README.md" "$ROOT/home.nix"; do

    assert_not_contains "$(cat "$file")" "$pat_fm_home" "$file mentions $pat_fm_home"
    assert_not_contains "$(cat "$file")" "$pat_fm_root" "$file mentions $pat_fm_root"
    assert_not_contains "$(cat "$file")" "$pat_config" "$file mentions $pat_config"
    assert_not_contains "$(cat "$file")" "$pat_watch" "$file mentions $pat_watch"
    assert_not_contains "$(cat "$file")" "$pat_op" "$file mentions $pat_op"
    assert_not_contains "$(cat "$file")" "$pat_dash" "$file mentions $pat_dash"
    assert_not_contains "$(cat "$file")" "$separator" "$file contains the operational separator"
  done
  # The upstream project name may appear only in a license attribution.
  local attribution_name="First""mate"
  license_hits=$(grep -rni "$attribution_name" "$CALM_DIR" "$ROOT/README.md" "$ROOT/home.nix" 2>/dev/null | grep -v "Adapted from" || true)
  [ -z "$license_hits" ] || fail "unexpected upstream references outside license attribution: $license_hits"
  grep -q "MIT License" "$CALM_DIR/LICENSE" || fail "calm LICENSE lost the MIT permission text"
  grep -q "Copyright (c) 2026 Kun Chen" "$CALM_DIR/LICENSE" || fail "calm LICENSE lost the copyright notice"
  for file in "$CALM_DIR/index.ts" "$CALM_DIR/lib/visibility.ts" "$CALM_DIR/lib/preference.ts" "$CALM_DIR/lib/collapsed-thinking.ts" "$CALM_DIR/lib/working-ship.ts"; do
    grep -q "Copyright (c) 2026 Kun Chen" "$file" || fail "$file lost its copyright attribution header"
  done

  # The runtime preference file must never be tracked or Home Manager managed.
  if git -C "$ROOT" ls-files --error-unmatch home/.pi/agent/calm >/dev/null 2>&1; then
    fail "the Calm state file is tracked in the repository"
  fi
  assert_not_contains "$(cat "$ROOT/home.nix")" '.pi/agent/calm' "home.nix manages the Calm state file"
  grep -q '^/home/.pi/agent/calm$' "$ROOT/.gitignore" \
    || fail ".gitignore does not guard /home/.pi/agent/calm"

  # The shipped tree never references upstream paths or identifiers in code.
  assert_not_contains "$(cat "$CALM_DIR/index.ts")" "pi.events" "index.ts emits on a shared event bus"
  assert_not_contains "$(cat "$CALM_DIR/index.ts")" "registerEntryRenderer" "index.ts registers a synthetic entry renderer"
  assert_not_contains "$(cat "$CALM_DIR/index.ts")" "InteractiveMode" "index.ts patches user-row layout"

  pass "zero coupling: no forbidden identifiers, attribution limited to license headers, state file untracked and unmanaged"
}

test_static_typescript_and_repo_wiring() {
  # Home Manager links the extensions directory as a whole, so the calm
  # subdirectory auto-loads without any new declaration.
  grep -q 'home.file.".pi/agent/extensions".source =' "$ROOT/home.nix" \
    || fail "home.nix no longer links ~/.pi/agent/extensions as a directory"
  grep -q "mkOutOfStoreSymlink \"\${dotfiles}/home/.pi/agent/extensions\"" "$ROOT/home.nix" \
    || fail "home.nix changed the Pi extensions link target"
  [ -f "$CALM_DIR/index.ts" ] || fail "calm extension entry point missing"
  [ -f "$CALM_DIR/LICENSE" ] || fail "calm license file missing"

  # JavaScript syntax of the pre-existing extension stays valid.
  node --check "$ROOT/home/.pi/agent/extensions/terminal-status-title.js" \
    || fail "terminal-status-title.js has a JavaScript syntax error"

  if ! have_pi_package; then
    echo "skip: installed @earendil-works/pi-coding-agent package not found for TypeScript check"
  elif ! command -v tsc >/dev/null 2>&1; then
    echo "skip: tsc not found for TypeScript check"
  else
    local fixture="$TMP_ROOT/typecheck"
    build_node_fixture "$fixture"
    mkdir -p "$fixture/node_modules/@types"
    ln -s "$PI_PACKAGE_DIR/node_modules/@types/node" "$fixture/node_modules/@types/node"
    cat >"$fixture/tsconfig.json" <<'JSON'
{
  "compilerOptions": {
    "target": "esnext",
    "module": "esnext",
    "moduleResolution": "bundler",
    "lib": ["esnext"],
    "types": ["node"],
    "strict": true,
    "noEmit": true,
    "allowImportingTsExtensions": true,
    "skipLibCheck": true,
    "verbatimModuleSyntax": true
  },
  "include": ["calm/**/*.ts"]
}
JSON
    (cd "$fixture" && tsc -p tsconfig.json) \
      || fail "Pi Calm extension does not typecheck under strict TypeScript"
  fi

  pass "static wiring: Home Manager auto-load intact, TypeScript typechecks, existing JS extension parses"
}

test_preference_and_command() {
  local fixture out status
  if ! command -v node >/dev/null 2>&1; then
    echo "skip: node not found for Pi Calm preference test"
    return 0
  fi
  if ! have_pi_package; then
    echo "skip: installed @earendil-works/pi-coding-agent package not found"
    return 0
  fi

  fixture="$TMP_ROOT/preference"
  mkdir -p "$fixture/agent" "$fixture/readonly-agent"
  build_node_fixture "$fixture"

  out=$(cd "$fixture" && \
    EXT="$fixture/calm/index.ts" \
    AGENT_DIR="$fixture/agent" \
    READONLY_AGENT_DIR="$fixture/readonly-agent" \
    node --input-type=module 2>&1 <<'JS'
import { chmodSync, existsSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

process.env.PI_CODING_AGENT_DIR = process.env.AGENT_DIR;
const extension = await import(`${pathToFileURL(process.env.EXT).href}?pref=${Date.now()}`);
const preference = await import(`${pathToFileURL(`${process.cwd()}/calm/lib/preference.ts`).href}?pref=${Date.now()}`);
const visibility = await import(pathToFileURL(`${process.cwd()}/calm/lib/visibility.ts`).href);

const check = (condition, message) => {
  if (!condition) throw new Error(message);
};

check(
  preference.calmPreferencePath() === join(process.env.AGENT_DIR, "calm"),
  `preference path did not follow PI_CODING_AGENT_DIR: ${preference.calmPreferencePath()}`,
);

let calmCommand;
const handlers = new Map();
const pi = {
  on(event, handler) {
    const existing = handlers.get(event) ?? [];
    existing.push(handler);
    handlers.set(event, existing);
  },
  registerCommand(name, command) {
    if (name === "calm") calmCommand = command;
  },
  registerTool() {},
};
extension.default(pi);
check(!!calmCommand, "Calm command was not registered");
for (const event of ["session_start", "agent_start", "agent_settled", "session_shutdown"]) {
  check(handlers.has(event), `Calm did not register a ${event} handler`);
}
check(!handlers.has("input"), "Calm registered a semantic input interceptor");
check(!handlers.has("tool_call"), "Calm registered a tool-call interceptor");
check(!handlers.has("tool_result"), "Calm registered a tool-result interceptor");
check(!handlers.has("context"), "Calm registered a model-context interceptor");

let editorText = "";
let expanded = false;
let hiddenThinkingLabel = "unset";
const uiCalls = [];
const ctx = {
  ui: {
    getEditorText: () => editorText,
    getToolsExpanded: () => expanded,
    setToolsExpanded(value) {
      uiCalls.push(["setToolsExpanded", value]);
      expanded = value;
    },
    onTerminalInput: () => () => {},
    setHiddenThinkingLabel(value) {
      hiddenThinkingLabel = value;
    },
    setWidget() {},
    setWorkingVisible() {},
  },
};
const fire = async (event, payload = {}) => {
  for (const handler of handlers.get(event) ?? []) await handler(payload, ctx);
};

// Off by default: no state file means inactive and nothing is written.
await fire("session_start", { reason: "startup" });
check(!visibility.calmPresentationIsActive(), "Calm was not off by default");
check(!existsSync(`${process.env.AGENT_DIR}/calm`), "session start created the state file without a toggle");
check(hiddenThinkingLabel === undefined, "default session did not keep the stock thinking label");

// Malformed state content also means off, and is left untouched until a toggle.
writeFileSync(`${process.env.AGENT_DIR}/calm`, "sometimes\n");
await fire("session_start", { reason: "reload" });
check(!visibility.calmPresentationIsActive(), "malformed state did not fall back to off");
check(readFileSync(`${process.env.AGENT_DIR}/calm`, "utf8") === "sometimes\n", "loading a malformed state rewrote it");

// Toggle on: persists "on\n" with owner-only permissions and hides the label.
expanded = true;
await calmCommand.handler("", ctx);
check(visibility.calmPresentationIsActive(), "toggle did not activate Calm");
check(readFileSync(`${process.env.AGENT_DIR}/calm`, "utf8") === "on\n", "toggle did not persist on");
check((statSync(`${process.env.AGENT_DIR}/calm`).mode & 0o777) === 0o600, "state file is not owner-only");
check(hiddenThinkingLabel === "", "Calm did not hide the collapsed thinking label");
check(expanded === true, "toggle changed the Ctrl+O tools-expanded state");

// The choice survives new sessions and replacement reasons.
for (const reason of ["startup", "new", "resume", "fork", "reload"]) {
  await fire("session_start", { reason });
  check(visibility.calmPresentationIsActive(), `${reason} session lost the persisted on choice`);
  check(hiddenThinkingLabel === "", `${reason} session lost the hidden thinking label`);
}

// Toggle off again: persists "off\n" and restores the stock label.
await calmCommand.handler("", ctx);
check(!visibility.calmPresentationIsActive(), "second toggle did not deactivate Calm");
check(readFileSync(`${process.env.AGENT_DIR}/calm`, "utf8") === "off\n", "second toggle did not persist off");
check(hiddenThinkingLabel === undefined, "turning Calm off did not restore the stock thinking label");
await fire("session_start", { reason: "startup" });
check(!visibility.calmPresentationIsActive(), "restart did not retain the persisted off choice");

// An unwritable state file fails the toggle with a clear error and leaves the
// in-memory state untouched, so the failure is loud instead of silently
// reverting on the next restart.
process.env.PI_CODING_AGENT_DIR = process.env.READONLY_AGENT_DIR;
const readonlyPreferencePath = preference.calmPreferencePath();
chmodSync(process.env.READONLY_AGENT_DIR, 0o555);
let thrown = "";
try {
  await calmCommand.handler("", ctx);
} catch (error) {
  thrown = error instanceof Error ? error.message : String(error);
}
chmodSync(process.env.READONLY_AGENT_DIR, 0o755);
check(thrown.length > 0, "an unwritable state file did not fail the toggle");
check(
  thrown.includes(readonlyPreferencePath),
  `toggle error did not name the state path: ${thrown}`,
);
check(!visibility.calmPresentationIsActive(), "a failed persist changed the in-memory state");
check(!existsSync(readonlyPreferencePath), "a failed persist left a state file");
JS
)
  status=$?
  [ "$status" -eq 0 ] || fail "Pi Calm preference and command contract failed: $out"
  [ -z "$out" ] || fail "Pi Calm preference test printed output: $out"
  pass "Pi Calm registers /calm with no semantic interceptors, defaults to off, persists the toggle with atomic owner-only writes, treats malformed state as off, and fails loudly without state changes on an unwritable preference file"
}

test_rendering_adapters_and_tool_shells() {
  local fixture out status
  if ! command -v node >/dev/null 2>&1 || ! have_pi_package; then
    echo "skip: node or installed Pi package not found for rendering contract"
    return 0
  fi

  fixture="$TMP_ROOT/rendering"
  mkdir -p "$fixture/agent"
  build_node_fixture "$fixture"
  out=$(cd "$fixture" && EXT="$fixture/calm/index.ts" AGENT_DIR="$fixture/agent" PI_PACKAGE_DIR="$PI_PACKAGE_DIR" node --input-type=module 2>&1 <<'JS'
import { writeFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

process.env.PI_CODING_AGENT_DIR = process.env.AGENT_DIR;
const root = process.env.PI_PACKAGE_DIR;
const [{ AgentSession, AssistantMessageComponent, ToolExecutionComponent, createBashToolDefinition, createEditToolDefinition, createFindToolDefinition, createGrepToolDefinition, createLsToolDefinition, createReadToolDefinition, createWriteToolDefinition }, { initTheme }, { Text }] = await Promise.all([
  import("@earendil-works/pi-coding-agent"),
  import(pathToFileURL(`${root}/dist/modes/interactive/theme/theme.js`).href),
  import("@earendil-works/pi-tui"),
]);
initTheme("dark");
const extension = await import(pathToFileURL(process.env.EXT).href);
const visibility = await import(pathToFileURL(`${process.cwd()}/calm/lib/visibility.ts`).href);
const check = (condition, message) => { if (!condition) throw new Error(message); };

const tools = [];
const handlers = new Map();
let command;
const pi = {
  on(event, handler) { const list = handlers.get(event) ?? []; list.push(handler); handlers.set(event, list); },
  registerCommand(name, value) { if (name === "calm") command = value; },
  registerTool(tool) { tools.push(tool); },
};
extension.default(pi);
check(tools.length === 0, "Calm replaced active tool definitions");
const ui = {
  getEditorText: () => "",
  getToolsExpanded: () => false,
  onTerminalInput: () => () => {},
  setHiddenThinkingLabel() {},
  setToolsExpanded() {},
  setWidget() {},
  setWorkingVisible() {},
};
const ctx = { ui };
for (const handler of handlers.get("session_start")) await handler({ reason: "startup" }, ctx);

const assistant = new AssistantMessageComponent({
  role: "assistant", api: "test", provider: "test", model: "test", timestamp: 1,
  usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, totalTokens: 0, cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 } },
  stopReason: "stop",
  content: [{ type: "thinking", thinking: "PRIVATE_REASONING" }, { type: "text", text: "VISIBLE_ASSISTANT_TEXT" }],
}, true, undefined, "Thinking...");
check(assistant.render(100).join("\\n").includes("Thinking..."), "Calm changed collapsed thinking while off");
await command.handler("", ctx);
check(visibility.calmPresentationIsActive(), "Calm did not activate for rendering coverage");
assistant.setHiddenThinkingLabel("");
const hiddenAssistant = assistant.render(100).join("\\n");
check(!hiddenAssistant.includes("PRIVATE_REASONING") && hiddenAssistant.includes("VISIBLE_ASSISTANT_TEXT"), "collapsed thinking was not removed gaplessly while assistant text stayed visible");
assistant.setHideThinkingBlock(false);
check(assistant.render(100).join("\\n").includes("PRIVATE_REASONING"), "expanding thinking did not restore its original content");
assistant.setHideThinkingBlock(true);

const renderUi = { requestRender() {} };
const builtInFactories = [createReadToolDefinition, createBashToolDefinition, createEditToolDefinition, createWriteToolDefinition, createGrepToolDefinition, createFindToolDefinition, createLsToolDefinition];
for (const factory of builtInFactories) {
  const definition = factory(process.cwd());
  const toolName = definition.name;
  const session = Object.create(AgentSession.prototype);
  session._toolDefinitions = new Map([[toolName, { definition, sourceInfo: { source: "builtin" } }]]);
  check(session.getToolDefinition(toolName) === definition, `${toolName} definition lookup changed identity`);
  const row = new ToolExecutionComponent(toolName, `call-${toolName}`, {}, { showImages: false }, definition, renderUi, process.cwd());
  row.markExecutionStarted();
  row.setArgsComplete();
  row.updateResult({ content: [{ type: "text", text: `RESULT_${toolName}` }], details: {}, isError: false });
  check(row.render(100).length === 0, `${toolName} left a supported call/result shell visible`);
  visibility.setCalmStockExportRendering(true);
  row.setExpanded(true);
  check(row.render(100).length > 0, `${toolName} was missing from stock export/share rendering`);
  visibility.setCalmStockExportRendering(false);
}
const custom = {
  name: "custom_boundary", label: "Custom boundary", description: "test", parameters: { type: "object", properties: {} }, renderShell: "self",
  async execute() { return { content: [{ type: "text", text: "CUSTOM_RESULT" }], details: {} }; },
  renderCall() { return new Text("CUSTOM_CALL", 0, 0); },
  renderResult() { return new Text("CUSTOM_RESULT", 0, 0); },
};
const customRow = new ToolExecutionComponent("custom_boundary", "custom-call", {}, { showImages: false }, custom, renderUi, process.cwd());
customRow.markExecutionStarted(); customRow.setArgsComplete(); customRow.updateResult({ content: [{ type: "text", text: "CUSTOM_RESULT" }], details: {}, isError: false });
check(customRow.render(100).join("\\n").includes("CUSTOM_CALL"), "Calm hid a generic custom tool");
const collidingCustom = { ...custom, name: "read" };
const customSession = Object.create(AgentSession.prototype);
customSession._toolDefinitions = new Map([["read", { definition: collidingCustom, sourceInfo: { source: "sdk" } }]]);
check(customSession.getToolDefinition("read") === collidingCustom, "custom collision definition lookup changed identity");
const collidingRow = new ToolExecutionComponent("read", "custom-read-call", {}, { showImages: false }, collidingCustom, renderUi, process.cwd());
collidingRow.markExecutionStarted(); collidingRow.setArgsComplete(); collidingRow.updateResult({ content: [{ type: "text", text: "CUSTOM_RESULT" }], details: {}, isError: false });
check(collidingRow.render(100).join("\\n").includes("CUSTOM_CALL"), "Calm hid a built-in-named custom tool");
const baseOverrideCustom = { ...custom, name: "bash" };
const baseOverrideSession = Object.create(AgentSession.prototype);
baseOverrideSession._baseToolsOverride = { bash: baseOverrideCustom };
baseOverrideSession._toolDefinitions = new Map([["bash", { definition: baseOverrideCustom, sourceInfo: { source: "builtin" } }]]);
check(baseOverrideSession.getToolDefinition("bash") === baseOverrideCustom, "SDK base override lookup changed identity");
const baseOverrideRow = new ToolExecutionComponent("bash", "sdk-bash-call", {}, { showImages: false }, baseOverrideCustom, renderUi, process.cwd());
baseOverrideRow.markExecutionStarted(); baseOverrideRow.setArgsComplete(); baseOverrideRow.updateResult({ content: [{ type: "text", text: "CUSTOM_RESULT" }], details: {}, isError: false });
check(baseOverrideRow.render(100).join("\\n").includes("CUSTOM_CALL"), "Calm hid an SDK base-tool override");
const session = [{ type: "message", message: { role: "user", content: "REAL_USER_PROMPT" } }, { type: "message", message: { role: "assistant", content: "VISIBLE_ASSISTANT_TEXT" } }];
const before = JSON.stringify(session);
check(JSON.stringify(session) === before, "presentation test changed session data");
await command.handler("", ctx);
assistant.setHiddenThinkingLabel("Thinking...");
check(!visibility.calmPresentationIsActive(), "Calm did not deactivate");
check(assistant.render(100).join("\\n").includes("Thinking..."), "Calm off did not restore collapsed thinking label");
JS
)
  status=$?
  [ "$status" -eq 0 ] || fail "Pi Calm rendering contract failed: $out"
  [ -z "$out" ] || fail "Pi Calm rendering contract printed output: $out"
  pass "Pi Calm hides only collapsed thinking and known built-in shells, retains custom content, and restores stock export/share rendering"
}

test_working_ship_and_lifecycle() {
  local fixture out status
  if ! command -v node >/dev/null 2>&1 || ! have_pi_package; then
    echo "skip: node or installed Pi package not found for working-ship contract"
    return 0
  fi

  fixture="$TMP_ROOT/working-ship"
  mkdir -p "$fixture/agent"
  build_node_fixture "$fixture"
  out=$(cd "$fixture" && EXT="$fixture/calm/index.ts" AGENT_DIR="$fixture/agent" PI_PACKAGE_DIR="$PI_PACKAGE_DIR" node --input-type=module 2>&1 <<'JS'
import { pathToFileURL } from "node:url";

process.env.PI_CODING_AGENT_DIR = process.env.AGENT_DIR;
const root = process.env.PI_PACKAGE_DIR;
const [{ visibleWidth }, { initTheme }] = await Promise.all([
  import("@earendil-works/pi-tui"),
  import(pathToFileURL(`${root}/dist/modes/interactive/theme/theme.js`).href),
]);
initTheme("dark");
const ship = await import(pathToFileURL(`${process.cwd()}/calm/lib/working-ship.ts`).href);
const extension = await import(pathToFileURL(process.env.EXT).href);
const check = (condition, message) => { if (!condition) throw new Error(message); };
const strip = (line) => line.replace(/\x1b\[[0-9;]*m/g, "");
const { createCalmWorkingShipAnimation, createCalmWorkingShipWidget, CALM_WORKING_SHIP_TICK_MS, CALM_WORKING_SHIP_TICKS_PER_MOVE, CALM_WORKING_SHIP_WIDGET_KEY } = ship;
check(CALM_WORKING_SHIP_TICK_MS * CALM_WORKING_SHIP_TICKS_PER_MOVE === 880, "boat cadence changed from 880ms per column");
const animation = createCalmWorkingShipAnimation();
for (let width = 1; width <= 100; width += 1) {
  for (let frame = 0; frame < 12; frame += 1) {
    const lines = animation.render(width);
    check(lines.length === (width >= 4 ? 2 : 1), `width ${width} produced wrong row count`);
    for (const line of lines) check(visibleWidth(line) <= width, `width ${width} wraps`);
    check(visibleWidth(lines.at(-1)) === width, `width ${width} has incomplete water`);
    animation.tick();
  }
}
animation.reset(); animation.render(40);
const origin = animation.position();
for (let tick = 0; tick < CALM_WORKING_SHIP_TICKS_PER_MOVE - 1; tick += 1) animation.tick();
check(animation.position() === origin && animation.waterPhase() !== 0, "water did not ripple independently before boat movement");
animation.tick(); check(animation.position() === origin + 1, "boat did not move on its slower cadence");
while (animation.position() < 36) animation.tick();
const shrunk = animation.render(12);
check(animation.position() === 8 && animation.direction() === -1 && visibleWidth(shrunk[1]) === 12, "wide-to-narrow resize did not clamp and reverse safely");
const frozen = { position: animation.position(), direction: animation.direction(), phase: animation.waterPhase() };
const tui = { requests: 0, requestRender() { this.requests += 1; } };
const widget = createCalmWorkingShipWidget(tui, animation);
widget.render(12); widget.dispose();
check(animation.position() === frozen.position && animation.direction() === frozen.direction && animation.waterPhase() === frozen.phase, "disposing a widget advanced frozen animation state");
const resumed = createCalmWorkingShipWidget(tui, animation);
resumed.render(12);
check(animation.position() === frozen.position && animation.direction() === frozen.direction, "resuming changed frozen position or heading");
resumed.dispose();

const tools = []; const handlers = new Map(); let command;
const pi = { on(event, handler) { const values = handlers.get(event) ?? []; values.push(handler); handlers.set(event, values); }, registerCommand(name, value) { if (name === "calm") command = value; }, registerTool(tool) { tools.push(tool); } };
extension.default(pi);
const widgets = new Map(); const changes = []; let expanded = true;
const ui = {
  getEditorText: () => "", getToolsExpanded: () => expanded, onTerminalInput: () => () => {}, setHiddenThinkingLabel() {},
  setToolsExpanded(value) { expanded = value; },
  setWorkingVisible(value) { changes.push(["working", value]); },
  setWidget(key, value) { changes.push(["widget", key, value === undefined ? "clear" : "set"]); if (value === undefined) { widgets.get(key)?.dispose?.(); widgets.delete(key); } else widgets.set(key, value(tui)); },
};
const ctx = { ui };
const fire = async (event) => { for (const handler of handlers.get(event) ?? []) await handler({}, ctx); };
await fire("session_start"); changes.length = 0;
await fire("agent_start"); await fire("agent_settled");
check(changes.length === 0, "Calm off changed Pi's stock working row");
await command.handler("", ctx); check(expanded, "Calm toggle changed Ctrl+O expansion state");
await fire("agent_start");
check(changes.some((change) => change[0] === "widget" && change[1] === CALM_WORKING_SHIP_WIDGET_KEY && change[2] === "set"), "Calm did not install its working widget");
check(changes.some((change) => change[0] === "working" && change[1] === false), "Calm did not hide stock working row during a run");
changes.length = 0; await fire("session_shutdown");
check(changes.some((change) => change[0] === "widget" && change[2] === "clear"), "extension shutdown did not clear working widget");
check(changes.some((change) => change[0] === "working" && change[1] === true), "extension shutdown did not restore stock working row");
JS
)
  status=$?
  [ "$status" -eq 0 ] || fail "Pi Calm working ship and lifecycle contract failed: $out"
  [ -z "$out" ] || fail "Pi Calm working ship test printed output: $out"
  pass "Pi Calm working ship has fixed geometry and cadence, survives resize and freeze/resume, and restores stock lifecycle behavior"
}

test_collapsed_thinking_degradation() {
  local fixture out status
  if ! command -v node >/dev/null 2>&1 || ! have_pi_package; then
    echo "skip: node or installed Pi package not found for adapter degradation"
    return 0
  fi

  fixture="$TMP_ROOT/degradation"
  build_node_fixture "$fixture"
  out=$(cd "$fixture" && EXT="$fixture/calm/index.ts" node --input-type=module 2>&1 <<'JS'
import { AssistantMessageComponent } from "@earendil-works/pi-coding-agent";
import { pathToFileURL } from "node:url";
const original = AssistantMessageComponent.prototype.updateContent;
const diagnostics = [];
const previousError = console.error;
console.error = (...args) => diagnostics.push(args.join(" "));
delete AssistantMessageComponent.prototype.updateContent;
let command;
const handlers = new Map();
try {
  const extension = await import(`${pathToFileURL(process.env.EXT).href}?degraded=${Date.now()}`);
  extension.default({
    on(event, handler) { handlers.set(event, handler); },
    registerCommand(name, value) { if (name === "calm") command = value; },
    registerTool() {},
  });
} finally {
  AssistantMessageComponent.prototype.updateContent = original;
  console.error = previousError;
}
if (!command || !handlers.has("session_start")) throw new Error("a missing collapsed-thinking seam stopped the rest of Calm from registering");
if (!diagnostics.some((line) => line.includes("collapsed-thinking") && /unavailable.*skipping/i.test(line))) {
  throw new Error(`missing clear collapsed-thinking degradation diagnostic: ${JSON.stringify(diagnostics)}`);
}
JS
)
  status=$?
  [ "$status" -eq 0 ] || fail "Pi Calm collapsed-thinking degradation contract failed: $out"
  [ -z "$out" ] || fail "Pi Calm collapsed-thinking degradation test printed output: $out"
  pass "Pi Calm degrades only its exported-class collapsed-thinking adapter with a clear diagnostic"
}

test_real_pi_tui_smoke() {
  local fixture agent project socket pane i
  if ! command -v pi >/dev/null 2>&1 || ! command -v tmux >/dev/null 2>&1; then
    echo "skip: pi or tmux not found for isolated real TUI smoke"
    return 0
  fi
  [ "$(pi --version 2>/dev/null || true)" = "0.82.0" ] \
    || fail "real Pi smoke requires the installed Pi 0.82.0 proof target"

  fixture="$TMP_ROOT/tui-smoke"
  agent="$fixture/agent"
  project="$fixture/project"
  socket="pi-calm-smoke-$$"
  mkdir -p "$agent/extensions" "$project" "$fixture/captures" "$fixture/sessions"
  capture_tui() {
    local label=$1
    tmux -L "$socket" capture-pane -p -t "$TMUX_SESSION" >"$fixture/captures/$label.current.txt" 2>/dev/null || true
    tmux -L "$socket" capture-pane -p -t "$TMUX_SESSION" -S -100 >"$fixture/captures/$label.scrollback.txt" 2>/dev/null || true
    tmux -L "$socket" capture-pane -ep -t "$TMUX_SESSION" >"$fixture/captures/$label.current.ansi.txt" 2>/dev/null || true
    tmux -L "$socket" capture-pane -ep -t "$TMUX_SESSION" -S -100 >"$fixture/captures/$label.scrollback.ansi.txt" 2>/dev/null || true
  }
  cp -R "$CALM_DIR" "$agent/extensions/"
  cat >"$project/provider.ts" <<'TS'
import { appendFileSync } from "node:fs";
import { createAssistantMessageEventStream } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const mark = (event: string) => {
  const file = process.env.CALM_SMOKE_MARKERS;
  if (file) appendFileSync(file, `${Date.now()} ${event}\n`);
};

export default function (pi: ExtensionAPI): void {
  pi.registerProvider("calm-smoke", {
    baseUrl: "http://127.0.0.1/unused", apiKey: "test-only", api: "openai-completions",
    models: [{ id: "deterministic", name: "Calm smoke", reasoning: false, input: ["text"], cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 }, contextWindow: 4096, maxTokens: 128 }],
    streamSimple(model) {
      mark(`streamSimple ${model.provider}/${model.id}`);
      const stream = createAssistantMessageEventStream();
      const output = { role: "assistant" as const, content: [], api: model.api, provider: model.provider, model: model.id, usage: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, totalTokens: 0, cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 } }, stopReason: "stop" as const, timestamp: Date.now() };
      queueMicrotask(() => {
        mark("stream-start");
        stream.push({ type: "start", partial: output });
        setTimeout(() => {
          const text = "CALM_SMOKE_GENUINE_ASSISTANT";
          output.content.push({ type: "text", text });
          stream.push({ type: "text_start", contentIndex: 0, partial: output });
          stream.push({ type: "text_delta", contentIndex: 0, delta: text, partial: output });
          stream.push({ type: "text_end", contentIndex: 0, content: text, partial: output });
          stream.push({ type: "done", reason: "stop", message: output });
          mark("stream-done");
          stream.end();
        }, 1400);
      });
      return stream;
    },
  });
  pi.registerCommand("calm-smoke", {
    description: "Deterministic local Calm smoke provider.",
    handler: async (_args, ctx) => {
      mark("command-enter");
      const model = ctx.modelRegistry.find("calm-smoke", "deterministic");
      if (!model || !(await pi.setModel(model))) throw new Error("Calm smoke model unavailable");
      mark("model-selected");
      pi.sendUserMessage("CALM_SMOKE_GENUINE_USER");
      mark("user-message-sent");
    },
  });
}
TS

  tmux -L "$socket" new-session -d -s "$TMUX_SESSION" -x 100 -y 30 \
    "cd '$project' && env PI_CODING_AGENT_DIR='$agent' PI_CODING_AGENT_SESSION_DIR='$fixture/sessions' PI_OFFLINE=1 CALM_SMOKE_MARKERS='$fixture/provider-markers.txt' pi --approve --no-context-files --no-skills --no-prompt-templates -e ./provider.ts"
  for i in $(seq 1 120); do
    tmux -L "$socket" capture-pane -p -t "$TMUX_SESSION" -S -100 >"$fixture/pane" 2>/dev/null || true
    grep -Fq 'provider.ts' "$fixture/pane" && break
    sleep 0.05
  done
  grep -Fq 'provider.ts' "$fixture/pane" || fail "real Pi smoke did not load the disposable provider"
  capture_tui ready
  tmux -L "$socket" send-keys -t "$TMUX_SESSION" -l '/calm'
  tmux -L "$socket" send-keys -t "$TMUX_SESSION" Enter
  sleep 0.2
  capture_tui after-calm
  tmux -L "$socket" send-keys -t "$TMUX_SESSION" -l '/calm-smoke'
  tmux -L "$socket" send-keys -t "$TMUX_SESSION" Enter
  for i in $(seq 1 120); do
    if [ -f "$fixture/provider-markers.txt" ] && grep -Fq 'stream-start' "$fixture/provider-markers.txt"; then
      capture_tui working-wide
      tmux -L "$socket" capture-pane -p -t "$TMUX_SESSION" -S -100 >"$fixture/wide" 2>/dev/null || true
      grep -Fq '\__/' "$fixture/wide" && break
    fi
    sleep 0.02
  done
  grep -Fq 'stream-start' "$fixture/provider-markers.txt" || fail "real Pi smoke did not enter the provider stream"
  grep -Fq '\__/' "$fixture/wide" || fail "real Pi smoke did not show Calm's wide working boat"
  tmux -L "$socket" resize-window -t "$TMUX_SESSION" -x 40 -y 30
  for i in $(seq 1 120); do
    capture_tui working-narrow
    tmux -L "$socket" capture-pane -p -t "$TMUX_SESSION" -S -100 >"$fixture/narrow" 2>/dev/null || true
    grep -Fq '\__/' "$fixture/narrow" && break
    grep -Fq 'stream-done' "$fixture/provider-markers.txt" 2>/dev/null && break
    sleep 0.02
  done
  grep -Fq '\__/' "$fixture/narrow" || fail "real Pi smoke did not reflow Calm's working boat on resize"
  for i in $(seq 1 120); do
    tmux -L "$socket" capture-pane -p -t "$TMUX_SESSION" -S -100 >"$fixture/pane" 2>/dev/null || true
    grep -Fq 'CALM_SMOKE_GENUINE_ASSISTANT' "$fixture/pane" && break
    sleep 0.05
  done
  pane=$(cat "$fixture/pane")
  assert_contains "$pane" 'CALM_SMOKE_GENUINE_USER' "real Pi smoke hid a genuine user prompt"
  assert_contains "$pane" 'CALM_SMOKE_GENUINE_ASSISTANT' "real Pi smoke hid genuine assistant text"
  [ "$(cat "$agent/calm")" = on ] || fail "real Pi smoke did not persist Calm on"
  tmux -L "$socket" send-keys -t "$TMUX_SESSION" -l '/calm'
  tmux -L "$socket" send-keys -t "$TMUX_SESSION" Enter
  sleep 0.15
  [ "$(cat "$agent/calm")" = off ] || fail "real Pi smoke did not persist Calm off"
  tmux -L "$socket" send-keys -t "$TMUX_SESSION" -l '/quit'
  tmux -L "$socket" send-keys -t "$TMUX_SESSION" Enter
  sleep 0.1
  tmux -L "$socket" kill-server 2>/dev/null || true
  pass "isolated Pi 0.82 TUI proves auto-load, /calm persistence, resize-safe working animation, and genuine transcript text without credentials"
}

test_zero_coupling_and_state_file
test_static_typescript_and_repo_wiring
test_preference_and_command
test_rendering_adapters_and_tool_shells
test_working_ship_and_lifecycle
test_collapsed_thinking_degradation
test_real_pi_tui_smoke
