# CHANGELOG

> 研发知识库与工程变更日志，**追加式**记录，勿覆盖历史。每次开发按「日期 / 新增 / 修改 / 删除 / 影响模块 / Breaking Changes」登记。

# CHANGELOG

> 研发知识库与工程变更日志，**追加式**记录，勿覆盖历史。每次开发按「日期 / 新增 / 修改 / 删除 / 影响模块 / Breaking Changes」登记。

# CHANGELOG

> 研发知识库与工程变更日志，**追加式**记录，勿覆盖历史。每次开发按「日期 / 新增 / 修改 / 删除 / 影响模块 / Breaking Changes」登记。

# CHANGELOG

> 研发知识库与工程变更日志，**追加式**记录，勿覆盖历史。每次开发按「日期 / 新增 / 修改 / 删除 / 影响模块 / Breaking Changes」登记。

# CHANGELOG

> 研发知识库与工程变更日志，**追加式**记录，勿覆盖历史。每次开发按「日期 / 新增 / 修改 / 删除 / 影响模块 / Breaking Changes」登记。

## 2026-07-16（底栏选中标签改用主文字色）

### 修改
- 底部导航选中态标签颜色由 `AppColors.accentYellow`（品牌强调色）改为 `AppColors.textPrimary`：`navLabelActiveDark`（`lib/core/theme/app_text_styles.dart`）。
- 三主题经 `textPrimary` 既有 `_isLight` 分支解析：`yellow_light` / `pink_light` 深墨 `#1A1A2E`（黑字），`yellow_dark` 纯白。选中态图标仍为主题色稿（黄/粉），仅标签文字改色。
- 已在 iPhone 17 模拟器 `--dart-define=THEME=yellow_light` 验证：选中「书架」标签为黑字、图标黄色，未选标签灰色。

### 影响模块
- `lib/core/theme/app_text_styles.dart`（`navLabelActiveDark`）
- `design-system/README.md`（§底部导航：选中标签由 `primary` 更正为 `textPrimary`）

### Breaking Changes
- 无。

## 2026-07-16（修复 yellow_light 底栏图标不显示）

### 修改
- 清洗 `assets/icons/nav/yellow_light/` 全部 10 个底栏 Tab 图标：去掉 `fill`/`stroke` 的 `style="...:color(display-p3 …);"` 声明，保留同段 `#hex` 呈现属性。
- 根因：这批 SVG 由 Figma 以 Display P3 导出，`flutter_svg` 无法解析 `color(display-p3 …)`，而 CSS `style` 优先级高于 `fill=`/`stroke=`，导致填充/描边被丢弃——激活态 `书城` 只剩黑描边、未选中态 `福利/伙伴/书架/我的` 完全不可见。
- 已在 iPhone 17 模拟器 `--dart-define=THEME=yellow_light` 重建验证：激活态黄色实心 home、未选中态灰色图标均正常显示。
- `pink_light` / `yellow_dark` 两包为纯 `#hex` 导出，不受影响，无需改动。

### 影响模块
- `assets/icons/nav/yellow_light/*.svg`（10 个）
- `docs/09_Assets.md`（新增「导出禁用 Display P3」强制约定）

### Breaking Changes
- 无。

## 2026-07-16（书架书卡增加卡面底）

### 新增
- 新增 `lib/shared/components/book_card_surface.dart`（`BookCardSurface`）：网格书卡卡面底，卡面色走语义 `AppColors.surfaceCard`、`AppRadius.md` 圆角、`AppSpacing.xs` 内边距，作为卡面样式单一真源。

### 修改
- 书架/阅读历史网格每本书铺一层卡面底：`BookCardVertical` / `BookGridCard` 新增可选 `showCardBackground`（默认 false，其余调用点外观不变），书架网格 `BookshelfBookGrid` 两处渲染路径开启。
- 书架管理态选择卡 `BookshelfSelectableBookCard` 同步铺 `BookCardSurface`。
- `BookshelfBookGrid.itemHeightForWidth` 按卡面内边距扣除封面宽度重新换算单元格高度。
- 三主题统一：卡面 `surfaceCard` 与标题 `textOnDark`(=`textPrimary`) 均经既有 `_isLight` 分支解析——`pink_light`/`yellow_light` 为白面 + 深墨字，`yellow_dark` 为深灰面 + 白字，文字与卡面对比在三主题均可读，无新增 token、无 keep-dark 例外。

