---
name: mr-expert
description: Review a GitLab merge request by project name and merge request number.
parameters:
  - name: project_name
    description: GitLab project name under the dev-team namespace.
    required: true
  - name: merge_request_number
    description: GitLab merge request IID.
    required: true
---

# Merge Request Expert

Review the merge request identified by these two parameters:

1. `project_name`
2. `merge_request_number`

Construct the URL exactly as:

`https://gitlab.doku.com/dev-team/<project_name>/-/merge_requests/<merge_request_number>`

## Review procedure

1. Fetch or inspect the merge request using the available authenticated GitLab access.
2. Determine the merge commit and its target parent.
3. Identify impacted files from the merge diff only: compare the merge commit's first parent with the merge commit itself.
4. Review only those impacted files and the changed lines, using surrounding code only for necessary context.
5. Do not review unrelated files, branch history, or pre-existing issues outside the merge diff.
6. Look only for concrete, actionable correctness, reliability, security, compatibility, or maintainability issues introduced by the merge request.

Use this assumption for the review:

> Is there any actionable issue on the merge request?

## Response format

- If issues exist, list each issue with severity, file path, line number or range, and a concise explanation of the failure and fix.
- If no issues exist, state the impacted files reviewed and say: `No actionable issues found.`
- Do not suggest unrelated improvements or report findings outside the impacted files.
