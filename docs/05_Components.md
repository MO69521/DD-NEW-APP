# 05 · 公共组件说明（Components）

> 范围：`lib/shared/` 全部公共组件，三级分层（L1 原子 `widgets/` · L2 组合 `components/` · 骨架 `layouts/`）。每项含：位置、用途、主要参数、使用页面、是否建议复用、可继续抽象点。参数只列关键项（req=必填 / opt=可选），完整签名以源码为准。返回 [文档导航](./README.md)。

## 概览与结论

- **总量**：L1 约 17 文件、L2 约 24 文件、layouts 7 文件；绝大多数已被多页面复用，token 化彻底。
- **未被引用（建议清理或补用例）**：`AppFocalCoverImage`、`AppLottie`、`GlassChipButton`、`BookCardRankingCompact`、`BookListTile`、`MainTabPlaceholder`、`showAppScrimDialog`（`showAppBlurredDialog` 的别名）。
- **偏业务、需警惕 shared 污染**：`EnergyRechargePurchaseDialog`、`RechargePackagesSection`（及其 `part` 文件）、`VipPromoBanner`、`CurrencyBalanceBar`——均含具体业务模型（能量/充值/VIP），若使用面收窄建议下沉回 `currency_wallet` / `membership`。
- **主要可抽象点**：① 扫光/液态系列（`SweepHighlightOverlay` / `LiquidSweepCtaClip` / `AppGradientCtaButton` / `VipPromoBanner`）共享扫光引擎，可统一底层动画；② 书卡遗留变体（`BookCardHorizontal` / `BookCardRankingCompact` / `BookListTile`）与主用 `BookCardVertical` / `BookCardLargeRow` 重叠，建议收敛。

