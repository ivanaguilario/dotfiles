---
name: go-test-write
description: Write meaningful Go tests with strict naming, explicit Arrange/Act/Assert sections, table-driven cases, and testify assertions
compatibility: opencode
metadata:
  audience: maintainers
  workflow: testing
---

## What I do

- Write new Go tests that verify meaningful behavior, not just coverage.
- Update existing Go tests to make them clearer, more deterministic, and more valuable.
- Apply strict conventions for test naming, test body organization, and assertions.
- Use table-driven tests when they improve readability and behavior coverage.
- Use `testify` `assert` and `require` for cleaner, more readable tests.

## When to use me

Use this skill when the user wants to add, improve, or review Go tests and wants them written with consistent naming, explicit Arrange/Act/Assert sections, and meaningful assertions.

## Default behavior

- Default to the smallest meaningful test change.
- Prefer tests that explain behavior over tests that mirror implementation details.
- Prefer deterministic tests over clever or highly abstracted tests.
- Do not add tests solely to increase coverage numbers.
- If the code is hard to test, first look for the smallest safe seam rather than adding invasive test-only complexity.
- If a requested test would mostly assert implementation details, stop and propose a better behavior-focused shape.

## Test naming rules

Test function names must follow this exact shape:

```text
Test<Type>_<Struct>_<Method>_<Test>
```

Where:

- `<Type>` is one of `Unit`, `Integration`, `E2E`
- `<Struct>` is the main type, component, or subject under test
- `<Method>` is the method, function, or operation under test
- `<Test>` describes the behavior being verified

Rules:

- Use PascalCase segments.
- Name the subject first, then the operation, then the behavior.
- Make the final segment behavior-oriented.
- Avoid generic endings like `Success`, `Failure`, `Error`, `Works`, `Case1`, or `HappyPath`.
- If the code under test is a package-level function rather than a method, use the function name in the `<Method>` slot.
- If the code under test has no obvious struct, use the most meaningful component or subject name available.

Examples:

- `TestUnit_UserService_Create_RejectsEmptyEmail`
- `TestIntegration_UserRepo_Save_PersistsRecord`
- `TestE2E_LoginHandler_Post_RedirectsToDashboard`
- `TestUnit_LevelParser_Parse_RejectsUnknownLevel`

## Test body organization

Use these exact comments to clearly delimit the test body sections:

```go
// Arrange

// Act

// Assert
```

Rules:

- Use these section comments in non-trivial tests.
- Keep setup in `Arrange`.
- Keep exactly one main action in `Act`.
- Keep assertions in `Assert`.
- Do not mix setup into `Act` or assertions into `Arrange`.
- If setup is so trivial that comments would hurt readability, you may omit them only when the test is genuinely obvious and very short. Otherwise include them.

Preferred shape:

```go
func TestUnit_UserService_Create_RejectsEmptyEmail(t *testing.T) {
	// Arrange
	svc := NewUserService()

	// Act
	err := svc.Create(User{Email: ""})

	// Assert
	require.Error(t, err)
	assert.ErrorIs(t, err, ErrEmptyEmail)
}
```

## Assertion rules

Use `testify` assertions.

Required packages:

- `github.com/stretchr/testify/assert`
- `github.com/stretchr/testify/require`

Rules:

- Use `require` for preconditions and anything that should stop the test immediately.
- Use `assert` for follow-up checks where continued validation improves diagnosis.
- Prefer `require.NoError(t, err)` for setup steps in `Arrange` that must succeed before the test can continue.
- Do not silently ignore setup errors.
- When an error is the primary result under test, assert it explicitly with `require.Error`, `assert.ErrorIs`, `require.ErrorAs`, or similar helpers.
- Prefer behavior-oriented assertions over brittle exact-string comparisons.
- Do not over-assert unrelated details in the same test.

Examples:

```go
func TestUnit_ConfigLoader_Load_ReturnsConfig(t *testing.T) {
	// Arrange
	f, err := os.CreateTemp(t.TempDir(), "config-*.yaml")
	require.NoError(t, err)

	_, err = f.WriteString("name: demo\n")
	require.NoError(t, err)

	err = f.Close()
	require.NoError(t, err)

	loader := NewConfigLoader()

	// Act
	cfg, err := loader.Load(f.Name())

	// Assert
	require.NoError(t, err)
	assert.Equal(t, "demo", cfg.Name)
}
```

