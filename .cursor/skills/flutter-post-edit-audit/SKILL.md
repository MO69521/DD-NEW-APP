---
name: flutter-post-edit-audit
description: >-
  Audits Flutter code changes after every edit for design-token compliance and
  STRICT V2 architecture rules, and enforces the highest-priority design-system/
  authority (README + canvas three-way consistency and canvas sync). Use after
  completing any Flutter/Dart code modification, feature implementation, refactor,
  or bug fix, AND after editing anything under design-system/.
---

# Flutter 修改后合规审计

每次完成 Flutter/Dart 代码修改后，**必须**执行本审计，再向用户汇报结果。

规范全文：[flutter-architecture-strict-v2.mdc](../../rules/flutter-architecture-strict-v2.mdc)
设计规范（**最高优先级唯一权威**，见规范 §0.1）：

- 文本基线：[design-system/README.md](../../../design-system/README.md)
- 可视化目录：[design-system/design-system-spec.canvas.tsx](../../../design-system/design-system-spec.canvas.tsx)

## 设计规范治理（最高优先级 · 强制）

- **先对照后动手**：涉及颜色 / 字号 / 行高 / 字重 / 间距 / 圆角 / 组件外观或变体的改动，**动手前必须先读** `design-system/README.md`，直接引用已有 token / 组件档位；与规范冲突时**以规范为准**。
- **改源即全局**：token 真源在 `lib/core/theme/*`，组件真源在 `lib/shared/*`；只改这一处即全局同步，禁止在页面内重定义样式或复制组件。
- **严禁擅自新增**：收敛去重（把重复字面量指向已有 token、值不变）可直接做；一旦需要**新增字面量 / 新 token / 新档位 / 新色系 / 新组件变体**（超出规范），**必须停止，先向用户说明用途与建议值并取得确认**，落地后**同步更新** `design-system/README.md`。
- **改样式 / 增删组件 = 文档 + 画廊同步（强制 · 不可漏）**：只要本次改动**修改样式（`lib/core/theme/*`）**或**新增 / 删除共享组件（`lib/shared/{components,widgets,layouts}/*.dart`）**，就**必须同步更新** `design-system/README.md`（文本权威）**与** `design-system/design-system-spec.canvas.tsx`（可视化画廊）：
  - **新增组件** → 在 README §7 对应组件表补一行（类名 + 位置 + 变体/说明）；**可视组件（`StatelessWidget`/`StatefulWidget`）必须同时在 canvas 画廊补展示 section 或并入同类 section**（缺画廊 = 未同步）；纯函数 / delegate 可只登记 README；
  - **删除组件** → 从 README 与 canvas 移除该组件的行 / 展示，不得残留悬空引用；
  - **改样式/变体** → 同步 README 描述与 canvas 预览。
  - 该项由 **Step 2.7** 的 `scripts/design-system-component-sync.sh` **自动守卫**，退出码 2 即视为漏同步，必须补齐后重跑，**禁止跳过**。
- **三处一致**：README.md（文本）、canvas 源文件、Cursor 托管渲染副本必须一致；改了可视化文档后**必须运行** `scripts/sync-canvas.sh` 同步（见 Step 2.6）。
- `--dart-define=THEME` 换色系时，不得改动 `dark`（默认）分支源值。

## 触发时机

- 新增/修改/删除任意 `lib/**/*.dart` 文件后
- **新增/修改任意 `design-system/**` 文件后**（对照三处一致 + 同步 canvas）
- 用户要求实现功能、修 bug、重构后
- 准备说「已完成」之前

## 审计流程

### Step 1 — 确定变更范围

```bash
git diff --name-only
git diff --name-only --cached
```

若无 git，则审计本次会话中编辑过的所有 Dart 文件。

### Step 2 — 运行自动扫描（优先）

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/audit.sh
```

脚本返回非 0 时，进入 Step 4 修复后重跑，直至通过或明确列出无法自动修复项。

### Step 2.5 — 设计规范对照（强制）

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/design-system-check.sh
```

