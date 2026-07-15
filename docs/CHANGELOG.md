# CHANGELOG

> 研发知识库与工程变更日志，**追加式**记录，勿覆盖历史。每次开发按「日期 / 新增 / 修改 / 删除 / 影响模块 / Breaking Changes」登记。

## 2026-07-15（清理未引用 SVG/位图）

### 删除
- `assets/icons/profile/wish_star.png`（未引用；愿星走 `icons/welfare/wish_star.png`）
- `assets/icons/welfare/more_benefits_arrow.png`
- `assets/images/welfare/recharge_hot_badge.png`、`stardust_exchange_badge.png`
- 空目录 `assets/images/my_messages/`（空态图已迁 `empty_states/`）

### 影响模块
- 仅资源清理，无代码路径改动。

### Breaking Changes
- 无

## 2026-07-15（空状态插图归类 empty_states · 三主题公用）

### 新增
- `assets/images/empty_states/`：`empty_bookshelf` / `empty_card_pack` / `empty_messages`（不随 THEME 分包）。
- `lib/core/theme/app_shared_assets.dart`：跨主题位图语义路径。

### 修改
- 书架空态、卡包空态、消息空态改引 `AppSharedAssets`。

### Breaking Changes
- 旧路径 `bookshelf/empty_bookshelf.png`、`profile/empty_card_pack.png`、`my_messages/empty_messages.png` 已迁入 `empty_states/`。

## 2026-07-15（登录 / 我的页头图按主题分包）

### 新增
- `lib/core/config/app_theme_id.dart`：纯 Dart 主题 id（domain 可引用）。
- `assets/images/auth/<themeId>/login_top_bg.png`、`assets/images/profile/<themeId>/hero_background_default.png`（浅色包暂用现图占位）。

### 修改
- `AppThemeAssets` 增加 `authLoginTopBg` / `profileHeroBackgroundDefault`；登录页与「我的」/装扮默认头图改为主题路径。

### Breaking Changes
- 旧路径 `assets/images/auth/login_top_bg.png`、`assets/images/profile/hero_background_default.png` 已迁入主题子目录。

## 2026-07-15（icons 目录中英对照说明）

### 新增
- `assets/icons/README.md`：英文目录名 ↔ 中文用途对照表（不改文件夹名，不影响引用）。

## 2026-07-15（整理根目录散落图标：shared / search）

### 新增
- `lib/core/theme/app_icon_assets.dart`：通用 UI 图标语义路径（与 `AppThemeAssets` 分工）。
- `assets/icons/shared/`：`arrow_right`、`chevron_down`、`hot_flame`。
- `assets/icons/search/search.svg`：搜索入口 / 空态。

### 修改
- 25 处调用改为 `AppIconAssets.*`；顺带修复 `hot_flame.png` 失效引用 → `hot_flame.svg`。
- `docs/09_Assets.md`、`design-system/README.md`、`pubspec.yaml` 登记新目录。

### Breaking Changes
- 根路径 `assets/icons/arrow_right.svg` 等已迁走，请改用 `AppIconAssets`。

## 2026-07-15（主题资源目录统一：feature / themeId / shared）

### 修改
- 底栏纹理改为 `assets/images/bottom_nav/<themeId>/nav_texture.png`（含 `yellow_light` 占位，复用 dark）。
- 书详跨主题图标迁入 `assets/icons/book_detail/shared/`（`promo_reward_tag` / `refresh`），经 `AppThemeAssets` 暴露。
- `AppThemeAssets.bottomNavTexture` 统一按 `_assetThemeId` 解析；`docs/09_Assets.md` 写明主题分包约定。

### 影响模块
- 资源目录 / `AppThemeAssets`；书详 promo / content 路径。

### Breaking Changes
- 旧路径 `nav_texture_dark.png` / `nav_texture_pink.png`、以及 `book_detail/` 根下 `promo_reward_tag.svg` / `refresh.svg` 已迁移，请勿再引用。

## 2026-07-15（主题感知图标：底栏 + 书详加入书架/送心）

