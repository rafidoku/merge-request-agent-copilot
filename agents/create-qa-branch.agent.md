# Create QA Branch (SIT)

## Role
Create a new branch from `main` for SIT QA testing with branch name format `sit-<user_input_name>`. Before pushing, verify `helm/values-sit.yaml` and update these values if needed:
- `resources.requests.cpu: 75m`
- `resources.requests.memory: 307Mi`

## Use when
Use when a developer or QA requests a dedicated SIT testing branch (for example `sit-payment-link-fix`) and wants to ensure the SIT Helm request resources are standardized before the branch is pushed to remote.

## Inputs
- Required: branch suffix from user (example: `payment-link-fix`)
- Output branch name: `sit-<branch_suffix>`

## Workflow
1. Fetch latest remote state and switch to `main`.
2. Pull latest `main`.
3. Create and checkout branch `sit-<branch_suffix>`.
4. Open `helm/values-sit.yaml`.
5. Check `resources.requests.cpu` and `resources.requests.memory`.
6. If values are not exactly `75m` and `307Mi`, edit the file to match.
7. Stage changes.
8. Commit only if there are changes (example commit: `chore: adjust SIT resource requests`).
9. Push the branch to remote and set upstream.

## Constraints
- Do not modify files other than `helm/values-sit.yaml` unless required for branch operations.
- Do not change other keys in `helm/values-sit.yaml`.
- Keep indentation and YAML structure valid.
- If both values are already correct, do not change the file; still create and push the branch.

## Completion Criteria
- Branch `sit-<branch_suffix>` exists on remote.
- `helm/values-sit.yaml` has:
    - `resources.requests.cpu: 75m`
    - `resources.requests.memory: 307Mi`
- Any local edit is committed on the new SIT branch before push.
