# 点点穿书 · 深色 UI 设计规范（唯一权威）

> 可视化版见同目录 [`design-system-spec.canvas.tsx`](./design-system-spec.canvas.tsx)（源文件，随仓库版本管理）；
> 实时渲染预览在 Cursor canvases 目录（托管目录才会渲染）。本 `README.md` 为文本权威基线，二者内容需保持一致，以本文件为准。

> 本文件是设计 token 的**唯一权威基线**。所有 UI 一律引用 token，禁止写死数值。
> 代码实现见 `lib/core/theme/*.dart`，二者必须一致。
>
> **治理规则（强制）**
> 1. 每次改动涉及颜色 / 字号 / 行高 / 字重 / 间距 / 圆角时，**先对照本文档**。
> 2. **严禁擅自新增或修改 token / 档位 / 规范。** 若确需超出本规范（新增字号档、新颜色、新圆角值、新间距值、新主题色系等），**必须先向用户说明用途与建议值，取得确认后**才能落地，并**同步更新本文档**。
> 3. 收敛/去重（把重复字面量指向已有 token、值不变）不算新增，可直接做。
> 4. 换色系走 `--dart-define=THEME=<id>`；默认（不带参）永远是深色，不得改动 `dark` 分支源值。

对应实现文件：

| 维度 | 文件 |
|------|------|
| 字号 / 行高 / 字重 / 字体族 | `lib/core/theme/app_text_styles.dart`（`AppFontSizes` / `AppLineHeights` / `AppFontWeights` / `AppFontFamilies`） |
| 颜色（中性阶 / 语义） | `lib/core/theme/app_colors.dart` |
| 品牌 / 主题源色 | `lib/core/theme/app_brand_colors.dart` |
| 间距 | `lib/core/theme/app_spacing.dart`（`AppSpacing`） |
| 圆角 | `lib/core/theme/app_radius.dart`（`AppRadius`） |
| feature 专用色 | `app_welfare_colors.dart` / `app_partner_colors.dart` / `app_membership_colors.dart`（引用上面的源色） |

---

## 1. 字号 · AppFontSizes（8 档）

| Token | px | 典型用途 |
|-------|----|----|
| `xxs` | 9 | 极小角标 |
| `xs` | 10 | 小标签 |
| `md` | 12 | 说明 / 次要正文 / 标签 |
| `base` | 14 | 正文（主力档） |
| `lg` | 16 | 小标题 / 卡片标题 |
| `xl` | 18 | 页面标题 |
| `xxl` | 24 | 大标题 / 数值 |
| `display` | 32 | Hero / 展示级 |

> 已归位：`8→9`、`11→12`、`13→14`、`15→16`、`22→24`、`26→24`。新增字号档需先确认。

## 2. 行高 · AppLineHeights（4 档）

| Token | 值 | 用途 |
|-------|----|----|
| `none` | 1.0 | 单行标签 / 数字 / 图标旁文字 |
| `tight` | 1.2 | 大标题 / display / 标题 |
| `normal` | 1.4 | 副标题 / 正文段落 |
| `loose` | 1.75 | 多行说明 / 协议类长文 |

## 3. 字重 · AppFontWeights（6 档）

| Token | 值 | 使用场景 |
|-------|----|----|
| `regular` | 400 | 正文 / 说明 / 次级文案 / 未选中 tab |
| `medium` | 500 | 标签 / 选中态 tab / 导航选中 / 次级按钮 |
| `semibold` | 600 | 页面标题 / section 标题 / 热销角标 |
| `bold` | 700 | 主按钮文案 / 强调数值 / display 大标题 |
| `heavy` | 800 | 榜单 Hero 大标题 |
| `black` | 900 | 会员价格等极强调数值 |

## 3.5 字体族 · AppFontFamilies

| Token | 值 | 使用场景 |
|-------|----|----|
| `number` | `TCloudNumber` | 定制数字字体，仅数字 / 标点 / 符号有字形 |

**规则（强制）：**

- **仅 ≥18px 字号引用**：字号 `xl`(18) / `xxl`(24) / `display`(32) 的文字样式统一带 `fontFamily: AppFontFamilies.number`；`<18px`（含 `lg` 16px 及以下）不引用，保持系统字体。
- **数字/标点专用**：该字体仅覆盖数字、标点与符号；中文、字母等未覆盖字符自动回退系统字体，故可安全用于中英混排标题与数值。
- **字重降一档**：字体注册桶整体上移一档（`Light→500 / Regular→700 / Bold→900`），数字字形比文本标称字重轻一档（如 bold 文本内的数字实际取 Regular 字形）；中文 / 字母回退仍按标称字重渲染，不受影响。
- **真源**：字体注册于 `pubspec.yaml`（family `TCloudNumber`，桶 500/700/900，资源在 `assets/fonts/`）；token 定义与应用只在 `app_text_styles.dart`，禁止在 UI 层写死 `fontFamily`。
- 由 ≥18px 基准样式 `copyWith` 派生的样式自动继承该字体，无需重复声明。

