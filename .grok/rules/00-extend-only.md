# Extend only — upstream-sync proof

This fork tracks `xai-org/grok-build`. Official `main` is merged in on a schedule. Your edits must never make that merge fail and must never rewrite upstream source.

## Forbidden

Do not modify, delete, rename, move, or reformat any path that already exists on `upstream/main`. That includes, without exception:

- `crates/`, `prod/`, `third_party/`, `bin/`
- Root `Cargo.toml`, `Cargo.lock` (generated / upstream-owned)
- `README.md`, `CONTRIBUTING.md`, `LICENSE`, `SECURITY.md`, `SOURCE_REV`, `THIRD-PARTY-NOTICES`
- `clippy.toml`, `rustfmt.toml`, `rust-toolchain.toml`, `.cargo/`, `.gitignore`

Do not add workspace members to the root `Cargo.toml`. Do not "just tweak" an official crate to hook a feature. Do not apply patches onto upstream files. Do not format or lint-fix official sources as a side effect of your work.

If the user asks for a change that requires editing an official file, refuse that approach. Explain the extend-only rule and propose one of the allowed options below.

## Allowed

Add new files only under these reserved overlay roots:

- `AGENTS.md`
- `.grok/`
- `.github/`
- `extensions/`

Prefer official extension mechanisms before writing Rust:

1. Skills, hooks, plugins, MCP, and permission rules under `.grok/`
2. New crates, scripts, or wrappers under `extensions/` in a **separate** Cargo workspace (path-depend on upstream crates; do not join the generated workspace)

## Before you finish any change

Run from the repo root:

```sh
extensions/scripts/check-upstream-untouched.sh
```

The script must exit 0. If it lists paths, revert those paths. They exist on `upstream/main` and must stay byte-identical to what the last upstream merge brought in, except through a later upstream merge itself.

## Collision with a future upstream path

If `xai-org/grok-build` adds `AGENTS.md`, `.grok/`, `.github/`, or `extensions/`, do not overwrite their files. Move ours to a still-unused overlay path, keep theirs, and update `AGENTS.md`.