- 脚本列出本次改动在 token 层新增的颜色 / 字号 / 行高字面量与新 token 名。
- 逐项对照 [design-system/README.md](../../../design-system/README.md)：
  - 若属**收敛去重**（新增只是把重复值指向已有 token、值不变）→ 可继续。
  - 若属**规范外新增**（新值 / 新档位 / 新 token / 新色系）→ **停止**，在报告中列出并**向用户说明用途 + 建议值，取得确认后**才落地，并同步更新规范文档。
- 退出码 2 表示检测到 token 层新增，需人工判定；0 表示无新增。

### Step 2.6 — 设计规范一致性 + canvas 同步（改动涉及 `design-system/` 或 UI token/组件时强制）

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/design-system-consistency.sh
```

- 校验 §0.1「三处一致」：`README.md` / canvas 源 / Cursor 托管渲染副本，以及 canvas 中登记的组件源码路径是否真实存在。
- 退出码 2（不一致 / 缺失）→ 修复后重跑。若仅是托管副本落后，运行同步脚本：

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/sync-canvas.sh
```

- **凡编辑过 `design-system/design-system-spec.canvas.tsx`，收尾前必须跑一次 `sync-canvas.sh`**，否则预览不更新。

### Step 2.7 — 组件 / 样式增删改 ↔ 文档 + 画廊同步守卫（改动含 `lib/shared/*` 组件或 `lib/core/theme/*` 时强制）

```bash
bash .cursor/skills/flutter-post-edit-audit/scripts/design-system-component-sync.sh
```

- 依据 §0.1「改样式 / 增删组件 = 文档 + 画廊同步」强制守卫本次改动：
  - **A 新增组件未登记**：新增的共享组件需登记。**可视组件**（公共类 `extends StatelessWidget / StatefulWidget`）**必须 README + canvas 画廊双登记**（缺任一即退出码 2）；纯函数 / delegate 等非可视文件至少登记 `README`（画廊可选）；仅私有 `_Xxx` 内部拆分自动跳过。
  - **B 删除组件悬空引用**：删除的共享组件仍被 `README` / canvas 引用 → 退出码 2，须移除。
  - **C 漏同步**：本次改了「增/删共享组件」或「token 样式（`lib/core/theme`）」，却没有改动 `design-system/`（README 或 canvas）→ 退出码 2。
  - **D 修改提醒**：仅「修改」了共享组件时列出清单，人工确认外观/变体是否变化，若变则同步文档与画廊（软提示）。
- 纯内部拆分文件（仅私有 `_Xxx` 类、无公共 API）自动跳过，不误报。
- 退出码 2 → 补齐 `README` + canvas（改了 canvas 源再跑 `sync-canvas.sh`）后重跑，**禁止跳过**。

### Step 3 — 人工核对清单

对变更文件逐项核对 [checklist.md](checklist.md)。重点：

| 类别 | 检查点 |
|------|--------|
| **Token** | 是否新增 `AppColors`/`AppSpacing`/`AppRadius`/`AppTextStyles`/`AppDurations` 常量；UI 是否写死 `Color(`、`fontSize:`、`EdgeInsets.` 数值、`BorderRadius.circular(` 数值 |
| **分层** | 文件是否放在正确层（`data/domain/application/presentation`） |
| **依赖** | 有无跨 feature 引用 `data/*` 或 `application/*`；domain 是否 import flutter/http |
| **组件** | 新组件级别是否正确（L1 shared/widgets、L2 shared/components、L3 feature） |
| **组件/样式同步** | 新增/删除共享组件、改 token 样式后，`design-system/README.md` 与 canvas 是否已同步（Step 2.7 守卫，退出码 2 视为漏同步） |
| **状态** | state 是否在 application 层；UI 是否直接改 state 字段 |
| **路由** | 是否使用 `Navigator.push` 而非 `AppRouter` |
| **状态栏留白** | 页面顶栏是否预留状态栏高度；`AppTopBar` 是否传入带 placeholder 回退的 `statusBarHeight`（§3.1） |
| **性能** | List 是否用 builder；是否不必要的全局 rebuild |

### Step 4 — 处理问题

- **可立即修复**：当场修复，重新跑 Step 2–3
- **需用户决策**：说明原因与选项，不标记为通过

### Step 5 — 输出审计报告

## 报告模板