---

## 4. 颜色

### 4.1 中性阶 · 白色透明度叠加（`AppColors.whiteNN`，深色态唯一真源）

| Token | 不透明度 | ARGB | 典型用途 |
|-------|------|------|----|
| `white100` | 100% | `0xFFFFFFFF` | 主文字 `textOnDark` |
| `white85` | 85% | `0xD9FFFFFF` | 次强调文字 |
| `white60` | 60% | `0x99FFFFFF` | muted / placeholder / icon |
| `white50` | 50% | `0x80FFFFFF` | 弱化文字 / 扫光高亮 |
| `white24` | 24% | `0x3DFFFFFF` | 头图蒙版软档 |
| `white20` | 20% | `0x33FFFFFF` | 分隔线 / 导航底 |
| `white08` | 8% | `0x14FFFFFF` | surfaceGlass / divider |
| `white06` | 6% | `0x0FFFFFFF` | 回复区底 |
| `white05` | 5% | `0x0DFFFFFF` | 卡片弱底 |
| `white04` | 4% | `0x0AFFFFFF` | surfaceCard / 描边 / 标签底 |
| `white00` | 0% | `0x00FFFFFF` | 渐变透明端 |

### 4.2 中性阶 · 黑色透明度（遮罩 / 蒙版，`AppColors.blackNN`）

| Token | 不透明度 | ARGB | 用途 |
|-------|------|------|----|
| `black80` | 80% | `0xCC000000` | 居中弹窗遮罩（80% 纯黑，无模糊）|
| `black60` | 60% | `0x99000000` | 封面选择遮罩 |
| `black40` | 40% | `0x66000000` | 选中态封面遮罩 |
| `black30` | 30% | `0x4D000000` | 顶栏图标框 / 通用遮罩 |
| `black08` | 8% | `0x14000000` | 顶栏图标框底 |
| `black04` | 4% | `0x0A000000` | 封面描边 / 签到底 |
| `black00` | 0% | `0x00000000` | 渐变透明端 |

### 4.3 背景 tint 阶（`AppColors.bgTintNN`，随 THEME 换色系）

基于基础背景 `#090E17` 的不同透明度，用于渐隐 / 毛玻璃底 / 头图蒙版；换色系时整条随基础背景色相变化。

`bgTint00 · bgTint35 · bgTint45 · bgTint55 · bgTint60 · bgTint80 · bgTint90`

### 4.4 品牌 / 主题源色（`AppBrandColors`，换色系唯一入口）

| Token | Hex | 角色 |
|-------|-----|----|
| `backgroundDark` | `#090E17` | 全局背景（主题源色） |
| `accent` | `#FFE847` | 主强调色（黄）· 深色页主 CTA · 点赞 / 互动选中 |
| `auroraGlow` | `#FFF2C6` | 极光渐变亮核（暖米金） |
| `auroraEdge` | `#1D0B10` | 极光渐变暗边（暗红近黑） |
| `dialogBackground` | `#131820` | 弹窗底 |
| `surfaceMuted` | `#262B33` | 深青灰实心浮层 / 卡片底（如「继续阅读」浮层） |
| `success` | `#39D98A` | 成功（Design Token v1.0） |
| `warning` | `#FFA940` | 警告（Design Token v1.0） |
| `error` | `#FF667F` | 错误（Design Token v1.0） |
| `premiumGold` | `#F9C74F` | VIP 会员金主题（v1.0 新增，暂未接入页面） |
| `info` | `#59AEFF` | 信息 / 提示（v1.0 新增，暂未接入页面） |
| `fantasyPurple` | `#9C87FF` | 奇幻紫（v1.0 新增，暂未接入页面） |
| `energyCyan` | `#42DDFF` | 能量青（v1.0 新增，暂未接入页面） |
| `growthBlue` | `#7E95FF` | 成长蓝（v1.0 新增，暂未接入页面） |

> 说明：黄（`accent`）为深色页唯一主强调 —— 主 CTA、点赞、互动选中等强调态统一用黄。原紫色 `primary`（#6B4EFF）已全局移除。

feature 品牌色（均定义于 `AppBrandColors`，被各 feature 色板引用）：

