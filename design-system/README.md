# 点点穿书 · 设计系统（Design System · 唯一权威）

> 可视化版见同目录 [`design-system-spec.canvas.tsx`](./design-system-spec.canvas.tsx)（源文件，随仓库版本管理）；
> 实时渲染预览在 Cursor canvases 目录（托管目录才会渲染）。本 `README.md` 为文本权威基线，二者内容需保持一致，以本文件为准。

> 本文件是设计 token 的**唯一权威基线**。所有 UI 一律引用 token，禁止写死数值。
> 代码实现见 `lib/core/theme/*.dart`，二者必须一致。
>
> **治理规则（强制）**
> 1. 每次改动涉及颜色 / 字号 / 行高 / 字重 / 间距 / 圆角时，**先对照本文档**。
> 2. **严禁擅自新增或修改 token / 档位 / 规范。** 若确需超出本规范（新增字号档、新颜色、新圆角值、新间距值、新主题色系等），**必须先向用户说明用途与建议值，取得确认后**才能落地，并**同步更新本文档**。
> 3. 收敛/去重（把重复字面量指向已有 token、值不变）不算新增，可直接做。
> 4. 换色系走 `--dart-define=THEME=<id>`；默认（不带参）永远是深色，不得改动 `yellow_dark` 分支源值。

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

## 3.6 文字样式层级 · AppTextStyles（何时用一级 / 二级标题）

> 研发直接**按"角色"对号入座**选用语义样式，不要自己拼 `fontSize` / `fontWeight`。真源 [app_text_styles.dart](../lib/core/theme/app_text_styles.dart)；颜色随主题自动翻转（`AppColors`），页面只引用样式名。层级从上到下由强到弱。

| 角色 | 样式 token | 字号 | 字重 | 行高 | 默认色 | 使用场景 / 示例 |
|------|-----------|------|------|------|--------|----------------|
| 展示级 / Hero | `displayLarge` | 32 | bold | tight | `textPrimary` | 展示级超大数值 / Hero 主视觉数字（会员价格、头图大数） |
| 展示级（单行） | `displaySm` | 24 | bold | none | `textPrimary` | 单行大数值（余额、计数），不折行 |
| 大标题 | `headlineMedium` | 24 | semibold | tight | `textPrimary` | 页面大标题 / 关键数值 |
| **一级标题**（页面 / 区块标题） | `titleMedium` | 18 | semibold | normal | `textPrimary` | 页面标题、section 标题、弹窗标题（最常用的"标题"） |
| **二级标题** / 卡片小标题 | `bodyLarge` | 16 | regular | normal | `textPrimary` | 卡片标题、小标题、需强调的正文（一级文字色） |
| 正文（主力） | `bodyMedium` | 14 | regular | normal | `textSecondary` | 正文段落、说明、次级文案（次级文字色） |
| 标签 | `labelMedium` | 12 | medium | normal | `textSecondary` | 标签、选中态 tab、列表次要信息 |
| 说明 | `captionMd` | 12 | medium | none | `textSecondary` | 次要说明 / 元信息（单行） |
| 小角标 | `captionSm` | 10 | medium | none | `textSecondary` | 小标签 / 角标 |
| 极小角标 | `captionMicro` | 9 | medium | none | `textSecondary` | 极小角标 |
| 按钮文案 | `buttonLabel14` / `buttonLabel16` | 14 / 16 | bold | none | 随按钮变体前景 | 按钮标签（`AppButton`，尺寸决定 14/16） |

**用法要点：**

- **选标题**：页面 / 区块 / 弹窗标题一律用 `titleMedium`（一级）；标题下的卡片小标题或需要强调的正文用 `bodyLarge`（二级）。
- **选正文**：正文默认 `bodyMedium`（次级色）；需要一级文字色的正文用 `bodyLarge`。
- **`*Dark` 派生**（`titleMediumDark` / `bodyMediumDark` / `sectionTitleDark` 等）：是上述**同级样式**经 `copyWith` 换深色页专用文字色的派生，**不新增层级**；深浅主题下颜色自动适配。
- **禁止**：页面 / 组件写死 `fontSize` / `fontWeight`，一律引用本表样式名。

---

## 4. 颜色

> **三层色板架构**：① **原色层 `AppPalette`**（§4.1，唯一 `Color(0x…)` 出处，无语义、不分主题）→ ② **语义层 `AppColors` / `AppBrandColors`**（§4.2，给原色起语义名 + 按 `themeId` 选深/浅、做中性翻转）→ ③ **组件层**（§4.3，组件只用语义名，不碰原色、不写死色值）。深/浅主题都从同一 `AppPalette` 取原色，换主题不改任何调用点。

### 4.1 原色层 · AppPalette（Tier 1 · 唯一原色真源，`lib/core/theme/app_palette.dart`）

全项目唯一允许 `Color(0x…)` 字面量的地方；只放原色、无语义、不分主题。新增原色必须登记此处。组件底色 / 文本 / 描边优先使用实体中性色；白/黑透明阶仅作为 effect / overlay / mask 原语保留。

#### 4.1.1 实体 / 品牌 / 状态原色一览

| 分组 | 原色（AppPalette 名 → hex） |
|------|------|
| 深色实体 | `neutralWhite #FFFFFF` · `neutralCool400 #9AA0AA` · `neutralCool500 #737B86` · `neutralCool900 #151B24` · `neutralCool920 #111722` · `neutralCool800 #252B34` · `neutralCool820 #232A33` |
| 浅色实体 | `neutralBlue950 #1A1A2E` · `neutralCool600 #6B7280` · `neutralGray400 #9B9B9B` · `neutralCool100 #F3F4F6` · `neutralCool200 #E5E7EB` · `pink75 #F8E6ED` · `neutralCool50 #F8F7FC` |
| 透明效果原语 | `whiteAlpha100…whiteAlpha00` / `blackAlpha80…blackAlpha00`（主要用于遮罩、蒙版、扫光、渐隐等 effect；不作为组件底色 / 文本色库。**例外**：深色态弱描边 `borderSubtle` 取 `whiteAlpha04`（4% 白），见 §4.2） |
| 壳基色 · 深 | `neutralCool950 #090E17` + `neutralCool950Alpha00` / `neutralCool950Alpha35` / `neutralCool950Alpha45` / `neutralCool950Alpha55` / `neutralCool950Alpha60` / `neutralCool950Alpha80` / `neutralCool950Alpha90` |
| 壳基色 · 粉浅 | `pink50 #F4F2F4` + `pink50Alpha00` / `pink50Alpha35` / `pink50Alpha45` / `pink50Alpha55` / `pink50Alpha60` / `pink50Alpha80` / `pink50Alpha90` |
| 壳基色 · 黄浅 | `neutralCool50 #F8F7FC` + `neutralCool50Alpha00` / `neutralCool50Alpha35` / `neutralCool50Alpha45` / `neutralCool50Alpha55` / `neutralCool50Alpha60` / `neutralCool50Alpha80` / `neutralCool50Alpha90`（`yellow_light` 页面大背景，中性浅灰、不偏黄） |
| 深壳装饰 | `cream100 #FFF2C6` · `wine950 #1D0B10` · `neutralCool880 #131820` · `neutralCool800 #262B33` |
| 主强调 | `yellow500 #FFE847`（+ `yellow500Alpha04`/`yellow500Alpha08`/`yellow500Alpha40`）· `pink500 #FF4D88`（+ `pink500Alpha04`/`pink500Alpha08`/`pink500Alpha40`） |
| 面板深字/灰 | `neutralWarm900 #202020` · `neutralGray500 #919191` · `neutralGray600 #8C8C8C` · `neutralCool300 #B2B3BA` · `neutralCool350 #ABACB3` · `neutralGray700 #757575` |
| VIP 粉紫 | `peach100 #FFDDC1` · `pink300 #F393DC` · `magenta950 #740551` · `peach50 #FFEBD4` · `pink100Soft #FFD5DB` · `pink200 #FF9CC7` · `magenta500 #E541BC` · `magenta980 #310F29` |
| 伙伴粉 | 主色 = `pink500` · `pink400 #FF7AA8` · `pink600 #E03D74` |
| 福利金/橙 | `brown600 #935C1A` · `brown500 #AA722E` · `brown800 #5D3A12` · `orange500 #FF7E32` |
| 促销条 | `rose500/orange550/orange300/cream50/orange700`（值见 §4.2.2） |
| 榜单头图 | `cream200 #FFFAD7` · `cream200Alpha90 #E6FFFAD7` |
| 书详情更新 | `tan400 #F0B16A` |
| 语义状态 | `green500 #39D98A` · `amber500 #FFA940` · `rose400 #FF667F` · `red400 #FF6B6B` · `cream10 #FFFEF4` |
| 蓝色预设 | `neutralCool960 #0A1628` · `blue500 #4DA6FF`（礼花粒子 / 休眠 `AppColorScheme.brandBlue`） |
| v1.0 扩展 | `gold400 #F9C74F` · `sky500 #59AEFF` · `purple400 #9C87FF` · `cyan400 #42DDFF` · `indigo400 #7E95FF` |

