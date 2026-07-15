---
name: flutter-post-edit-audit
description: >-
  Audits Flutter code changes after every edit for design-token compliance and
  STRICT V2 architecture rules, and enforces design-system authority (README +
  canvas sync). Default: UI/token changes must cover yellow_dark, pink_light,
  yellow_light unless the user specifies otherwise. Use after any lib/ or
  design-system/ edit, before telling the user the task is done.
---

# Flutter 修改后合规审计

每次完成 `lib/` 或 `design-system/` 改动后，**必须**跑完本流程并向用户输出审计报告。

## 权威与参考（细则不在此重复）

| 文档 | 用途 |
|------|------|
| [references/design-system.md](references/design-system.md) | 设计规范治理、三主题、三处一致、Step 2.5–2.7 说明 |
| [references/token-rules.md](references/token-rules.md) | Token 禁止项、豁免、快速 grep、状态栏 §3.1 |
| [references/report-template.md](references/report-template.md) | Step 5 报告模板（✅ / ⚠️） |
| [checklist.md](checklist.md) | Step 3 人工核对全清单 |
| [flutter-architecture-strict-v2.mdc](../../rules/flutter-architecture-strict-v2.mdc) | 架构规范全文 |

动手前 / 改 token·组件时：先读 [references/design-system.md](references/design-system.md)。

## 触发时机

- 新增/修改/删除 `lib/**/*.dart`
- 新增/修改 `design-system/**`
- 功能 / 修 bug / 重构完成后
- 准备说「已完成」之前

纯问答、无代码改动 → **不执行**。

## 审计流程

### Step 1 — 确定变更范围

```bash
git diff --name-only
git diff --name-only --cached
```

无 git 时 → 审计本次会话编辑过的所有相关文件。

### Step 2 — 自动扫描（主入口）

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/audit.sh
```

非 0 → Step 4 修复后重跑。`audit.sh` 在涉及 theme/design-system 时会链式调用 Step 2.5 / 2.6。

### Step 2.5 · 2.6 · 2.7 — 设计规范子步骤

条件、脚本、退出码含义见 [references/design-system.md](references/design-system.md)。

| 步骤 | 脚本 |
|------|------|
| 2.5 规范对照 | `scripts/design-system-check.sh` |
| 2.6 三处一致 | `scripts/design-system-consistency.sh` |
| 2.6 canvas 同步 | `scripts/sync-canvas.sh`（改了 canvas 源必跑） |
| 2.7 组件/样式守卫 | `scripts/design-system-component-sync.sh` |

### Step 3 — 人工核对

逐项勾选 [checklist.md](checklist.md)，重点：**三主题覆盖**（§0.2）、Token、分层、依赖、状态栏（§3.1）。

Token / grep / 状态栏细则：[references/token-rules.md](references/token-rules.md)

### Step 4 — 处理问题

- 可立即修复 → 修复后重跑 Step 2–3
- 需用户决策 → 说明选项，**不**标为通过

### Step 5 — 输出审计报告

按 [references/report-template.md](references/report-template.md) 在回复末尾输出，含规范链接与变更文件列表。

## 注意事项

- 只审计**本次变更**，不全库大扫除
- 不得省略最终报告
- 三主题：用户未特别声明时，「当前预览对了」≠ 完成；须确认 `yellow_dark` / `pink_light` / `yellow_light` 均正确，或已登记 keep-dark / 用户例外（见 design-system 参考）
