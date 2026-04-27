# AGENTS.md

# General
- NEVER read .env, .vault_password or any other files that contain credentials. Ask if unsure.
- NEVER read any SSH or GPG private keys. Ask if unsure.
- Never print, copy, or summarize secret values found in config files.
- Prefer environment-variable references over hardcoded credentials when suggesting config changes.
- Prefer minimal, targeted changes and avoid unrelated refactors.
- Do not modify generated files or lockfiles unless the task requires it.
- After making changes, run the smallest relevant verification step available.
- If verification cannot be run, state that clearly.
- Always check the current workspace before asking to check outside it.
- Never attempt to check outside the current workspace unless explicitly told to.
- Ask before performing destructive, external, or high-impact actions.
- Always use an available skill when the task matches it.
- Always use skills when possible.

# Kubernetes
- NEVER read Kubernetes secrets.
- NEVER apply manifests, install / update helm releases, etc. without confirmation.
- When modifying Helm values files, ALWAYS check the actual chart to verify the values and keys are correct.

# Terraform / OpenTofu / Pulumi
- NEVER plan or apply infrastructure changes unless explicitly allowed.
- NEVER read state files of any kind unless explicitly allowed.

# Git
- Never commit any work.
- Never push, force-push, rebase, or amend commits unless explicitly requested.
- Do not revert user changes you did not make.
- Always create branches from updated main when starting a work session.
- Branch names should be prefixed with chore/, feat/ or fix/ depending on the work we're doing.

# Delegation
- When delegating to a specialized subagent whose output format is part of the task, preserve that output verbatim.
- For `video-normalizer` and `music-normalizer`, do not summarize, paraphrase, or rewrite the subagent's final response.
- Do not convert subagent Markdown tables into bullets.
- Do not collapse fenced code blocks from subagent output.
- Return the subagent's final response body unchanged.
- If additional context is necessary, add at most one short line before the raw subagent output.
- If a subagent is explicitly instructed to produce a table, checklist, command block, or other structured format, preserve that structure in the final user-visible response.

# Observability
- When designing dashboards, always run the queries you will use for panels to verify data is correct.
- When proposing dashboards or alerts, prefer queries that can be validated against live data first.
- Call out assumptions about labels, metrics, or datasource names.
