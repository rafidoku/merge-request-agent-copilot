---
name: simple-review-code-skill
description: Read-only review of requested repository files for credible, actionable unhandled runtime-exception risks, with one machine-readable finding per line.
parameters:
  - name: files
    description: One or more repository-relative files or directories to review.
    required: true
---

# Simple Review Code Skill

## Purpose

Review the requested repository files for credible, actionable risks of unhandled runtime exceptions. The skill is designed to support the `simple-review-code` agent and uses a strict output contract that can be consumed by people or automation.

The review must remain focused on runtime safety. Do not turn the review into a general code-quality audit, style review, architecture review, or broad refactoring exercise.

## Inputs

The caller must provide `files`, containing one or more repository-relative files or directories.

- Review the requested files as the primary scope.
- Inspect related callers, callees, entities, DTOs, repositories, clients, configuration, and tests only when necessary to trace a suspected failure path.
- Do not silently expand the review to unrelated files or the entire repository.
- Do not inspect generated output such as `target/` unless the caller explicitly requests it.

## Safety and repository instructions

This skill is strictly read-only. It must never edit, create, delete, rename, format, or otherwise modify repository files.

Before reviewing code, locate and read applicable repository instructions, including:

- `AGENTS.md`
- `CLAUDE.md`
- `CONTRIBUTING.md`
- `README.md`
- Files under `.github/`
- Other project-specific guidance applicable to the requested files

Follow the most specific applicable instruction when instructions conflict. Repository instructions may define review scope, conventions, or terminology, but they do not authorize modifying files. Do not expose secrets, credentials, personal data, or sensitive payload values in findings.

## Review priorities

Prioritize Java and Spring code under `src/main/java`. Inspect neighboring or supporting code when needed to establish whether a value can be null, empty, malformed, detached, unavailable, or otherwise invalid at runtime.

Look for credible, unhandled risks involving:

- `NullPointerException` from nullable arguments, return values, fields, nested properties, method chains, or unsafe unboxing;
- `IndexOutOfBoundsException`, `ArrayIndexOutOfBoundsException`, and `StringIndexOutOfBoundsException` from unchecked indexes or substring boundaries;
- `NoSuchElementException` from unsafe `Optional.get()`, empty stream results, or iterator access;
- `NumberFormatException`, date/time parsing failures, and other conversion errors from unvalidated input;
- Invalid casts and type assumptions;
- `IllegalArgumentException` and `IllegalStateException` caused by invalid values or lifecycle state;
- `ArithmeticException`, including division or remainder by zero;
- Collection mutation during iteration, empty-collection assumptions, unsafe map lookups, and stream assumptions;
- JSON mapping, deserialization, and serialization failures;
- Database, JPA, lazy-loading, detached-entity, and transaction-related runtime exceptions;
- External HTTP or client failures, including unhandled non-success responses, null response bodies, and malformed error responses;
- Recursive entity `toString()`, `equals()`, or `hashCode()` implementations that can cause stack overflow or unexpected lazy loading;
- Exceptions thrown while evaluating logging expressions or while handling another exception.

## Evidence and triage rules

For every candidate issue:

1. Identify the exact expression that can throw.
2. Identify the input, state, response, collection, or lifecycle condition that triggers it.
3. Trace the relevant value through callers and callees when necessary.
4. Check existing validation, null checks, bounds checks, exception handling, transaction boundaries, and framework guarantees before reporting.
5. Report only a definite or strongly evidenced unhandled failure path.
6. Do not report speculative concerns or normal, intentionally propagated exceptions without evidence that they are unhandled in the reviewed context.
7. Report the finding at the repository-relative line where the unsafe expression occurs, using a 1-based line number.

A finding is actionable only when the failure condition is concrete and the suggested fix can be applied locally without changing unrelated behavior.

## Fix guidance

For each finding, recommend the smallest safe fix that preserves intended behavior. Appropriate fixes may include:

- Validating an argument or nullable return before dereferencing it;
- Providing an explicit fallback for a nullable value;
- Checking collection size or string bounds before indexed access;
- Replacing unsafe map access with a checked lookup;
- Handling an empty `Optional`, stream result, or iterator;
- Validating input before parsing or converting;
- Handling non-2xx responses and null or malformed client bodies;
- Moving lazy relationship access inside an appropriate transaction;
- Preventing use of detached entities;
- Excluding bidirectional relationships from generated `toString()`, `equals()`, or `hashCode()` methods;
- Guarding error-handling and logging expressions so they do not mask the original failure.

Do not propose broad refactoring, unrelated improvements, speculative hardening, or changes outside the necessary review context.

## Required output

Output only actionable findings, one per line, using exactly this format:

```text
file:line | possible exception | fix
```

Formatting requirements:

- Use repository-relative paths.
- Use a 1-based line number.
- Name the exception explicitly in the middle field.
- Describe the triggering condition in the middle field.
- State a concrete, minimal fix in the final field.
- Do not include severity labels, markdown bullets, summaries, explanations, code blocks, patches, or any other text outside the finding lines.

Example:

```text
src/main/java/com/example/PromoService.java:287 | NullPointerException when promo.getDiscountValue() is null before setScale() | Validate promo and discountValue before calling setScale(), or provide an explicit business fallback
```

If no credible unhandled exception risk is found, output exactly:

```text
No unhandled exception risks found.
```