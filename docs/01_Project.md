# 01 · 项目概述（Project）

> 研发知识库首篇。内容基于当前仓库实际代码整理，细节以代码为准。返回 [文档导航](./README.md)。

## 1. 项目简介

`diandian_chuanshu`，一款「穿书 / 互动阅读」主题移动阅读社区 App。Flutter 跨端（iOS / Android / Web / macOS），当前以 Web 预览演示（`https://diandian-preview.vercel.app`）。UI 与交互高度完整，数据层几乎全走 Mock。架构基准 Feature First（`core / shared / features / routes`）+ 唯一权威设计系统 `design-system/`。

## 2. 技术栈

- 框架：Flutter + Dart；状态管理 `flutter_bloc`（Cubit + State）
- 路由：`go_router`（统一走 [app_router.dart](../lib/routes/app_router.dart)，禁裸 `Navigator.push`）
- 网络：`http`（封装于 [core/network](../lib/core/network/api_client.dart)：客户端 / 配置 / 异常）
- 其他：`equatable`、`flutter_svg`、`animations`、`confetti`、`lottie`、`image_picker`、`url_launcher`；自定义字体 `TCloudNumber` + 着色器 `aurora/liquid_button`
- 工程：`flutter_lints`；CI = GitHub Actions + Vercel；DI = 轻量 `ServiceLocator`
- 研发工具：Cursor（架构审计 skill、`design-system/*.canvas.tsx` 可视化）

## 3. Flutter Version

Flutter 3.44.1（stable，revision `924134a44c`，见 [.metadata](../.metadata)）。

## 4. Dart Version

Dart 3.12.1（`pubspec.yaml` 约束 `sdk: ^3.12.1`）。

## 5. 已完成模块

23 个 feature 均已完成四层结构（data / domain / application / presentation）+ 页面 UI（约 36 页），Mock 驱动可跑通：

`splash`、`onboarding`、`auth`、`home`、`bookstore`、`category`、`ranking`、`editor_pick`、`book_detail`、`bookshelf`、`search`、`partner`、`welfare`、`membership`、`currency_wallet`、`dress_up`、`card_pack`、`my_messages`、`profile`、`account_settings`、`settings`、`help_feedback`、`dev_tools`。

基础设施：统一网络层 + 单测范式；`bookstore` / `search` 两个真实接口接入范例（含 Remote + DTO + 测试）；各 feature 已抽象 `*_data_source.dart`，接真接口只需加 Remote 实现（详见 [08_API.md](./08_API.md)）。

## 6. 尚未完成模块

- 真实后端接入：除 `bookstore` / `search` 外仍为 Mock；`RestAuthService` 仅占位，登录未通 HTTP
- 登录态持久化：`InMemoryAuthSessionService` 重启失效，需换安全存储
- 写操作：加书架 / 签到 / 送心点赞评论 / 会员开通 / 分页等为本地模拟
- 测试覆盖：仅 6 个测试文件，缺 cubit / repository 测试
- 原生平台配置：`android/ios/macos/web` 为模板级，发布前需完善签名 / 权限 / 图标

## 7. 成熟度

高保真 Prototype（UI 近功能完整、Mock 驱动）。距 Production 三大缺口：后端接入、登录态持久化、测试补齐。详见 [12_TechLeadReview.md](./12_TechLeadReview.md)。

## 8. 目录入口

- 入口：[lib/main.dart](../lib/main.dart) → [lib/app.dart](../lib/app.dart)（`MaterialApp.router`）
- 路由：[lib/routes/app_router.dart](../lib/routes/app_router.dart)（初始 `splash`），分组见 `lib/routes/groups/`
- 预览：`lib/previews/global_preview_main.dart` 等
- 设计权威：[design-system/README.md](../design-system/README.md)；目录详解见 [02_ProjectStructure.md](./02_ProjectStructure.md)

## 9. 运行方式

```bash
flutter pub get                 # 安装依赖
flutter run                     # 本地运行（Mock，默认设备）
flutter run -d chrome           # Web 预览
flutter run --dart-define=API_BASE_URL=https://api.example.com  # 接真实后端
flutter test && flutter analyze # 测试 + 静态检查
flutter build web -t lib/previews/global_preview_main.dart --release  # Web 构建（CI 同款入口）
```

> iCloud 路径下跑 iOS 模拟器需先 `rsync` 到 `/tmp/diandian-sim-preview`（排除 `.git`/`build`/`.dart_tool`），见 [icloud-ios-simulator-workflow](../.cursor/rules/icloud-ios-simulator-workflow.mdc)。