### 影响模块
- `lib/shared/components/book_card_surface.dart`（新增）
- `lib/shared/components/book_card_variants.dart`、`lib/shared/components/book_grid_card.dart`
- `lib/features/bookshelf/presentation/components/bookshelf_book_grid.dart`、`bookshelf_selectable_book_card.dart`
- `docs/05_Components.md`、`docs/06_Pages.md`

### Breaking Changes
- 无（`showCardBackground` 默认 false，`BookCardVertical`/`BookGridCard` 现有调用点行为不变）。

## 2026-07-16（福利进度节点统一：7日阅读对齐任务时间线）

### 新增
- `welfare_timeline_dot.dart`：抽出共享的进度时间线节点圆点 `WelfareTimelineDot`（已达/可领橙色实心 `taskTimelineDotReached` + 未达灰底 `taskTimelineDot`，统一 2px 描边环 `taskTimelineDotBorder`）。

### 修改
- `welfare_task_timeline.dart`：任务时间线节点由私有 `_TimelineDot` 改为复用 `WelfareTimelineDot`（外观不变）。
- `reading_vip_progress_section.dart`：7 日阅读福利进度节点由私有 `_ProgressDot`（无描边、高亮用 `taskTimelineFill`）改为复用 `WelfareTimelineDot`，补齐描边环并与任务时间线节点样式完全一致。
- 节点色 token 均为主题分支（`taskTimelineDotReached`/`taskTimelineDot`/`taskTimelineDotBorder`），一处共用三主题（`yellow_dark`/`pink_light`/`yellow_light`）自动解析。

### 影响模块
- `lib/features/welfare/presentation/components/welfare_timeline_dot.dart`（新增 L3）
- `lib/features/welfare/presentation/components/welfare_task_timeline.dart`
- `lib/features/welfare/presentation/components/reading_vip_progress_section.dart`

### Breaking Changes
- 无

## 2026-07-16（福利页切图统一命名对齐）

### 修改
- 切图更新并统一命名后，`WelfareAssetMapper.checkInRewardIconAsset` 的星尘图标由 `check_in_stardust.png` 改为 `stardust.png`（与货币条星尘 `CurrencyConfig` 共用同一张切图，去掉重复文件）。
- 其余福利图标引用（`recharge_info.svg`、`vip_badge.png`、`check_in_claimed.svg`、`stardust.png`、`energy.svg` 等）本已是统一命名，无需改动。
- 图标为主题无关的共享资源，一处引用三主题（`yellow_dark`/`pink_light`/`yellow_light`）共用；已在 `yellow_light` 预览机验证福利页图标全部正常渲染。

### 影响模块
- `lib/features/welfare/presentation/mappers/welfare_asset_mapper.dart`
- `assets/icons/welfare/`（切图重命名，按目录注册自动打包）

### Breaking Changes
- 无

## 2026-07-16（pink_light 卡片描边调浅）

### 新增
- `AppPalette.pink75 = #F8E6ED`：比旧 `pink100 #F4D9E4` 更浅的浅粉，用作 `pink_light` 浅色卡片细描边（经用户确认取值）。

### 修改
- `AppBrandColors.lightCardBorder`（`pink_light` 分支）由 `pink100` 改为 `pink75`，全局卡片描边（`borderSubtle` / `guessLikeTagBorder` 等）粉色系整体调浅。`yellow_light`（中性浅灰 `neutralCool200`）与 `yellow_dark`（`whiteAlpha04`）不受影响。
- 同步 `design-system/README.md`、`design-system-spec.canvas.tsx`（+ 托管副本）三处一致。

### 删除
- `AppPalette.pink100`（改色后不再被引用）。

### 影响模块
- `lib/core/theme/app_palette.dart`、`lib/core/theme/app_brand_colors.dart`
- `design-system/README.md`、`design-system/design-system-spec.canvas.tsx`

### Breaking Changes
- 无（仅 `pink_light` 描边取值变浅）

