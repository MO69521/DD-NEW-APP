# 09 · 资源（Assets）

> 静态资源统一放 `assets/`，按用途 + feature 分目录，命名 snake_case，并须在 [pubspec.yaml](../pubspec.yaml) 的 `flutter.assets` / `fonts` / `shaders` 登记。**禁止在代码里裸写字符串路径**，统一走 `AppAssetImage`（自动辨 SVG/位图）/ `AppIcon`（SVG 图标）加载。返回 [文档导航](./README.md)。

## 1. 目录总览

| 目录 | 内容 | 加载方式 |
|---|---|---|
| `assets/covers/` | 书籍封面 mock（`cover_01.png` …） | `AppAssetImage` / `BookCover` |
| `assets/icons/` | SVG 图标 + 少量位图图标（按 feature 分子目录） | `AppIcon` / `AppAssetImage` |
| `assets/images/` | 业务位图（按 feature 分子目录） | `AppAssetImage` |
| `assets/fonts/` | 定制数字字体 `TCloudNumber`（3 档字重） | 字体族 `AppFontFamilies.number` |
| `assets/lottie/` | Lottie 动画（当前仅 `README.md` 占位，**暂无 .json**） | `AppLottie`（待接入） |
| `assets/shaders/` | 片元着色器 `aurora.frag`、`liquid_button.frag` | `AuroraBackground` / 液态按钮 |

## 2. Images（位图）

- `assets/images/<feature>/`：按业务分目录，现有 `auth`、`book_detail`、`bookshelf`、`membership`、`my_messages`、`onboarding`、`partner`、`profile`、`ranking`、`splash`、`welfare`。
- `assets/covers/`：书籍封面 mock（真实接入后由后端返回 `coverUrl`，网络图走 `AppNetworkAvatar` / `Image.network` 封装）。
- 加载：统一 `AppAssetImage(assetPath: ...)`；封面场景用 `BookCover`。

## 3. Icons（图标）

- `assets/icons/<feature>/`：`account_settings`、`book_detail`、`membership`、`nav`、`payment`、`profile`、`ranking`、`search`、`welfare` 等子目录；根级通用图标如 `arrow_right.svg`、`chevron_down.svg`、`search.svg`。
- 少量位图图标（`hot_flame.png`）与 SVG 混存，`AppAssetImage` 按扩展名自动选择渲染器。
- 加载：SVG 图标优先 `AppIcon(assetPath: ...)`。

## 4. Fonts（字体）

- `assets/fonts/TCloudNumber-{Light,Regular,Bold}.ttf`：定制**数字字体**，仅数字/标点/符号有字形，中文/字母自动回退系统字体。
- 仅 ≥18px（`AppFontSizes.xl` 及以上）字号引用（`AppFontFamilies.number`）；字重桶整体上移一档（见 [pubspec.yaml](../pubspec.yaml) 注释）。
- 详见 [03_Theme.md](./03_Theme.md) 字体系统。

## 5. SVG

- 使用 `flutter_svg`，经 `AppIcon` / `AppAssetImage` 加载。
- 图标色优先用 `color` 参数注入 token 语义色，避免在 SVG 内写死颜色。

## 6. Lottie

- `assets/lottie/` 目前仅 `README.md` 占位，**尚无实际 `.json` 动画**。
- 封装组件 `AppLottie`（[app_lottie.dart](../lib/shared/components/app_lottie.dart)）已就绪但**未被引用**；接入 Lottie 时把 `.json` 放入本目录、登记 pubspec，再用 `AppLottie(asset: ...)`。

## 7. Rive

- **本项目未使用 Rive**（无 `.riv` 文件、无 rive 依赖）。动效由 Lottie + 片元着色器 + Flutter 显隐/显式动画承担，详见 [10_Animation.md](./10_Animation.md)。

## 8. Shaders（片元着色器）

- `assets/shaders/aurora.frag`：极光动画背景，驱动 `AuroraBackground`（partner / membership 使用）。
- `assets/shaders/liquid_button.frag`：液态按钮效果。
- 在 [pubspec.yaml](../pubspec.yaml) 的 `flutter.shaders` 登记。

## 9. 规范

- **登记**：任何新增资源必须加入 `pubspec.yaml` 对应段（`assets` / `fonts` / `shaders`）。
- **命名**：snake_case；按 feature 归目录，避免根目录堆积。
- **禁止裸路径**：不在业务代码写死 `'assets/...'` 字符串散落；统一经 `AppAssetImage` / `AppIcon`（如需集中管理路径常量，建议后续引入 assets 路径常量类）。
- **真实接入**：mock 封面/头像（`coverAsset`/`avatarAsset`）接后端后映射为 `coverUrl`/`avatarUrl`，在 data 层 DTO 完成，UI 不改。