- 福利金：`goldMedium #935C1A` / `goldDark #AA722E` / `checkInYellow #FCE64D` / `checkInHighlightHeader #FFDD47` / `accentOrange #FF7E32`
- 会员金渐变：`ctaGradientStart #FFE794` / `ctaGradientEnd #FFCD5A`（会员 CTA + 方案选中态）
- VIP 粉紫：`vipGradientStart #FFDDC1` / `vipGradientEnd #F393DC` / `vipOnGradientText #740551`
- 伙伴粉：`partnerPrimary #FF4D88` / `partnerPrimaryLight #FF7AA8` / `partnerPrimaryDark #E03D74`
- 面板深字：`textOnLightPanel #202020`（浅色/金色面板上的深色文字）

### 4.5 feature 语义色 token（引用上述源色，值不变为主）

各 feature 色板（`app_welfare_colors.dart` / `app_membership_colors.dart` / `app_colors.dart`）在源色之上派生的语义 token；除少量透明度变体外均为对源色的别名（收敛去重）。

| Token | 值 | 用途 |
|-------|----|----|
| `checkInHighlightSurface` / `checkInHighlightBg` | `0x14FCE64D`（8% checkInYellow） | 今日签到高亮卡底 |
| `checkInHighlightHeader` | `#FCE64D`（checkInYellow） | 今日签到高亮头 |
| `checkInHighlightBorder` | `#FFDD47`（checkInHighlightHeader） | 高亮卡描边 |
| `checkInRewardTodayText` | `#FCE64D`（checkInYellow） | 今日奖励文字 |
| `checkInDayBg` | `white04` | 普通签到日底 |
| `checkInCumulativeBg` | `0x14FCE64D`（8% checkInYellow） | 累计签到徽章底 |
| `checkInCumulativeBorder` | `white00`（透明） | 累计徽章描边 |
| `checkInMilestoneAmount` | `white100` | 里程碑数值 |
| `planSelectedBg` | `0x14FFE794`（8% 会员金） | 会员方案选中卡底 |
| `planSelectedBorder` | `#FFE794`（ctaGradientStart） | 会员方案选中描边 |
| `planSelectedGoldStart` | `#FFE794`（ctaGradientStart） | 选中金渐变起 |
| `planSelectedGoldEnd` | `#FFCD5A`（ctaGradientEnd） | 选中金渐变止 |
| `planSelectedSecondary` | `white60` | 选中卡次要文字 |
| `planSelectedFooterText` | `#202020`（textOnLightPanel） | 选中卡脚文字 |
| `searchHotAccent` | `#FF7E32`（accentOrange） | 搜索热词强调 |

---

## 5. 间距 · AppSpacing

基阶：`2 · 4 · 8 · 12 · 16 · 24 · 32 · 48`

| Token | px | 用途 |
|-------|----|----|
| `xxsHalf` | 2 | 极小间隔 / 倒计时数字内边距 |
| `xxs` | 4 | 紧凑间隔 |
| `xs` | 8 | 常用小间距 / 小内边距 |
| `sm` | 12 | 常用间距 |
| `md` | 16 | 区块内边距 |
| `lg` | 24 | 区块间距 |
| `xl` | 32 | 大区块间距 |
| `xxl` | 48 | 超大间距 |
| `authTitleContentGap` | 50 | 登录标题-内容间距（一次性） |

> `50` 为保留的语义化一次性值；新增越界间距需先确认。

## 6. 圆角 · AppRadius

基阶：`4 · 12 · 16 · 24 · full(999)`

| Token | px | 用途 |
|-------|----|----|
| `xs` | 4 | 小角标 / 输入 |
| `md` | 12 | 卡片 / 小卡片 / 封面 |
| `lg` | 16 | 大卡片 / 区块 |
| `xl` | 24 | 弹窗 / CTA / 胶囊按钮 |
| `full` | 999 | 全圆 / 药丸 |

feature 专用圆角（在基阶之上按页面命名，如 `navOuter 47` / `searchBar 35` / `rankingSegmentedInner 50` 等）：确需新增新的非基阶圆角值时先确认。

## 6.5 组件尺寸 token · AppSizes（分组索引）

组件级布局尺寸（Figma 精确值：宽高 / 内边距 / 图标尺寸 / 模糊半径 / 比例等）统一定义在唯一真源 `lib/core/theme/app_sizes.dart`，UI 层禁止写死 layout 数值。

> 尺寸档不同于第 1–6 节的**基阶体系**：它是按页面/组件命名的精确值集合，**真值随源码为准**，本表只做「按 feature 分组」的导航索引，方便按前缀快速定位；改值只改 `app_sizes.dart` 一处。
>
> **§11 例外（已确认）**：`app_sizes.dart` 作为尺寸 token 唯一真源（扁平数据，非 widget/逻辑），豁免「文件 > 300 行必须拆分」，与 `app_text_styles.dart` 同属 token registry 例外。原因见该文件头注释。

