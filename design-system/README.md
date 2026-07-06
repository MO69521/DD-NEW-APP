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
| 字号 / 行高 / 字重 | `lib/core/theme/app_text_styles.dart`（`AppFontSizes` / `AppLineHeights` / `AppFontWeights`） |
| 颜色（中性阶 / 语义） | `lib/core/theme/app_colors.dart` |
| 品牌 / 主题源色 | `lib/core/theme/app_brand_colors.dart` |
| 间距 | `lib/core/theme/app_spacing.dart`（`AppSpacing`） |
| 圆角 | `lib/core/theme/app_radius.dart`（`AppRadius`） |
| feature 专用色 | `app_welfare_colors.dart` / `app_partner_colors.dart` / `app_membership_colors.dart`（引用上面的源色） |

---

## 1. 字号 · AppFontSizes（9 档）

| Token | px | 典型用途 |
|-------|----|----|
| `xxs` | 9 | 极小角标 |
| `xs` | 10 | 小标签 |
| `sm` | 11 | 说明文字 |
| `md` | 12 | 次要正文 / 标签 |
| `base` | 14 | 正文（主力档） |
| `lg` | 16 | 小标题 / 卡片标题 |
| `xl` | 18 | 页面标题 |
| `xxl` | 24 | 大标题 / 数值 |
| `display` | 32 | Hero / 展示级 |

> 已归位：`8→9`、`13→14`、`15→16`、`22→24`、`26→24`。新增字号档需先确认。

## 2. 行高 · AppLineHeights（6 档）

| Token | 值 | 用途 |
|-------|----|----|
| `none` | 1.0 | 单行标签 / 数字 / 图标旁文字 |
| `tight` | 1.2 | 大标题 / display |
| `snug` | 1.3 | 标题 |
| `normal` | 1.4 | 副标题 / 紧凑正文 |
| `relaxed` | 1.5 | 正文段落 |
| `loose` | 1.75 | 多行说明 / 协议类长文 |

## 3. 字重 · AppFontWeights（6 档）

| Token | 值 |
|-------|----|
| `regular` | 400 |
| `medium` | 500 |
| `semibold` | 600 |
| `bold` | 700 |
| `heavy` | 800 |
| `black` | 900 |

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
| `black80` | 80% | `0xCC000000` | 无模糊弹窗遮罩 |
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
| `accent` | `#FFE847` | 主强调色（黄） |
| `dialogBackground` | `#131820` | 弹窗底 |
| `success` | `#10B981` | 成功 |
| `warning` | `#F59E0B` | 警告 |
| `error` | `#EF4444` | 错误 |

feature 品牌色（均定义于 `AppBrandColors`，被各 feature 色板引用）：

- 福利金：`goldMedium #935C1A` / `goldDark #AA722E` / `checkInYellow #FCE64D` / `accentOrange #FF7E32`
- VIP 粉紫：`vipGradientStart #FFDDC1` / `vipGradientEnd #F393DC` / `vipOnGradientText #740551`
- 伙伴粉：`partnerPrimary #FF4D88` / `partnerPrimaryLight #FF7AA8` / `partnerPrimaryDark #E03D74`

---

## 5. 间距 · AppSpacing

基阶：`4 · 8 · 12 · 16 · 24 · 32 · 48`

| Token | px | 用途 |
|-------|----|----|
| `xxsHalf` | 2 | 极小间隔 |
| `countdownValueInset` | 3 | 倒计时数字内边距（一次性） |
| `xxs` | 4 | 紧凑间隔 |
| `insetXs` | 6 | 小内边距（一次性） |
| `xs` | 8 | 常用小间距 |
| `sm` | 12 | 常用间距 |
| `insetMd` | 14 | 中内边距（一次性） |
| `md` | 16 | 区块内边距 |
| `lg` | 24 | 区块间距 |
| `xl` | 32 | 大区块间距 |
| `xxl` | 48 | 超大间距 |
| `authTitleContentGap` | 50 | 登录标题-内容间距（一次性） |

> `3 / 6 / 14 / 50` 为保留的语义化一次性值；新增越界间距需先确认。

## 6. 圆角 · AppRadius

基阶：`4 · 8 · 12 · 16 · 24 · full(999)` + `coverSm 6` + `cta 26`

| Token | px | 用途 |
|-------|----|----|
| `xs` | 4 | 小角标 / 输入 |
| `coverSm` | 6 | 封面 |
| `sm` | 8 | 小卡片 |
| `md` | 12 | 卡片 |
| `lg` | 16 | 大卡片 / 区块 |
| `xl` | 24 | 弹窗 |
| `cta` | 26 | CTA / 胶囊按钮（多处 26 的真源） |
| `full` | 999 | 全圆 / 药丸 |

feature 专用圆角（在基阶之上按页面命名，如 `navOuter 47` / `searchBar 35` / `rankingSegmentedInner 50` 等）：确需新增新的非基阶圆角值时先确认。

---

## 7. 使用约定

1. **UI 只用 token**：禁止 `Color(0x…)`、`fontSize: 数字`、`EdgeInsets(数字)`、`BorderRadius.circular(数字)`（仅 `lib/core/theme/` 内定义 token 本身可用字面量）。
2. **单一真源**：中性叠加色 → `AppColors` 白/黑阶；品牌与主题源色 → `AppBrandColors`；背景蒙版 → `bgTint` 阶；feature 色板只引用上述源色，不本地重定义。
3. **换色系**：在 `AppBrandColors` 按 `themeId` 加分支，构建时 `--dart-define=THEME=<id>`；默认不带参永远是深色，`dark` 分支源值不得改动。
4. **新增即询问**：任何超出本文档的新 token / 新值 / 新色系，先向用户说明并确认，再落地并更新本文档。
