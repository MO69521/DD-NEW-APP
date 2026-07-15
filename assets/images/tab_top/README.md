# tab_top · 一级 Tab 顶部纹理（随主题）

书城 / 福利 / 书架顶部装饰纹理，全宽 × 高 120（`AppSizes.tabTopTextureHeight`）。

| 主题目录 | 文件 |
|----------|------|
| `yellow_dark/` | `top_texture.png` |
| `pink_light/` | `top_texture.png` |
| `yellow_light/` | `top_texture.png` |

路径：`AppThemeAssets.tabTopTexture`（切图未到位时为 `null`，组件只预留槽位）。

切图到位后：将各主题文件放入对应目录，并把 `AppThemeAssets.tabTopTexture` 改为  
`'assets/images/tab_top/$_pack/top_texture.png'`。
