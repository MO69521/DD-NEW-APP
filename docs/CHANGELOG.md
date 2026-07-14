# CHANGELOG

> 研发知识库与工程变更日志，**追加式**记录，勿覆盖历史。每次开发按「日期 / 新增 / 修改 / 删除 / 影响模块 / Breaking Changes」登记。

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
