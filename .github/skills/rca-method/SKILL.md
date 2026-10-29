---
name: rca-method
description: Structured root cause analysis method and report template. Use when debugging an error, stack trace, failing test, regression, or incident and you need to identify the root cause with evidence.
---
# Root Cause Analysis Method

## Why
Patching the symptom makes the bug return. A fixed method (reproduce, narrow, prove) keeps the analysis evidence-based instead of guess-based.

## Steps
1. **Define the symptom**: exact error, where, when, expected vs actual.
2. **Reproduce or locate**: find the failing path (stack trace, failing test, logs). Note if it cannot be reproduced.
3. **Check what changed**: `git log -p`, `git blame`, recent deploys/config/dependency bumps near the first failure.
4. **Narrow down**: bisect by file, commit, or input until the smallest failing unit is found.
5. **5 Whys**: repeat "why?" until you reach a cause you can change (code, config, process).
6. **Disprove**: list alternative causes and say why each is ruled out.
7. **Recommend**: a fix for the root cause, a short-term mitigation, and a prevention (test, alert, guard).

## Report format
```
## Summary
One sentence: what broke and why.

## Symptom
## Timeline / Trigger
## Evidence
- file:line | log | command output
## Root cause
## 5 Whys
## Ruled out
## Recommendation
- Fix:
- Mitigation:
- Prevention:
## Confidence
High / Medium / Low, and what would raise it.
```
