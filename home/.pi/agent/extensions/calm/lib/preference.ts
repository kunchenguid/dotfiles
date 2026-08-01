// Pi Calm - persisted on/off preference.
//
// Copyright (c) 2026 Kun Chen. MIT License - see the LICENSE file in this directory.
//
// The preference lives in a plain local state file named "calm" directly under
// Pi's agent directory (~/.pi/agent by default, PI_CODING_AGENT_DIR when set).
// That directory is Pi runtime territory: this repository never tracks the
// state file and Home Manager never manages it. The file contains exactly
// "on\n" or "off\n"; anything else, including a missing or unreadable file,
// means off.

import { randomUUID } from "node:crypto";
import {
  mkdirSync,
  readFileSync,
  renameSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { homedir } from "node:os";
import { dirname, join } from "node:path";
import * as PiCodingAgent from "@earendil-works/pi-coding-agent";

export const CALM_PREFERENCE_FILE_NAME = "calm";

/**
 * Resolve Pi's agent directory through Pi's exported getAgentDir(), which
 * honors PI_CODING_AGENT_DIR and tilde expansion. If a future Pi stops
 * exporting it, fall back to the documented environment variable and default
 * path instead of failing.
 */
export function calmAgentDir(): string {
  if (typeof PiCodingAgent.getAgentDir === "function") return PiCodingAgent.getAgentDir();
  const envDir = process.env.PI_CODING_AGENT_DIR?.trim();
  if (envDir) return envDir;
  return join(homedir(), ".pi", "agent");
}

export function calmPreferencePath(): string {
  return join(calmAgentDir(), CALM_PREFERENCE_FILE_NAME);
}

/** Load the persisted preference. Calm is off by default and on any read error. */
export function loadCalmPreference(): boolean {
  try {
    return readFileSync(calmPreferencePath(), "utf8").trim() === "on";
  } catch {
    return false;
  }
}

/**
 * Persist the preference atomically (unique temp file plus rename) so a
 * crashed write never leaves a truncated state file. A failure throws a clear
 * error naming the path so /calm can surface it instead of silently applying
 * a toggle that would not survive a restart.
 */
export function persistCalmPreference(active: boolean): void {
  const path = calmPreferencePath();
  try {
    mkdirSync(dirname(path), { recursive: true });
    const temporaryPath = `${path}.${process.pid}.${randomUUID()}.tmp`;
    try {
      writeFileSync(temporaryPath, active ? "on\n" : "off\n", {
        encoding: "utf8",
        flag: "wx",
        mode: 0o600,
      });
      renameSync(temporaryPath, path);
    } finally {
      rmSync(temporaryPath, { force: true });
    }
  } catch (error) {
    const reason = error instanceof Error ? error.message : String(error);
    throw new Error(`Pi Calm could not persist its preference to ${path}: ${reason}`);
  }
}
