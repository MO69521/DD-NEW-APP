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

## 2. Images（图片资源）

- `assets/images/<feature>/`：按业务分目录；**空状态插图**统一放 [`assets/images/empty_states/`](../assets/images/empty_states/)（三主题公用，经 [`AppSharedAssets`](../lib/core/theme/app_shared_assets.dart)）。
- 书城下拉刷新使用 `assets/images/bookstore/refresh_bear/frame_01.png` … `frame_20.png` 透明序列帧，三主题共用并经 `AppSharedAssets.bookstoreRefreshBearFrames` 集中取用；源图 500×500，界面按 50×50 播放。
- 书架今日阅读横幅的小熊使用 `assets/images/bookshelf/reading_bear.svg`，由 `AppAssetImage` 自动经 `flutter_svg` 加载；以 64×64 方形画布和 top 8 偏移绘制，使用 `BoxFit.contain` 保持比例，下半身由横幅底边裁剪。
- **随主题变的位图**：`assets/images/<feature>/<themeId>/`（例：登录头图、我的 Hero、底栏纹理）。
- `assets/covers/`：书籍封面 mock（真实接入后由后端返回 `coverUrl`，网络图走 `AppNetworkAvatar` / `Image.network` 封装）。
- 加载：统一 `AppAssetImage(assetPath: ...)`；封面场景用 `BookCover`；主题位图经 `AppThemeAssets`；空态等共用图经 `AppSharedAssets`。

## 3. Icons（图标）

- `assets/icons/<feature>/`：`account_settings`、`book_detail`、`membership`、`nav`、`payment`、`profile`、`ranking`、`search`、`shared`、`welfare` 等。中文含义见 [`assets/icons/README.md`](../assets/icons/README.md)（**勿改英文目录名**）。
- **场景归类**：
  - `shared/`：跨页面通用 UI 图标（`arrow_right` 行尾箭头、`chevron_down` 展开、`hot_flame` 热门角标），路径经 [`AppIconAssets`](../lib/core/theme/app_icon_assets.dart)。
  - `search/`：搜索入口 / 空态（`search.svg`）。
  - 其余按业务 feature 分子目录。
- **主题分包约定**（仅「随主题变」的资源）：
  ```text
  assets/icons/<feature>/{yellow_dark|pink_light|yellow_light}/…  # 主题色稿
  assets/icons/<feature>/shared/…                          # 同 feature 跨主题共用
  assets/images/<feature>/{yellow_dark|pink_light|yellow_light}/… # 主题位图
  ```
  未建主题子目录的 feature（如 `payment`、`profile`）视为跨主题共用，**不复制三份**。
- 当前主题包：`nav/<themeId>/`（10 Tab）、`book_detail/<themeId>/`（加入书架/送心）、`book_detail/shared/`（促销标/刷新）、`images/bottom_nav/<themeId>/nav_texture.png`。路径经 [`AppThemeAssets`](../lib/core/theme/app_theme_assets.dart)；完整色稿 **不再** `ColorFilter` 染色。
- 加载：主题相关 → `AppThemeAssets`；通用 UI → `AppIconAssets`；其余可用 `AppIcon`。

## 4. Fonts（字体）

- `assets/fonts/TCloudNumber-{Light,Regular,Bold}.ttf`：定制**数字字体**，仅数字/标点/符号有字形，中文/字母自动回退系统字体。
- 仅 ≥18px（`AppFontSizes.xl` 及以上）字号引用（`AppFontFamilies.number`）；字重桶整体上移一档（见 [pubspec.yaml](../pubspec.yaml) 注释）。
- 详见 [03_Theme.md](./03_Theme.md) 字体系统。

## 5. SVG

- 使用 `flutter_svg`，经 `AppIcon` / `AppAssetImage` 加载。
- **通用单色图标**：仍可用 `color` 参数注入 token 语义色。
- **主题完整色稿**（底栏 Tab、书详加入书架 / 送心）：经 `AppThemeAssets` 按主题选文件，**禁止**再染 `color`。
- **导出禁用 Display P3（强制）**：Figma 导出 SVG 时若开启 P3，`fill`/`stroke`/`stop-color` 会带 `style="...:color(display-p3 …);"`。`flutter_svg` 无法解析 `color(display-p3 …)`，且 CSS `style` 优先级高于 `fill=`/`stroke=` 呈现属性，会导致填充/描边被丢弃——图标渲染为纯描边或**整体不可见**（曾致 `yellow_light` 底栏图标只剩黑描边 / 消失）。导出时关闭 P3 用 sRGB 十六进制；已入库的 P3 SVG 需清洗掉 `style` 内的 `…:color(display-p3 …);` 声明（保留同段的 `#hex` 呈现属性即可）。

## 5.1 主题资源（`AppThemeAssets`）

真源 [`lib/core/theme/app_theme_assets.dart`](../lib/core/theme/app_theme_assets.dart)，与 `AppBrandColors` 平行，按 `--dart-define=THEME` 选资源：

| 语义 | 资源目录 / 文件 |
|---|---|
| 底栏纹理 | `assets/images/bottom_nav/<themeId>/nav_texture.png` |
| 福利页顶部纹理 | `assets/images/tab_top/<themeId>/top_texture.png`（`AppThemeAssets.tabTopTexture`；切图未到位时为 `null`；书城首页 / 书架不调用） |
| 登录页头图 | `yellow_light` 复用 `assets/images/profile/yellow_light/hero_background_default.png`；`pink_light` / `yellow_dark` 保持 `assets/images/auth/<themeId>/login_top_bg.png` |
| 我的页默认头图 | `assets/images/profile/<themeId>/hero_background_default.png` |
| 底栏 Tab（10） | `assets/icons/nav/<themeId>/{bookstore,welfare,partner,bookshelf,profile}_{active,inactive}.svg` |
| 书详加入书架 / 送心（4） | `assets/icons/book_detail/<themeId>/{add_to_shelf,in_shelf,send_heart,send_heart_sent}.svg` |
| 书详共用 | `assets/icons/book_detail/shared/{promo_reward_tag,refresh}.svg` |

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
- **禁止裸路径**：不在业务代码写死 `'assets/...'` 字符串散落；统一经 `AppAssetImage` / `AppIcon`；随主题变化走 `AppThemeAssets`，通用 UI 图标走 `AppIconAssets`，空状态等跨主题位图走 `AppSharedAssets`。
- **真实接入**：mock 封面/头像（`coverAsset`/`avatarAsset`）接后端后映射为 `coverUrl`/`avatarUrl`，在 data 层 DTO 完成，UI 不改。