> 上层映射：`AppBrandColors.partnerPrimary = pink500`、`primary = pink_light ? pink500 : yellow500`（`yellow_dark`/`yellow_light` 同走黄）、`textPrimary = isLightExperiment ? neutralBlue950 : neutralWhite`、`surface = isLightExperiment ? neutralWhite : neutralCool900` … 语义名与调用点全部不变，仅底层改为引用 `AppPalette`。§A 分「中性外壳」（按 `isLightExperiment` 翻转，`pink_light`/`yellow_light` 共用）与「强调身份」（`accent`/`onAccent`/`accentSoft04/08`/`accentDisabledFill`/`lightCardBorder`，按 `themeId==pink_light` 选粉 vs 黄）。
>
> 语义别名（值不变，收敛登记补全）：`white00` / `white04` / `white05` / `white06` / `white08` / `white20` / `white24` / `white30` / `white50` / `white60` / `white85` / `white100` / `black00` / `black04` / `black08` / `black30` / `black40` / `black60` / `black80` / `background` / `backgroundLight` / `surface` / `border` / `divider` / `textSecondary` / `textOnPrimary` / `primary` / `primarySoft` / `accentYellow` / `accentYellow04` / `navActiveText` / `sectionActionIcon` / `navActiveBackground` / `auroraGlow` / `auroraEdge` / `originalPriceMuted` / `planOriginalPrice` / `subtitleMuted` / `hotSaleBadge` / `hotSaleBadgeText` / `vipCtaGradientStart` / `vipCtaGradientEnd` / `vipCtaBorder` / `vipSelectedBorder` / `vipBannerText` / `brandBlueBackground` / `brandBlueAccent` 均为上述 `AppPalette` 原色的语义命名。

#### 4.1.2 透明效果原语 · 白阶（`whiteAlphaNN`，ARGB 原值）

> 主要用于扫光、高光、图片蒙版、渐隐等 effect；组件底色 / 文本不得直接以 `whiteAlphaNN` 作为设计依据，应使用 §4.2 语义 token。描边**唯一例外**：深色态 `borderSubtle` = `whiteAlpha04`（全局边框源），组件仍引用语义名 `borderSubtle` / `borderGlass`，不直接写 `whiteAlpha04`。

| Token | 不透明度 | ARGB | 典型用途 |
|-------|------|------|----|
| `whiteAlpha100` | 100% | `0xFFFFFFFF` | 白色实底 / 图上白字 / 蒙版不透明端 |
| `whiteAlpha85` | 85% | `0xD9FFFFFF` | 图上次强调（effect） |
| `whiteAlpha60` | 60% | `0x99FFFFFF` | 图上弱提示 / icon 叠加（effect） |
| `whiteAlpha50` | 50% | `0x80FFFFFF` | 扫光高亮 |
| `whiteAlpha24` | 24% | `0x3DFFFFFF` | 头图蒙版软档 |
| `whiteAlpha30` | 30% | `0x4DFFFFFF` | 弱化叠加（effect） |
| `whiteAlpha20` | 20% | `0x33FFFFFF` | 亮色叠加 / 图片线（effect） |
| `whiteAlpha08` | 8% | `0x14FFFFFF` | shimmer 底等微弱高光 |
| `whiteAlpha06` | 6% | `0x0FFFFFFF` | 低透明叠加（effect） |
| `whiteAlpha05` | 5% | `0x0DFFFFFF` | 低透明叠加（effect） |
| `whiteAlpha04` | 4% | `0x0AFFFFFF` | 深色态全局弱描边（`borderSubtle`）· 低透明叠加（effect） |
| `whiteAlpha00` | 0% | `0x00FFFFFF` | 渐变透明端 |

#### 4.1.3 透明效果原语 · 黑阶（`blackAlphaNN`，遮罩 / 蒙版）

> 仅用于弹窗遮罩、封面/头图遮罩、图上文字保底、渐隐等 effect；组件底色 / 文本 / 描边不得直接以 `blackAlphaNN` 作为设计依据。

| Token | 不透明度 | ARGB | 用途 |
|-------|------|------|----|
| `blackAlpha80` | 80% | `0xCC000000` | 居中弹窗遮罩（80% 纯黑，无模糊）|
| `blackAlpha60` | 60% | `0x99000000` | 封面选择遮罩；榜单名次角标底（语义别名 `rankingMutedBadgeScrim`，第 4 名起，20px，左上角 `bookCover` + 右下角 `md` 圆角，保证白色数字清晰）|
| `blackAlpha40` | 40% | `0x66000000` | 选中态封面遮罩 |
| `blackAlpha30` | 30% | `0x4D000000` | 通用遮罩 `overlayScrim` |
| `blackAlpha08` | 8% | `0x14000000` | 8% 黑（备用）|
| `blackAlpha04` | 4% | `0x0A000000` | 封面描边 / 签到底 |
| `blackAlpha00` | 0% | `0x00000000` | 渐变透明端 |

### 4.2 语义层 · AppColors / AppBrandColors（Tier 2 · 引用原色 + 按 `themeId` 选深/浅）

给 §4.1 原色起全局语义名，并按主题选深/浅、做中性翻转；页面只用这里的语义名。

#### 4.2.0 核心语义 token（跨组件复用职责）

| 语义 token | yellow_dark 解析 | pink_light 解析 | yellow_light 解析 | 职责 |
|------|------|------|------|------|
| `primary` | `#FFE847` | `#FF4D88` | `#FFE847` | 主强调 |
| `onPrimary` | `#090E17` | `#FFFFFF` | `#090E17` | 主强调色面上的文字 / 图标（跟随强调色：黄底深墨、粉底白） |
| `background` | `#090E17` | `#F4F2F4` | `#F8F7FC` | 页面背景 |
| `surface` | `#151B24` | `#FFFFFF` | `#FFFFFF` | 普通容器面 |
| `surfaceSoft` | `#111722` | `#F8F7FC` | `#F8F7FC` | 弱容器面 |
| `surfaceElevated` | `#131820` | `#FFFFFF` | `#FFFFFF` | 浮层 / 弹窗面 |
| `textPrimary` | `#FFFFFF` | `#1A1A2E` | `#1A1A2E` | 一级文字 |
| `textSecondary` | `#9AA0AA` | `#6B7280` | `#6B7280` | 二级文字 |
| `textTertiary` | `#737B86` | `#9B9B9B` | `#9B9B9B` | 三级文字 / 占位 |
| `borderSubtle` | `whiteAlpha04`（4% 白 `0x0AFFFFFF`） | `#F8E6ED` | `#E5E7EB` | 弱描边（深色态全局边框；黄色浅色态用中性浅灰） |
| `divider` | `#232A33` | `#F3F4F6` | `#F3F4F6` | 分割线 |
| `overlayScrim80` | `blackAlpha80` | `blackAlpha80` | `blackAlpha80` | 弹窗遮罩 |

#### 4.2.1 主题壳 tint 阶 & 毛玻璃 scrim（`AppColors.bgTintNN`，随 THEME）

基于基础背景 `#090E17` 的不同透明度，用于渐隐 / 毛玻璃底 / 头图蒙版；换色系时整条随基础背景色相变化。

`bgTint00 · bgTint35 · bgTint45 · bgTint55 · bgTint60 · bgTint80 · bgTint90`

语义引用：`chromeBarScrim = bgTint80`，`bottomNavScrim`（深 `backgroundDark` 不透明 / 浅 `white100` 纯白不透明），`bottomNavTextureScrim = bgTint60`（预留：纹理需透出时叠色，当前底栏默认用不透明 `bottomNavScrim` 盖住纹理），`topChromeBarScrolledScrim`（深 `bgTint80` / 浅 `white100` 纯白），用于压实全局毛玻璃、减少下方内容透出。浅色态底部导航与 `AppPageChrome` 顶栏为纯白实心底、**无 backdrop blur**；书详情顶栏走 `chromeBarScrim`，保持磨砂。`AppBottomNav` 铺 `AppThemeAssets.bottomNavTexture`（可选）+ 不透明 `bottomNavScrim`。

#### 4.2.2 主题壳 / 品牌语义名（`AppBrandColors`）

| Token | Hex | 角色 |
|-------|-----|----|
| `backgroundDark` | `#090E17` | 全局背景（主题源色） |
| `accent` | `#FFE847` | 主强调色（黄）· 深色页主 CTA · 点赞 / 互动选中 |
| `cream100` | `#FFF2C6` | 极光渐变亮核（暖米金） |
| `wine950` | `#1D0B10` | 极光渐变暗边（暗红近黑） |
| `dialogBackground` | `#131820` | 弹窗底 |
| `surfaceMuted` | `#262B33` | 深青灰实心浮层 / 卡片底（如「继续阅读」浮层） |
| `success` | `#39D98A`（green500） | 成功（Design Token v1.0） |
| `warning` | `#FFA940`（amber500） | 警告（Design Token v1.0） |
| `error` | `#FF667F`（rose400） | 错误（Design Token v1.0） |
| `premiumGold` | `#F9C74F`（gold400） | VIP 会员金主题（v1.0 新增，暂未接入页面） |
| `info` | `#59AEFF`（sky500） | 信息 / 提示（v1.0 新增，暂未接入页面） |
| `fantasyPurple` | `#9C87FF`（purple400） | 奇幻紫（v1.0 新增，暂未接入页面） |
| `energyCyan` | `#42DDFF`（cyan400） | 能量青（v1.0 新增，暂未接入页面） |
| `growthBlue` | `#7E95FF`（indigo400） | 成长蓝（v1.0 新增，暂未接入页面） |