### 新增
- `AppThemeAssets` 扩展底栏 10 图标 + 书详/搜索 4 图标语义路径（按 `THEME` → `assets/icons/<feature>/<themeId>/`）。
- 资源目录：`assets/icons/nav/{dark,pink_light,yellow_light}/`、`assets/icons/book_detail/{dark,pink_light,yellow_light}/`（当前为烘焙色占位，设计交付后整文件替换即可）。

### 修改
- `MainTabConfig` / `AppNavIcon`：图标走 `AppThemeAssets`，去掉运行时 `ColorFilter` 染色。
- `BookDetailBottomBar`、搜索结果「加入书架」：改引 `AppThemeAssets`，同样不再染色。
- `pubspec.yaml` 登记各主题子目录；文档 `09_Assets.md`、`design-system/README.md`。

### 影响模块
- Shell 底栏、书详底栏、搜索结果行 trailing。

### Breaking Changes
- 底栏 / 书详相关图标不再接受运行时染色；切图须为完整色稿（或替换占位文件）。

## 2026-07-15（新增第三个编译期主题包 yellow_light）

### 新增
- 主题包 `yellow_light`（黄色浅色系）：复用现有 `pink_light` 中性浅色外壳（背景 `#F4F2F4`、白卡片、现有分割线），主强调色换成深色主题黄 `#FFE847`，卡片细描边改中性浅灰 `#E5E7EB`。构建：`--dart-define=THEME=yellow_light`。
- `lib/core/theme/app_palette.dart`：原色 `yellow500Alpha40 = 0x66FFE847`（供浅色态按钮禁用底，与 `pink500Alpha40` 对齐）。
- `lib/core/theme/app_brand_colors.dart`：强调身份源色 `onAccent`、`accentSoft04`、`accentSoft08`、`accentDisabledFill`、`lightCardBorder`（按 `themeId==pink_light` 判定粉 vs 黄）。
- `.vscode/launch.json` 新增「点点 · 黄色浅色（yellow_light）」运行配置。

### 修改
- `lib/core/theme/app_brand_colors.dart`：`isLightExperiment` 扩展为 `pink_light || yellow_light`；中性外壳 token（`backgroundDark`/`dialogBackground`/`textOnDark`/`surfaceMuted`/`bgTint00..90`）判定由 `themeId==pink_light` 改为 `isLightExperiment`，两浅色包共用。
- `lib/core/theme/app_colors.dart`：`onPrimary`→`AppBrandColors.onAccent`、`primarySoft`→`accentSoft04`、`segmentedSelectedFill`→`accentSoft08`、`buttonDisabledFill` 浅色分支→`accentDisabledFill`、`_lightBorder`→`lightCardBorder`。强调身份色不再看 `_isLight`，改为跟随强调色，修复「亮黄底 + 白字」不可读。
- `scripts/run-sim.sh`、`scripts/check-light-theme.sh`：允许列表 / 注释补充 `yellow_light`。
- 文档：`03_Theme.md`、`04_DesignToken.md`；设计规范 `design-system/README.md` + `design-system-spec.canvas.tsx`（+ 托管副本三处一致）。

### 影响模块
- 全局主题层（`core/theme`）；`app_welfare/membership/partner_colors.dart` 因复用 `isLightExperiment` 与 `onPrimary`，自动惠及新包。
- `dark` 与 `pink_light` 解析值零回归（强调身份色与中性外壳在两包下取值不变）。

### Breaking Changes
- 无（默认 `dark` 及既有 `pink_light` 取值不变；仅新增 `yellow_light` 分支与强调身份源色重构，语义名 / 调用点零改动）。

## 2026-07-15（数据源环境开关脚手架）

### 新增
- `lib/core/config/api_env.dart`：`ApiEnvConfig`（`--dart-define=API_ENV=rest` 切真实接口，缺省 `mock`）。

