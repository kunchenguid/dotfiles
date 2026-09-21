# Kunchen Reproducible Mac Environment — Design

**Date:** 2026-09-21  
**Status:** Approved (Approach B)  
**Sources:** Reproducible Mac Agentic Engineering Cookbook (PDF), https://youtu.be/5N-okeDdIuI

## Goal

Declarative, rebuildable macOS agentic engineering environment (Nix-Darwin + Home Manager + WezTerm + Neovim + herdr + Claude Code) activated on this machine without wiping existing Homebrew installs.

## Architecture

- Flake at repo root; stable path `~/.dotfiles` → this repo (no `~/files`).
- `darwinConfigurations.Mac` composes `configuration.nix` and Home Manager.
- User `oibaf`, `aarch64-darwin`.
- Determinate Nix already installed → `nix.enable = false`.
- Homebrew `onActivation.cleanup = "none"` for first activate.
- Brew package is `herdr` (cookbook says “Herder”).

## Deviations from cookbook PDF (applied)

- Channel pins: **25.05** (24.11 fails system-wide activation assertions on current tooling).
- `nix-homebrew` omitted: latest module wants `pkgs.ruby_4_0` absent from nixpkgs-25.05; host Homebrew is used instead.
- `security.pam.services.sudo_local.enable = false` (SIP blocks managing `/etc/pam.d/sudo_local`).
- Home Manager `backupFileExtension = "backup"`; config paths use `mkOutOfStoreSymlink` for writable Neovim.

## Scope

**In:** flake, system defaults, homebrew wezterm/claude-code/herdr, HM zsh + symlinks, WezTerm Lua, Neovim Lazy/Oil/Snacks baseline, agent SSOT (`home-agents.md`), activate + verify.

**Out:** zap/uninstall cleanup, migrating existing Homebrew formulas into Nix, renaming `Untitled`, full mega-IDE Neovim.

## Manual post-steps

- Claude Code `/status-line` configuration inside Claude.
- First herdr multiplexer session.
