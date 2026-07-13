import 'package:flutter/material.dart';

/// 色板层（Tier 1 · 原色真源）。
///
/// 全项目**唯一**允许出现 `Color(0x……)` 字面量的地方：这里只放「原色」，
/// 不含任何语义、不分主题。上层：
/// - [AppBrandColors]（壳 / 品牌语义 + 主题选择）引用本层；
/// - [AppColors]（全局语义 token + 深浅翻转）引用本层；
/// - 页面只用 [AppColors] / [AppBrandColors] 的语义名，不直接引用本层。
///
/// 新增主题包时：在此加所需原色（如新壳基色 + 其透明度阶），语义层按 `themeId`
/// 从这些原色里选。新增原色需登记 `design-system/README.md` §4。
abstract final class AppPalette {
  // ── 中性 · 纯白透明阶（深色态叠加原语）──
  static const Color white100 = Color(0xFFFFFFFF);
  static const Color white85 = Color(0xD9FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white08 = Color(0x14FFFFFF);
  static const Color white06 = Color(0x0FFFFFFF);
  static const Color white05 = Color(0x0DFFFFFF);
  static const Color white04 = Color(0x0AFFFFFF);
  static const Color white00 = Color(0x00FFFFFF);

  // ── 中性 · 纯黑透明阶（遮罩 / 蒙版原语）──
  static const Color black80 = Color(0xCC000000);
  static const Color black60 = Color(0x99000000);
  static const Color black40 = Color(0x66000000);
  static const Color black30 = Color(0x4D000000);
  static const Color black08 = Color(0x14000000);
  static const Color black04 = Color(0x0A000000);
  static const Color black00 = Color(0x00000000);

  // ── 中性 · 浅色实体（墨 / 面 / 线）──
  static const Color ink = Color(0xFF1A1A2E); // 主墨（浅色正文）
  static const Color inkMuted = Color(0xFF6B7280); // 次墨
  static const Color inkFaint = Color(0xFF9B9B9B); // 弱墨 / 占位 / 原价
  static const Color line = Color(0xFFF3F4F6); // 浅分隔
  static const Color hairline = Color(0xFFE5E7EB); // 浅描边
  static const Color pinkBorder = Color(0xFFF4D9E4); // 浅粉卡片描边
  static const Color paperCool = Color(0xFFF8F7FC); // 冷白背景（Material 预留）

  // ── 壳基色 & 透明度阶（背景渐隐 / 毛玻璃底）──
  static const Color shellDark = Color(0xFF090E17);
  static const Color shellDarkT00 = Color(0x00090E17);
  static const Color shellDarkT35 = Color(0x59090E17);
  static const Color shellDarkT45 = Color(0x73090E17);
  static const Color shellDarkT55 = Color(0x8C090E17);
  static const Color shellDarkT60 = Color(0x99090E17);
  static const Color shellDarkT80 = Color(0xCC090E17);
  static const Color shellDarkT90 = Color(0xE6090E17);
  static const Color shellPink = Color(0xFFFFF5F9);
  static const Color shellPinkT00 = Color(0x00FFF5F9);
  static const Color shellPinkT35 = Color(0x59FFF5F9);
  static const Color shellPinkT45 = Color(0x73FFF5F9);
  static const Color shellPinkT55 = Color(0x8CFFF5F9);
  static const Color shellPinkT60 = Color(0x99FFF5F9);
  static const Color shellPinkT80 = Color(0xCCFFF5F9);
  static const Color shellPinkT90 = Color(0xE6FFF5F9);

  // ── 深壳装饰 ──
  static const Color auroraGlow = Color(0xFFFFF2C6);
  static const Color auroraEdge = Color(0xFF1D0B10);
  static const Color dialogDark = Color(0xFF131820);
  static const Color surfaceMutedDark = Color(0xFF262B33);

  // ── 主强调 & 同色透明填充 ──
  static const Color brandYellow = Color(0xFFFFE847);
  static const Color brandYellow04 = Color(0x0AFFE847);
  static const Color brandYellow14 = Color(0x14FFE847);
  static const Color brandPink = Color(0xFFFF4D88); // 玫粉（伙伴主色 / 浅色主强调）
  static const Color brandPink04 = Color(0x0AFF4D88);
  static const Color brandPink14 = Color(0x14FF4D88);

  // ── 面板深字 / 中性灰 ──
  static const Color onLightPanel = Color(0xFF202020); // 浅/金面板深字
  static const Color grayStrike = Color(0xFF919191); // 划线原价
  static const Color graySubtitle = Color(0xFF8C8C8C); // 次级副标
  static const Color iconGray = Color(0xFFB2B3BA); // 图标默认灰
  static const Color iconGray2 = Color(0xFFABACB3); // 图标次级灰
  static const Color emptyGray = Color(0xFF757575); // 空态文案

  // ── VIP 粉紫系 ──
  static const Color vipGradStart = Color(0xFFFFDDC1);
  static const Color vipGradEnd = Color(0xFFF393DC);
  static const Color vipOnGradText = Color(0xFF740551);
  static const Color vipCtaStart = Color(0xFFFFEBD4);
  static const Color vipCtaEnd = Color(0xFFFFD5DB);
  static const Color vipCtaBorder = Color(0xFFFF9CC7);
  static const Color vipSelectedBorder = Color(0xFFE541BC);
  static const Color vipBannerText = Color(0xFF310F29);

  // ── 伙伴粉系（主色 = brandPink）──
  static const Color partnerLight = Color(0xFFFF7AA8);
  static const Color partnerDark = Color(0xFFE03D74);

  // ── 福利金 / 橙系 ──
  static const Color goldMedium = Color(0xFF935C1A);
  static const Color goldDark = Color(0xFFAA722E);
  static const Color goldText = Color(0xFF5D3A12);
  static const Color orange = Color(0xFFFF7E32);
  static const Color checkInYellow = Color(0xFFFCE64D);
  static const Color checkInHeader = Color(0xFFFFDD47);

  // ── 书籍详情悬浮促销条 ──
  static const Color promoStart = Color(0xFFFF4E6C);
  static const Color promoMid = Color(0xFFFF6F4B);
  static const Color promoEnd = Color(0xFFFF9359);
  static const Color promoSubtitle = Color(0xFFFFF9F2);
  static const Color promoReward = Color(0xFFE64D00);

  // ── 榜单头图 ──
  static const Color rankingTitle = Color(0xFFFFFAD7); // 头图标题米白
  static const Color rankingSubtitle = Color(0xE6FFFAD7); // 头图副标（90% 米白）

  // ── 书详情「更新」高亮 ──
  static const Color bookUpdateHighlight = Color(0xFFF0B16A);

  // ── 语义状态色 ──
  static const Color success = Color(0xFF39D98A);
  static const Color warning = Color(0xFFFFA940);
  static const Color error = Color(0xFFFF667F);
  static const Color hotSale = Color(0xFFFF6B6B);
  static const Color hotSaleText = Color(0xFFFFFEF4);

  // ── 蓝色预设（礼花粒子 / 休眠 AppColorScheme.brandBlue）──
  static const Color blueBg = Color(0xFF0A1628);
  static const Color blueAccent = Color(0xFF4DA6FF);

  // ── Design Token v1.0 · 语义强调扩展 ──
  static const Color premiumGold = Color(0xFFF9C74F);
  static const Color info = Color(0xFF59AEFF);
  static const Color fantasyPurple = Color(0xFF9C87FF);
  static const Color energyCyan = Color(0xFF42DDFF);
  static const Color growthBlue = Color(0xFF7E95FF);
}
