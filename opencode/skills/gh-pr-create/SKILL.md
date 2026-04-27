---
name: gh-pr-create
description: Analyze the current branch, draft a conventional-commit PR title and description, and open a GitHub pull request with gh
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## What I do

- Analyze the changes in the current branch relative to its base branch.
- Draft a GitHub pull request title that follows conventional commits.
- Draft a pull request description from the actual branch contents.
- Open the pull request with `gh pr create`.
- Return the PR URL after creation.

## When to use me

Use this skill when the user wants to create a GitHub pull request for the current branch and wants the PR title and description generated from the branch's real diff and commit history.

## Default behavior

- Default to preview first.
- Do not create the PR unless the user explicitly asks to proceed.
- Analyze the full branch change set, not only the latest commit.
- Be conservative about ambiguity.
- If the correct base branch, conventional-commit type, scope, or included PR contents are unclear, stop and ask.

## Required inputs

- A git repository with the intended branch checked out.
- A GitHub remote configured for the repository.
- `gh` authenticated for the target repository.

Optional inputs:

- Preferred base branch, if it should not be inferred.
- Preferred PR state, such as draft or ready for review.
- Preferred title override, if the user wants to force the final title.
- Preferred scope override, if the user wants to force a conventional-commit scope.

## Branch analysis workflow

Analyze the current branch before proposing a PR.

Collect and reason about all of the following:

- Current branch name
- Working tree status
- Upstream tracking status
- Whether the branch has already been pushed
- Whether an open PR already exists for the branch
- The likely base branch
- All commits included in the PR
- The cumulative diff included in the PR

Use this workflow:

1. Check the working tree with `git status`.
2. Determine the current branch.
3. Determine whether the branch tracks a remote branch.
4. Determine whether the branch is ahead of the likely base branch.
5. Determine the most likely base branch:
   - Prefer the repository's default branch when it is clear.
   - Prefer `main` when the default branch cannot be directly determined but `main` is clearly present.
   - If the base branch is still ambiguous, stop and ask.
6. Inspect the full PR contents with:
   - `git log <base>..HEAD`
   - `git diff <base>...HEAD`
7. Check for an existing PR for the current branch before creating a new one.

Never summarize the branch from the latest commit alone when multiple commits are included in the PR.

## Conventional commit title rules

The PR title must follow conventional commit style.

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

- Choose the type from the overall branch intent, not incidental file changes.
- Use a scope only when the branch clearly targets a bounded area such as a package, service, app, domain, or subsystem.
- Keep type and scope lower-case.
- Keep the summary concise, specific, and action-oriented.
- Do not end the title with a period.
- Do not include issue numbers unless the user explicitly wants them.
- Do not invent a scope if the branch spans multiple areas without a clear center of gravity.
- Prefer repository terms already used in package names, directories, or team language.
- If the branch contains a mixed set of changes and no dominant type is clear, stop and ask.
- If a scope might fit multiple areas and no single scope is clearly correct, omit the scope or stop and ask if omission would make the title misleading.

Scope selection guidance:

- Infer scope from the dominant area changed across the branch.
- Good scope signals include:
  - top-level package or app name
  - service or module name
  - dominant directory
  - explicit domain terminology in code and commits
- Avoid scope when:
  - the branch spans unrelated areas
  - infra plus app changes are equally central
  - there is no stable repo-specific label for the touched area

Examples:

- `fix: handle ambiguous base branch detection`
- `fix(backend): handle ambiguous base branch detection`
- `feat(auth): add repository-aware PR drafting workflow`
- `docs(opencode): document PR creation skill behavior`

## PR description rules

The PR description must use this exact section structure:

```md
## Summary

## Why

## Risks / Rollout

Built with 🤖 <actual runtime model name> via <actual tool name>
```

Additional rules:

- `## Summary`
  - Use 1 to 3 bullet points.
  - Summarize the most important reviewer-relevant changes.
  - Focus on the branch as a whole.
- `## Why`
  - Explain the motivation for the change.
  - Focus on intent and rationale, not a file-by-file restatement.
- `## Risks / Rollout`
  - Call out risks, migrations, rollout concerns, operational impact, or reviewer caution points.
  - If there are no meaningful risks or rollout notes, write `None`.
- Final line:
  - Always end with `Built with 🤖 <actual runtime model name> via <actual tool name>`.
  - Use the real current model name from system context, exactly as provided there.
  - Use the real current tool name from system context, exactly as provided there.
  - Do not substitute a generic product name like `ChatGPT` or hardcode a version.
  - Do not hardcode a tool name; use the actual tool in use, such as `OpenCode` or `Claude Code`.

Do not invent motivations, risks, or rollout notes that are not supported by the branch contents or user context.

## Preview mode behavior

In preview mode:

- Analyze the current branch.
- Propose a conventional-commit PR title.
- Propose a PR description.
- Report the intended base branch.
- Report whether the branch needs to be pushed first.
- Report whether an existing PR already exists.
- Do not create the PR.

## Execute mode behavior

In execute mode:

- Re-run the branch analysis immediately before creation.
- Confirm that the planned base branch and PR contents still match the current repository state.
- Push the branch if needed.
- Create the PR with `gh pr create`.
- Return the created PR URL.

Preferred execution sequence:

1. Verify branch state again.
2. Push with upstream tracking if needed.
3. Create the PR with explicit `--title` and `--body`.
4. Return the PR URL.

Use a heredoc for the PR body when constructing the `gh pr create` command to preserve formatting.

## Existing PR behavior

Before creating a PR:

- Check whether an open PR already exists for the current branch.
- If one already exists, do not create a duplicate.
- Report the existing PR URL instead.
- If the user wants to change the title or description of the existing PR, stop and ask before taking further action.

## Stop conditions

Stop and ask if any of the following are true:

- `HEAD` is detached.
- The base branch is ambiguous.
- There are no commits ahead of the base branch.
- The branch contains a confusing or unrelated mix of changes that makes a single conventional-commit title unsafe.
- The working tree contains uncommitted changes that appear relevant to the PR scope and make the final PR contents unclear.
- `gh` is unavailable or not authenticated.
- A matching PR already exists and the user has not said whether to reuse or update it.

Never force-push.
Never open a duplicate PR for the same branch.
Never guess the PR type or scope when the branch intent is genuinely unclear.

## Output format

When previewing, use this structure:

## Summary

- Number of commits in the PR
- Whether the branch is pushed
- Whether an existing PR was found
- Whether the PR is ready to create

## Branch State

- Current branch
- Proposed base branch
- Upstream status
- Existing PR status

## Proposed Title

```text
<conventional-commit-title>
```

## Proposed Description

```md
## Summary
- ...
- ...

## Why
...

## Risks / Rollout
None

Built with 🤖 <actual runtime model name> via <actual tool name>
```

## Open Questions

- List any ambiguity that must be resolved before creating the PR

When executing, use this structure:

## Created PR

- Title: `<final-title>`
- Base branch: `<base>`
- PR URL: `<url>`

## Notes

- Whether the branch was pushed during execution
- Whether ambiguity checks were revalidated
- Any non-fatal warnings the user should know