## 1. L1 原子组件（`lib/shared/widgets/`）

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `AppText` · [app_text.dart](../lib/shared/widgets/app_text.dart) | 统一文字原子 | `data` req · `style` · `maxLines` · `overflow` | 全站通用（150+） | 强烈建议 | 已足够原子 |
| `AppButton` · [app_button.dart](../lib/shared/widgets/app_button.dart) | 统一按钮（变体/尺寸/loading） | `label` req · `onPressed` · `variant` · `size` · `isExpanded` | 全站通用（35+） | 强烈建议 | 变体足够；渐变 CTA 已另拆 |
| `AppPressable` · [app_pressable.dart](../lib/shared/widgets/app_pressable.dart) | 通用按压反弹反馈 | `child` req · `onTap` · `pressScale` | 全站通用（70+） | 强烈建议 | 已足够通用 |
| `AppAssetImage` · [app_asset_image.dart](../lib/shared/widgets/app_asset_image.dart) | 按扩展名自动选 SVG/位图 | `assetPath` req · `width` · `height` · `fit` · `color` | 全站通用（40+） | 强烈建议 | 与 `AppIcon` 职责相近，可评估合并 |
| `AppIcon` · [app_icon.dart](../lib/shared/widgets/app_icon.dart) | 加载 SVG 图标 | `assetPath` req · `width/height` · `color` | 约 25 处 | 建议 | 可并入 `AppAssetImage` |
| `AppSwitch` · [app_switch.dart](../lib/shared/widgets/app_switch.dart) | 深色 UI 开关 | `value` req · `onChanged` req | settings、dev_tools | 建议 | 已足够 |
| `AppSelectionMark` · [app_selection_mark.dart](../lib/shared/widgets/app_selection_mark.dart) | 圆形选中标记 | `isSelected` req · 各色/边宽可覆写 | auth、bookshelf、currency_wallet、help_feedback | 建议 | 已足够 |
| `AppNetworkAvatar` · [app_network_avatar.dart](../lib/shared/widgets/app_network_avatar.dart) | 圆形网络头像 + 占位 | `imageUrl` req · `size` req · `placeholderAsset` | my_messages、dress_up、membership、profile、account_settings | 建议 | 已足够 |
| `AnimatedCountText` · [animated_count_text.dart](../lib/shared/widgets/animated_count_text.dart) | 数值滚动文本 | `value` req · `style` · `prefix/suffix` | currency_wallet、bookshelf | 建议 | 已足够 |
| `AppMarqueeText` · [app_marquee_text.dart](../lib/shared/widgets/app_marquee_text.dart) | 溢出跑马灯 | `text` req · `style` · `velocity` | bookstore | 建议 | 使用面小，可推广 |
| `AppShimmer` / `AppShimmerBox` · [app_shimmer.dart](../lib/shared/widgets/app_shimmer.dart) | 骨架扫光层 / 占位块 | `child` req；box：`width/height/radius` | shared（骨架卡） | 建议 | 已足够 |
| `BookCover` · [book_cover.dart](../lib/shared/widgets/book_cover.dart) | 书封（尺寸/角标/Hero） | `assetPath` req · `aspectRatio` · `topEndBadge` · `heroTag` | bookstore、bookshelf、book_detail、my_messages | 强烈建议 | 已足够 |
| `bookCoverHeroRectTween` / `…FlightShuttleBuilder` · [book_cover_hero.dart](../lib/shared/widgets/book_cover_hero.dart) | 书封 Hero 飞行补间/交叉淡入 | 见源码（函数） | book_cover、bookstore、book_detail | 建议 | 已足够 |
| `AppNavIcon` · [app_nav_icon.dart](../lib/shared/widgets/app_nav_icon.dart) | 底部 Tab 图标动画 | `item` req · `isSelected` req · `tapEpoch` | shared（`app_bottom_nav`） | 内部件 | 与 bottom_nav 强耦合，保持 |
| `AuroraBackground` · [aurora_background.dart](../lib/shared/widgets/aurora_background.dart) | 极光着色器背景 | `colorStops` · `amplitude` · `blend` · `opacity` · `child` | partner、membership | 建议 | 已足够 |
| `OverscrollStretch` · [overscroll_stretch.dart](../lib/shared/widgets/overscroll_stretch.dart) | 头图下拉视差拉伸 | `controller` req · `baseHeight` req · `child` req | membership、book_detail | 建议 | 已足够 |
| `AdvancedTransitionWrapper` · [advanced_transition_wrapper.dart](../lib/shared/widgets/advanced_transition_wrapper.dart) | 容器转换转场（卡片→全屏） | `closedChild` req · `openBuilder` · `borderRadius` | welfare、shared（充值区） | 建议 | 已足够 |

## 2. L2 组合组件（`lib/shared/components/`）

### 2.1 顶栏 / 导航 / 页面门闸

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `AppTopBar` (+`AppTopBarAction`) · [app_top_bar.dart](../lib/shared/components/app_top_bar.dart) | 通用顶栏（三槽位多变体） | `statusBarHeight` · `title` · `onBack` · `actions` · `showScrim` | 全站二级页通用 | 强烈建议 | 已足够 |
| `AppTopBarIconButton` · [app_top_bar_icon_button.dart](../lib/shared/components/app_top_bar_icon_button.dart) | 顶栏图标按钮（模糊圆底） | `iconAsset` req · `iconColor` · `onTap` | bookstore、partner、welfare、profile、ranking | 建议 | 已足够 |
| `AppTopBarTextButton` · [app_top_bar_text_button.dart](../lib/shared/components/app_top_bar_text_button.dart) | 顶栏文字动作 | `label` req · `style` · `onTap` | bookshelf；`AppTopBar` 内部 | 建议 | 已足够 |
| `AppAsyncPageBody` · [app_async_page_body.dart](../lib/shared/components/app_async_page_body.dart) | 加载/错误/空/内容门闸 | `isLoading` req · `errorMessage` · `onRetry` · `isEmpty` · `child` req | 全站 Tab/二级页通用 | 强烈建议 | 已足够 |
| `AppBlurredChromeBar` · [app_blurred_chrome_bar.dart](../lib/shared/components/app_blurred_chrome_bar.dart) | Chrome 背景（可选 blur / 纹理） | `child` req · `enabled` · `blurEnabled` · `blurSigma` · `scrimColor` · `textureAsset?` | 全站通用 | 强烈建议 | 已足够 |
| `BlurredPinnedHeaderDelegate` · [blurred_pinned_header_delegate.dart](../lib/shared/components/blurred_pinned_header_delegate.dart) | 吸顶 Sliver 头部（毛玻璃） | `height` req · `child` req | welfare | 建议 | 使用面小，可推广 |

