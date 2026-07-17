# images · 位图资源（中英对照）

> **英文目录名不要改**。随主题变的头图等在 `<feature>/<themeId>/` 下。

| 目录 | 中文 | 说明 |
|------|------|------|
| `auth/` | 登录 | `pink_light` / `yellow_dark` 使用各自 `login_top_bg.png`；`yellow_light` 改为复用 profile Hero |
| `profile/` | 我的 | `…/hero_background_default.png` 默认 Hero；其中 `yellow_light` 同时供登录页使用 |
| `bottom_nav/` | 底栏纹理 | 各主题 `nav_texture.png` |
| `tab_top/` | 一级 Tab 顶纹理 | 书城/福利/书架；`top_texture.png`（三主题）；未到位时路径为 null |
| `empty_states/` | 空状态插图 | **三主题公用**一套（书架/卡包/消息等）；见 `AppSharedAssets` |
| `bookstore/refresh_bear/` | 书城刷新动画 | 20 帧透明 PNG，界面按 50×50 播放；三主题公用 |
| `bookshelf/` 等 | 各业务图片 | 如 `reading_bear.svg`；空态插图请放 `empty_states/` |

详见 [`docs/09_Assets.md`](../../docs/09_Assets.md)。
