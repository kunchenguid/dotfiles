const DEFAULT_TITLE = "π";
const PREFIX = "π";
const MAX_TITLE_LENGTH = 40;
const SPINNER_INTERVAL_MS = 120;
const SPINNER_FRAMES = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"];

function truncateTitle(title) {
  if (title.length <= MAX_TITLE_LENGTH) return title;
  return title.slice(0, MAX_TITLE_LENGTH - 3) + "...";
}

function basename(path) {
  if (!path) return DEFAULT_TITLE;

  const trimmed = path.replace(/[\\/]+$/, "");
  if (!trimmed) return DEFAULT_TITLE;

  return trimmed.split(/[\\/]/).pop() || DEFAULT_TITLE;
}

function getSessionName(pi) {
  const name = pi.getSessionName?.();
  return typeof name === "string" ? name.trim() : "";
}

function getRawTitle(pi, ctx) {
  return getSessionName(pi) || basename(ctx.cwd);
}

function isSpinningStatus(status) {
  return status === "working";
}

function statusIndicator(status, spinnerFrame) {
  if (isSpinningStatus(status)) {
    if (SPINNER_FRAMES.length === 0) return "◉";
    return SPINNER_FRAMES[spinnerFrame % SPINNER_FRAMES.length];
  }

  if (status === "done") return "✓";
  if (status === "error") return "✗";
  return "○";
}

function formatTitle(pi, ctx, status, spinnerFrame) {
  const rawTitle = getRawTitle(pi, ctx);
  const suffix = rawTitle === DEFAULT_TITLE ? DEFAULT_TITLE : `${PREFIX} | ${truncateTitle(rawTitle)}`;

  return `${statusIndicator(status, spinnerFrame)} | ${suffix}`;
}

export default function terminalStatusTitle(pi) {
  let status = "idle";
  let spinnerFrame = 0;
  let spinnerInterval;
  let deferredWrite;
  let lastCtx;

  function clearDeferredWrite() {
    if (!deferredWrite) return;

    clearTimeout(deferredWrite);
    deferredWrite = undefined;
  }

  function writeTitle(ctx = lastCtx) {
    if (!ctx?.hasUI) return;

    lastCtx = ctx;
    ctx.ui.setTitle(formatTitle(pi, ctx, status, spinnerFrame));
  }

  function stopSpinner() {
    if (!spinnerInterval) return;

    clearInterval(spinnerInterval);
    spinnerInterval = undefined;
    spinnerFrame = 0;
  }

  function startSpinner(ctx) {
    if (!ctx?.hasUI || spinnerInterval) return;

    spinnerFrame = 0;
    spinnerInterval = setInterval(() => {
      if (!isSpinningStatus(status)) {
        stopSpinner();
        return;
      }

      spinnerFrame = (spinnerFrame + 1) % SPINNER_FRAMES.length;
      writeTitle();
    }, SPINNER_INTERVAL_MS);
    spinnerInterval.unref?.();
  }

  function setStatus(nextStatus, ctx) {
    clearDeferredWrite();
    status = nextStatus;
    lastCtx = ctx;

    if (isSpinningStatus(status)) {
      startSpinner(ctx);
    } else {
      stopSpinner();
    }

    writeTitle(ctx);
  }

  function scheduleWrite(ctx) {
    clearDeferredWrite();
    deferredWrite = setTimeout(() => {
      deferredWrite = undefined;
      writeTitle(ctx);
    }, 0);
    deferredWrite.unref?.();
  }

  pi.on("session_start", async (_event, ctx) => {
    setStatus("idle", ctx);
    scheduleWrite(ctx);
  });

  pi.on("agent_start", async (_event, ctx) => {
    setStatus("working", ctx);
  });

  pi.on("agent_settled", async (_event, ctx) => {
    setStatus("done", ctx);
  });

  pi.on("session_shutdown", async () => {
    clearDeferredWrite();
    stopSpinner();
  });
}
