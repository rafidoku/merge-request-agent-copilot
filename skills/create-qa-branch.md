# create-qa-branch

## Purpose
Create and push a dedicated SIT QA branch from `main` with naming format `sit-<user_input_name>`, while standardizing SIT Helm request resources before push.

## Use when
Use this skill when a developer/QA asks to create a SIT testing branch (for example: `sit-enhancement-emailTemplate`, `sit-payment-link-fix`) and expects branch push readiness with validated `helm/values-sit.yaml` request resources.

## Why
- SIT QA branches must be reproducible and follow one naming convention (`sit-*`).
- Resource request drift in `helm/values-sit.yaml` can cause inconsistent SIT pod scheduling and test behavior.
- Standardizing `resources.requests.cpu` and `resources.requests.memory` before push reduces QA environment variance.

## Rules
- Always branch from latest `main`.
- Branch name must be `sit-<branch_suffix>`.
- Only edit `helm/values-sit.yaml` for config normalization.
- Keep YAML structure/indentation valid.
- Do not modify other keys in `helm/values-sit.yaml`.
- Commit only if there are file changes.

## How to
1. Fetch remote and switch to `main`.
2. Pull latest `main`.
3. Create and checkout `sit-<branch_suffix>`.
4. Read `helm/values-sit.yaml`.
5. Ensure:
    - `resources.requests.cpu: 75m`
    - `resources.requests.memory: 307Mi`
6. If different, edit only those two values.
7. Stage changes.
8. Commit only when there is a diff (example: `chore: adjust SIT resource requests`).
9. Push branch and set upstream.

## Done when
- Remote branch `sit-<branch_suffix>` exists.
- `helm/values-sit.yaml` has exact values:
    - `resources.requests.cpu: 75m`
    - `resources.requests.memory: 307Mi`
- Any local `helm/values-sit.yaml` edit is committed on that SIT branch.