### 2.2 Tab / 分段 / 指示器（Tab 系统）

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `AppTopTabBar` (+`AppTopTabItem`) · [app_top_tab_bar.dart](../lib/shared/components/app_top_tab_bar.dart) | 顶部一级 Tab 栏（弹性指示 + 角标） | `items` req · `selectedIndex` req · `onSelected` req · `swipeProgress` | bookstore、partner、my_messages、help_feedback | 强烈建议 | 已足够 |
| `AppSwipeTabSwitcher` · [app_swipe_tab_switcher.dart](../lib/shared/components/app_swipe_tab_switcher.dart) | Tab 内容区跟手左右切换 | `children`/`child` · `selectedIndex` req · `onIndexChanged` req · `tabCount` | 全站通用 | 强烈建议 | 已足够 |
| `AppAnimatedTabLabel` · [app_animated_tab_label.dart](../lib/shared/components/app_animated_tab_label.dart) | Tab 文字选中态插值过渡 | `index`/`selectedIndex`/`label` req · `active/inactiveStyle` req | 经 `AppTopTabBar`；bookshelf、dress_up、bookstore | 建议 | 已足够 |
| `ElasticTabIndicator` · [elastic_tab_indicator.dart](../lib/shared/components/elastic_tab_indicator.dart) | 弹性指示条（平移+拉伸回弹） | `selectedIndex` req · `slotWidth/slotPitch` · `axis` · `swipeProgress` | currency_wallet；shared（tab 系列） | 强烈建议 | 已足够（底层件） |
| `ElasticTabRow` · [elastic_tab_row.dart](../lib/shared/components/elastic_tab_row.dart) | 变宽 Tab 行 + 内置指示条 | `selectedIndex` req · `children` req · `swipeProgress` | bookshelf、dress_up | 建议 | 已足够 |
| `AppSegmentedSwitch` (+`AppSegmentedItemBuilder`) · [app_segmented_switch.dart](../lib/shared/components/app_segmented_switch.dart) | 毛玻璃横向分段开关 | `itemCount`/`selectedIndex`/`onChanged`/`itemBuilder` req | book_detail、ranking | 建议 | 已足够 |
| `AppVerticalRailSwitch` · [app_vertical_rail_switch.dart](../lib/shared/components/app_vertical_rail_switch.dart) | 竖向选项轨（弹性指示）；榜单维度栏未选字 `rankingDimensionInactive`（`textSecondary`） | `itemCount`/`selectedIndex`/`onChanged`/`itemBuilder`/`itemSlotHeight` req | ranking | 建议 | 已足够 |
| `AppTabCountBadge` · [app_tab_count_badge.dart](../lib/shared/components/app_tab_count_badge.dart) | Tab 悬浮数字角标 | `count` req · `color` | book_detail；经 `AppTopTabBar` | 建议 | 已足够 |
| `AppPageDots` · [app_page_dots.dart](../lib/shared/components/app_page_dots.dart) | 分页指示点 | `count` req · `current` req · `onDotTap` | membership、onboarding | 建议 | 已足够 |

