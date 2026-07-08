# STRICT V2 审计清单

对照 [flutter-architecture-strict-v2.mdc](../../rules/flutter-architecture-strict-v2.mdc) 使用。

## 0. 核心目标

- [ ] 修改可维护、可扩展，未引入隐性依赖

## 1. 架构（Feature First）

- [ ] 新文件位于 `core/`、`shared/`、`features/<name>/`、`routes/` 之一
- [ ] feature 内文件位于 `data/`、`domain/`、`application/`、`presentation/` 之一
- [ ] 无 `features/A` → `features/B/data/*` 或 `application/*` 引用
- [ ] 跨 feature 仅通过 domain 契约、interface、`core/services`

## 2. 依赖方向

- [ ] `presentation → application → domain → data` 未被打破
- [ ] `shared` 仅依赖 `core`
- [ ] `domain` 无 `import flutter` / `import ui` / `import http`
- [ ] `data` 无 UI、无状态管理、无业务编排
- [ ] `core` 未 import `features/*`

## 0.1 设计规范权威（最高优先级 · 见规范 §0.1）

- [ ] 涉及颜色/字号/行高/字重/间距/圆角/组件外观或变体的改动，**动手前已先对照** `design-system/README.md`
- [ ] token 只改 `lib/core/theme/*`、组件只改 `lib/shared/*`（改源即全局），未在页面内重定义样式或复制组件
- [ ] 无规范外新增；如需超出，已停下向用户确认并同步更新 `design-system/README.md`
- [ ] 若改了 `design-system/`：README / canvas 源 / 托管渲染副本**三处一致**，且已运行 `scripts/sync-canvas.sh`
- [ ] canvas 中登记的组件源码路径（`src="lib/..."`）真实存在

## 3. UI / Design Token

- [ ] 使用 `AppColors`、`AppSpacing`、`AppRadius`、`AppTextStyles`、`AppDurations`
- [ ] 无写死 `Color(...)`、`fontSize:` 数值、`EdgeInsets` 数值、`BorderRadius.circular` 数值（`core/theme` 除外）
- [ ] UI 仅渲染 state、触发 action，无业务判断下沉不当
- [ ] 已对照 [design-system/README.md](../../../design-system/README.md)；字号/行高/字重/颜色/间距/圆角均在规范档位内
- [ ] 无规范外新增 token/值/色系；如需超出，已停下并向用户确认、并同步更新规范文档（见 SKILL「设计规范治理」）

### 3.1 状态栏留白

- [ ] 页面顶栏未贴物理顶边；已预留状态栏高度
- [ ] `AppTopBar` 已传入 `statusBarHeight`
- [ ] 使用 `AppLayout.statusBarHeight(context)`，非 inline `topInset` 或裸 `MediaQuery.padding.top`
- [ ] loading / error 态若含顶栏，同样遵守 §3.1

## 4. 组件分级

- [ ] L1 → `shared/widgets/`
- [ ] L2 → `shared/components/`
- [ ] L3 → `features/*/presentation/components/`
- [ ] 未将 feature 逻辑组件放入 `shared`
- [ ] `shared` 无业务逻辑

## 5. 状态管理

- [ ] state 在 `application` 层定义
- [ ] UI 未 `new` 业务 state 或未在 widget 内持有可变业务状态
- [ ] UI / Domain / Interaction state 未混在同一可变对象
- [ ] state 不可变（`copyWith` / 重建），无直接改字段

## 6. data 层

- [ ] 仅 API、DTO mapping、cache/storage
- [ ] 无业务规则、无 UI 结构

## 7. domain 层

- [ ] 纯 Dart：entity、value object、interface、业务规则

## 8. shared 污染

- [ ] 放入 shared 的组件满足 ≥3 次复用或基础 UI/layout
- [ ] 无 API 相关组件、无页面拆分业务组件

## 9. 路由

- [ ] 使用 `AppRouter.go()` / `AppRouter.pushNamed()`
- [ ] 无 `Navigator.push()`（`app_router.dart` 内部实现除外）
- [ ] 新路由已注册 `routes/app_router.dart`

## 10. import

- [ ] 顺序：`core → shared → feature → local`
- [ ] 无 deep import（优先 `features/<name>/index.dart`）

## 11. 代码体量

- [ ] 单 widget ≤ 150 行
- [ ] 单文件 ≤ 300 行
- [ ] 嵌套 ≤ 5 层（否则已拆分）

## 12. 性能

- [ ] 列表使用 builder 构造
- [ ] 无多余全局 rebuild；局部订阅 state
- [ ] 大 widget 已 `const` 或 memoize

## 13. 生成前五问（本次改动是否违反）

1. [ ] 属于哪一层？
2. [ ] 是否违反依赖方向？
3. [ ] 是否应复用 shared？
4. [ ] 是否写死样式？
5. [ ] 是否引入跨 feature 依赖？
6. [ ] **页面顶部是否预留状态栏高度（§3.1）？**

## 14. 强制重构触发（出现则需修复）

- [ ] UI 包含业务逻辑
- [ ] shared 被 feature 逻辑污染
- [ ] feature 互引实现层
- [ ] state 跨层修改
- [ ] widget 过重未拆分
