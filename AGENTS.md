# Repository agent instructions

## Project skills

This repository keeps project-local skills under `.cursor/skills/`. They are
not automatically registered as built-in Codex skills, so agents must discover
and load the relevant `SKILL.md` files from that directory before acting.

For every change that touches `lib/**/*.dart` or `design-system/**`:

1. Read `.cursor/skills/flutter-post-edit-audit/SKILL.md` completely before
   making the change, including every reference it requires for that change.
2. Follow the skill throughout the implementation.
3. Before reporting the iteration as complete, run:

   ```bash
   bash .cursor/skills/flutter-post-edit-audit/scripts/audit.sh
   ```

4. Fix blocking findings, rerun the audit, and include the skill's audit report
   in the final response.

Pure questions or iterations with no `lib/` or `design-system/` changes do not
require the audit.
