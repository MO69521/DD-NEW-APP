# API 接口草案

本文是给后端的接口草案，路径和字段名可按公司现有规范调整。重点是说明前端页面需要哪些数据。

## 通用约定建议

### 响应包裹

```json
{
  "code": 0,
  "message": "ok",
  "data": {}
}
```

列表分页建议统一使用游标：

```json
{
  "items": [],
  "nextCursor": "optional_cursor",
  "hasMore": true
}
```

### 图片字段

当前前端 mock 字段多叫 `coverAsset` / `avatarAsset`，真实接口建议统一返回 URL：

- `coverUrl`
- `avatarUrl`
- `imageUrl`
- `backgroundUrl`

前端接入时会在 data 层 DTO 映射到现有 domain model。

## 1. 鉴权与用户

| 接口 | 用途 | 前端入口 |
|---|---|---|
| `POST /auth/sms/send` | 发送验证码 | `RestAuthService.sendCode` |
| `POST /auth/sms/login` | 手机号验证码登录 | `RestAuthService.login` |
| `POST /auth/carrier/login` | 一键登录 | `RestAuthService.oneClickLogin` |
| `POST /auth/logout` | 退出登录 | `RestAuthService.logout` |
| `GET /me` | 当前用户资料 | `MemberAccount` / 我的页 |
| `PATCH /me/profile` | 修改昵称/头像 | 账号设置 |

### 登录响应字段

对应前端 `AuthSession`：

```json
{
  "accessToken": "string",
  "refreshToken": "string",
  "expiresAt": "2026-07-11T12:00:00Z",
  "user": {
    "id": "string",
    "phone": "string",
    "nickname": "string",
    "avatarUrl": "string"
  }
}
```

## 2. 书城

### `GET /bookstore/home`

用途：书城首页首屏聚合数据。  
前端模型：`BookstorePageContent`。

建议响应：

```json
{
  "searchPlaceholder": "穿书后：将门六姝",
  "rankingBooksByTab": {
    "recommend": [],
    "popular": [],
    "rising": [],
    "completed": [],
    "following": [],
    "potential": [],
    "interaction": []
  },
  "editorPicks": [],
  "guessLikeBooks": [],
  "continueReadingBook": {}
}
```

### `GET /bookstore/guess-like`

用途：猜你喜欢分页。  
参数：`cursor`、`limit`。  
返回：`items: Book[]`、`nextCursor`、`hasMore`。

### `GET /rankings`

用途：榜单页和书城榜单区。  
参数：`channel`、`dimension`、`cursor`、`limit`。  
返回榜单维度、频道和书籍列表。

## 3. 搜索

| 接口 | 方法 | 用途 |
|---|---|---|
| `/search/hot-keywords` | GET | 热搜词 |
| `/search/suggestions` | GET | 输入联想，参数 `q` |
| `/search` | GET | 搜索结果，参数 `q`、`cursor`、`limit` |
| `/search/recommendations` | GET | 搜索页默认推荐书单 |
| `/me/search-history` | GET | 搜索历史 |
| `/me/search-history` | POST | 新增搜索历史 |
| `/me/search-history` | DELETE | 清空搜索历史 |

搜索结果项对应 `SearchResultItem`：

```json
{
  "book": {
    "id": "book_id",
    "title": "书名",
    "category": "分类",
    "coverUrl": "https://..."
  },
  "audienceTags": ["女性向", "未来", "甜宠"],
  "description": "简介",
  "status": "serializing"
}
```

## 4. 书籍详情

### `GET /books/{bookId}`

用途：书籍详情首屏聚合。  
前端模型：`BookDetail`。

包含：

- 书籍基本信息：标题、作者、封面、标签、简介
- 统计：书架人数、热度、字数、送心数
- 目录摘要和章节列表
- 讨论列表
- 更新时间线
- 角色卡
- 作者其他作品
- 推荐书籍

### 写操作

| 接口 | 方法 | 用途 |
|---|---|---|
| `/books/{bookId}/shelf` | POST | 加入书架 |
| `/books/{bookId}/shelf` | DELETE | 移出书架 |
| `/books/{bookId}/heart` | POST | 送心/点赞 |
| `/books/{bookId}/comments` | GET | 评论列表 |
| `/books/{bookId}/comments` | POST | 发布评论 |
| `/comments/{commentId}/replies` | GET/POST | 回复列表/发布回复 |

## 5. 书架

### `GET /me/bookshelf`