### 修改
- `lib/features/bookstore/application/bookstore_cubit.dart`、`lib/features/search/application/search_cubit.dart`：默认注入改为按 `ApiEnvConfig.isRest` 在 Remote / Mock 数据源间选择（`_defaultRepository()`）。
- `lib/core/services/auth_service_config.dart`：`environment` 缺省跟随 `API_ENV`（`rest`→真实登录，否则 Mock）。
- 文档：`07_DataFlow.md`（替换点速查改为环境开关）、`08_API.md`（接入步骤 + 预留列）、`01_Project.md`（运行命令加 `API_ENV=rest`）、`12_TechLeadReview.md`（标注 P0/P1 进度）。

### 影响模块
- `bookstore` / `search` / `auth` 的**默认数据源选择**；**缺省行为不变**（仍 Mock）。仅当显式 `--dart-define=API_ENV=rest` 时走真实通路。
- 验证：`flutter test` 全 20 项通过；改动文件 ReadLints 无报错。

### Breaking Changes
- 无（默认 mock 行为与之前一致；无后端预览 / 演示不受影响）。

## 2026-07-14（修复福利页浅色态 token 不翻转）

### 修改
- `lib/core/theme/app_welfare_colors.dart`：福利页签到 / 任务区多处把 `whiteNN`（白透明叠加）与个别深色 `Color(0x…)` 直接用作**面 / 描边 / 文字 / 里程碑圆点**，浅色实验包（`pink_light`）下不翻转导致「白底看不见、深色圆点变黑块、白字消失」。按 `_isLight`（`AppBrandColors.isLightExperiment`）加分支：**深色分支保持原值不变**，浅色分支翻到已有实体语义 token（`surfaceSoft` / `borderSubtle` / `divider` / `border` / `textPrimary` / `textSecondary`）。涉及 `checkInDayBg/…Header/…Border/…LabelMuted`、`checkInProgressTrack/…DotFill/…DotStroke`、`checkInMilestoneAmount/…Label`、`rechargePriceBg`、`taskDivider/taskActionBg/taskRewardChipBg/taskRewardChipText/taskRewardChipMutedText/taskTimelineTrack/taskTimelineBubbleReached/taskTimelineDot/taskTimelineDotBorder/taskProgressLabel`。**未引入新色值**（浅色分支全部复用既有语义 token）。
- `design-system/README.md` §4.2.5：更新 `checkInDayBg` / `checkInMilestoneAmount` 行说明，补「福利页浅色翻转」说明段。
- `design-system/design-system-spec.canvas.tsx` §4.2.5：上述两行改为深/浅双色卡展示（同步托管副本）。

### 影响模块
- 福利页（`features/welfare`）全部签到 / 任务区组件（经 `AppWelfareColors` 单一真源，自动生效）；深色默认态视觉不变。
- 设计规范 `design-system/`（README + canvas 源 + 托管副本三处一致）。

### Breaking Changes
- 无（深色默认态 token 取值全部保持不变，仅新增浅色分支）。

## 2026-07-15（修复预览入口浅色态状态栏白图标）

### 修改
- `lib/previews/{global,shell,partner,bookstore,editor_pick}_preview_main.dart`：启动时原**硬编码** `SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light)`（白图标），未走真源，导致 `THEME=pink_light` 浅底上时间/信号/电量/Home 指示条为白色不可读。改为 `SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle)`——随主题翻转（深色壳白图标 / 浅色实验包深图标）。真实 App（`main.dart`/`app.dart`）本就用真源，不受影响；`component_gallery` 预览此前已正确。

### 影响模块
- 各 Web/模拟器预览入口的系统状态栏 / 导航栏在浅色实验包下的图标明暗（深色默认态不变）。

### Breaking Changes
- 无。

## 2026-07-15（修复预览入口浅色态状态栏图标不翻转）

### 修改
- `lib/previews/{global,shell,bookstore,partner,editor_pick,component_gallery}_preview_main.dart`：各预览 App 只在启动时 `SystemChrome.setSystemUIOverlayStyle` 一次，iOS 首帧后失效，导致浅色（pink_light）态状态栏时间/信号/电量仍为白图标（浅底不可读）。改为与正式 `app.dart` 一致，用 `AnnotatedRegion<SystemUiOverlayStyle>(value: AppTheme.systemUiOverlayStyle)` 包裹 `MaterialApp`，持续施加、随主题翻转（深壳白图标 / 浅壳深图标）。

