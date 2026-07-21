# Lottie 动画资源目录

经 `AppLottie`（`lib/shared/components/app_lottie.dart`）引用；目录已在 `pubspec.yaml`
的 `flutter/assets` 声明。

## 底栏 Tab（`yellow_light`）

路径：`assets/lottie/bottom_nav/yellow_light/<tab>/…`

| Tab | JSON | 未选中静态图 |
|---|---|---|
| 书城 | `book_city/book_city.json` | `assets/images/bottom_nav/yellow_light/bookcity_nor.webp` |
| 福利 | `welfare/data.json` | `…/welfare_nor.webp` |
| 书架 | `bookcase/bookcase.json` | `…/bookcase_nor.webp` |
| 我的 | `mine/mine.json`（需同级 `images/img_0.webp`） | `…/mine_nor.webp` |

另入库、暂未接底栏默认态：`sign/`（福利签到态）、`partner/`（伙伴 Tab 下线中）、
`book_city/back_to_top.json`（书城回顶，非 Tab 切换）。

**约束**：每个 Lottie JSON 与其 `images/` 子目录相对位置不可拆散。语义路径经
`AppThemeAssets.nav*SelectedLottie` / `nav*Inactive` 解析，仅 `THEME=yellow_light`
非 null；其它主题仍走 SVG。

**pubspec**：须逐级登记 `assets/lottie/bottom_nav/yellow_light/<tab>/`（及 `images/`），
仅声明 `assets/lottie/` 时深层 JSON 不会打进包。
