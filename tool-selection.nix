# Turns ./tools.nix's per-tool metadata into concrete package lists for one
# target. Shared by configuration.nix (currentPlatform = "macos", always) and
# home.nix (currentPlatform derived per Linux homeConfigurations output from
# pkgs.stdenv.hostPlatform) so the three-decision selection logic - is the
# tool enabled, does it apply here, which installer owns it - lives in one
# place instead of drifting between the macOS and Ubuntu paths.
#
# See README.md ("Package metadata") for the full field/selection reference.
{ lib, usePersonalSetup, currentPlatform }:

let
  tools = import ./tools.nix;

  # Decision 1: is the tool wanted on this machine's setup at all?
  isEnabled = t:
    t.scope == "basic" || usePersonalSetup;

  # Decision 2: does the tool apply to the OS we're installing onto?
  isForCurrentPlatform = t:
    t.platform == "all" || t.platform == currentPlatform;

  # Decision 3a: on any OS, a stable "all" package is Nix-managed - it is
  # never macOS/Ubuntu-specific, so nix.enable=false aside, Nix owns it.
  useNix = t:
    isForCurrentPlatform t
    && t.updatePolicy == "stable"
    && t.platform != "macos";

  # Decision 3b: on macOS, tools that apply to macOS use Homebrew when they
  # are either fast-moving or macOS-specific. A platform=all/updatePolicy=fast
  # tool is Homebrew-managed only because currentPlatform is "macos" right
  # now, not because Homebrew is inherently "the" fast-package installer.
  useHomebrew = t:
    currentPlatform == "macos"
    && isForCurrentPlatform t
    && (t.platform == "macos" || t.updatePolicy == "fast");

  # Decision 3c: on Ubuntu, fast-moving tools that apply there use a native
  # installer instead of Homebrew (which doesn't exist on this path at all).
  useNative = t:
    currentPlatform == "ubuntu"
    && isForCurrentPlatform t
    && t.updatePolicy == "fast";

  isCaskTool = t: t.isCask or false;
  brewName = t: t.brewName or t.name;
  nixName = t: t.nixName or t.name;

  enabled = lib.filter isEnabled tools;
in
{
  inherit isEnabled isForCurrentPlatform useNix useHomebrew useNative isCaskTool brewName nixName;
  nixTools = lib.filter useNix enabled;
  brewTools = lib.filter (t: useHomebrew t && !isCaskTool t) enabled;
  caskTools = lib.filter (t: useHomebrew t && isCaskTool t) enabled;
  nativeTools = lib.filter useNative enabled;
}