用途：书架页聚合。  
前端模型：`BookshelfPageContent`。

返回：

- `todayReadingMinutes`
- `booksByTab.shelf`
- `booksByTab.history`
- `recommendationBooks`

写操作：

| 接口 | 方法 | 用途 |
|---|---|---|
| `/me/bookshelf/{bookId}` | POST | 加入书架 |
| `/me/bookshelf/{bookId}` | DELETE | 移出书架 |
| `/me/bookshelf/batch-delete` | POST | 批量移除 |
| `/me/reading-history` | GET | 阅读历史 |
| `/me/reading-history/batch-delete` | POST | 删除阅读历史 |

## 6. 我的 / 账号 / 资产

### `GET /me/profile-page`

用途：我的页聚合数据。  
前端模型：`ProfilePageContent`。

返回：

- `user`
- `currencyBalances`
- `vipMonthlyEnergy`
- `vipPriceYuan`
- `rechargePackages`
- `freeClaimOptions`
- `achievementCount`
- `achievementBadges`
- `menuItems` 可由前端固定，也可后端配置

### 资产与钱包

| 接口 | 方法 | 用途 |
|---|---|---|
| `/me/currencies` | GET | 能量/祈愿星/爱心/星尘余额 |
| `/me/currencies/{type}/wallet` | GET | 单货币钱包页 |
| `/me/currencies/{type}/records` | GET | 流水记录 |
| `/recharge/packages` | GET | 充值档位 |
| `/orders/recharge` | POST | 创建充值订单 |
| `/me/stardust/exchange` | POST | 星尘兑换能量 |

## 7. 会员 / 福利

| 接口 | 方法 | 用途 |
|---|---|---|
| `/membership/page` | GET | 会员页套餐、权益、轮播、协议 |
| `/membership/activate` | POST | 开通/续费会员 |
| `/welfare/page` | GET | 福利页聚合 |
| `/welfare/check-in` | POST | 每日签到 |
| `/welfare/tasks` | GET | 任务列表 |
| `/welfare/tasks/{taskId}/claim` | POST | 领取任务奖励 |
| `/welfare/ad-reward/claim` | POST | 看广告奖励 |

福利页聚合对应 `WelfarePageContent`，重点返回：

- 资产余额
- VIP 月度能量和价格
- 充值档位
- 签到信息
- 阅读福利
- 吃饭签到
- 任务列表

## 8. 伙伴 / 消息 / 互动

### `GET /partner/page`

用途：伙伴页聚合数据。  
前端模型：`PartnerPageContent`。

返回：

- `categoryTags`
- `characters`
- `conversations`
- `interactionScenes`
- `messageUnreadCount`
- `interactionUnreadCount`
- `filterOptions`

建议后续拆分为：

| 接口 | 方法 | 用途 |
|---|---|---|
| `/partner/characters` | GET | 探索角色列表，参数 `category`、`sort`、`filter`、`cursor` |
| `/partner/conversations` | GET | 伙伴消息会话列表 |
| `/partner/interaction-scenes` | GET | 互动场景列表 |
| `/partner/characters/{id}/collect` | POST/DELETE | 收藏/取消收藏角色 |
| `/partner/conversations/{id}/read` | POST | 标记消息已读 |

## 9. 我的消息

### `GET /me/messages`

参数：`tab=reply|like|notification`、`cursor`、`limit`。  
返回：回复、获赞、通知列表。

写操作：

| 接口 | 方法 | 用途 |
|---|---|---|
| `/me/messages/unread-counts` | GET | 各 Tab 未读数 |
| `/me/messages/{id}/read` | POST | 标记已读 |
| `/me/messages/read-all` | POST | 全部已读 |

## 10. 装扮 / 卡包

| 接口 | 方法 | 用途 |
|---|---|---|
| `/dress-up/page` | GET | 装扮列表、拥有状态、当前选中 |
| `/dress-up/{itemId}/equip` | POST | 穿戴装扮 |
| `/dress-up/{itemId}/buy` | POST | 购买装扮 |
| `/me/card-pack` | GET | 卡包/卡册 |

## 11. 帮助反馈 / 设置

| 接口 | 方法 | 用途 |
|---|---|---|
| `/help-feedback/page` | GET | FAQ、问题类型 |
| `/help-feedback/feedback` | POST | 提交反馈 |
| `/settings/page` | GET | 设置项配置 |
| `/documents/{type}` | GET | 用户协议、隐私政策等 |