### 2.3 弹窗 / 反馈 / 空态

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `showAppBlurredDialog` · [app_blurred_dialog.dart](../lib/shared/components/app_blurred_dialog.dart) | 全局居中弹窗入口（80% 遮罩） | `context`/`builder` req · `barrierDismissible` | 全站通用 | 强烈建议 | `showAppScrimDialog` 别名未用，建议删 |
| `AppConfirmDialog` · [app_confirm_dialog.dart](../lib/shared/components/app_confirm_dialog.dart) | 确认弹窗壳（双/单按钮） | `title` req · `message`/`body` · `primaryLabel`/`secondaryLabel` | auth、settings、search、bookshelf | 强烈建议 | 已足够 |
| `DialogCloseButton` · [dialog_close_button.dart](../lib/shared/components/dialog_close_button.dart) | 弹窗右上角关闭按钮 | `onTap` req | 全站通用 | 强烈建议 | 已足够 |
| `AppToast` · [app_toast.dart](../lib/shared/components/app_toast.dart) | 全局轻提示（静态 API） | `AppToast.show(context, message)` | 全站通用 | 强烈建议 | 已足够 |
| `EmptyState` · [empty_state.dart](../lib/shared/components/empty_state.dart) | 空状态组合 | `title` req · `description` · `action` · `illustration` | 全站通用 | 强烈建议 | 已足够 |
| `AppTabTopTexture` · [app_tab_top_texture.dart](../lib/shared/components/app_tab_top_texture.dart) | 一级 Tab 顶部装饰纹理（全宽 × 120） | 无必填 | 书城 / 福利 / 书架 | 建议 | 切图未到位时透明槽位 |
| `AppListLoadMoreFooter` · [app_list_load_more_footer.dart](../lib/shared/components/app_list_load_more_footer.dart) | 上拉加载指示（可 Sliver） | `isLoading` req · `asSliver` · `padding` | bookshelf、category、editor_pick | 建议 | 已足够 |
| `AppConfetti` · [app_confetti.dart](../lib/shared/components/app_confetti.dart) | 礼花庆祝层 | `duration` | welfare | 建议 | 已足够 |
| `ShareBottomSheet` · [share_bottom_sheet.dart](../lib/shared/components/share_bottom_sheet.dart) | 分享底部弹层（静态 show） | `onChannelTap` | book_detail | 建议 | 使用面小，可推广 |

### 2.4 列表 / 卡片 / 内容块

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `SectionHeader` · [section_header.dart](../lib/shared/components/section_header.dart) | 区块标题 + 右侧操作 | `title` req · `actionLabel` · `onActionTap` | book_detail、bookshelf、bookstore | 强烈建议 | 已足够 |
| `AppGroupedListCard` · [app_grouped_list_card.dart](../lib/shared/components/app_grouped_list_card.dart) | 分组列表卡（标题 + 分割线） | `title` · `children` req | settings、account_settings | 建议 | 已足够 |
| `AppNavigationListRow` · [app_navigation_list_row.dart](../lib/shared/components/app_navigation_list_row.dart) | 导航列表行（标题 + 箭头） | `label` req · `subtitle` · `trailing` · `onTap` | settings、account_settings | 建议 | 已足够 |
| `BookCardLargeRow` · [book_card_large_row.dart](../lib/shared/components/book_card_large_row.dart) | 大封面横向书卡 | `coverAsset`/`title` req · `meta` · `description` · `trailing` | category、editor_pick、ranking、search | 强烈建议 | 已足够 |
| `BookGridCard` · [book_grid_card.dart](../lib/shared/components/book_grid_card.dart) | 网格竖向书卡（薄封装） | `title`/`category`/`coverAsset` req · `coverTag` · `heroTag` · `showCardBackground`(默认 false) | book_detail、bookshelf、bookstore | 强烈建议 | 与 `BookCardVertical` 可评估合并 |
| `book_card_variants.dart`（`BookCardVertical` / `BookCardRankingCompact` / `BookCardHorizontal`） | 书卡变体集合 | 各 `title/category/coverAsset` req · Vertical 支持 `showCardBackground` 铺卡面底 | Vertical 经 `BookGridCard`；其余遗留 | 部分（Vertical 是） | **收敛**：`RankingCompact`/`Horizontal` 遗留，建议合并或删 |
| `BookCardSurface` · [book_card_surface.dart](../lib/shared/components/book_card_surface.dart) | 网格书卡卡面底（`surfaceCard` + `md` 圆角 + `xs` 内边距，三主题语义解析） | `child` req · 静态 `padding`/`radius` 供网格高度换算复用 | bookshelf（书架/阅读历史 + 管理态选择卡） | 建议 | 已足够 |
| `BookListTile` · [book_list_tile.dart](../lib/shared/components/book_list_tile.dart) | 榜单紧凑横向书项（遗留） | `title/category/coverAsset` req | 未被引用 | 否 | **建议删除**（死代码） |
| `BookCoverTagBadge` · [book_cover_tag_badge.dart](../lib/shared/components/book_cover_tag_badge.dart) | 封面状态角标（磨砂底） | `tag` req · `bookCoverTagBlurSigma` | bookstore；书卡内部 | 建议 | 已足够 |
| `RankingRankBadge` · [ranking_rank_badge.dart](../lib/shared/components/ranking_rank_badge.dart) | 榜单名次角标（Top3 SVG；4 名起恒白字） | `rank` req | bookstore、ranking | 建议 | 已足够 |
| 书卡骨架族 · [book_card_skeletons.dart](../lib/shared/components/book_card_skeletons.dart)（`BookLargeRowListSkeleton` / `BookGridSkeleton` 等） | 书卡加载骨架 | `count` · `columns` · `padding` | category、ranking、search、bookshelf | 强烈建议 | 已足够 |