### 影响模块
- 全部预览入口（QA 走查）；正式 App（`app.dart`）本已正确，不受影响。

### Breaking Changes
- 无。

## 2026-07-14（清理 pubspec 失效资源目录条目）

### 修改
- `pubspec.yaml`：移除失效条目 `assets/icons/search/`（该目录已随 `add_to_shelf.svg` 删除而不存在，导致 `flutter run` 每次热重启刷「unable to find directory entry」警告）。`assets/icons/search.svg` 文件仍由 `assets/icons/` 条目覆盖，不受影响。

### 影响模块
- `pubspec.yaml` 资源清单；消除构建/热重启期的非致命警告。

### Breaking Changes
- 无。

## 2026-07-14（浅色主题 token 专项排查与收敛 + 检测脚本）

### 新增
- `scripts/check-light-theme.sh`：浅色（pink_light）token 反模式检测。① 公开 token 直绑 `_dark*` 为硬门禁（退出码 2）；②③④（feature 色板硬编码 / UI 直用 `whiteNN` / UI 裸 `Color(0x…)`）为人工复核清单，豁免项加行内注释 `// light-audit: keep-dark|effect`。

### 修改
- `lib/core/theme/app_membership_colors.dart`：会员页浅色 bug 收敛——`planUnselectedBg→(_isLight?surfaceSoft:white04)`、`planUnselectedBorder→borderSubtle`、`planSelectedSecondary→(_isLight?textSecondary:white60)`、`benefitIconBg→(_isLight?surfaceSoft:white05)`、`agreementLink→(_isLight?textPrimary:white100)`（原白底/白字浅色下消失）。
- `lib/core/theme/app_partner_colors.dart`：`messageRowDivider→(_isLight?divider:white08)`；沉浸式互动场景 / 品牌粉紫 tint / 装饰光晕 / 封面阴影加 `// light-audit: keep-dark|effect` 留档（按既定「沉浸场景恒暗」决定）。
- `lib/core/theme/app_colors.dart`：`topBarIconFrameBorder`、`bookshelfSelectionMarkBorderUnselected` 两处图上恒暗 `_dark*` 直绑加 `// light-audit: keep-dark` 留档。
- `lib/features/help_feedback/.../help_feedback_inputs.dart`：输入框填充 `white08/white04→surface/surfaceSoft`（浅色下白底叠白看不见）。
- `lib/shared/*`、`lib/features/*`：`app_tab_count_badge`/`membership_hero`/`continue_reading_card`/`sweep_highlight_overlay`/`app_marquee_text`/`app_page_dots` 的 `whiteNN` 直用确认为特效/蒙版/阴影/恒白角标字，加 `// light-audit: effect` 留档。
- `design-system/README.md`：新增 §4.2.6「浅色主题 token 审计与收敛约定（强制）」+ 反模式表 + 脚本登记；更新 `planSelectedSecondary` 行深/浅解析。

### 排查结论（无需改）
- `app_text_styles.dart` 65 个 `*Dark` 文字样式：color 均走 `textOnDark/…Muted/…Placeholder / accentYellow / onAccent` 等**可翻转别名**，命名 `Dark` 仅指「深色基线」，无烘焙固定色。
- `app_color_scheme.dart`：`dark` 预设各字段引用会翻转的 `AppColors.*`，编译到 pink_light 自动变浅；硬编码 `Color(0x)` 仅属 `brandBlue` 实验预设。
- features 层无裸 `Color(0x…)`；`whiteNN/blackNN` 直用仅 9 处且均为特效。

### 影响模块
- 会员页、伙伴消息面、帮助与反馈输入框（浅色态修复）；深色默认态取值全部不变。
- 设计规范 `design-system/README.md`、`scripts/`。