> 说明：黄（`accent`）为深色页唯一主强调 —— 主 CTA、点赞、互动选中等强调态统一用黄。原紫色 `primary`（#6B4EFF）已全局移除。

feature 品牌色（均定义于 `AppBrandColors`，被各 feature 色板引用）：

- 福利金：`goldMedium #935C1A` / `goldDark #AA722E` / `goldText #5D3A12` / `checkInYellow = primary #FFE847` / `checkInHighlightHeader = primary #FFE847` / `accentOrange #FF7E32`
- 会员金渐变：`ctaGradientStart #FFE794` / `ctaGradientEnd #FFCD5A`（会员 CTA + 方案选中态）
- VIP 粉紫：`vipGradientStart #FFDDC1` / `vipGradientEnd #F393DC` / `vipOnGradientText #740551`
- 伙伴粉：`partnerPrimary #FF4D88` / `partnerPrimaryLight #FF7AA8` / `partnerPrimaryDark #E03D74`
- 面板深字：`textOnLightPanel #202020`（浅色/金色面板上的深色文字）
- 中性图标灰：`iconMuted #B2B3BA` / `iconMutedSecondary #ABACB3`（弱化图标默认灰 / 次级灰）
- 榜单头图：`rankingHeroTitle #FFFAD7`（头图标题米白）
- 书籍详情悬浮促销条（Figma 1598:4319）：条底暖渐变 `promoBarGradientStart #FF4E6C` / `promoBarGradientMid #FF6F4B` / `promoBarGradientEnd #FF9359` · 副标题 `promoSubtitle #FFF9F2` · `+N` 能量角标字 `promoRewardText #E64D00`（「立即领取」按钮为切图 `assets/images/book_detail/promo_claim_button.png`，叠加统一扫光 + 呼吸动效，见 §9.1/§9.3）

#### 4.2.3 编译期实验包 · §A 壳源色覆盖（`--dart-define=THEME=<id>`）

多风格小流量实验用**编译期整包换皮**，只覆盖「§A 主题壳源色」，其余 §B 品牌色恒定；**不提供用户运行时切换**。默认（不带参）永远是 `yellow_dark`，其源值不得改动。机制与加包步骤见 §8.3 与 `app_brand_colors.dart` 文件头配方。各 token 在 yellow_dark / pink_light / yellow_light 下的解析对照，可视化见 `design-system-spec.canvas.tsx` 的「多风格」tab（04）。

| THEME | backgroundDark | accent | bgTint 基色 | aurora/dialog/surfaceMuted | 备注 |
|-------|----------------|--------|------------|----------------------------|------|
| `yellow_dark`（默认） | `#090E17` | `#FFE847`（黄） | `#090E17` | 见 §4.2.2 | 默认深色壳，源值锁定 |
| `pink_light` | `#F4F2F4`（浅灰粉） | `#FF4D88`（玫粉，复用 `partnerPrimary`） | `#F4F2F4`（同基色标准透明度阶） | dialog/浮层 `#FFFFFF`；壳文字深墨 `#1A1A2E` | 粉色浅色系；需 §4.2.4 中性翻转层 |
| `yellow_light` | `#F8F7FC`（`neutralCool50` 中性浅灰） | `#FFE847`（黄，复用深色主强调） | `#F8F7FC`（`neutralCool50Alpha*` 阶） | dialog/浮层 `#FFFFFF`；壳文字深墨 `#1A1A2E` | 黄色浅色系；壳背景中性浅灰（不偏黄），强调身份为黄；卡片细描边 `borderSubtle` 中性浅灰 `#E5E7EB` |

> 实现命名：§A 分「中性外壳」（`backgroundDark`/`bgTint*`：`pink_light`→`pink50`、`yellow_light`→`neutralCool50`；`dialogBackground`/`textOnDark`/`surfaceMuted` 两浅色包仍共用）与「强调身份」（`accent`/`onAccent`/`accentSoft04/08`/`accentDisabledFill`/`lightCardBorder`，按 `themeId==pink_light` 选粉 vs 黄，`yellow_dark`/`yellow_light` 同走黄），集中在 `app_brand_colors.dart` §A。

#### 4.2.4 浅色实验包 · 中性翻转层 + 强调身份层（`_isLight` / `isLightExperiment`）

深色态组件底色与文本用实体中性色（`neutralCool900` / `neutralCool820` / `neutralWhite` / `neutralCool400/500`）承载；**描边例外**：深色态全局边框（`borderSubtle` / `borderGlass` / `topBarIconFrameBorder` / `guessLikeTagBorder`）统一取 `whiteAlpha04`（4% 白），随底自然融合。**磨砂玻璃底例外**：顶栏圆形图标框 `topBarIconFrameBackground` 取纯白半透明（深色态 `whiteAlpha04` 4%；浅色态头图偏亮，提高到 `whiteAlpha30` 30%），配 `BackdropFilter` 呈磨砂玻璃。其余白/黑透明阶仅用于 effect / overlay / mask。浅色实验包（`pink_light` / `yellow_light`；页面壳背景 `pink_light`=`pink50`、`yellow_light`=`neutralCool50`）在 `AppColors` 用 `_isLight`（源 `AppBrandColors.isLightExperiment = pink_light || yellow_light`）把以下**中性**语义 token 翻到浅底取值。

**中性翻转（按 `_isLight`，两浅色包一致）：**
- **文字**：`textPrimary`→`#1A1A2E` / `textSecondary`→`#6B7280` / `textTertiary`→`#9B9B9B`；兼容别名 `textOnDark*` 随这些语义一起翻转。
- **中性面/描边**：`surface`→`#FFFFFF`；`divider`→`#F3F4F6`；`borderSubtle`→ `lightCardBorder`（`pink_light` 浅粉 `#F8E6ED` / `yellow_light` 中性浅灰 `#E5E7EB`）；深色态 `surface` / `divider` 对应 `neutralCool900` / `neutralCool820` 实体中性色，`borderSubtle` 深色态取 `whiteAlpha04`（4% 白）。兼容别名 `surfaceCard` / `surfaceGlass` / `borderGlass` / `dividerOnDark` 指向这些核心语义。
- **双职责拆分（图上遮罩恒暗）**：`rankingHeroScrimTop`/`rankingHeroScrimMid`/`searchStatusBadgeBackground` 深色随主题壳基色渐隐；浅色态改用 `blackAlphaNN`，保证头图/封面上的白色文字仍可读（不随浅背景变浅）。「背景渐隐 / 毛玻璃底」类（`chromeBarScrim`/`gradientFade*` 等）仍走 §A `bgTint`，跟随浅色。

**强调身份（跟随强调色而非 `_isLight`；按 `themeId==pink_light` 选粉 vs 黄，`yellow_dark`/`yellow_light` 同走黄）：**
- **primary 上的文字/图标**：核心语义 token `onPrimary`（= `AppBrandColors.onAccent`）——黄底（`yellow_dark`/`yellow_light`）深墨 `#090E17`、粉底（`pink_light`）白 `#FFFFFF`。**修复要点**：不再按 `_isLight` 固定白字，避免 `yellow_light` 亮黄底上白字不可读。`onAccent` 为兼容别名。
- **primary 派生填充**：`primarySoft`（4%）= `accentSoft04`、`segmentedSelectedFill`（8%）= `accentSoft08`——`pink_light` 玫粉叠加（`0x0AFF4D88` / `0x14FF4D88`），`yellow_dark`/`yellow_light` 品牌黄叠加（`0x0AFFE847` / `0x14FFE847`）。
- **按钮禁用底**：`buttonDisabledFill` 深色态弱实体面（`_darkSurface`），浅色态 = `accentDisabledFill`（`pink_light` 玫粉 40% `0x66FF4D88` / `yellow_light` 黄 40% `0x66FFE847`）+ 85% 白字。
- **选中胶囊**：`discussionFilterSelectedBackground` 深色态白 `#FFFFFF`，浅色态翻为 primary 胶囊（`pink_light` 玫粉 / `yellow_light` 黄）+ `onPrimary` 文字。
- **底部导航**：选中 / 未选图标均为主题完整色稿（`AppThemeAssets.nav*`，按 `THEME` 选 `assets/icons/nav/<themeId>/`），**不再** `srcIn` 运行时着色；选中标签用 `textPrimary`（浅色主题深墨 `#1A1A2E`、`yellow_dark` 纯白），未选标签 `iconMutedSecondary` 中性灰；`aurora` 背景默认走 `primary`。
- **主 CTA 文字**：`AppButton` 的 `accent` 变体前景随 `onPrimary`——黄底（`yellow_dark`/`yellow_light`）深字、粉底（`pink_light`）白字。
- **系统状态栏**：`AppTheme.systemUiOverlayStyle` 深色态白图标（`_darkOverlayStyle`），浅色实验态深图标（`_lightOverlayStyle`，`statusBarIconBrightness: Brightness.dark`），保证浅底上时间/信号/电量可读。
- **系统键盘**：应用及全部预览入口统一使用 `AppTheme.current`；`pink_light` / `yellow_light` 输出 `Brightness.light`，所有系统输入法随 `TextField` 继承浅色外观；`yellow_dark` 保持 `Brightness.dark` 深色键盘。
- **主题资源例外（用户指定）**：`AppThemeAssets.authLoginTopBg` 仅在 `yellow_light` 下解析为 `assets/images/profile/yellow_light/hero_background_default.png`；`pink_light` / `yellow_dark` 继续解析为 `assets/images/auth/<themeId>/login_top_bg.png`，不得随浅黄切图一并替换。

