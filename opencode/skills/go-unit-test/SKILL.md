---
name: go-unit-test
description: Plans and writes focused Go unit tests by defining unit-scope behaviors first, then implementing tests with repository Go testing conventions
compatibility: opencode
metadata:
  audience: maintainers
  workflow: testing
  language: go
---

## What I do

- Plan and write focused Go unit tests by orchestrating two skills:
  - `unit-test-plan` for defining unit-scope behaviors, dependencies, and isolation constraints
  - `go-test-write` for implementing Go tests with the repository's test conventions
- Inspect target code and nearby tests before making test changes.
- Keep unit tests behavior-focused, isolated, repeatable, and aligned with repository conventions.

## When to use me

Use this skill when the user wants focused Go unit tests planned and, when appropriate, implemented with repository testing conventions.

## Default behavior

- Inspect the target code and any nearby existing tests first.
- Always load `unit-test-plan` before writing tests.
- Treat the `unit-test-plan` output as the source of truth for what belongs in unit scope.
- If the requested behavior is not a good unit-test candidate, stop and explain why.
- If unit scope or expected behavior is ambiguous, ask a clarifying question before writing tests.
- If the user clearly asked for implementation and the plan is safe, proceed to write tests.
- If the user asked only for planning or review, stop after producing the plan.

## Workflow

1. Read the target code and nearby tests.
2. Load the `unit-test-plan` skill.
3. Identify:
   - behaviors that should be unit tested
   - behaviors that should not be unit tested
   - dependencies that must be controlled
   - repeatability and parallel-safety risks
4. If the plan shows the request is not unit-scope, stop.
5. If the plan is valid and implementation is requested, load `go-test-write`.
6. Write the smallest meaningful Go test changes.
7. Run the smallest relevant `go test` command when verification is useful and safe.

## Writing rules

- Keep each test focused on one behavior.
- Do not write integration-style tests and call them unit tests.
- Do not invent behavior that is not established by the code or user request.
- Prefer minimal fixtures and controlled dependencies.
- Preserve existing repository conventions unless they directly conflict with `go-test-write` and the user asked for the new conventions.

## Verification rules

- Prefer the smallest relevant `go test` target.
- If verification cannot be run safely or precisely, say so clearly.
- Report any failing verification directly.

## Output format

When planning only, use this output structure:

```md
## Summary

- What should be unit tested
- What should not be unit tested
- Whether the request is safe to implement as unit tests

## Unit Test Plan

- Planned behaviors
- Dependencies to control
- Isolation and repeatability constraints

## Exclusions

- Anything that belongs outside unit scope

## Risks / Ambiguities

- Any unclear contract, hidden state, or setup risk
```

When writing tests, use this output structure:

```md
## Summary

- What was planned
- What was written

## Unit Test Plan

- Behaviors covered
- Dependencies controlled

## Written Tests

- Files changed
- Tests added or updated

## Verification

- Commands run
- Results

## Risks / Ambiguities

- Any remaining uncertainty or out-of-scope behavior
```