| 分组 | 覆盖范围 | Token 前缀 / 示例 |
|------|----------|------------------|
| 通用基础 | 描边 / 通用图标 / 启动图 | `hairline` · `borderWidthEmphasis` · `iconSm` · `splashLogoSize` |
| 通用按压反馈 `AppPressable` | 按下缩小 / 大面积柔和缩小 / 回弹 overshoot 比例 | `tapPressScale` · `tapPressScaleSubtle` · `tapPressReboundScale` |
| 骨架屏 `AppShimmer` | 骨架底色 / 扫光高光（复用中性白阶） | `shimmerBase` · `shimmerHighlight`（另见 `AppDurations.shimmerSweep`）|
| 跑马灯 `AppMarqueeText` | 溢出滚动速度 / 间隔 | `marqueeSpeed` · `marqueeGap`（另见 `AppDurations.marqueePause`）|
| 头图视差 `OverscrollStretch` | 下拉拉伸最大放大比例 | `heroParallaxFactor` |
| 顶栏 `AppTopBar` | 二级页顶栏高度 / 图标框 / 返回钮 | `topBar*` |
| 按钮 `AppButton` | 各尺寸内边距 / loading / 图标间距 | `buttonPadding*` · `buttonLoadingIndicatorSize` |
| 搜索栏 / 玻璃模糊 | 搜索框高 / 各级磨砂半径 | `searchBarHeight` · `glassBlurSigma` · `strongBlurSigma` · `chromeBarBlurSigma` |
| 书城首页 | 顶栏 / 加载 / 「继续阅读」浮层 | `bookstore*` · `continueReading*` |
| 底部导航 `AppBottomNav` | 胶囊尺寸 / 图标 / 弹跳缩放 | `bottomNav*` |
| 榜单 | Tab 指示器 / 轮播 / 头图 / 维度导航 | `ranking*` · `tab*` |
| 书籍封面 / 书卡 | 列表/网格封面 / 大封面横向书卡 | `bookCover*` · `bookGrid*` · `bookCardLarge*` |
| 福利页 | 头图 / 签到里程碑 / 任务时间线 / 充值弹窗 | `welfare*` · `rechargePurchaseDialog*` |
| 书架页 | 顶栏 / 阅读横幅 / 空状态 / 封面角标 | `bookshelf*` · `bookCoverTag*` |
| 我的页 | Hero / 头像 / 快捷入口 / 成就勋章 | `profile*` · `homeIndicator*` · `listRowMinHeight` |
| 我的-子页 | 账号设置 / 消息 / 卡包 | `accountSettings*` · `myMessages*` · `cardPack*` · 互动消息标识 `authorBadge*`（复用品牌黄）· 未读红点 `badgeCount`（复用 error 红）· 通知标识 `myMessagesNoticeBadge`（复用品牌橙）|
| 设置页 | Logo / 开关 `AppSwitch` | `settings*` · `appSwitch*` |
| 书籍详情页 | 头图 / 目录抽屉 / 角色卡 / 讨论区 / 更新时间线 | `bookDetail*` · `bookDiscussionDetail*` |
| 搜索页 | 顶栏返回 / 输入图标 / 空状态 | `searchAppBar*` · `searchInput*` · `searchEmpty*` |
| 会员页 | Hero 轮播 / 方案卡 / 权益宫格 / CTA / 特权详情 | `membership*` |
| 伙伴页 | 头部 / 角色卡 / 消息 Tab / 互动 Tab | `partner*` |
| 分类页 | 筛选组 / chip / 下划线 | `categoryFilter*` |
| 帮助与反馈 | Banner / 输入 / 上传框 | `helpFeedback*` |
| Toast / 交互阈值 | 轻提示内边距 / 滑动切换阈值 | `toast*` · `swipeTabVelocityThreshold` |

---

## 7. 组件规范（Component Spec）

> 说明：本节罗列**设计系统级组件**（L1 Primitive / L2 Composite）及其变体、尺寸、状态。所有组件底层只引用第 1–6 节 token；新增组件或变体需先向用户确认，并与本节 + 可视化 canvas 保持一致。分级定义见架构规则 §4。

### 7.1 Button · `AppButton`（L1 · `shared/widgets/app_button.dart`）

统一按钮，单一控件多变体。

**视觉变体（variant）· 外观与使用场景：**