> 新增色值：`yellow500Alpha40 = 0x66FFE847`（`yellow_light` 按钮禁用底）；`yellow_light` 的浅色外壳全部复用 `pink_light` 既有源色（背景 `#F4F2F4`、白面板 `#FFFFFF`），卡片描边复用中性 `neutralCool200 #E5E7EB`。翻转/身份开关命名前缀：`_isLight` / `isLightExperiment` / `_ink*` / `_light*` / `_dark*` / `onAccent` / `accentSoft*` / `accentDisabledFill` / `lightCardBorder`。v1 已知未覆盖（后续视觉走查）：极光片元着色器如需浅色专属配色、少量 `whiteAlphaNN` 渐变遮罩/CTA 扫光（本为图/CTA 上光效，保留白色）。

#### 4.2.5 feature 语义色 token（引用原色，值不变为主）

各 feature 色板（`app_welfare_colors.dart` / `app_membership_colors.dart` / `app_colors.dart`）在源色之上派生的语义 token；除少量透明度变体外均为对源色的别名（收敛去重）。

> **福利页浅色翻转（`app_welfare_colors.dart`）**：福利页签到 / 任务区原先把 `whiteNN`（白透明叠加）与个别深色 `Color(0x…)` 直接用作**面 / 描边 / 文字 / 里程碑圆点**，浅色实验包（`pink_light`）下不翻转会「白底看不见、深点变黑块、白字消失」。已按 `_isLight`（`AppBrandColors.isLightExperiment`）分支：**深色分支保持原值不变**，浅色分支翻到已有实体语义 token —— 面 `checkInDayBg/…Header/taskActionBg/taskRewardChipBg/taskTimelineBubbleReached/checkInProgressTrack/taskTimelineTrack → surfaceSoft`（轨道/分割类 → `divider`）、描边 `checkInDayBorder → borderSubtle`、圆点 `checkInProgressDot*/taskTimelineDot* → border/divider`、文字 `checkInDayLabelMuted/checkInMilestoneLabel/taskRewardChipMutedText/taskProgressLabel → textSecondary`、`checkInMilestoneAmount/taskRewardChipText → textPrimary`。`rechargePriceBg` 与 `sectionMoreActionBackground` 同为 `blackAlpha04` 全主题统一（价格胶囊 / 「免费领」/ 「更多福利」）。未引入新色值。
>
> **主色上的文字/图标必须走 `onPrimary`（强制）**：坐在 `primary`/`accent` 面上的文字与图标一律用 `onPrimary`（深色黄底 → 深墨、浅色粉底 → 白），**禁止**用 `textOnLightPanel`（那是「浅色/金色面板上的深字」，仅用于恒定浅/金底，不随主强调翻转）。福利页已修：今日签到卡头 `checkInTodayHeaderText`、签到 CTA 文字/spinner `checkInCtaTextDark`、任务高亮按钮文字 `taskActionHighlightText` 三处 `_isLight ? onPrimary : textOnLightPanel`（深色不变、浅色翻白）；福利任务主操作按钮前置图标 `WelfareTaskActionButton` 直接用 `onPrimary` 与 `AppButton` 前景一致。

| Token | 值 | 用途 |
|-------|----|----|
| `checkInHighlightSurface` / `checkInHighlightBg` | `yellow500Alpha08`（8% primary） | 今日签到高亮卡底 |
| `checkInHighlightHeader` | `primary #FFE847` | 今日签到高亮头 |
| `checkInHighlightBorder` | `primary #FFE847`（checkInHighlightHeader） | 高亮卡描边 |
| `checkInRewardTodayText` | `primary #FFE847` | 今日奖励文字 |
| `checkInDayBg` | 深色 `whiteAlpha04` / 浅色 `surfaceSoft`（`_isLight` 翻转，浅底可见实体面） | 普通签到日底 / 里程碑气泡底 / 累计卡底 |
| `checkInCumulativeBg` | `yellow500Alpha08`（8% primary） | 累计签到徽章底 |
| `checkInCumulativeBorder` | `whiteAlpha00`（透明） | 累计徽章描边 |
| `checkInMilestoneAmount` | 深色 `whiteAlpha100` / 浅色 `textPrimary`（`_isLight` 翻转，浅底墨字可读） | 里程碑数值 |
| `planSelectedBg` | `0x14FFE794`（8% 会员金） | 会员方案选中卡底 |
| `planSelectedBorder` | `#FFE794`（ctaGradientStart） | 会员方案选中描边 |
| `planSelectedGoldStart` | `#FFE794`（ctaGradientStart） | 选中金渐变起 |
| `planSelectedGoldEnd` | `#FFCD5A`（ctaGradientEnd） | 选中金渐变止 |
| `planSelectedSecondary` | 深 `whiteAlpha60` / 浅 `textSecondary`（`_isLight` 翻转） | 选中卡次要文字 |
| `planSelectedFooterText` | `#202020`（textOnLightPanel） | 选中卡脚文字 |
| `searchHotAccent` | `#FF7E32`（accentOrange） | 搜索热词强调 |
| `bookDetailUpdateHighlight` | `#F0B16A` | 书详情「更新」高亮：日期 / 时间轴圆点边 / 文字（`...Highlighted` 别名均指向它） |
| `rankingSegmentedSelectedText` | `#202020`（textOnLightPanel） | 榜单分段控件选中字 |
| `segmentedSelectedBorder` | `whiteAlpha00`（透明） | 分段控件选中态**去描边**（全局统一，仅靠 `segmentedSelectedFill` + 黄字区分） |
| `bookDetailPromoGradientStart/Mid/End` | `#FF4E6C` / `#FF6F4B` / `#FF9359` | 悬浮促销条底暖渐变（约 94°，stops 0.11/0.46/0.99） |
| `bookDetailPromoTitle` | `whiteAlpha100` | 促销条主标题 |
| `bookDetailPromoSubtitle` | `#FFF9F2`（cream50） | 促销条副标题 |
| `bookDetailPromoRewardText` | `#E64D00`（orange700Text） | `+N` 能量角标文字（「立即领取」按钮为切图，见 §4.2.2 说明） |
| `bookDetailPromoCloseIcon` | `whiteAlpha100` | 促销条关闭 X |
| `discussionFilterUnselectedText` | `textTertiary` | 书详情讨论筛选未选中文字 |
| `discussionItemReplyBackground` | `surfaceSoft`（深 `neutralCool920` / 浅 `neutralCool50`） | 书详情讨论回复摘要底 |
| `discussionLikeIcon` | `textTertiary` | 书详情讨论点赞图标默认色 |
| `guessLikeCardBackground` | `_isLight ? surface : surfaceSoft`（深 `neutralCool920` / 浅 `neutralWhite` 纯白实体） | 猜你喜欢卡片底 |
| `guessLikeTagBackground` | `surface`（深 `neutralCool900` / 浅 `neutralWhite`） | 猜你喜欢标签底 |
| `guessLikeTagBorder` | `borderSubtle`（深 `whiteAlpha04` / 浅 `pink75`） | 猜你喜欢标签描边 |
| `bookCoverTagCompletedScrim` | `blackAlpha60`（恒暗，压在封面上） | 封面角标「完结/连载」底 |
| `bookCoverTagCompletedText` | `white100`（恒白，压在封面上） | 封面角标「完结/连载」字 |
| `bookCoverTagCompletedBorder` | `blackAlpha04`（恒暗 4% 黑 · `hairline` 0.5px） | 封面角标「完结/连载」描边 |
| `bookCoverTagUpdatedBorder` | `whiteAlpha04`（纯白 4%，全主题恒定 · `hairline` 0.5px） | 封面角标「更新」描边 |
| `cornerBadgeText` | `white100`（恒白，彩色角标） | 卡片角标字（充值「热」/ 星尘兑换等饱和色底） |
| `vipFreeClaimBadgeBackground` | `pink100Soft`（`vipCtaGradientEnd`，恒浅粉 keep-dark） | 充值「会员免费领」角标底（含 `pink_light` 不变） |
| `vipFreeClaimBadgeText` | `magenta950`（`vipOnGradientText`，恒深玫红） | 充值「会员免费领」角标字（浅粉底可读） |
| `sectionMoreActionBackground` | `blackAlpha04`（纯黑 4%，全主题统一） | 区块胶囊操作入口底（「更多福利」「完整榜单」） |
| `rechargePriceBg` | `sectionMoreActionBackground`（同黑 4%） | 充值卡价格胶囊 / 非 VIP「免费领」按钮底 |
| `continueReadingCardBackground` | `neutralCool800`（恒暗 keep-dark） | 书城「继续阅读」浮层底 |
| `continueReadingCardBorder` | `whiteAlpha04`（恒暗 keep-dark） | 书城「继续阅读」浮层描边 |
| `continueReadingCaptionText` | `neutralCool500`（恒暗 keep-dark） | 书城「继续阅读」副标「继续阅读」 |
| `continueReadingTitleText` | `neutralWhite`（恒暗 keep-dark） | 书城「继续阅读」书名 |
| `continueReadingCloseIcon` | `neutralCool400`（恒暗 keep-dark） | 书城「继续阅读」关闭图标 |
| `rankingMutedBadgeScrim` | `blackAlpha60`（恒暗 keep-dark） | 榜单名次角标底（第 4 名起） |
| `rankingMutedBadgeText` | `white100`（恒白 keep-dark） | 榜单名次角标字（第 4 名起） |
| `taskVipBadgeBg` | `segmentedSelectedFill`（8% primary） | 福利任务 VIP 标识底 |