### 2.5 表单选项 / 徽章 / 装饰

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `AgeRangeOption` · [age_range_option.dart](../lib/shared/components/age_range_option.dart) | 年龄段单选胶囊 | `label`/`selected`/`onTap` req | settings、onboarding | 建议 | 与 `GenderAvatarOption` 可归一为通用选项 |
| `GenderAvatarOption` · [gender_avatar_option.dart](../lib/shared/components/gender_avatar_option.dart) | 性别头像选项 | `label`/`activeAsset`/`inactiveAsset`/`selected`/`onTap` req | onboarding、settings | 建议 | 同上 |
| `AppCornerBadge` · [app_corner_badge.dart](../lib/shared/components/app_corner_badge.dart) | 卡片斜切角标（饱和色底恒白字；VIP 浅粉底用 `vipFreeClaimBadgeText`） | `label`/`color` req · `textColor` 默认 `cornerBadgeText` | currency_wallet；充值卡 | 建议 | 已足够 |
| `GlassChipButton` · [glass_chip_button.dart](../lib/shared/components/glass_chip_button.dart) | 玻璃态胶囊按钮/容器 | `child` req · `onTap` · `expanded` · `height` | 未被引用 | 否 | **建议接用或删除** |
| `AppFocalCoverImage` · [app_focal_cover_image.dart](../lib/shared/components/app_focal_cover_image.dart) | 焦点智能裁切封面 | `image` req · `focalPoint` · `minRevealHeightRatio` | 未被引用 | 否 | **建议接用**（榜单/详情头图可用） |
| `AppLottie` · [app_lottie.dart](../lib/shared/components/app_lottie.dart) | Lottie 动画封装 | `asset` req · `repeat` · `fit` | 未被引用 | 否 | **建议接用或删除** |

### 2.6 扫光 / 液态 CTA 系列（可统一抽象）

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `SweepHighlightOverlay` · [sweep_highlight_overlay.dart](../lib/shared/components/sweep_highlight_overlay.dart) | 扫光高亮带循环滑过 | `highlightColor`/`edgeColor` · `bandWidthRatio` · `progress` | book_detail、welfare；shared | 建议 | 与下列共用扫光引擎，可抽公共动画 |
| `LiquidSweepCtaClip` · [liquid_sweep_cta_clip.dart](../lib/shared/components/liquid_sweep_cta_clip.dart) | 液态扫光裁剪壳 | `progress` req · `borderRadius` req · `child` req | book_detail、welfare；shared | 建议 | 同上 |
| `AppGradientCtaButton` · [app_gradient_cta_button.dart](../lib/shared/components/app_gradient_cta_button.dart) | 渐变 CTA（扫光+呼吸+loading） | `child`/`gradientColors`/`height`/`borderRadius`/`sweepHighlight`/`sweepEdge`/`loadingColor` req | membership、welfare | 建议 | 参数偏多，可用配置对象收敛 |

