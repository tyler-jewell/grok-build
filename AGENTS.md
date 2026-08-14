# This fork

This repository is [tyler-jewell/grok-build](https://github.com/tyler-jewell/grok-build), a fork of [xai-org/grok-build](https://github.com/xai-org/grok-build).

Two purposes only:

1. **Stay current** with official `xai-org/grok-build` `main` via the scheduled GitHub Action in `.github/workflows/sync-upstream.yml`.
2. **Extend** Grok Build for our needs. Those needs are not specified yet. Until they are, do not invent product features.

Upstream does not accept external PRs. Do not open PRs against `xai-org/grok-build`.

## Extend, do not modify

Every change in this fork must survive the next upstream sync without a conflict and without rewriting official source.

Hard rule (also in `.grok/rules/00-extend-only.md`):

- **Never edit, delete, rename, or reformat a file that exists on `upstream/main`.**
- **Only add files** under reserved overlay paths listed below.
- If a task seems to require touching an official file, stop. Use an official extension point, or add a new file under `extensions/`. Do not patch upstream source "just this once."

Preferred order when we do start extending:

1. Official runtime extension points: `.grok/skills/`, `.grok/hooks/`, `.grok/plugins/`, `.grok/config.toml` (MCP, permissions).
2. New files under `extensions/` (own Cargo workspace, scripts, docs). Never add members to the generated root `Cargo.toml`.
3. Source edits to `crates/`, `prod/`, `third_party/`, or other upstream paths — **not allowed**.

## Reserved overlay paths

These are the only paths this fork may add. They do not exist on upstream today:

| Path | Role |
|------|------|
| `AGENTS.md` | This file |
| `.grok/` | Project rules, skills, hooks, plugins, project config |
| `.github/` | Sync + protect-upstream workflows |
| `extensions/` | Our code, scripts, and notes that must not collide with upstream |

If upstream later creates one of these paths, do not merge-overwrite. Relocate *our* files, keep *their* files intact, and update this table.

## Sync model

- Remote `origin` = this fork. Remote `upstream` = `https://github.com/xai-org/grok-build.git`.
- `main` is official `main` plus the overlay only. It is not a clean fast-forward of upstream after the first overlay commit.
- The scheduled workflow **merges** `upstream/main` into `main` (no `-X ours` / `-X theirs`). A conflict is a policy failure: an overlay file leaked into an upstream path.
- Verify before every commit:

  ```sh
  extensions/scripts/check-upstream-untouched.sh
  ```

## Working rules

- Do not commit on a dirty tree of official files "to try something." Use a throwaway branch, then throw it away.
- Do not update `SOURCE_REV`, `Cargo.toml`, `Cargo.lock`, or `crates/**` unless the change came in through an upstream merge.
- Do not copy README or user-guide content into this file. Link if needed.
- `grok inspect` shows which instruction files are loaded.