## 2026-07-16（每日签到里程碑气泡底色对齐累计签到卡）

### 修改
- `check_in_milestone_bubble.dart`：里程碑能量气泡（100/150/200）由黄色渐变底改为与左侧「累计签到」卡同底（`checkInDayBg`），符合 `design-system/README.md` §签到色「里程碑气泡底 = `checkInDayBg`」的既有规范。三主题经 `_isLight` 分支自动覆盖。去掉气泡描边（描边在底部三角尾巴处会穿帮）。

### 删除
- `app_welfare_colors.dart`：移除改色后不再引用的 `checkInMilestoneBubbleStart` / `checkInMilestoneBubbleEnd` 渐变 token（此前未在 README 登记）。

### 影响模块
- `lib/features/welfare/presentation/components/check_in_milestone_bubble.dart`
- `lib/core/theme/app_welfare_colors.dart`

### Breaking Changes
- 无

## 2026-07-15（flutter-post-edit-audit skill 瘦身：references 下沉）

### 修改
- `SKILL.md` 瘦身为编排层（~90 行），细则迁至 `references/design-system.md`、`references/token-rules.md`、`references/report-template.md`；触发时机与 Step 1–5 不变。

### 影响模块
- `.cursor/skills/flutter-post-edit-audit/`

### Breaking Changes
- 无（审计流程与脚本路径不变）

## 2026-07-15（规范：三主题默认同步修改）

### 修改
- `.cursor/rules/flutter-architecture-strict-v2.mdc` §0.1：新增「三主题默认同步」强制规则。
- `.cursor/skills/flutter-post-edit-audit/SKILL.md` + `checklist.md`：审计清单与报告模板增加「三主题覆盖」项；用户未特别声明时，`yellow_dark` / `pink_light` / `yellow_light` 须一并生效。
- `docs/11_DevelopmentGuide.md` §B8 补充三主题默认同步说明。

### 影响模块
- `.cursor/rules/`、`.cursor/skills/flutter-post-edit-audit/`、`docs/11_DevelopmentGuide.md`

### Breaking Changes
- 无

## 2026-07-15（榜单 4 名起角标左上角贴合封面圆角）

### 修改
- `RankingRankBadge` 第 4 名起数字角标补 `topLeft: AppRadius.bookCover`（4px），与封面左上角圆角裁切一致；`pink_light` / `yellow_light` / `yellow_dark` 统一。

### 影响模块
- `lib/shared/components/ranking_rank_badge.dart`、`design-system/`、`docs/CHANGELOG.md`

### Breaking Changes
- 无

## 2026-07-15（榜单 Top3 名次 SVG 角标修复）

### 修改
- `RankingRankBadge` Top 1–3 改用 `AppIcon` 加载 `rank_1/2/3.svg`（与项目 SVG 图标规范一致）；清理 SVG 内 Figma `display-p3` style 属性，避免部分运行时解析失败导致角标空白。

### 影响模块
- `lib/shared/components/ranking_rank_badge.dart`、`assets/icons/ranking/rank_*.svg`、`docs/CHANGELOG.md`

### Breaking Changes
- 无

## 2026-07-15（榜单名次角标 4 名起恒白字 + Top3 SVG）

### 修改
- `rankingMutedBadgeText`（`white100` keep-dark）：第 4 名起名次数字全主题恒白，`pink_light` / `yellow_light` 不再误用翻转的 `textOnDark`。
- `RankingRankBadge` Top 1–3 切图路径改为 `rank_1/2/3.svg`（对接更新后的 SVG 资源）。

### 影响模块
- `lib/core/theme/app_colors.dart`、`ranking_rank_badge.dart`、`design-system/`、`docs/05_Components.md`

### Breaking Changes
- 无

## 2026-07-15（继续阅读浮层锁定深色样式）

### 修改
- 书城「继续阅读」浮层新增 `continueReadingCard*` keep-dark token；`pink_light` / `yellow_light` 下不再误用浅色页面背景与翻转文字色，视觉与 `yellow_dark` 统一。

### 影响模块
- `lib/core/theme/app_colors.dart`、`continue_reading_card.dart`、`design-system/`、`docs/06_Pages.md`