### 2.7 业务偏重（评估下沉）

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `CurrencyBalanceBar` · [currency_balance_bar.dart](../lib/shared/components/currency_balance_bar.dart) | 虚拟货币余额条 | `balances` req · `onCurrencyTap` | profile、welfare | 建议（跨 2 页） | 含货币模型，勉强属 shared |
| `RechargePackagesSection` · [recharge_packages_section.dart](../lib/shared/components/recharge_packages_section.dart)（含 2 个 `part`：`_cards` / `_free_claim`） | 充值套餐区块 | `packages` req · `onPackageTap` · `freeClaimOptions` · `collapsible` | currency_wallet、profile、welfare | 建议（跨 3 页） | 业务强；`part` 拆分已合理 |
| `EnergyRechargePurchaseDialog` · [energy_recharge_purchase_dialog.dart](../lib/shared/components/energy_recharge_purchase_dialog.dart) | 能量充值支付确认弹窗 | `package` req · `onConfirm` · 静态 `show` | profile、routes | 观望 | **偏业务**，使用面窄时下沉 `currency_wallet` |
| `VipPromoBanner` · [vip_promo_banner.dart](../lib/shared/components/vip_promo_banner.dart) | VIP 开通引导横幅 | `monthlyEnergy`/`priceYuan` req · `onTap` | profile | 观望 | **偏业务**，仅 1 页用，建议下沉 `membership` |

## 3. 骨架层（`lib/shared/layouts/`）

| 组件 / 位置 | 用途 | 主要参数 | 使用范围 | 建议复用 | 可继续抽象 |
|---|---|---|---|---|---|
| `MainTabShell` (+`MainTabPlaceholder`) · [main_tab_shell.dart](../lib/shared/layouts/main_tab_shell.dart) | 主 Tab 壳（切换 + 共享底栏） | `pages` req · `initialIndex` · `controller` · `hideBottomNav` | routes（根路由） | 内部件 | `MainTabPlaceholder` 未用，建议删 |
| `MainTabController` · [main_tab_controller.dart](../lib/shared/layouts/main_tab_controller.dart) | 外部切 Tab 控制器 | 无（默认构造） | routes、bookshelf、bookstore、profile | 建议 | 已足够 |
| `AppBottomNav` (+`AppBottomNavStyle`) · [app_bottom_nav.dart](../lib/shared/layouts/app_bottom_nav.dart) | 底部 5 Tab 导航栏 | `items` · `selectedIndex` · `onTabChanged` · `style` · `blurEnabled` | 实例：`main_tab_shell`；`barHeight` 常量全站留白通用 | 建议 | 已足够 |
| `AppPageChrome` · [app_page_chrome.dart](../lib/shared/layouts/app_page_chrome.dart) | 页面 Chrome 叠层（内容滚入顶栏下 + 顶栏毛玻璃） | `topBar` req · `body` req | 全站二级页通用 | 强烈建议 | 已足够 |
| `AppScrollBlurScope` · [app_scroll_blur_scope.dart](../lib/shared/layouts/app_scroll_blur_scope.dart) | 滚动判定→顶栏毛玻璃开关 | `builder` req | book_detail、membership、partner、ranking | 建议 | 已足够 |
| `AppChromeBlur` · [app_chrome_blur.dart](../lib/shared/layouts/app_chrome_blur.dart) | Chrome 毛玻璃滚动判定工具 | 静态方法 | shared 内部 | 内部件 | 已足够 |
| `AppScaffold` · [app_scaffold.dart](../lib/shared/layouts/app_scaffold.dart) | 通用脚手架（AppBar + body + FAB） | `title` · `body` req · `floatingActionButton` | home（唯一页面级） | 观望 | 使用面极窄；多数页走 `AppPageChrome`，可评估合并/弃用 |
