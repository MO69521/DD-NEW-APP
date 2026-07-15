# 审计报告模板

Step 5 必须在回复末尾输出，**不要省略**，即使改动很小。

规范链接：[flutter-architecture-strict-v2.mdc](../../rules/flutter-architecture-strict-v2.mdc)

## 全部通过

```markdown
---

## 架构合规检查 ✅

本次修改符合 [Flutter STRICT V2 架构规范](.cursor/rules/flutter-architecture-strict-v2.mdc)。

| 检查项 | 结果 |
|--------|------|
| Design Token | ✅ 无写死样式；新增 token（如有）已登记于 `lib/core/theme/` |
| 设计规范对照 | ✅ 已对照 `design-system/README.md`；无规范外新增（或已获用户确认并更新文档） |
| 设计规范一致性 | ✅ README / canvas 源 / 托管副本三处一致（涉及 `design-system/` 时已跑 sync-canvas.sh） |
| 组件/样式同步 | ✅ 增删组件 / 改样式已同步 README + canvas（Step 2.7 守卫退出码 0） |
| 三主题覆盖 | ✅ 默认三主题均生效（`yellow_dark` / `pink_light` / `yellow_light`）；例外已登记 |
| Feature 分层 | ✅ |
| 依赖方向 | ✅ |
| 组件分级 | ✅ |
| 状态管理 | ✅ |
| 路由 | ✅ |
| 状态栏留白 | ✅ |
| 代码体量 | ✅ |

**变更文件：** `path/to/file.dart`, ...
```

## 存在问题

```markdown
---

## 架构合规检查 ⚠️

规范参考：[Flutter STRICT V2 架构规范](.cursor/rules/flutter-architecture-strict-v2.mdc)

| 检查项 | 结果 | 说明 |
|--------|------|------|
| Design Token | ❌ | `features/foo/.../bar.dart:42` 写死 `fontSize: 14` |
| 三主题覆盖 | ❌ | 仅修了 `pink_light`，`yellow_light` 未覆盖 |
| ... | ... | ... |

**待修复：** （已修复的项标注 ✅ 已修复）
```