### Breaking Changes
- 无

## 2026-07-15（充值「会员免费领」角标字色修复）

### 修改
- `AppWelfareColors.vipFreeClaimBadgeText`（`magenta950` / `vipOnGradientText`）：浅粉角标底 `#FFD5DB` 上改深玫红字，不再误用恒白 `cornerBadgeText`；`pink_light` / `yellow_light` / `yellow_dark` 统一。

### 影响模块
- `lib/core/theme/app_welfare_colors.dart`、`recharge_packages_section_free_claim.dart`、`app_corner_badge.dart`、`design-system/`、`docs/05_Components.md`

### Breaking Changes
- 无

## 2026-07-15（榜单侧导航未选中字色提升可读性）

### 修改
- `AppTextStyles.rankingDimensionInactive` 字色由 `textOnDarkPlaceholder`（`textTertiary` `#9B9B9B`）改为 `textOnDarkMuted`（`textSecondary` `#6B7280`），与书卡简介 `bookCardLargeDescription` 同级；`pink_light` / `yellow_light` / `yellow_dark` 同步生效。

### 影响模块
- `lib/core/theme/app_text_styles.dart`、`design-system/README.md`、`docs/05_Components.md`

### Breaking Changes
- 无

## 2026-07-15（yellow_light 大背景改中性浅灰 neutralCool50）

### 修改
- `yellow_light` 页面壳背景 / `bgTint*` 由 `cream50`（偏黄）改为 `neutralCool50`（`#F8F7FC` 中性浅灰）；比 `pink50` 更淡、不偏黄。
- 移除未使用的 `cream50Alpha*` 原色阶（`cream50` 实体仍保留给促销条副标题）。

### 影响模块
- `lib/core/theme/app_palette.dart`、`app_brand_colors.dart`、`design-system/`、`docs/03_Theme.md`、`docs/04_DesignToken.md`

### Breaking Changes
- 无

## 2026-07-15（yellow_light 大背景改淡 cream50）

### 修改
- `yellow_light` 页面壳背景 / `bgTint*` 由共用 `pink50`（`#F4F2F4`）改为更淡暖白 `cream50`（`#FFF9F2`）及 `cream50Alpha*`；`pink_light` 不变。

### 影响模块
- `lib/core/theme/app_palette.dart`、`app_brand_colors.dart`、`design-system/`

### Breaking Changes
- 无（仅 `THEME=yellow_light` 视觉变浅）

## 2026-07-15（编辑推荐外层卡片与榜单一致）

### 修改
- `EditorPickSection`：外层 `surfaceCard` + `AppRadius.lg` 内边距，与 `RankingSection` / `LimitedFreeSection` 一致；标题与网格间距 `md`。

### 影响模块
- `lib/features/bookstore/presentation/components/editor_pick_section.dart`、`book_grid_section.dart`

### Breaking Changes
- 无

## 2026-07-15（充值价格/免费领胶囊底 黑 4%）

### 修改
- `rechargePriceBg` → `sectionMoreActionBackground`（`blackAlpha04`）；`_RechargePillButton` 价格区与「免费领」与「更多福利」同底，浅粉/浅黄/深色统一。VIP「VIP领取」仍用粉紫渐变。

### 影响模块
- `lib/core/theme/app_welfare_colors.dart`、`recharge_packages_section_cards.dart`

### Breaking Changes
- 无

## 2026-07-15（会员免费领角标浅粉锁定）

### 修改
- `AppWelfareColors.vipFreeClaimBadgeBackground`（`pink100Soft` #FFD5DB）：充值 VIP 角标底显式锁定，全主题含 `pink_light` 不变；仅统一字色为白，不改浅粉底色。
- design-system 画廊修正「会员免费领」预览色（原误为黄底深字）。

### 影响模块
- `lib/core/theme/app_welfare_colors.dart`、`recharge_packages_section_free_claim.dart`、`design-system/`

### Breaking Changes
- 无

## 2026-07-15（区块胶囊操作入口底 黑 4%）