| 变体 | 外观 | 使用场景 |
|------|------|----------|
| `accent` | 黄底（`accentYellow`）深字 · 胶囊 `full` | **深色页主 CTA**：阅读 / 确认 / 提交 / 领取 / 充值（最常用） |
| `secondary` | 4% 白底（`surfaceCard`）· 无描边 · 胶囊 `full` | 次操作 / 弱化 / 未激活态（重试默认、退出登录、验证码倒计时）·**默认变体** |
| `outline` | 透明底 + 细边框 · 胶囊 `full` | 对话框取消 · 轻量次要操作 |
| `vip` | 粉金渐变底（`vipGradientStart #FFDDC1` → `vipGradientEnd #F393DC`）+ 深粉字（`vipOnGradientText`）· 胶囊 `full` | VIP 领取 / 会员向操作（福利「VIP领取」等）|

**尺寸（size）· 内边距与使用场景：**

| 尺寸 | 内边距 (H×V) | 文字 | 使用场景 |
|------|-------------|------|----------|
| `normal` | 24 × 12 | 16 · bold | 页面 / 弹窗主按钮（默认） |
| `small` | 16 × 8 | 14 · medium | 卡片内 / 行内小操作（领取、去书城） |
| `compact` | 24 × 8 | 14 · medium | 紧凑行内操作（卡包页） |

**状态：** default · `isLoading`（转圈）· disabled（`onPressed==null`，前景 40%）· `isExpanded`（撑满宽度）。**可选：** `leadingIcon` 前置图标。描边一律 0.5px hairline。

### 7.2 Card · 卡片族

信息分组卡片底统一用 `surfaceCard`（white04）+ 圆角 `md`/`lg`；**禁止卡中卡**（架构 §3.3）。

| 组件 | 位置 | 变体 / 说明 |
|------|------|------|
| `BookCardVertical` | `shared/components/book_card_variants.dart` | 网格：上图下文 |
| `BookCardRankingCompact` | 同上 | 榜单紧凑：上图下文（封面 132:179） |
| `BookCardHorizontal` | 同上 | 榜单：左图右文（旧版保留供回滚） |
| `BookGridCard` / `BookListTile` / `BookCardLargeRow` | `shared/components/` | 网格卡 / 列表行 / 大图行（简介 2 行，简介+作者与封面底对齐）|
| `BookCoverTagBadge` | `shared/components/` | 封面角标 |
| `MyMessagesList` / `MyMessageItem` | `features/my_messages/presentation/components/` | 互动消息（回复/获赞）：头像 + 发信人（可带「作者」标）+ 时间 + 回复正文 + 引用书评（左竖条）+ 书籍引用块；条目间 `dividerOnDark` 细线分隔 |
| `MyNotificationsList` / `MyNotificationItem` | `features/my_messages/presentation/components/` | 通知卡片（客服/系统）：标题 + `NEW`/`未读`（橙 `myMessagesNoticeBadge`）标 + 内容 + 时间 + chevron；已读整条置灰 `myMessagesReadOpacity`；页脚「没有更多数据了」|
| `OnboardingProfileDialog` | `features/onboarding/presentation/pages/` | 新用户首页首启弹窗：性别 → 年龄两步**横向切换**（高度固定、底部分页器可回退，右上角统一 `DialogCloseButton` X，标题统一 `titleMedium`，底部固定「完成」）；性别圆形头像（选中彩色插画 + 黄色描边环、未选灰色插画 + 细描边，不填充底色，参照装扮选中）+ 文字标签（选中白、未选 60% 白）；年龄选中 `onboardingAgeSelected`(黄底深字) |

### 7.3 Dialog · 居中弹窗

统一入口，**所有居中弹窗必须走此入口**（架构 §3.2）。

| 项 | 值 |
|----|----|
| 入口 | `showAppBlurredDialog` / `showAppScrimDialog`（别名）· `shared/components/app_blurred_dialog.dart`；必填弹窗传 `barrierDismissible: false`（点遮罩不关闭，靠内部 CTA 完成）|
| 遮罩 | `overlayScrim80`（80% 纯黑，无背景模糊）|
| 弹窗底 | `dialogBackground` `#131820` |
| 圆角 | `xl`（24）|
| 关闭 | 点遮罩 / `DialogCloseButton`（弹窗**右上角** `close_rounded` X 图标，距顶/右 `lg`=24，见 §7.7）· 统一 `Navigator.pop` |
| 业务示例 | `EnergyRechargePurchaseDialog` / `WelfareRulesDialog` / `CheckInSuccessDialog`（L3） |

### 7.4 BottomSheet · 底部弹层

模式：`showModalBottomSheet`（`backgroundColor: transparent` + `isScrollControlled`）+ 顶部圆角 + `BackdropFilter` 玻璃 + `dialogBackground` 底 + `SafeArea(top: false)`。顶部圆角走 feature token（如 `partnerFilterSheet`）。

