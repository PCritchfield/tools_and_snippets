# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

A personal dotfile and configuration backup repo, plus a small standalone project (pireplace). There is no application build system, no test suite, and no CI/CD pipeline. Configs are currently installed manually (copy/symlink to their destinations) — there is no automated bootstrap process yet.

Each subdirectory is independent and self-contained. The repo has grown organically, so expect some overlap and drift between older and newer patterns (e.g., root `aliases` vs `zsh/aliases.zsh`).

## Repository Structure

- **`claude/`** — Backup of Claude Code workspace config: Rincewind personality (`CLAUDE.md`), model/permission settings (`settings.json`), and eight Watch Council subagent definitions in `agents/`. This is a backup — the live config lives at `~/.claude/`
- **`docker/`** — *Archival.* Ansible-in-a-container pattern (~2019). Kept as a reference for "containers as binary toolchain" approach, not actively used
- **`pireplace/`** — Standalone Raspberry Pi project: video looper script (mpv/omxplayer) for streaming video on repeat (originally a holiday fireplace)
- **`vagrant/`** — *Archival.* Ubuntu 16.04 xenial VM provisioning. Kept as reference
- **`zsh/`** — Shell configuration: `.zshrc` (Oh My Zsh + Starship + Atuin + Zoxide), aliases (eza, terraform/terragrunt, AWS SSO, gum-based git workflows)
- **Root files** — `brewfile` (Homebrew packages), `gclone` (smart git clone with org-based directory structure), `starship.toml` (prompt config), `vimrc` (Vundle plugins), `aliases` (legacy git aliases, largely superseded by `zsh/aliases.zsh`)

## Key Architectural Decisions

- **No cross-dependencies**: modules are fully independent of each other
- **`gclone`** enforces a `~/Projects/{host}/{org}/{repo}` directory convention using zoxide for tracking
- **Zsh aliases** rely on external tools: `gum` (interactive UI), `eza` (ls replacement), `zoxide` (cd replacement), `atuin` (history)
- **Watch Council agents** follow a strict promotion path: PLAN → PROBE → IMPLEMENT (NARROW) → IMPLEMENT (WIDE), with veto authority split among `watch-granny` (architecture), `watch-angua` (security), and `watch-vimes` (data safety)

## Shell Environment

The zsh setup expects Oh My Zsh installed at `~/.oh-my-zsh` with:
- Starship prompt (`eval "$(starship init zsh)"`)
- Zoxide (`eval "$(zoxide init zsh)"`)
- Atuin history (`eval "$(atuin init zsh)"`)
- NVM loaded from Homebrew prefix
- Aliases sourced from `~/.oh-my-zsh/custom/aliases.zsh`

## Git Branching

- Main branch: `master`
- Current feature work on `feat/claude`