## Meaningful test philosophy

Every test should answer a useful behavioral question such as:

- What behavior does this code guarantee?
- What input or state should produce what outcome?
- What failure mode must not regress?
- What contract matters to callers or maintainers?

Prefer tests that cover:

- business-critical behavior
- failure modes
- edge cases
- regressions
- public contracts
- meaningful branching logic

Avoid tests that only:

- increase coverage numbers
- mirror implementation steps without proving behavior
- assert brittle intermediate details
- exercise trivial pass-through code with no meaningful contract

## Table-driven test rules

Use table-driven tests when they improve clarity for behavior variants.

Use a table when it improves readability for:

- validation matrices
- parsing cases
- normalization logic
- edge-condition combinations
- pure or mostly pure logic with several stable variants

Do not use a table when:

- each case needs substantially different setup
- each case expresses a meaningfully different behavior
- the table would hide the test's intent
- a few standalone tests would read better

Rules:

- Use `tc` as the loop variable, not `tt`.
- Include a `name` field for subtests.
- Keep one behavior per table.
- Split into multiple tests when different behaviors require different reasoning.
- Keep table fields minimal and relevant.
- In subtests, use `tc := tc` before the closure when needed.
- If setup inside `Arrange` can fail, assert or require those errors there as well.

Preferred shape:

```go
func TestUnit_LevelParser_Parse_RejectsInvalidLevels(t *testing.T) {
	// Arrange
	tests := []struct {
		name  string
		input string
	}{
		{name: "empty", input: ""},
		{name: "unknown", input: "verbose"},
	}

	parser := NewLevelParser()

	for _, tc := range tests {
		tc := tc
		t.Run(tc.name, func(t *testing.T) {
			// Arrange

			// Act
			_, err := parser.Parse(tc.input)

			// Assert
			require.Error(t, err)
		})
	}
}
```

## Error testing conventions

Test errors intentionally.

Prefer checking:

- whether an error exists when only presence matters
- `assert.ErrorIs` or `require.ErrorIs` when sentinel or wrapped error identity matters
- `assert.ErrorAs` or `require.ErrorAs` when error type matters
- stable substrings only when the message is part of the contract and there is no better structured signal

Avoid brittle exact full-string comparisons unless the full text is part of the user-facing contract.

## Determinism rules

Tests must be deterministic.

Prefer:

- injected clocks over `time.Sleep`
- explicit synchronization over timing assumptions
- bounded resources and isolated temp directories
- fake or controlled randomness over ambient randomness
- `httptest` and small fakes over fragile external dependencies

Avoid:

- arbitrary sleeps
- depending on map iteration order
- depending on wall-clock timing when the contract is not time-based
- cross-test shared mutable state without isolation

## Helpers and fixtures

Keep test data close to the test unless reuse clearly improves readability.

Use helpers when they:

- remove noisy setup
- encode a domain concept clearly
- are reused enough to justify indirection

Rules:

- Mark helpers with `t.Helper()`.
- Keep helpers narrowly focused.
- Do not hide the important behavior of a test inside generic helpers.
- Prefer explicit helper names over vague names like `makeData`.

## Stop conditions

Stop and ask if any of the following are true:

- the intended behavior is unclear
- the code has multiple plausible contracts
- adding a useful test would require a non-trivial production refactor
- the requested test would mostly assert implementation details
- the repository already has established Go testing conventions that conflict with these rules
- the correct test type among `Unit`, `Integration`, and `E2E` is unclear from the request or code context

## Output format

When planning test changes, use this structure:

## Summary

- What behavior needs coverage
- Whether a new test or test update is needed
- Whether table-driven structure is appropriate

## Proposed Tests

- Test names
- What each test proves
- Whether each test is standalone or table-driven

## Notes

- Any helper, fake, fixture, or seam needed
- Any determinism or brittleness risks
- Any ambiguity that needs user confirmation

When writing or reviewing tests, explain choices in terms of behavior, readability, determinism, and regression value.