#### 4.2.6 浅色主题（pink_light）token 审计与收敛约定（强制）

pink_light 靠 `AppColors._isLight`（编译期 `THEME=pink_light`）翻转中性面/文字/描边。以下**反模式会导致浅色态出错**（白底叠白看不见、深色块压浅底、白字/深字消失、主色上黑字），一律按「**深色分支保持原值不变 + 浅色分支翻到已有语义 token**（不新增色值）」收敛：

| 反模式 | 现象 | 收敛到 |
|---|---|---|
| 公开 token 绑死私有 `_dark*` | 深块压浅底 | `surface / surfaceSoft / divider / borderSubtle`（深色值与 `_dark*` 相同，浅色翻） |
| `whiteNN` 当面/描边 | 浅色不可见 | `surfaceSoft / surface / divider / borderSubtle`（`_isLight ? … : whiteNN`） |
| `whiteNN` 当文字 | 白字消失 | `textPrimary / textSecondary / textTertiary` |
| 主强调面上的文字/图标用 `textOnLightPanel` | 粉底黑字 | `onPrimary`（黄底深字 / 粉底白字） |
| 硬编码深色 `Color(0x…)` 当面/圆点 | 黑块 | `_isLight ? 语义 token : 原深色值` |

**例外（保持恒暗，加行内注释 `// light-audit: keep-dark` 或 `// light-audit: effect`）**：压在封面/头图/角色立绘上的遮罩·描边·阴影、饱和色角标上的恒白字（`cornerBadgeText`）、充值 VIP 角标浅粉底+深玫红字（`vipFreeClaimBadgeBackground` / `vipFreeClaimBadgeText`）、书城「继续阅读」浮层（`continueReadingCard*`）、榜单名次角标第 4 名起（`rankingMutedBadgeScrim` / `rankingMutedBadgeText`）、alpha 淡出蒙版、扫光高光、品牌恒定色（金/橙/粉紫 tint）、伙伴沉浸式互动场景。

**检测脚本**：`bash scripts/check-light-theme.sh`——① 公开 token 直绑 `_dark*` 为**硬门禁**（退出码 2）；②③④ 为人工复核清单（feature 色板硬编码 / UI 直用 `whiteNN` / UI 裸 `Color(0x…)`，豁免项加上述行内注释）。

### 4.3 组件层 · Tier 3（组件消费语义 token）

组件**只引用 §4.2 语义名**，不直接用 `AppPalette` 原色、不写死 `Color(0x…)`；同一组件在不同主题下自动取不同色（跨主题对比见 `design-system-spec.canvas.tsx`「多风格」tab；组件规范全表见 §7）。典型映射：

| 组件 / 场景 | 引用的语义 token |
|------|------|
| 主按钮 `AppButton(accent)` | `primary` / `onPrimary` |
| 次按钮 `AppButton(secondary)` | `surface` / `textPrimary` |
| 确认弹窗 `AppConfirmDialog` | `surfaceElevated` / `textPrimary` / `textSecondary` |
| 卡片 / 玻璃面 | `surface` / `borderSubtle` / `textPrimary` |
| 分组列表 / 分割 | `surface` / `divider` |
| 顶栏 / 底栏毛玻璃 | `chromeBarScrim` / `topChromeBarScrolledScrim` / `bottomNavScrim` |
| 底部导航 | 底 `navBarBackground` · 选中/未选主题色稿图标（`AppThemeAssets`）+ 选中标签 `textPrimary`（浅色深墨 / 深色纯白）· 未选标签 `iconMutedSecondary` |
| 输入框 / 搜索 | 光标 `searchCursor`(=primary) · 文字 `textPrimary` · 占位 `textTertiary` |
| 弹窗 | 底 `surfaceElevated` · 遮罩 `overlayScrim80` |
| 分段控件 | 选中底 `segmentedSelectedFill` · 选中字 `segmentedSelectedText`(=accent) |
| 骨架屏 | `shimmerBase` / `shimmerHighlight` |
| 头图 / 封面遮罩（图上） | `rankingHeroScrimTop/Mid` / `searchStatusBadgeBackground`（浅色恒暗） |
| 榜单左侧维度栏 | 选中 `rankingDimensionActive`（`textPrimary`）· 未选 `rankingDimensionInactive`（`textSecondary`，与书卡简介同级） |
| 大封面横向书卡简介 | `bookCardLargeDescription`（`textSecondary`） |
| Toast / 作者徽 | 底 `primary` · 字 `onPrimary` |
| 状态栏 | `AppTheme.systemUiOverlayStyle`（深壳白图标 / 浅壳深图标） |

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
| 通用基础 | 描边 / 通用图标 / 启动图 | `neutralCool200` · `borderWidthEmphasis` · `iconSm` · `splashLogoSize` |
| 通用按压反馈 `AppPressable` | 按下缩小 / 大面积柔和缩小 / 回弹 overshoot 比例 | `tapPressScale` · `tapPressScaleSubtle` · `tapPressReboundScale` |
| 骨架屏 `AppShimmer` | 骨架底色 / 扫光高光（复用中性白阶） | `shimmerBase` · `shimmerHighlight`（另见 `AppDurations.shimmerSweep`）|
| 跑马灯 `AppMarqueeText` | 溢出滚动速度 / 间距 / 循环间隔 | `marqueeSpeed` · `marqueeGap`（滚完停在起点静止 `AppDurations.marqueeInterval`≈6s 再滚）|
| 头图视差 `OverscrollStretch` | 下拉拉伸最大放大比例 | `heroParallaxFactor` |
| 顶栏 `AppTopBar` | 二级页顶栏高度 / 图标框 / 返回钮 | `topBar*` |
| 按钮 `AppButton` | 各尺寸内边距 / loading / 图标间距 | `buttonPadding*` · `buttonLoadingIndicatorSize` · `buttonIconLabelGap*` |
| 搜索栏 / 玻璃模糊 | 搜索框高 / 各级磨砂半径 | `searchBarHeight` · `glassBlurSigma` · `strongBlurSigma` · `chromeBarBlurSigma` |
| 书城首页 | 顶栏 / 加载（刷新跑熊 50×50）/ 「继续阅读」浮层 / 「限时免费」倒计时块 | `bookstore*` · `continueReading*` · `limitedFreeCountdownBoxSize` |
| 选择标记 `AppSelectionMark` | 多选勾选标记尺寸 / 描边 / 勾号 | `selectionMark*` · `bookshelfSelectionCheckIconSize` |
| 新手引导 | 性别头像 / 步骤视口高 / 标签短线 | `onboarding*` |
| 底部导航 `AppBottomNav` | 胶囊尺寸 / 图标 / 毛玻璃 / 弹跳缩放 | `bottomNav*` · `bottomNavBlurSigma` |
| 一级 Tab 顶纹理 `AppTabTopTexture` | 全宽装饰层高度 | `tabTopTextureHeight` |
| 榜单 | Tab 指示器 / 轮播 / 头图 / 维度导航 | `ranking*` · `tab*` |
| 书籍封面 / 书卡 | 列表/网格封面 / 大封面横向书卡 | `bookCover*` · `bookGrid*` · `bookCardLarge*` |
| 福利页 | 头图 / 签到里程碑 / 任务时间线 / 充值弹窗 | `welfare*` · `rechargePurchaseDialog*` |
| 书架页 | 顶栏 / 阅读横幅（小熊 64×64、top 8、底边裁剪）/ 空状态 / 封面角标 | `bookshelf*` · `bookCoverTag*`（含 `bookCoverTagBlurSigma`） |
| 我的页 | Hero / 头像 / 快捷入口 / 成就勋章 | `profile*` · `homeIndicator*` · `listRowMinHeight` |
| 我的-子页 | 账号设置 / 消息 / 卡包 | `accountSettings*` · `myMessages*` · `cardPack*` · 互动消息标识 `authorBadge*`（复用品牌黄）· 未读红点 `badgeCount`（复用 rose400 红）· 通知标识 `myMessagesNoticeBadge`（复用品牌橙）|
| 设置页 | Logo / 开关 `AppSwitch` | `settings*` · `appSwitch*` |
| 书籍详情页 | 头图 / 目录抽屉 / 角色卡 / 讨论区 / 更新时间线 | `bookDetail*` · `bookDiscussionDetail*` |
| 搜索页 | 顶栏返回 / 输入图标 / 空状态 | `searchAppBar*` · `searchInput*` · `searchEmpty*` |
| 会员页 | Hero 轮播 / 方案卡 / 权益宫格 / CTA / 特权详情 | `membership*` |
| 伙伴页 | 头部 / 顶部极光 / 角色卡 / 消息 Tab / 互动 Tab | `partner*` · `partnerTopAuroraHeight` · `partnerTopAuroraOpacity` |
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
| `accent` | 黄底（`primary`）深字 · 胶囊 `full` | **深色页主 CTA**：阅读 / 确认 / 提交 / 领取 / 充值（最常用） |
| `secondary` | 实体弱底（`surface`）· 无描边 · 胶囊 `full` | 次操作 / 弱化 / 未激活态（重试默认、退出登录、验证码倒计时）·**默认变体** |
| `outneutralCool100` | 透明底 + 细边框 · 胶囊 `full` | 对话框取消 · 轻量次要操作 |
| `vip` | 粉金渐变底（`vipGradientStart #FFDDC1` → `vipGradientEnd #F393DC`）+ 深粉字（`vipOnGradientText`）· 胶囊 `full` | VIP 领取 / 会员向操作（福利「VIP领取」等）|

