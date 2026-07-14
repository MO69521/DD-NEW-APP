# CHANGELOG

> 研发知识库与工程变更日志，**追加式**记录，勿覆盖历史。每次开发按「日期 / 新增 / 修改 / 删除 / 影响模块 / Breaking Changes」登记。

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