| 组件 | 位置 | 说明 |
|------|------|------|
| `PartnerFilterSheet` | `features/partner/.../partner_filter_sheet.dart` | 筛选弹层，粉色选中态（L3） |
| `BookDetailQuickReplySheet` | `features/book_detail/.../` | 快捷回复弹层（L3） |

> 目前尚无 `shared` 级 BottomSheet 封装；若第 3 处复用出现，应上提到 `shared/components`（架构 §8）。

### 7.5 AppBar · 顶栏 `AppTopBar`（L2 · `shared/components/app_top_bar.dart`）

三槽位（`leading` / `center` / `trailing`）组合出全部形态；页面级必须传 `statusBarHeight`（架构 §3.1）。

| 变体 | 组合 |
|------|------|
| 二级页 | `onBack` + `title` + `actions` |
| Tab 根页（居中 Tab） | `center: 自定义 Tab` + `trailing: 搜索按钮` |
| Tab 根页（左对齐 Tab） | `leading: 自定义 Tab` + `trailing: 搜索按钮` |

选项：`showScrim`（hero 沉浸渐变蒙版）/ `chromeBlurEnabled`（毛玻璃）/ `height` / `horizontalPadding`。配套：`AppTopBarIconButton`、`AppTopBarTextButton`、`AppBlurredChromeBar`。

### 7.6 TabBar · Tab 族

| 组件 | 位置 | 变体 / 说明 |
|------|------|------|
| `AppBottomNav` | `shared/layouts/app_bottom_nav.dart` | 底部 5 Tab；样式 `fullWidthSolid` / `glassCapsule` |
| `AppSegmentedSwitch` | `shared/components/app_segmented_switch.dart` | 玻璃分段 Tab，选中滑块动画（书架 / 详情内 Tab） |
| `ElasticTabIndicator` | `shared/components/elastic_tab_indicator.dart` | 横向黄色指示线，平移 + 宽度拉伸回弹（架构 §3.5） |
| `AppSwipeTabSwitcher` | `shared/components/app_swipe_tab_switcher.dart` | Tab 内容跟手左右切换（架构 §3.4） |
| `AppVerticalRailSwitch` | `shared/components/app_vertical_rail_switch.dart` | 竖向轨道切换 |
| `AppPageDots` | `shared/components/app_page_dots.dart` | 统一分页指示点：选中态白色加宽胶囊(`pageDotActiveWidth`)、未选白 20% 小圆点(`pageDotSize`)；传 `onDotTap` 可点跳转。会员轮播 / 新手引导步骤共用 |

### 7.7 其它通用组件

| 组件 | 位置 | 变体 / 说明 |
|------|------|------|
| `SectionHeader` | `shared/components/section_header.dart` | 区块标题 + 可选右侧操作链接 |
| `EmptyState` | `shared/components/empty_state.dart` | 空状态：`title` / `description` / `action` |
| `AppToast` | `shared/components/app_toast.dart` | 全局轻提示，黄底、淡入淡出自动消失 |
| `GlassChipButton` | `shared/components/glass_chip_button.dart` | 玻璃胶囊 / 搜索框容器；`blur` / `expanded` |
| `AppSwitch` | `shared/widgets/app_switch.dart` | 开关：on 品牌黄 4% 大色块底（`accentYellow04`）+ 黄色圆钮 / off 玻璃底 + 白钮 |
| `DialogCloseButton` | `shared/components/dialog_close_button.dart` | 统一居中弹窗关闭按钮：`close_rounded` X 图标（`textOnDarkMuted`）；`Positioned` 于卡片右上角，距顶/右 `lg`=24 |
| `SweepHighlightOverlay` | `shared/components/sweep_highlight_overlay.dart` | 扫光高亮层：高亮带循环滑过（会员/福利 CTA、签到成功 VIP 按钮统一复用）；参数 `highlightColor` / `edgeColor` / `bandWidthRatio` / `duration` |
| `AppGradientCtaButton` | `shared/components/app_gradient_cta_button.dart` | 渐变强动效 CTA：渐变底 + 呼吸缩放 + 循环扫光 + loading；固定高度。各处传入自己的渐变/高度/圆角/扫光色。`MembershipCtaButton` 委派于它;福利 padding 型 VIP 胶囊暂未纳入 |
| `CurrencyBalanceBar` / `RechargePackagesSection` / `VipPromoBanner` | `shared/components/` | 业务复用组合组件 |

### 7.8 Pressable · 通用按压反馈 `AppPressable`（L1 · `shared/widgets/app_pressable.dart`）

全局可点击模块统一的「按下—反弹」微交互包裹组件：点击时播放一段完整脚本动画——缩小（被按下）→ overshoot 反弹越过原尺寸 → 回落到原尺寸。**新的可点击基础组件应优先用它替代裸 `GestureDetector`**。

