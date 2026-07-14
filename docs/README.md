# 研发知识库（点点穿书 新 APP）

> `docs/` 是本项目**唯一研发知识库**。新人 / 交接从本页进入。内容基于当前仓库实际代码整理，细节以代码为准；代码变更须同步更新对应编号文档并追加 [CHANGELOG.md](./CHANGELOG.md)。

## 项目简介

`diandian_chuanshu`，「穿书 / 互动阅读」主题移动阅读社区 App。Flutter 跨端（iOS / Android / Web / macOS）。架构 Feature First（`core / shared / features / routes`）+ 唯一权威设计系统 `design-system/`。当前 UI 高保真、数据层以 Mock 为主。详见 [01_Project.md](./01_Project.md)。

## 快速开始

```bash
flutter pub get                 # 安装依赖
flutter run                     # 本地运行（Mock，默认设备）
flutter run -d chrome           # Web 预览
flutter run --dart-define=API_BASE_URL=https://api.example.com  # 接真实后端
flutter test && flutter analyze # 测试 + 静态检查
flutter build web -t lib/previews/global_preview_main.dart --release  # Web 构建（CI 同款入口）
```

> Flutter 3.44.1 · Dart 3.12.1。iCloud 路径下跑 iOS 模拟器需先 `rsync` 到 `/tmp/diandian-sim-preview`（见 [icloud-ios-simulator-workflow](../.cursor/rules/icloud-ios-simulator-workflow.mdc)）。

## 文档导航

| 编号 | 文档 | 内容 |
|---|---|---|
| 01 | [01_Project.md](./01_Project.md) | 项目简介 / 技术栈 / Flutter·Dart 版本 / 完成度 / 运行方式 |
| 02 | [02_ProjectStructure.md](./02_ProjectStructure.md) | 目录结构 / 目录职责 / 新增位置规范 |
| 03 | [03_Theme.md](./03_Theme.md) | 颜色 / 字体 / 间距 / 圆角 / 阴影 / 主题修改入口 |
| 04 | [04_DesignToken.md](./04_DesignToken.md) | Primitive / Semantic / Component Token 与使用规范 |
| 05 | [05_Components.md](./05_Components.md) | 公共组件（用途 / 参数 / 使用页面 / 复用建议） |
| 06 | [06_Pages.md](./06_Pages.md) | 页面职责 / 结构 / 模块 / Model / Repository |
| 07 | [07_DataFlow.md](./07_DataFlow.md) | 数据流 UI→Repository→Service→API 与替换点 |
| 08 | [08_API.md](./08_API.md) | 需接入接口清单 / Loading·Empty·Error / 预留 |
| 09 | [09_Assets.md](./09_Assets.md) | Images / Icons / Fonts / SVG / Lottie / Shader |
| 10 | [10_Animation.md](./10_Animation.md) | Implicit / Explicit / Hero / Transition / Shader / Lottie |
| 11 | [11_DevelopmentGuide.md](./11_DevelopmentGuide.md) | 研发规范（可改/禁改/复用）+ 扩展指南（如何新增） |
| 12 | [12_TechLeadReview.md](./12_TechLeadReview.md) | 工程最终审核 + 整改优先级 |
| — | [CHANGELOG.md](./CHANGELOG.md) | 变更日志（追加式） |

## 其它资料

| 主题 | 文档 |
|---|---|
| 后端接入草案（字段 / 接口） | [backend/README.md](./backend/README.md)、[backend/API接口草案.md](./backend/API接口草案.md) |
| 书城推荐页 Figma 设计稿 | [Figma · 142:1828](https://www.figma.com/design/JcW6L04t1puN1dWmqQ8gHh/cursor%E8%B5%84%E6%96%99-%E6%B5%8B%E8%AF%95?node-id=142-1828) |
| UI 设计唯一权威 | [design-system/README.md](../design-system/README.md) |
| 架构强制规范 | [.cursor/rules/flutter-architecture-strict-v2.mdc](../.cursor/rules/flutter-architecture-strict-v2.mdc) |

## 文档维护约定

每次开发自动执行：**开发 → Code Review → 更新受影响的编号文档 → 追加 CHANGELOG → 输出开发总结**。仅更新受影响章节，不重写全量文档。对应关系：

- 新增/改页面 → `06_Pages` + `CHANGELOG`
- 新增/改组件 → `05_Components`
- 新增/改 Theme → `03_Theme` + `04_DesignToken`
- 新增/改 API → `07_DataFlow` + `08_API`
- 新增 Assets → `09_Assets`；新增动画 → `10_Animation`
- 改目录结构 → `02_ProjectStructure`；改开发规范 → `11_DevelopmentGuide`

## 最近更新

见 [CHANGELOG.md](./CHANGELOG.md)。最新：2026-07-14 建立编号研发知识库。