**尺寸（size）· 内边距与使用场景：**

| 尺寸 | 内边距 (H×V) | 文字 | 使用场景 |
|------|-------------|------|----------|
| `normal` | 24 × 16 | 16 · bold | 页面 / 弹窗主按钮（默认） |
| `small` | 16 × 8 | 14 · medium | 卡片内 / 行内小操作（领取、去书城） |
| `compact` | 24 × 8 | 14 · medium | 紧凑行内操作（卡包页） |

**状态：** default · `isLoading`（转圈，保留变体外观）· **disabled（不可点击：`onPressed==null` 且非 loading）→ 全局统一 `buttonDisabledFill` + `buttonDisabledText`，无渐变、无描边，覆盖所有变体；主题感知：深色态弱实体面（`_darkSurface`）+ 三级字，浅色态半透明玫粉底（`pink500Alpha40`）+ 85% 白字（`white85`）** · `isExpanded`（撑满宽度）。**可选：** `leadingIcon` 前置图标；`iconLabelGap` 可覆写图标与文字间距（默认 `buttonIconLabelGap`，紧凑场景用 `buttonIconLabelGapTight`）。描边一律 0.5px neutralCool200。

### 7.2 Card · 卡片族

信息分组卡片底统一用 `surface`（深色实体面）+ 圆角 `md`/`lg`；**禁止卡中卡**（架构 §3.3）。

| 组件 | 位置 | 变体 / 说明 |
|------|------|------|
| `BookCardVertical` | `shared/components/book_card_variants.dart` | 网格：上图下文；开启卡面底时封面贴齐左/上/右边，文字区保留 `xs` 内边距（与书城卡片流对齐） |
| `BookCardRankingCompact` | 同上 | 榜单紧凑：上图下文（封面 132:179） |
| `BookCardHorizontal` | 同上 | 榜单：左图右文（旧版保留供回滚） |
| `BookGridCard` / `BookListTile` / `BookCardLargeRow` | `shared/components/` | 网格卡 / 列表行 / 大图行（简介 2 行，简介+作者与封面底对齐）|
| `RankingRankBadge` | `shared/components/ranking_rank_badge.dart` | 榜单封面左上角名次角标：Top 1–3 使用 SVG 切图（`rank_1/2/3.svg`），第 4 名起 20px `rankingMutedBadgeScrim` 底 + `rankingMutedBadgeText` 恒白字，左上角 `bookCover` + 右下角 `md` 圆角；书城榜单与榜单详情共用 |
| `BookCoverTagBadge` | `shared/components/book_cover_tag_badge.dart` | 封面角标：定位 inset top/right=`xxs`（4px），贴近书封右上角并避开圆角裁切；文字统一 `AppFontSizes.xs`（10px regular），内边距 H×V=`xxs × xxsHalf`（4×2px），减少封面遮挡；全主题统一 `bookCoverTagBlurSigma` 磨砂底；更新=主色底+onPrimary 字+纯白 4% hairline 描边；完结/连载=黑 60% 底+恒白字+黑 4% hairline 描边 |
| `AppCornerBadge` | `shared/components/app_corner_badge.dart` | 卡片右上角标：饱和色底字恒 `cornerBadgeText`（白）；VIP「会员免费领」底恒 `vipFreeClaimBadgeBackground`（`pink100Soft`）+ 字 `vipFreeClaimBadgeText`（`magenta950`）；其余底色按语义传入 |
| `GenderAvatarOption` | `shared/components/` | 性别选项：圆形头像 `onboardingGenderAvatarSize` 80px（选中彩色插画 + 黄色描边环、未选灰色插画 + 细描边，不填充底色，参照装扮选中）+ 文字标签（选中白、未选 60% 白）；新手弹窗与偏好设置页共用 |
| `AgeRangeOption` | `shared/components/` | 年龄段单选胶囊（整行，`horizontal md` / `vertical xs`）：选中 `segmentedSelectedFill`（8% 黄底，无描边）+ 黄字 `primary`**加粗**（`semibold`）、未选 `surface` + `borderSubtle` 细描边 + `textSecondary` 字，圆角 `full`；新手弹窗与偏好设置页共用（高度/选中样式统一）|
| `MyMessagesList` / `MyMessageItem` | `features/my_messages/presentation/components/` | 互动消息（回复/获赞）：头像 + 发信人（可带「作者」标）+ 时间 + 回复正文 + 引用书评（左竖条）+ 书籍引用块；条目间 `divider` 细线分隔 |
| `MyNotificationsList` / `MyNotificationItem` | `features/my_messages/presentation/components/` | 通知卡片（客服/系统）：标题 + `NEW`/`未读`（橙 `myMessagesNoticeBadge`）标 + 内容 + 时间 + 行尾实心三角箭头；已读整条置灰 `myMessagesReadOpacity`；页脚「没有更多数据了」|
| `OnboardingProfileDialog` | `features/onboarding/presentation/pages/` | 新用户首页首启弹窗：性别 → 年龄两步**横向切换**（高度固定、内容区无上下滚动、底部分页器可回退，右上角统一 `DialogCloseButton` X，标题统一 `titleMedium`，底部固定「完成」）；性别使用共用 `GenderAvatarOption`（圆形头像 80px，**左右并排**，选中彩色 + 黄描边环、未选灰 + 60% 白字，与偏好设置页一致），选中性别后短暂停留展示反馈再切到年龄；年龄使用共用 `AgeRangeOption`（8% 黄底 + 黄字加粗，无描边，与偏好设置页统一）|
| `ReadingPreferencesPage` | `features/settings/presentation/pages/` | 偏好设置页（二级页）：性别（共用 `GenderAvatarOption` 头像，左右并排）+ 年龄（共用 `AgeRangeOption` 胶囊单选，8% 黄底 + 黄字加粗、无描边，与新手弹窗统一）；底部「保存」|

### 7.3 Dialog · 居中弹窗

统一入口，**所有居中弹窗必须走此入口**（架构 §3.2）。

| 项 | 值 |
|----|----|
| 入口 | `showAppBlurredDialog` / `showAppScrimDialog`（别名）· `shared/components/app_blurred_dialog.dart`；所有弹窗默认 `barrierDismissible: false`，点遮罩不关闭 |
| 遮罩 | `overlayScrim80`（80% 纯黑，无背景模糊）|
| 弹窗底 | `surfaceElevated` `#131820` |
| 圆角 | `xl`（24）|
| 关闭 | 只能通过弹窗内部按钮 / `DialogCloseButton`（弹窗**右上角** `close_rounded` X 图标，距顶/右 `lg`=24，见 §7.7）关闭；点遮罩不关闭 · 统一 `Navigator.pop` |
| 确认壳 | `AppConfirmDialog`（`shared/components/app_confirm_dialog.dart`，L2）— 面板 chrome + 标题/正文 + 双按钮（默认左次按钮 `secondary` / 右主按钮 `accent`；可覆写变体、单主按钮、关闭钮）；业务 L3 只填文案 |
| 业务示例 | `EnergyRechargePurchaseDialog` / `WelfareRulesDialog` / `DailyCheckInDialog`（首页首启签到弹窗，性别/年龄收集后弹出，内容同「每日签到」区块）→ `CheckInSuccessDialog`（点签到后弹出）（L3） |

### 7.4 BottomSheet · 底部弹层

模式：`showModalBottomSheet`（`backgroundColor: transparent` + `isScrollControlled`）+ 顶部圆角 + `BackdropFilter` 玻璃 + `surfaceElevated` 底 + `SafeArea(top: false)`。顶部圆角走 feature token（如 `partnerFilterSheet`）或基阶 `xl`。