### 修改
- `AppColors.sectionMoreActionBackground`（`blackAlpha04`）：福利「更多福利」、书城榜单「完整榜单」胶囊底由 `surfaceCard` 改为纯黑 4%；`yellow_light` / `pink_light` / `yellow_dark` 统一。

### 影响模块
- `lib/core/theme/app_colors.dart`、`recharge_packages_section_cards.dart`、`ranking_section_header.dart`

### Breaking Changes
- 无

## 2026-07-15（我的成就标题行上下居中对齐）

### 修改
- `ProfileAchievementSection` 标题行：`我的成就` 与 `共获得 N 枚勋章` 改 `CrossAxisAlignment.center`，移除 `bottom` 内边距与 baseline 手工偏移；三主题统一。

### 影响模块
- `lib/features/profile/presentation/components/profile_achievement_section.dart`

### Breaking Changes
- 无

## 2026-07-15（卡片彩色角标字色统一恒白）

### 修改
- `AppColors.cornerBadgeText`（`white100`）；`AppCornerBadge` / `hotSaleBadgeText` 默认改恒白，不再误用随浅色翻转的 `textOnDark`。
- 福利充值「热」「0/300每日」、星尘兑换角标等 `yellow_light` / `pink_light` 下字色恢复纯白。

### 影响模块
- `lib/core/theme/app_colors.dart`、`app_welfare_colors.dart`、`lib/shared/components/app_corner_badge.dart`、`recharge_packages_section_free_claim.dart`

### Breaking Changes
- 无

## 2026-07-15（修复 recharge part 文件 analyze error）

### 修改
- `recharge_packages_section_cards.dart`：`part of` 须为唯一指令，将 `app_icon_assets` import 上移至主库 `recharge_packages_section.dart`。

### 影响模块
- `lib/shared/components/recharge_packages_section.dart`、`recharge_packages_section_cards.dart`

### Breaking Changes
- 无

## 2026-07-15（底栏纯色不透明 + 纹理铺底层）

### 修改
- `AppBottomNav`（`fullWidthSolid`）：关闭 backdrop blur，始终用不透明 `bottomNavScrim`（浅 `white100` / 深 `backgroundDark`）铺底；纹理仍经 `AppThemeAssets.bottomNavTexture` 铺在底层，后续设计交付切图后只需调整叠色策略。
- `AppBlurredChromeBar` 拆分 `blurEnabled` 与 `enabled`：可仅铺实心底/纹理、不磨砂。
- `bottomNavScrim` 深色分支由 `bgTint90` 改为不透明 `backgroundDark`，修复浅色主题底栏发灰半透明。

### 影响模块
- `lib/shared/layouts/app_bottom_nav.dart`、`lib/shared/components/app_blurred_chrome_bar.dart`、`lib/core/theme/app_colors.dart`

### Breaking Changes
- 无

## 2026-07-15（封面角标统一背景模糊）

### 修改
- `BookCoverTagBadge`：全主题统一 `ClipRRect` + `BackdropFilter`（`bookCoverTagBlurSigma = 8`），压在封面上磨砂可读；完结/连载/更新三种变体共用。
- `AppSizes.bookCoverTagBlurSigma` 登记；design-system / CHANGELOG 同步。

### 影响模块
- `lib/shared/components/book_cover_tag_badge.dart`、`lib/core/theme/app_sizes.dart`

### Breaking Changes
- 无

## 2026-07-15（封面角标「完结/连载」浅色恒白字 + 黑 4% 描边）

### 修改
- `BookCoverTagBadge`：「完结/连载」字色改 `bookCoverTagCompletedText`（`white100` 恒白），描边改 `bookCoverTagCompletedBorder`（`blackAlpha04` + `hairline` 0.5px）；不再误用随浅色翻转的 `textPrimary` / `borderSubtle`。`yellow_light` / `pink_light` 编辑推荐等封面角标恢复设计稿。
- `app_colors.dart` 登记 `bookCoverTagCompletedText` / `bookCoverTagCompletedBorder`（`light-audit: keep-dark`）。

### 影响模块
- `lib/shared/components/book_cover_tag_badge.dart`、`lib/core/theme/app_colors.dart`
- 书城编辑推荐、猜你喜欢、分类/榜单/搜索等共用 `BookCoverTagBadge` 的封面

