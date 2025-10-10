# Pull Request Format Rules

Purpose:
- Enforce a single, consistent PR description format across this repository.
- Applies to all contributors and all PRs.

Language:
- Write PR descriptions in English unless explicitly requested otherwise.

Cline Rule (MUST):
- When asked to draft a PR description, Cline MUST read and follow this file (.clinerules/02-pr-format.md) exactly.
- If required data is missing, Cline MUST ask for it before drafting, or clearly mark placeholders.
- Output MUST keep the section headings exactly as defined below and MUST NOT add or remove sections.
- Keep the structure stable for review automation and team consistency.

PR Description Template (copy and paste verbatim):

--- PR Description ---
## Note (if necessary)
- Record the NOTES and requirements related to the order of merging PRs or any necessary configurations.

## Description
- Rewrite the summary of the tasks performed for this issue and its goal.

## Evidence
- Include screenshots showing changes or fixes.
--- end ---

Filling Guidance:
- Note:
  - Keep this section even if empty; use a single dash “-” if there is nothing to note.
  - Include merge order dependencies, post-deploy ops, toggles/flags, environment changes, or migration notes.
- Description:
  - Be concise and outcome-oriented. State what was changed and why.
  - Prefer links to issues/commits for long details. Example: “Closes #123”.
  - Mention scope and any user-facing impact.
- Evidence:
  - Prefer inline screenshots (GitHub supports drag & drop) or links to recordings, preview URLs, or logs.
  - If UI changes are involved, include before/after images.
  - For backend-only changes, include test results or logs.

Do / Don’t:
- Do keep the three headings as-is: “Note”, “Description”, “Evidence”.
- Do use bullet points where appropriate.
- Don’t add extra headings or rename/remove any section.
- Don’t paste large code dumps; link or summarize.

Reviewer Checklist (optional):
- [ ] Note: Merge order, config prerequisites, or runbooks documented (or explicitly not required).
- [ ] Description: Clear “what” and “why”, includes scope/impact and related issues/PRs.
- [ ] Evidence: Sufficient visuals/logs to verify the change.

How to Ask Cline to Write a PR Description:
- “Draft a PR description using the format in .clinerules/02-pr-format.md. Use the three required sections (Note, Description, Evidence). Ask me for any missing details. Keep it in English unless I say otherwise.”

GitHub Auto-Prefill (optional):
- You can add a matching template at .github/pull_request_template.md to auto-populate PR bodies with the same structure.
