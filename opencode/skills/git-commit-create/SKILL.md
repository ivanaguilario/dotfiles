---
name: git-commit-create
description: Analyze current git changes, draft a conventional commit message, and create a safe commit when explicitly requested
compatibility: opencode
metadata:
  audience: maintainers
  workflow: git
---

## What I do

- Inspect staged, unstaged, and untracked git changes.
- Explain the pending changes in simple text.
- Draft a concise conventional commit message from the actual diff.
- Create the commit only when the user explicitly asks to commit.

## When to use me

Use this skill when the user wants help preparing or creating a git commit from the current working tree.

## Default behavior

- Preview only.
- Do not create a commit unless the user explicitly asks to commit.
- Do not push.
- Do not amend a commit unless the user explicitly asks for amend behavior.
- Do not skip hooks with `--no-verify` unless the user explicitly asks.
- Be conservative when changes are ambiguous, unrelated, or risky.
- Keep the response simple: explain what changed and show the proposed commit message.

## Required inputs

- A git repository with changes intended for commit.

Optional inputs:

- Preferred conventional-commit type.
- Preferred conventional-commit scope.
- Exact commit message override.
- Explicit list of files to include or exclude.

## Analysis workflow

Before drafting or creating a commit, inspect the repository state.

Collect and reason about all of the following:

- Current branch and upstream status.
- Staged changes.
- Unstaged changes.
- Untracked file names.
- Recent commit message style.
- Whether a merge, rebase, cherry-pick, or revert is in progress.
- Whether any files look like secrets, credentials, private keys, environment files, or generated artifacts that should not be committed.

Use this workflow:

1. Check the working tree with `git status --short --branch`.
2. Inspect staged and unstaged diffs with `git diff --cached` and `git diff`.
3. Inspect untracked file names without reading secret-like files.
4. Review recent commit style with `git log --oneline -5`.
5. Decide whether the changes form a coherent commit.
6. Draft a conventional commit message based only on the actual changes and user-provided context.

If staged changes already exist, preserve the user's staging intent unless it is clearly unsafe. If unstaged changes appear relevant to the requested commit, explain that they need to be staged or ask before including them.

## Conventional commit rules

Commit messages should follow conventional commit style.

Allowed forms:

```text
<type>: <summary>
<type>(<scope>): <summary>
```

Common types:

- `feat`
- `fix`
- `docs`
- `refactor`
- `test`
- `chore`
- `build`
- `ci`
- `perf`

Rules:

- Choose the type from the main intent of the commit, not incidental files.
- Use a scope only when the changed area is clear and bounded.
- Keep type and scope lower-case.
- Keep the summary concise, specific, and action-oriented.
- Do not end the summary with a period.
- Do not include issue numbers unless the user explicitly asks.
- Do not invent a scope if the changes span unrelated areas.
- Stop and ask if the changes do not have a clear dominant type or intent.

## AI disclaimer

When generating a multi-line commit message, include an AI disclaimer at the bottom of the commit message body:

```text
Built with 🤖 <actual runtime model name> via <actual tool name>
```

Use the real current model name from system context and the real current tool name in use. Do not hardcode a model name, tool name, or version into the skill.

For single-line commits, show the disclaimer in the preview or result text after the commit message instead of appending it to the subject line.

## Preview behavior

In preview mode:

- Explain in simple text what the commit would include.
- Show the proposed conventional commit message in a fenced code block.
- Mention excluded files only when relevant.
- Mention ambiguities, secrets risk, generated files, or unrelated changes when present.
- Do not create the commit.

Example preview shape:

````md
This commit would add the git commit creation skill and document its conservative preview-first workflow.

Proposed commit message:

```text
feat(opencode): add git commit creation skill

Built with 🤖 <actual runtime model name> via <actual tool name>
```

No commit has been created yet.
````

## Execute behavior

In execute mode:

- Re-run the analysis immediately before committing.
- Confirm the working tree still matches the planned commit contents.
- Stage only the files that belong in the commit.
- Create the commit with the proposed or user-approved message.
- Let hooks run normally.
- Report the created commit hash and message.
- Report any remaining working tree changes.

Use normal `git commit` behavior. Do not use destructive git commands. Do not push after committing unless the user separately and explicitly asks to push.

## Stop conditions

Stop and ask if any of the following are true:

- There are no changes to commit.
- `HEAD` is detached.
- A merge, rebase, cherry-pick, or revert state makes the expected commit unclear.
- The changes are unrelated or too mixed for one safe commit.
- The requested files are ambiguous.
- A file appears to contain secrets or credentials.
- A requested file is a private key, `.env`, `.vault_password`, credentials file, or another sensitive file.
- The change includes generated files or lockfiles and it is unclear whether they should be committed.
- The conventional-commit type or scope cannot be inferred safely.
- Hooks fail during commit.

## Safety rules

- Never read secret files to decide whether they should be committed.
- Never print, copy, or summarize secret values.
- Never revert, reset, or discard user changes.
- Never stage every file blindly when unrelated changes are present.
- Never commit untracked files that look sensitive.
- Never amend, rebase, force-push, or skip hooks unless explicitly requested and safe.
- Prefer the smallest coherent commit over bundling unrelated changes.

## Operational style

- Be direct and concise.
- Explain what will be committed in plain language.
- Favor correctness over convenience.
- If unsure, stop and ask.