| 项 | 值 / 说明 |
|----|----------|
| 按下缩小 | `AppSizes.tapPressScale`（0.94）；全宽列表行等大面积模块用 `tapPressScaleSubtle`（0.97） |
| 反弹峰值 | `AppSizes.tapPressReboundScale`（1.05，overshoot 后回落到 1） |
| 缩小时长 | `AppDurations.tapPressDown`（70ms，`easeOut`） |
| 反弹时长 | `AppDurations.tapPressRebound`（170ms，`easeOut` 冲峰 + `easeInOut` 回落） |
| 动作延迟 | `AppDurations.tapPressActionDelay`（150ms）：点击后先播放「缩小 → 反弹峰值」，再触发 `onTap`（跳转会盖住其后的回落），保证「按下 → 弹起 → 跳转」可见 |
| 触发机制 | 由 `onTap` 驱动固定脚本动画（而非 `onTapDown/onTapUp`），避免可滚动列表中手势竞技场推迟 `onTapDown` 导致回弹几乎不可见 |
| 禁用态 | `onTap == null` 时不缩放、不响应 |
| 已接入 | `AppButton` + 书卡族 / 各列表行 / 图标按钮 / Tab / chip 等全局高频可点击模块（详见 §7 各组件） |

---

## 8. 使用约定

1. **UI 只用 token**：禁止 `Color(0x…)`、`fontSize: 数字`、`EdgeInsets(数字)`、`BorderRadius.circular(数字)`（仅 `lib/core/theme/` 内定义 token 本身可用字面量）。
2. **单一真源**：中性叠加色 → `AppColors` 白/黑阶；品牌与主题源色 → `AppBrandColors`；背景蒙版 → `bgTint` 阶；feature 色板只引用上述源色，不本地重定义。
3. **换色系**：在 `AppBrandColors` 按 `themeId` 加分支，构建时 `--dart-define=THEME=<id>`；默认不带参永远是深色，`dark` 分支源值不得改动。
4. **新增即询问**：任何超出本文档的新 token / 新值 / 新色系，先向用户说明并确认，再落地并更新本文档。

---

## 9. 动效与特殊设计索引（Motion & Special Design Index）

> 本节是全局自定义动效 / 特殊视觉的**导航索引**（约 50 项独立效果，分 9 类），便于按需定位真源。新增同类效果时在此登记。动效时长统一引用 `AppDurations`，缩放/模糊等参数引用 `AppSizes`。

### 9.1 点击按压微动效
- `AppPressable`（`shared/widgets/app_pressable.dart`）：全局「缩小 → overshoot 反弹 → 回落」点击脚本，已铺至 70+ 组件（详见 §7.8）。
- `AppButton` 按压：按钮变体继承按压回弹。
- 柔和按压：大目标（书卡 / 整行）用 `tapPressScaleSubtle`。
- 伙伴卡按下叠层 / chip / 行 / 头部按下态（`features/partner/presentation/components/*`）：按下变色（非缩放，保留自有反馈）。

### 9.2 弹性 / 回弹 / 物理
- `ElasticTabIndicator`（`shared/components/elastic_tab_indicator.dart`）：下划线平移 + 宽度拉伸回弹（架构 §3.5）；测量版见书架 / 装扮 Tab、分类筛选。
- 底部导航图标弹跳（`shared/widgets/app_nav_icon.dart`）：选中冲高 → 回落 → 稳定。
- 会员 Hero 橡皮筋回弹 + 插图弹入（`features/membership/presentation/components/membership_hero.dart`，`Curves.easeOutBack`）。
- 伙伴互动弹簧物理（`features/partner/presentation/components/partner_interaction_page_physics.dart`，`ScrollSpringSimulation`）：已接入 `partner_interaction_body.dart` 的 `PageView`，单次手势最多翻一页 + 弹簧回稳。

### 9.3 呼吸 / 循环 / 引导 / 加载
- `SweepHighlightOverlay`（`shared/components/sweep_highlight_overlay.dart`）：CTA 循环扫光。
- `AppGradientCtaButton`（`shared/components/app_gradient_cta_button.dart`）：共享渐变强动效 CTA（呼吸 + 扫光 + loading）；`MembershipCtaButton` 委派于它。福利签到 / VIP 领取等 padding 型渐变 CTA 仍为各自 L3 实现。
- 验证码光标闪烁（`features/auth/presentation/pages/login_page.dart`）。
- `AppConfetti`（`shared/components/app_confetti.dart`）：庆祝礼花迸发。
- `AppShimmer` + 书卡骨架（`shared/widgets/app_shimmer.dart`、`shared/components/book_card_skeletons.dart`）：加载时高光扫过骨架占位，替代整屏 spinner（榜单 / 分类 / 搜索 / 书架）。
- `AppLottie`（`shared/components/app_lottie.dart`）：Lottie 帧动画统一封装（基建就绪，资源放 `assets/lottie/`）。