**全部通过时**，回复末尾必须包含以下结构（链接使用项目相对路径，确保可点击）：

```markdown
---

## 架构合规检查 ✅

本次修改符合 [Flutter STRICT V2 架构规范](.cursor/rules/flutter-architecture-strict-v2.mdc)。

| 检查项 | 结果 |
|--------|------|
| Design Token | ✅ 无写死样式；新增 token（如有）已登记于 `lib/core/theme/` |
| 设计规范对照 | ✅ 已对照 `design-system/README.md`；无规范外新增（或已获用户确认并更新文档） |
| 设计规范一致性 | ✅ README / canvas 源 / 托管副本三处一致（涉及 `design-system/` 时已跑 sync-canvas.sh） |
| 组件/样式同步 | ✅ 增删组件 / 改样式已同步 README + canvas（Step 2.7 守卫退出码 0） |
| Feature 分层 | ✅ |
| 依赖方向 | ✅ |
| 组件分级 | ✅ |
| 状态管理 | ✅ |
| 路由 | ✅ |
| 状态栏留白 | ✅ |
| 代码体量 | ✅ |

**变更文件：** `path/to/file.dart`, ...
```

**存在问题时**，使用：

```markdown
---

## 架构合规检查 ⚠️

规范参考：[Flutter STRICT V2 架构规范](.cursor/rules/flutter-architecture-strict-v2.mdc)

| 检查项 | 结果 | 说明 |
|--------|------|------|
| Design Token | ❌ | `features/foo/.../bar.dart:42` 写死 `fontSize: 14` |
| ... | ... | ... |

**待修复：** （已修复的项标注 ✅ 已修复）
```

## Token 专项规则

### 禁止（UI / presentation 层）

```dart
Color(0xFF...)          // → AppColors.*
fontSize: 14            // → AppTextStyles.*
EdgeInsets.all(16)      // → AppSpacing.*
BorderRadius.circular(8)// → AppRadius.*
Duration(milliseconds: 300) // → AppDurations.*
```

### 允许新增 token 的唯一位置

```
lib/core/theme/app_colors.dart
lib/core/theme/app_spacing.dart
lib/core/theme/app_radius.dart
lib/core/theme/app_text_styles.dart
lib/core/theme/app_durations.dart
```

新增 token 时：

1. 命名语义化（禁止 `color1`、`spacingNew`）
2. 确认无现有 token 可复用
3. 在审计报告中列出新增项

### 写死样式豁免

仅限 `lib/core/theme/` 内定义 token 本身，以及第三方生成代码。

## 快速违规搜索

```bash
# 变更文件中的写死样式（排除 core/theme）
git diff -U0 -- '*.dart' | rg 'Color\(0x|fontSize:\s*[0-9]|EdgeInsets\.(all|symmetric|only)\([0-9]|BorderRadius\.circular\([0-9]'

# 跨 feature 违规 import
rg "features/[^/]+/(data|application)/" lib/features --glob '*.dart'

# Navigator 直连
rg 'Navigator\.(push|pop|of)' lib --glob '*.dart' | rg -v 'app_router'

# domain 层 Flutter 依赖
rg "import 'package:flutter" lib/features/*/domain --glob '*.dart'
```

## 状态栏留白专项（§3.1）

变更文件若含 `AppTopBar` 或 `presentation/pages/*_page.dart`，必须核对：

```dart
final statusBarHeight = AppLayout.statusBarHeight(context);
```

违规示例：

```dart
// ❌ Web 预览会多出 44px 空白（应使用 AppLayout）
final statusBarHeight = topInset > 0 ? topInset : AppSizes.statusBarPlaceholderHeight;

// ❌ 原生无 inset 时顶栏贴顶
final statusBarHeight = MediaQuery.paddingOf(context).top;

// ❌ 未传 statusBarHeight
AppTopBar(title: '...', onBack: AppRouter.pop)
```

## 注意事项

- 审计只针对**本次变更**，不要求全库大扫除
- 纯问答、无代码改动时不执行
- 不要省略最终报告，即使改动很小
- 通过时必须给出完整规范链接：`.cursor/rules/flutter-architecture-strict-v2.mdc`