### Breaking Changes
- 无

## 2026-07-15（猜你喜欢卡浅色纯白 + 底栏纹理接线）

### 修改
- `AppColors.guessLikeCardBackground`：浅色实验态改为 `surface`（`neutralWhite` #FFFFFF 实体白），深色态仍 `surfaceSoft`；书城 / 书架「猜你喜欢」卡文字区不再透出页面浅粉底。
- `AppBlurredChromeBar` 新增可选 `textureAsset`：纹理铺满 + `scrimColor` 前景叠色；`AppBottomNav` 接入 `AppThemeAssets.bottomNavTexture`，有纹理时用 `bottomNavTextureScrim`（`bgTint60`），无纹理回退 `bottomNavScrim`。
- design-system / docs（05/CHANGELOG）同步。

### 影响模块
- `lib/core/theme/app_colors.dart`、`lib/shared/components/app_blurred_chrome_bar.dart`、`lib/shared/layouts/app_bottom_nav.dart`
- `lib/features/bookstore/.../guess_like_section.dart`、`lib/features/bookshelf/.../bookshelf_recommendation_section.dart`（仅引用 token，无结构改动）

### Breaking Changes
- 无

## 2026-07-15（主题包 id：dark → yellow_dark）

### 修改
- 深色主题编译包 id 由 `dark` 统一更名为 `yellow_dark`：`AppThemeId` 默认值 / `assetPack`、资源目录、`pubspec`、launch / `run-sim`、docs、design-system。
- 资源路径：`assets/{icons,images}/**/dark/` → `**/yellow_dark/`。

### Breaking Changes
- 构建参数 `--dart-define=THEME=dark` 不再识别为合法包（未知 id 回退 `yellow_dark`）；请改用 `THEME=yellow_dark` 或不带参。

## 2026-07-15（一级 Tab 顶部纹理槽位 AppTabTopTexture）

### 新增
- `AppSizes.tabTopTextureHeight = 120`；`AppThemeAssets.tabTopTexture`（暂 `null`）。
- `assets/images/tab_top/{yellow_dark,pink_light,yellow_light}/` 资源目录（切图未到位）。
- `AppTabTopTexture`：全宽装饰层，接入书城 / 福利 / 书架 Stack 底层。

### 修改
- docs / design-system 登记组件与资源约定。

### Breaking Changes
- 无（槽位透明，视觉零变化；切图后改 `tabTopTexture` 路径即可）。

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
- 底栏纹理改为 `assets/images/bottom_nav/<themeId>/nav_texture.png`（含 `yellow_light` 占位，复用 yellow_dark）。
- 书详跨主题图标迁入 `assets/icons/book_detail/shared/`（`promo_reward_tag` / `refresh`），经 `AppThemeAssets` 暴露。
- `AppThemeAssets.bottomNavTexture` 统一按 `_assetThemeId` 解析；`docs/09_Assets.md` 写明主题分包约定。

### 影响模块
- 资源目录 / `AppThemeAssets`；书详 promo / content 路径。

### Breaking Changes
- 旧路径 `nav_texture_dark.png` / `nav_texture_pink.png`、以及 `book_detail/` 根下 `promo_reward_tag.svg` / `refresh.svg` 已迁移，请勿再引用。

## 2026-07-15（主题感知图标：底栏 + 书详加入书架/送心）

### 新增
- `AppThemeAssets` 扩展底栏 10 图标 + 书详/搜索 4 图标语义路径（按 `THEME` → `assets/icons/<feature>/<themeId>/`）。
- 资源目录：`assets/icons/nav/{yellow_dark,pink_light,yellow_light}/`、`assets/icons/book_detail/{yellow_dark,pink_light,yellow_light}/`（当前为烘焙色占位，设计交付后整文件替换即可）。

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
- `yellow_dark` 与 `pink_light` 解析值零回归（强调身份色与中性外壳在两包下取值不变）。

### Breaking Changes
- 无（默认 `yellow_dark` 及既有 `pink_light` 取值不变；仅新增 `yellow_light` 分支与强调身份源色重构，语义名 / 调用点零改动）。

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
