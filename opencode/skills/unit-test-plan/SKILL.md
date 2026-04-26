---
name: unit-test-plan
description: Plan simple, isolated, repeatable unit tests by identifying behaviors, dependencies, and risks before test implementation
compatibility: opencode
metadata:
  audience: maintainers
  workflow: testing
---

## What I do

- Analyze code or a requested change to identify what should be covered by unit tests.
- Break test planning into small, behavior-focused units.
- Identify dependencies that must be controlled for tests to stay isolated.
- Call out behaviors that are poor unit-test candidates.
- Produce a clear handoff plan for a test-writing skill or human reviewer.

## When to use me

Use this skill when the user wants to plan unit tests before writing them and wants the plan to focus on behavior, isolation, repeatability, and dependency control rather than language or framework details.

## Default behavior

- Default to the smallest meaningful unit-test plan.
- Prefer simple tests that verify one behavior at a time.
- Prefer behavior-focused tests over implementation-focused tests.
- Do not prescribe language-specific structure, naming, or framework usage.
- If a behavior is not a good unit-test candidate, say so clearly.
- If the code has unclear contracts or hidden shared state, stop and surface that ambiguity.

## Unit test planning principles

A good unit-test plan should answer:

- What behavior matters here?
- What is the smallest meaningful thing to test?
- What dependencies must be controlled?
- What risks could make the test flaky, stateful, or misleading?
- Does this belong in unit scope at all?

A planned unit test should be:

- simple
- isolated
- repeatable
- parallel-safe
- behavior-focused

## Single-behavior rule

Each proposed unit test should verify one thing.

Rules:

- One test should correspond to one behavior or one contract.
- Multiple checks are acceptable only when they all support the same behavior.
- If a candidate test mixes validation, persistence, retries, metrics, logging, and formatting together, split it.
- If a behavior naturally has distinct success and failure modes, plan those as separate tests unless they are inseparable parts of the same contract.

Prefer:

- one behavior
- one reason to fail
- one clear contract

Avoid:

- kitchen-sink tests
- tests that prove many unrelated outcomes at once
- tests that require reading the implementation to understand the point

## Isolation and side-effect rules

Unit tests should not introduce unrelated secondary effects.

Rules:

- Avoid dependence on real external systems such as databases, networks, queues, external APIs, or shared services.
- Avoid mutable shared process state when possible.
- Avoid plans that depend on filesystem state, environment variables, current working directory, wall-clock timing, or global caches unless those are explicitly isolated and central to the behavior under test.
- If the behavior cannot be tested in unit scope without side effects, say so and recommend a broader test level instead.

For every planned test, identify:

- what must be controlled
- what must be isolated
- what should remain real
- what external effects must be excluded

## Repeatability and parallel-safety rules

A planned unit test must be repeatable.

Rules for repeatability:

- Running the same test multiple times should not change behavior.
- The test should not depend on leftovers from prior runs.
- The test should not leave behind state that affects later tests.

Rules for parallel safety:

- Running tests in parallel should not change their outcome.
- Avoid shared mutable state, process-wide mutations, singleton state, reused temp paths, environment leakage, and ordering dependence.
- If a test cannot reasonably be parallel-safe, the plan must explain why.

When evaluating a test idea, ask:

- Does this mutate shared state?
- Does this depend on execution order?
- Does this depend on ambient state outside the test?
- Could two copies of this test interfere with one another?

If the answer is yes, call out the risk and propose isolation requirements.

## Dependency planning rules

For each proposed test, identify the dependencies involved and whether they need control.

Dependency questions to answer:

- What collaborators does the unit depend on?
- Which dependencies affect the behavior under test?
- Which dependencies must be controlled for deterministic results?
- Which dependencies should be replaced, isolated, or observed?
- What setup is required to keep the test focused and independent?

Good dependency planning should distinguish between:

- core inputs to the behavior
- dependencies that must be controlled
- dependencies that are incidental and should not dominate the test
- dependencies that push the behavior out of unit scope

Do not overcomplicate the dependency model. Prefer the smallest plan that keeps the behavior isolated and trustworthy.

## Behavior selection rules

Prefer planning tests for:

- public or caller-visible behavior
- business rules
- validation logic
- decision-making logic
- error handling
- edge conditions
- regressions
- state transitions with clear contracts

Avoid planning unit tests that mostly verify:

- incidental implementation steps
- trivial passthrough code with no meaningful contract
- unstable internal details
- behavior that is only meaningful when exercised across multiple real subsystems

## Out-of-scope cases

Call out when a test idea is not a good unit test candidate.

Examples include:

- behavior that fundamentally requires multiple real subsystems
- behavior whose value depends mainly on integration between components
- behavior that is mostly operational, timing-based, or environment-driven
- behavior that cannot be isolated without distorting what is actually being tested

In those cases, say that the behavior may belong in integration, system, or end-to-end testing instead of forcing a weak unit-test plan.

## Stop conditions

Stop and ask if any of the following are true:

- the intended behavior is unclear
- the contract has multiple plausible interpretations
- the code appears to rely on hidden shared state
- it is unclear which dependencies are part of the unit boundary
- the requested test appears to belong outside unit scope
- a useful plan would require guessing behavior that is not established by code or user intent

## Output format

When planning unit tests, use this structure:

## Summary

- Behaviors that should be unit tested
- Behaviors that should not be unit tested
- Main dependencies that need control

## Proposed Tests

For each proposed test, include:

- Behavior under test
- Why it belongs in unit scope
- Inputs and preconditions
- Dependencies to control
- Expected outcome
- Isolation notes
- Repeatability notes
- Parallel-safety notes

## Risks / Ambiguities

- Unclear contracts
- Hidden side effects
- Shared mutable state
- Behaviors that may belong outside unit scope
- Any assumptions needing confirmation

## Handoff Notes

- Anything a test-writing skill should preserve
- Any constraints that must remain true for the tests to stay isolated
- Any parts of the implementation that should not drive the test design directly
