# Token 专项规则

## 禁止（UI / presentation 层）

```dart
Color(0xFF...)           // → AppColors.*
fontSize: 14             // → AppTextStyles.*
EdgeInsets.all(16)       // → AppSpacing.*
BorderRadius.circular(8) // → AppRadius.*
Duration(milliseconds: 300) // → AppDurations.*
```

## 允许新增 token 的唯一位置

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
4. 登记 `design-system/README.md`（规范外新增须先获用户确认）

## 写死样式豁免

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

变更含 `AppTopBar` 或 `presentation/pages/*_page.dart` 时核对：

```dart
final statusBarHeight = AppLayout.statusBarHeight(context);
```

违规示例：

```dart
// ❌ Web 预览 phantom 44px
final statusBarHeight = topInset > 0 ? topInset : AppSizes.statusBarPlaceholderHeight;

// ❌ 原生无 inset 时顶栏贴顶
final statusBarHeight = MediaQuery.paddingOf(context).top;

// ❌ 未传 statusBarHeight
AppTopBar(title: '...', onBack: AppRouter.pop)
```