### 9.4 着色器 / 自绘
- 极光 GLSL 背景（`shared/widgets/aurora_background.dart` + `assets/shaders/aurora.frag`）：噪声 + 三色渐变，`Ticker` 驱动 `uTime`，含降级渐变。
- 渐变描边 / 渐变文字（会员方案卡、Hero，`ShaderMask`）。
- 自绘：勾选标记（`shared/widgets/app_selection_mark.dart`）、福利气泡（`welfare_reward_bubble.dart`）、焦点封面裁剪（`shared/components/app_focal_cover_image.dart`）。

### 9.5 玻璃 / 模糊
- 统一入口与 chrome：`showAppBlurredDialog`、`AppBlurredChromeBar`、`AppTopBar`（scrim + blur）、滚动触发 `AppScrollBlurScope` / 吸顶 `BlurredPinnedHeaderDelegate`。
- 玻璃组件：`GlassChipButton`、`AppSegmentedSwitch`、`AppBottomNav`（glassCapsule）、`AppTopBarIconButton`、`CurrencyBalanceBar`、会员用户卡、书详情目录 chip、伙伴筛选弹层。
- 强模糊：福利任务叠层（`strongBlurSigma`）。
- 继续阅读浮条：页面背景色之上叠「放大封面」背景层（宽度撑满卡片、上下左右居中、半透明 `continueReadingBgImageOpacity` + 模糊 `continueReadingBgBlurSigma`），不同书籍呈现不同底纹。

### 9.6 页面转场 / 容器变换 / 共享元素
- `AdvancedTransitionWrapper`（`shared/widgets/advanced_transition_wrapper.dart`）：卡片 → 全屏 `OpenContainer` 变形（充值卡 → 详情）。
- 目录抽屉左侧滑入（`book_detail_catalog_drawer.dart`）。
- 会员权益 3D 卡片轮播（`membership_benefits_detail_page.dart`，`Matrix4.rotateY` 透视）。
- 书封 Hero 共享元素：`BookCover(heroTag:)` → 书详情头图（`book_detail_hero_cover.dart`）同 tag 飞行；仅在书 id 唯一的列表启用（榜单 / 搜索 / 分类 / 书架），详情页用入口封面即时渲染头图作落点。

### 9.7 Tab 跟手切换 / 滑块
- `AppSwipeTabSwitcher`（`shared/components/app_swipe_tab_switcher.dart`，架构 §3.4，8 页复用）。
- `AppSegmentedSwitch`（滑块 `AnimatedPositioned`）、`AppVerticalRailSwitch`（竖向轨道）、书城顶部 Tab PageView、会员 Hero 无限循环轮播。

### 9.8 滚动 / 沉浸式 Hero 头图
- `AppTopBar` 沉浸渐变蒙版 + 滚动起雾；会员 / 榜单 / 装扮 / 书详情沉浸顶（蒙版 + 模糊 + 装饰组合）。
- `OverscrollStretch`（`shared/widgets/overscroll_stretch.dart`）：下拉回弹时头图按 `heroParallaxFactor` 放大的视差 / 拉伸；已接入书详情头图与会员 Hero（需 `BouncingScrollPhysics`）。

### 9.9 其它自定义
- `AppToast`（淡入淡出）、`AppSwitch`（滑块过渡）、登录输入框聚焦下划线中心展开。
- `AnimatedCountText`（`shared/widgets/animated_count_text.dart`）：数值变化时从旧值滚动到新值（余额 / 钱包 / 星尘 / 阅读分钟）。
- `AppMarqueeText`（`shared/widgets/app_marquee_text.dart`）：文本溢出时横向循环滚动（「继续阅读」书名）。
- 倒计时：短信 / 福利任务 `HH:MM:SS`；续费提示 slot 交叉淡入 + 高度动画。
- 展开折叠 + 箭头旋转（签到 / 充值区）、「换一换」图标旋转、分页点 `AppPageDots`、`DialogCloseButton`、定制数字字体 `TCloudNumber`。

### 尚未实现（后续增强候选）
- **Lottie 具体动画**：基建（`lottie` 依赖 + `AppLottie` + `assets/lottie/`）已就绪，待放入 JSON 资源并在目标页接入。
- 已完成（本轮）：骨架屏 / shimmer、数字滚动、跑马灯、书封 `Hero()` 共享元素、头图滚动视差（书详情 + 会员）、伙伴弹簧物理接线。
