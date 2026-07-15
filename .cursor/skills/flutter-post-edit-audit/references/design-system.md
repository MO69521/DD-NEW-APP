# 设计规范治理（最高优先级 · 强制）

权威文件：

| 文件 | 角色 |
|------|------|
| [design-system/README.md](../../../design-system/README.md) | 文本权威基线 |
| [design-system/design-system-spec.canvas.tsx](../../../design-system/design-system-spec.canvas.tsx) | 可视化目录源文件 |

规范全文：[flutter-architecture-strict-v2.mdc](../../rules/flutter-architecture-strict-v2.mdc) §0.1

## 动手前

- **先对照后动手**：颜色 / 字号 / 行高 / 字重 / 间距 / 圆角 / 组件外观或变体 → 先读 `design-system/README.md`，直接引用已有 token / 组件档位。
- **改源即全局**：token 真源 `lib/core/theme/*`，组件真源 `lib/shared/*`；禁止在页面内重定义样式或复制组件。
- **严禁擅自新增**：收敛去重（重复字面量指向已有 token、值不变）可直接做；超出规范的新 token / 新档位 / 新色系 → **停下**，向用户说明用途与建议值，确认后同步 `design-system/README.md`。

## 改样式 / 增删组件 → 文档 + 画廊（强制）

改动 `lib/core/theme/*` 或增删 `lib/shared/{components,widgets,layouts}/*.dart` 时：

| 操作 | 要求 |
|------|------|
| 新增组件 | README §7 登记；`StatelessWidget`/`StatefulWidget` **必须** canvas 画廊双登记 |
| 删除组件 | README + canvas 移除，无悬空引用 |
| 改样式/变体 | README 描述 + canvas 预览同步 |

守卫脚本：`scripts/design-system-component-sync.sh`（Step 2.7），退出码 2 禁止跳过。

## 三处一致

`design-system/README.md` · canvas 源 · Cursor 托管副本 `~/.cursor/projects/<workspace>/canvases/design-system-spec.canvas.tsx` 必须一致。

改了 `design-system-spec.canvas.tsx` 后收尾前必须：

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/sync-canvas.sh
```

守卫脚本：`scripts/design-system-consistency.sh`（Step 2.6）

## 三主题默认同步（强制）

用户**未特别声明**时，UI / token / 组件外观改动须同时覆盖：

| 主题 id | 说明 |
|---------|------|
| `yellow_dark` | 黄黑 · 默认 |
| `pink_light` | 浅粉 |
| `yellow_light` | 黄浅 |

- 优先改 theme / shared 真源，借 `_isLight` / `themeId` / keep-dark 一次覆盖三包。
- 对照 README §4.2.0 与 canvas「多风格」tab 确认三包可读。
- 用户指定「仅某主题」或 keep-dark 例外 → 代码注释 + README 登记 + 审计报告显式列出。
- **禁止**改动 `yellow_dark` 默认分支源值（`--dart-define=THEME` 实验包机制）。

## Step 2.5 — 设计规范对照

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/design-system-check.sh
```

- 列出 token 层新增字面量 / 新 token 名。
- 收敛去重 → 可继续；规范外新增 → 停止，取得用户确认后更新文档。
- 退出码 2 → 人工判定；0 → 无新增。

## Step 2.6 — 一致性 + canvas 同步

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/design-system-consistency.sh
bash .cursor/skills/flutter-post-edit-audit/scripts/sync-canvas.sh  # 托管副本落后时
```

## Step 2.7 — 组件 / 样式同步守卫

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/design-system-component-sync.sh
```

| 代号 | 含义 |
|------|------|
| A | 新增可视组件未 README + 画廊双登记 |
| B | 删除组件后 README/canvas 仍引用 |
| C | 改了 shared 组件或 theme 但未改 design-system/ |
| D | 修改提醒（软提示，人工确认外观是否变） |

私有 `_Xxx` 内部拆分自动跳过。
