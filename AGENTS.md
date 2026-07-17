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

## Preview refresh

After every completed UI, theme, or asset iteration, automatically run:

```bash
.cursor/hooks/refresh-preview.sh
```

Do this after checks and the post-edit audit, before reporting completion. If a
Flutter preview is running, the script syncs the workspace and refreshes it:
Dart-only changes use hot reload, while `pubspec.yaml` and asset changes such as
SVG, PNG, fonts, shaders, or JSON use hot restart. If no preview is running, the
script exits without error; mention that preview verification was skipped.