### Breaking Changes
- 无（深色默认态取值全部保持不变，仅新增浅色分支 / 行内注释）。

## 2026-07-14（修复浅色态：公开 token 绑死 _dark* 私有值不翻转）

### 修改
- `lib/core/theme/app_colors.dart`：多个公开语义 token 直接绑定私有 `_darkSurfaceSoft/_darkSurface/_darkBorder/_darkDivider`（恒深色），浅色实验包（`pink_light`）下不翻转，导致深色块 / 深字压深底看不见（书城「猜你喜欢」卡整块深色最明显）。改指向主题语义 token（其深色分支恰等于原 `_dark*` 值，故**深色像素级不变**、浅色自动翻转）：`guessLikeCardBackground`/`discussionItemReplyBackground`/`myMessagesBookRefBackground → surfaceSoft`、`guessLikeTagBackground → surface`、`guessLikeTagBorder → borderSubtle`、`myMessagesQuoteBar → divider`。
  - 暂不动（压在封面/头图上、需另行目视判断）：`topBarIconFrameBorder`、`bookshelfSelectionMarkBorderUnselected`。
- `design-system/README.md` §4.2.5：更新 `guessLikeCardBackground`/`guessLikeTagBackground`/`guessLikeTagBorder`/`discussionItemReplyBackground` 行，标注深/浅解析。

### 影响模块
- 书城「猜你喜欢」卡、书详情讨论回复块、我的消息书籍引用块 / 引用竖条（浅色态翻为浅实体面 + 深字可读，深色态不变）。

### Breaking Changes
- 无（深色默认态取值不变，仅浅色分支翻转）。

## 2026-07-14（修复福利页「主色上文字/图标」浅色态未翻白）

### 修改
- `lib/core/theme/app_welfare_colors.dart`：坐在主强调色（`accent`，浅色翻粉）上的文字/spinner 原用 `textOnLightPanel`（`#202020` 深字，仅适配深色黄底），浅色粉底上应为白。改 `checkInTodayHeaderText`（今日签到卡头）、`checkInCtaTextDark`（签到 CTA 文字 + loading spinner）、`taskActionHighlightText`（任务高亮按钮文字）为 `_isLight ? AppColors.onPrimary : AppBrandColors.textOnLightPanel`（深色不变、浅色翻白）。
- `lib/features/welfare/presentation/components/welfare_task_action_button.dart`：主操作（`AppButtonVariant.accent`）前置视频图标色由 `rankingSegmentedSelectedText`（=`textOnLightPanel` 深字）改为 `AppColors.onPrimary`，与 `AppButton` 内部文字前景一致（深黄底深字 / 浅粉底白字）。
- `design-system/README.md` §4.2.5：新增「主色上的文字/图标必须走 `onPrimary`（强制）」条目，禁止在主强调面上误用 `textOnLightPanel`。

### 影响模块
- 福利页签到卡头 / 签到 CTA / 任务高亮按钮 / 任务主操作图标（浅色态文字与图标翻白，深色态不变）。

### Breaking Changes
- 无（深色默认态取值不变，仅浅色分支翻转）。

## 2026-07-14（新增 pre-commit 文档同步校验）

### 新增
- `scripts/check-docs-sync.sh`：提交前检查，暂存含 `lib/*.dart` 改动但无 `docs/` 改动时**打印提醒（警告式，不阻断提交）**。
- `scripts/install-git-hooks.sh`：把 `pre-commit` 安装到 `.git/hooks/`（不改 git config，克隆后运行一次）。
- 已安装 `.git/hooks/pre-commit`（委托上述脚本）。

### 影响模块
- `scripts/`、`.git/hooks/`（后者不纳入版本管理，克隆后需重新 `bash scripts/install-git-hooks.sh`）。
- `docs/README.md` 快速开始已加入该安装步骤。

### Breaking Changes
- 无（警告式，永远放行提交；纯手工提交也会提醒）。

## 2026-07-14（新增文档同步常驻规则）