业务示例：`ShareBottomSheet`（`shared/components/share_bottom_sheet.dart`，L2）——标题「好东西要一起看！立刻分享到」+ 一行分享渠道（QQ好友/QQ空间/微信/朋友圈/分享海报，中性 `surface` 圆底 + 图标 `shareSheetChannelSize`/`shareSheetChannelIconSize`）+「取消」；点渠道回调 `onChannelTap`。书详情右上角分享入口调起。

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
| `AppTabTopTexture` | `shared/components/app_tab_top_texture.dart` | 一级 Tab（书城/福利/书架）顶部装饰纹理；全宽 × `tabTopTextureHeight`（120）；`AppThemeAssets.tabTopTexture` 为 null 时透明槽位 |
| `AppSegmentedSwitch` | `shared/components/app_segmented_switch.dart` | 玻璃分段 Tab，选中滑块动画（书架 / 详情内 Tab）；选中态**无描边**，仅 `segmentedSelectedFill`（8% 黄底）+ 黄字区分 |
| `ElasticTabIndicator` | `shared/components/elastic_tab_indicator.dart` | 黄色指示条，平移 + 沿主轴长度拉伸回弹（架构 §3.5）；`axis` 默认横向（下划线，宽度拉伸），传 `Axis.vertical` 作竖向侧边条（高度拉伸）；等宽 Tab 传 `slotWidth`+`slotPitch`，变宽 Tab（按文案实测）传 `centers`；`swipeProgress` 驱动跟手位移 |
| `ElasticTabRow` | `shared/components/elastic_tab_row.dart` | 变宽（按文案实测）横向 Tab 行：内部测量各 Tab 中心点并叠加 `ElasticTabIndicator`，支持 `swipeProgress` 跟手与 `indicatorColor` 主题色；书架 / 装扮 Tab 共用 |
| `AppTopTabBar` | `shared/components/app_top_tab_bar.dart` | **统一顶部一级 Tab 栏（书城首页同款）**：等宽槽位（按最宽文案实测）+ `ElasticTabIndicator` 弹性指示条 + `AppAnimatedTabLabel` 文字过渡/跟手。悬浮计数角标为其变体（`AppTopTabItem.badgeCount>0` 时渲染）。按语义传 `tabGap` / `indicatorColor` / `activeColor` / `inactiveColor` / `badgeColor`。书城顶栏 / 消息 / 伙伴 / 帮助反馈等**等宽顶栏统一复用**（feature 侧仅做枚举↔索引与主题色映射的薄封装）|
| `AppTabCountBadge` | `shared/components/app_tab_count_badge.dart` | Tab 悬浮数字角标：红/紫等语义色胶囊 + **纯白字**（`white100`，深浅主题一致），最小直径 `tabBadgeMinSize`，`>99` 显示 `99+`；由宿主 `Positioned` 到 Tab 文案右上角，不占布局宽度 |
| `AppAnimatedTabLabel` | `shared/components/app_animated_tab_label.dart` | Tab 文字标签：未选中↔选中样式（字号/字重/颜色）用 `TextStyle.lerp` 平滑过渡而非硬切；与 `ElasticTabIndicator` 同一进度模型——传 `swipeProgress` 随手指连续插值，未传则选中项变化时按 `AppDurations.normal` 平滑过渡。`AppTopTabBar` 及变宽 `ElasticTabRow`（书架 / 装扮）Tab 共用 |
| `AppTopTabBar` / `AppTopTabItem` | `shared/components/app_top_tab_bar.dart` | 顶部同级 Tab 栏：组合 `AppAnimatedTabLabel`（文字过渡）+ `ElasticTabIndicator`（黄条跟手）+ 可选未读角标（`AppTopTabItem.badgeCount`）；伙伴顶栏「探索/消息/互动」、帮助与反馈「常见问题/意见反馈」等共用 |
| `AppSwipeTabSwitcher` | `shared/components/app_swipe_tab_switcher.dart` | Tab 内容跟手左右切换（架构 §3.4） |
| `AppVerticalRailSwitch` | `shared/components/app_vertical_rail_switch.dart` | 竖向轨道切换（排行左侧维度栏）；左侧黄条复用 `ElasticTabIndicator`（`axis: Axis.vertical`），平移 + 高度拉伸回弹，与横向 Tab 黄条一致 |
| `AppPageDots` | `shared/components/app_page_dots.dart` | 统一分页指示点：选中态白色加宽胶囊(`pageDotActiveWidth`)、未选白 20% 小圆点(`pageDotSize`)；传 `onDotTap` 可点跳转。会员轮播 / 新手引导步骤共用 |

### 7.7 其它通用组件

| 组件 | 位置 | 变体 / 说明 |
|------|------|------|
| `SectionHeader` | `shared/components/section_header.dart` | 区块标题 + 可选右侧操作链接 |
| `EmptyState` | `shared/components/empty_state.dart` | 空状态：`title` / `description` / `action`；可选 `illustration` + `contentWidth` / 间距（插图引导空态） |
| `AppAsyncPageBody` | `shared/components/app_async_page_body.dart` | 页面异步门闸：加载中 / 失败重试 / 空数据 / 内容 |
| `AppConfirmDialog` | `shared/components/app_confirm_dialog.dart` | 居中确认弹窗壳（见 §7.3） |
| `AppGroupedListCard` | `shared/components/app_grouped_list_card.dart` | 分组列表卡：可选区块标题 + `surface` + 行间分割线（禁止卡中卡） |
| `AppNavigationListRow` | `shared/components/app_navigation_list_row.dart` | 设置/账号导航行：标题 + 可选副标题/尾部 + 箭头 |
| `AppListLoadMoreFooter` | `shared/components/app_list_load_more_footer.dart` | 列表底部上拉加载指示器；`asSliver` 可选 |
| `AppToast` | `shared/components/app_toast.dart` | 全局轻提示，黄底、淡入淡出自动消失 |
| `GlassChipButton` | `shared/components/glass_chip_button.dart` | 玻璃胶囊 / 搜索框容器；`blur` / `expanded` |
| `AppSwitch` | `shared/widgets/app_switch.dart` | 开关：on 主强调 4% 大色块底（`primarySoft`）+ 主强调圆钮 / off 玻璃底 + 白钮 |
| `AppSelectionMark` | `shared/widgets/app_selection_mark.dart` | 圆形多选勾选标记：选中黄底 + 深色勾（`selectionMarkSize` 圆 + `bookshelfSelectionCheckIconSize` 勾）、未选透明底 + 描边（`bookshelfSelectionMarkBorderUnselected`）；书架多选等复用 |
| `AppDigitCodeInput` | `shared/widgets/app_digit_code_input.dart` | 分格数字输入：`length` 控制位数，`obscureText` 控制密码圆点；每格最大 `digitCodeBoxMaxSize=56`，6 位紧凑铺满、4 位保持同尺寸并自动拉开；空格 `surfaceCard`、当前格 `primary` 描边/光标。登录验证码与青少年独立密码共用，三主题自动解析。 |
| `DialogCloseButton` | `shared/components/dialog_close_button.dart` | 统一居中弹窗关闭按钮：`close_rounded` X 图标（`textSecondary`）；`Positioned` 于卡片右上角，距顶/右 `lg`=24 |
| `LiquidSweepCtaClip` | `shared/components/liquid_sweep_cta_clip.dart` | 强 CTA 液态扫光裁剪壳：保留宿主原尺寸/渐变/切图，只让扫光经过的边缘产生轻微液态形变；用于所有“呼吸缩放 + 扫光”的 CTA |
| `SweepHighlightOverlay` | `shared/components/sweep_highlight_overlay.dart` | 扫光高亮层：高亮带循环滑过（会员/福利 CTA、签到成功 VIP 按钮统一复用）；参数 `highlightColor` / `edgeColor` / `bandWidthRatio` / `duration`，强 CTA 可传外部 `progress` 同步液态边缘形变 |
| `AppGradientCtaButton` | `shared/components/app_gradient_cta_button.dart` | 渐变强动效 CTA：渐变底 + 呼吸缩放 + 柔边倾斜扫光 + 液态边缘微形变 + loading；固定高度。各处传入自己的渐变/高度/圆角/扫光色。`MembershipCtaButton` 与福利 `CheckInCtaButton` 委派于它；其它已存在的缩放扫光按钮通过 `LiquidSweepCtaClip` 保留原尺寸接入形变 |
| `CurrencyBalanceBar` / `RechargePackagesSection` / `VipPromoBanner` | `shared/components/` | 业务复用组合组件；充值区价格按钮与「免费领 / VIP领取」CTA 共用同款暗色胶囊（`surface` 底、`welfareRechargePrice` 圆角、`welfareRechargePriceButtonHeight` 高），价格按钮用单段落 rich text 使 `¥` 与数字底对齐 |

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
3. **换色系（编译期整包，小流量实验用，不提供运行时切换）**：`AppBrandColors` 分两区——**§A 主题壳源色**（`backgroundDark` / `accent` / `bgTint00…90` 等随 `THEME` 切换的入口）与 **§B feature 品牌色**（VIP / 伙伴 / 福利金 / 语义状态色等，跨深壳实验恒定）。新增实验包：给 §A 每个字段的三元**前插**一条 `themeId == '<id>' ? _<id>源值 : _dark源值` 分支（新增 `_<id>*` 源值常量），构建时 `--dart-define=THEME=<id>`（Android flavor / iOS scheme / 渠道分包各固定一个 THEME）。`AppColors` / `AppColorScheme` / 页面均经 §A 取色，换包不改任何调用点。**默认（不带参）永远解析为 `yellow_dark`，§A 的 `_dark*` 源值与其默认分支不得改动。**
4. **新增即询问**：任何超出本文档的新 token / 新值 / 新色系（含实验包的 §A 具体色值），先向用户说明并确认，再落地并更新本文档。

