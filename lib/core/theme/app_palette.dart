import 'package:flutter/material.dart';

/// 色板层（Tier 1 · 原色真源）。
///
/// 全项目**唯一**允许出现 `Color(0x……)` 字面量的地方：这里只放「原色」，
/// 不含任何语义、不分主题。上层：
/// - [AppBrandColors]（壳 / 品牌语义 + 主题选择）引用本层；
/// - [AppColors]（全局语义 token + 深浅翻转）引用本层；
/// - 页面只用 [AppColors] / [AppBrandColors] 的语义名，不直接引用本层。
///
/// 新增主题包时：在此加所需原色（如新色系基色 + 其透明度阶），语义层按 `themeId`
/// 从这些原色里选。新增原色需登记 `design-system/README.md` §4。
abstract final class AppPalette {
  // ── Alpha 原语 ──
  static const Color whiteAlpha100 = Color(0xFFFFFFFF);
  static const Color whiteAlpha85 = Color(0xD9FFFFFF);
  static const Color whiteAlpha60 = Color(0x99FFFFFF);
  static const Color whiteAlpha50 = Color(0x80FFFFFF);
  static const Color whiteAlpha30 = Color(0x4DFFFFFF);
  static const Color whiteAlpha24 = Color(0x3DFFFFFF);
  static const Color whiteAlpha20 = Color(0x33FFFFFF);
  static const Color whiteAlpha08 = Color(0x14FFFFFF);
  static const Color whiteAlpha06 = Color(0x0FFFFFFF);
  static const Color whiteAlpha05 = Color(0x0DFFFFFF);
  static const Color whiteAlpha04 = Color(0x0AFFFFFF);
  static const Color whiteAlpha00 = Color(0x00FFFFFF);

  static const Color blackAlpha80 = Color(0xCC000000);
  static const Color blackAlpha60 = Color(0x99000000);
  static const Color blackAlpha40 = Color(0x66000000);
  static const Color blackAlpha30 = Color(0x4D000000);
  static const Color blackAlpha08 = Color(0x14000000);
  static const Color blackAlpha04 = Color(0x0A000000);
  static const Color blackAlpha00 = Color(0x00000000);

  // ── 中性原色 ──
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutralCool50 = Color(0xFFF8F7FC);
  static const Color neutralCool100 = Color(0xFFF3F4F6);
  static const Color neutralCool200 = Color(0xFFE5E7EB);
  static const Color neutralCool300 = Color(0xFFB2B3BA);
  static const Color neutralCool350 = Color(0xFFABACB3);
  static const Color neutralCool400 = Color(0xFF9AA0AA);
  static const Color neutralCool500 = Color(0xFF737B86);
  static const Color neutralCool600 = Color(0xFF6B7280);
  static const Color neutralCool800 = Color(0xFF252B34);
  static const Color neutralCool820 = Color(0xFF232A33);
  static const Color neutralCool880 = Color(0xFF131820);
  static const Color neutralCool900 = Color(0xFF151B24);
  static const Color neutralCool920 = Color(0xFF111722);
  static const Color neutralCool950 = Color(0xFF090E17);
  static const Color neutralCool960 = Color(0xFF0A1628);
  static const Color neutralBlue950 = Color(0xFF1A1A2E);
  static const Color neutralWarm900 = Color(0xFF202020);
  static const Color neutralGray400 = Color(0xFF9B9B9B);
  static const Color neutralGray500 = Color(0xFF919191);
  static const Color neutralGray600 = Color(0xFF8C8C8C);
  static const Color neutralGray700 = Color(0xFF757575);
  static const Color pink100 = Color(0xFFF4D9E4);

  // ── 主题基色 Alpha 原语 ──
  static const Color neutralCool950Alpha00 = Color(0x00090E17);
  static const Color neutralCool950Alpha35 = Color(0x59090E17);
  static const Color neutralCool950Alpha45 = Color(0x73090E17);
  static const Color neutralCool950Alpha55 = Color(0x8C090E17);
  static const Color neutralCool950Alpha60 = Color(0x99090E17);
  static const Color neutralCool950Alpha80 = Color(0xCC090E17);
  static const Color neutralCool950Alpha90 = Color(0xE6090E17);
  static const Color pink50 = Color(0xFFFFF5F9);
  static const Color pink50Alpha00 = Color(0x00FFF5F9);
  static const Color pink50Alpha35 = Color(0x59FFF5F9);
  static const Color pink50Alpha45 = Color(0x73FFF5F9);
  static const Color pink50Alpha55 = Color(0x8CFFF5F9);
  static const Color pink50Alpha60 = Color(0x99FFF5F9);
  static const Color pink50Alpha80 = Color(0xCCFFF5F9);
  static const Color pink50Alpha90 = Color(0xE6FFF5F9);

  // ── 彩色原色 ──
  static const Color cream50 = Color(0xFFFFF9F2);
  static const Color cream10 = Color(0xFFFFFEF4);
  static const Color cream100 = Color(0xFFFFF2C6);
  static const Color cream200 = Color(0xFFFFFAD7);
  static const Color cream200Alpha90 = Color(0xE6FFFAD7);
  static const Color wine950 = Color(0xFF1D0B10);
  static const Color yellow500 = Color(0xFFFFE847);
  static const Color yellow500Alpha04 = Color(0x0AFFE847);
  static const Color yellow500Alpha08 = Color(0x14FFE847);
  static const Color pink500Alpha04 = Color(0x0AFF4D88);
  static const Color pink500Alpha08 = Color(0x14FF4D88);
  static const Color pink100Soft = Color(0xFFFFD5DB);
  static const Color pink200 = Color(0xFFFF9CC7);
  static const Color pink300 = Color(0xFFF393DC);
  static const Color pink400 = Color(0xFFFF7AA8);
  static const Color pink500 = Color(0xFFFF4D88);
  static const Color pink600 = Color(0xFFE03D74);
  static const Color peach50 = Color(0xFFFFEBD4);
  static const Color peach100 = Color(0xFFFFDDC1);
  static const Color magenta500 = Color(0xFFE541BC);
  static const Color magenta950 = Color(0xFF740551);
  static const Color magenta980 = Color(0xFF310F29);
  static const Color brown500 = Color(0xFFAA722E);
  static const Color brown600 = Color(0xFF935C1A);
  static const Color brown800 = Color(0xFF5D3A12);
  static const Color orange300 = Color(0xFFFF9359);
  static const Color orange500 = Color(0xFFFF7E32);
  static const Color orange550 = Color(0xFFFF6F4B);
  static const Color orange700 = Color(0xFFE64D00);
  static const Color rose400 = Color(0xFFFF667F);
  static const Color rose500 = Color(0xFFFF4E6C);
  static const Color red400 = Color(0xFFFF6B6B);
  static const Color green500 = Color(0xFF39D98A);
  static const Color amber500 = Color(0xFFFFA940);
  static const Color tan400 = Color(0xFFF0B16A);
  static const Color blue500 = Color(0xFF4DA6FF);
  static const Color sky500 = Color(0xFF59AEFF);
  static const Color purple400 = Color(0xFF9C87FF);
  static const Color cyan400 = Color(0xFF42DDFF);
  static const Color indigo400 = Color(0xFF7E95FF);
  static const Color gold400 = Color(0xFFF9C74F);
}