### 新增
- `.cursor/rules/docs-sync.mdc`（`alwaysApply: true`）：固化「每次 `lib/` 改动后同步受影响编号文档 + 追加 CHANGELOG」的收尾流程与「改动→必更文档」映射，令后续所有 AI 会话自动遵守文档同步约定。

### 修改
- `docs/README.md`：文档维护约定注明现由常驻规则强制。

### 影响模块
- `.cursor/rules/`、`docs/`。

### Breaking Changes
- 无。

## 2026-07-14（删除过时的书城页实现文档）

### 删除
- `docs/features/bookstore/书城推荐页-结构与实现思路.md`：内容停留在「UI Only 静态原型」阶段，组件/Token 名已漂移（`BookstoreSearchHeader`/`BookstoreBottomNav`/`BookListTile`/`AppRadius.cardLg` 等与现状不符），页面结构已被 `06_Pages.md` 覆盖，属过时且易误导。

### 修改
- `docs/README.md`：「其它资料」中该实现文档链接改为直接指向书城推荐页 **Figma 设计稿**（保留唯一独有价值）。

### 影响模块
- 仅 `docs/`。`docs/features/bookstore/` 目录已空。

### Breaking Changes
- 无。

## 2026-07-14（backend 接入步骤并入 08）

### 新增
- `08_API.md` 增加「五、分阶段接入计划」：阶段 0–4 模块/接口/替换点表、最小首批 7 接口清单、前端每模块自测清单、接口对齐 5 件事。

### 删除
- `docs/backend/接入步骤建议.md`：独有内容（分阶段计划 / 验收 / 最小清单）已并入 `08_API.md`。

### 修改
- `docs/backend/README.md`：移除对 `接入步骤建议.md` 的引用，改指向 `08_API.md`。

### 影响模块
- 仅 `docs/`。保留 `backend/API接口草案.md`、`字段模型对照.md`（字段级 / JSON 细节）。

### Breaking Changes
- 无。

## 2026-07-14（backend 文档去重）

### 删除
- `docs/backend/前端数据接入总览.md`：内容（页面数据来源 / Repository / Model / 交互动作）已并入 `06_Pages.md` 与 `08_API.md`，属重复文档。

### 修改
- `docs/backend/README.md`：移除对 `前端数据接入总览.md` 的两处引用，改指向 `08_API.md` / `06_Pages.md`。
- `docs/08_API.md`：脚注引用由 `前端数据接入总览.md` 改为 `接入步骤建议.md`。

### 影响模块
- 仅 `docs/`。保留 `backend/API接口草案.md`、`字段模型对照.md`、`接入步骤建议.md`（后端向字段级 / JSON / 分阶段接入细节，与编号库互补，非重复）。

### Breaking Changes
- 无。

## 2026-07-14

### 新增
- 建立 `docs/` 编号研发知识库：`01_Project` · `02_ProjectStructure` · `03_Theme` · `04_DesignToken` · `05_Components` · `06_Pages` · `07_DataFlow` · `08_API` · `09_Assets` · `10_Animation` · `11_DevelopmentGuide` · `12_TechLeadReview`。
- 新增 `CHANGELOG.md`（本文件）。
- 新增 `04_DesignToken.md`（Primitive / Semantic / Component 三层）、`09_Assets.md`、`10_Animation.md`、`12_TechLeadReview.md` 四份此前不存在的文档。

### 修改
- 重写 `docs/README.md` 为研发入口（快速开始 + 文档导航 + 最近更新）。
- 根 `README.md` 顶部增加指向 `docs/README.md` 的入口。

### 删除
- `docs/点点穿书-新APP对接指南.md`（九部分内容已拆分迁移至 01–11 编号文档）。
- `docs/项目目录作用说明.md`（并入 `02_ProjectStructure.md`）。
- `docs/接口接入指南.md`（并入 `08_API.md`）。

### 影响模块
- 仅 `docs/`，未改动 `lib/` 源码、`design-system/` 与平台工程。

### Breaking Changes
- 无（纯文档重组；内容无丢失，旧文档链接失效需改指向新编号文件）。