---

## 9. 动效与特殊设计索引（Motion & Special Design Index）

> 本节是全局自定义动效 / 特殊视觉的**导航索引**（约 50 项独立效果，分 9 类），便于按需定位真源。新增同类效果时在此登记。动效时长统一引用 `AppDurations`，缩放/模糊等参数引用 `AppSizes`。

### 9.1 点击按压微动效
- `AppPressable`（`shared/widgets/app_pressable.dart`）：全局「缩小 → overshoot 反弹 → 回落」点击脚本，已铺至 70+ 组件（详见 §7.8）。
- `AppButton` 按压：按钮变体继承按压回弹。
- 柔和按压：大目标（书卡 / 整行）用 `tapPressScaleSubtle`。
- 伙伴卡按下叠层 / chip / 行 / 头部按下态（`features/partner/presentation/components/*`）：按下变色（非缩放，保留自有反馈）。

### 9.2 弹性 / 回弹 / 物理
- `ElasticTabIndicator`（`shared/components/elastic_tab_indicator.dart`）：指示条平移 + 沿主轴长度拉伸回弹（架构 §3.5）；横向为下划线（宽度拉伸），竖向（`axis: Axis.vertical`）为侧边条（高度拉伸，排行左侧维度栏 `AppVerticalRailSwitch` 复用）。变宽 Tab 传实测 `centers`，并可传 `swipeProgress` 随内容左右滑动跟手。变宽 Tab 行统一用 `ElasticTabRow`（书架 / 装扮 Tab）封装测量逻辑，避免各页重复实现。
- 底部导航图标弹跳（`shared/widgets/app_nav_icon.dart`）：选中冲高 → 回落 → 稳定。
- 会员 Hero 橡皮筋回弹 + 插图弹入（`features/membership/presentation/components/membership_hero.dart`，`Curves.easeOutBack`）。
- 伙伴互动弹簧物理（`features/partner/presentation/components/partner_interaction_page_physics.dart`，`ScrollSpringSimulation`）：已接入 `partner_interaction_body.dart` 的 `PageView`，单次手势最多翻一页 + 弹簧回稳。

### 9.3 呼吸 / 循环 / 引导 / 加载
- 书城下拉刷新奔跑小熊（`features/bookstore/presentation/components/bookstore_refresh_visual.dart`）：20 帧透明 PNG 在推荐页进入时预缓存，避免首次拖动解码停滞；`drag / armed / refresh / done` 全部可见阶段均以 0.8 秒周期持续循环，仅在 `inactive` 完全收起后停止。松手后弹簧先收敛到固定停留态，最短展示 1.6 秒，保证动画完整循环两次，刷新完成后统一回弹消失；显示尺寸 `bookstoreRefreshAnimationSize=50`，视觉下移 `AppSpacing.xxl + AppSpacing.xl + AppSpacing.lg`，刷新占位高度为 `chromeTopHeight - AppSpacing.md`，触发距离保持不变；在上一版基础上小熊再下移 24px，并进一步靠近下方内容，三主题共用。
- `LiquidSweepCtaClip`（`shared/components/liquid_sweep_cta_clip.dart`）：强 CTA 液态扫光裁剪壳；所有“呼吸缩放 + 扫光”的 CTA 均接入（会员/福利签到共享 CTA、福利 VIP 横幅小按钮、签到成功 VIP 按钮、书详情领取按钮），保留宿主原尺寸。
- `SweepHighlightOverlay`（`shared/components/sweep_highlight_overlay.dart`）：CTA 循环扫光；强 CTA 可传外部进度以同步液态边缘形变。
- `AppGradientCtaButton`（`shared/components/app_gradient_cta_button.dart`）：共享渐变强动效 CTA（呼吸 + 柔边倾斜扫光 + 液态边缘微形变 + loading）；`MembershipCtaButton` 与福利 `CheckInCtaButton` 委派于它。福利签到黄色 CTA 签到区块与首页签到弹窗共用（前后两段文案：立即签到+能量 / 看视频+星辰）。
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
- 继续阅读浮条：全主题保持深色壳样式（`continueReadingCard*` keep-dark，不随浅色包翻转）；页面背景色之上叠「放大封面」背景层（宽度撑满卡片、上下左右居中、半透明 `continueReadingBgImageOpacity` + 模糊 `continueReadingBgBlurSigma`），不同书籍呈现不同底纹；左侧封面缩略图放大并向上溢出卡片顶部（外层 `Stack` 不裁剪 + 投影 `continueReadingCoverShadowBlur`），呈悬浮抬起效果。

### 9.6 页面转场 / 容器变换 / 共享元素
- `AdvancedTransitionWrapper`（`shared/widgets/advanced_transition_wrapper.dart`）：卡片 → 全屏 `OpenContainer` 变形（充值卡 → 详情）。
- 目录抽屉左侧滑入（`book_detail_catalog_drawer.dart`）。
- 会员权益 3D 卡片轮播（`membership_benefits_detail_page.dart`，`Matrix4.rotateY` 透视）。
- 书封 Hero 共享元素：`BookCover(heroTag:)` → 书详情头图（`book_detail_hero_cover.dart`）同 tag 飞行；详情页用入口封面即时渲染头图作落点。两端共用 `shared/widgets/book_cover_hero.dart` 的飞行参数：位置/尺寸走 `MaterialRectCenterArcTween`，飞行途中在来源/目标外观间 easeInOut 交叉淡入淡出，平滑抹平圆角、描边与竖↔横裁切比例的突变（push/pop 对称）。书 id 唯一的列表（榜单 / 搜索 / 分类 / 书架）直接用 `book-cover-<id>`；同屏可能重复出现同一本书的场景（书城首页各板块）用 `book-cover-<板块>-<id>` 屏内唯一标签，并经 `AppRouter.goBookDetail(coverHeroTag:)` → 路由 `BookDetailRouteExtra.coverHeroTag` → 详情页透传该 tag（缺省回退 `book-cover-<id>`），避免"同 tag 多 Hero"冲突。

### 9.7 Tab 跟手切换 / 滑块
- `AppSwipeTabSwitcher`（`shared/components/app_swipe_tab_switcher.dart`，架构 §3.4，8 页复用）。
- `AppSegmentedSwitch`（滑块 `AnimatedPositioned`）、`AppVerticalRailSwitch`（竖向轨道）、书城顶部 Tab PageView、会员 Hero 无限循环轮播。
- `AppAnimatedTabLabel`（`shared/components/app_animated_tab_label.dart`）：Tab 标题文字未选中↔选中样式（字号/字重/颜色）随 `swipeProgress` 跟手连续插值，无 `swipeProgress` 时点击切换按 `AppDurations.normal` 平滑过渡；与 `ElasticTabIndicator` 同一进度模型，避免文字硬切。书城顶栏 / 消息 / 排行 / 书架 / 装扮 / 伙伴 Tab 共用。

### 9.8 滚动 / 沉浸式 Hero 头图
- `AppTopBar` 沉浸渐变蒙版 + 滚动起雾；会员 / 榜单 / 装扮 / 书详情沉浸顶（蒙版 + 模糊 + 装饰组合）。
- `OverscrollStretch`（`shared/widgets/overscroll_stretch.dart`）：下拉回弹时头图按 `heroParallaxFactor` 放大的视差 / 拉伸；已接入书详情头图与会员 Hero（需 `BouncingScrollPhysics`）。

### 9.9 其它自定义
- `AppToast`（淡入淡出）、`AppSwitch`（滑块过渡）、登录输入框聚焦下划线中心展开。
- `AnimatedCountText`（`shared/widgets/animated_count_text.dart`）：数值变化时从旧值滚动到新值（余额 / 钱包 / 星尘 / 阅读分钟）。
- `AppMarqueeText`（`shared/widgets/app_marquee_text.dart`）：文本溢出时横向循环滚动（「继续阅读」书名）。
- 倒计时：短信 / 福利任务 `HH:MM:SS`；续费提示 slot 交叉淡入 + 高度动画。
- 展开折叠 + 箭头旋转（签到 / 充值区）、「换一换」图标旋转、分页点 `AppPageDots`、`DialogCloseButton`、定制数字字体 `TCloudNumber`。
- 列表行 / 可点击条目行尾指示统一用**实心三角箭头** `AppIconAssets.arrowRight`（`assets/icons/shared/arrow_right.svg`，`AppIcon`，`AppSpacing.sm`=12，色 `textTertiary`）；禁止用 Material `chevron_right` 等描边箭头（设置 / 帮助与反馈 / 通知等已统一）。

### 尚未实现（后续增强候选）
- **Lottie 具体动画**：基建（`lottie` 依赖 + `AppLottie` + `assets/lottie/`）已就绪，待放入 JSON 资源并在目标页接入。
- 已完成（本轮）：骨架屏 / shimmer、数字滚动、跑马灯、书封 `Hero()` 共享元素、头图滚动视差（书详情 + 会员）、伙伴弹簧物理接线。
