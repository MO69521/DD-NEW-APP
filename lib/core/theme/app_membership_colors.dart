import 'package:flutter/material.dart';

/// 会员页（Figma 927:725）专用色 token，避免污染 [AppColors]。
abstract final class AppMembershipColors {
  // ── Hero 头图 ──
  /// 轮播指示点：未选中态（白 20%）。
  static const Color dotInactive = Color(0x33FFFFFF);

  // ── 套餐卡：选中态（金色高亮，Figma 1059:2297） ──
  static const Color planSelectedBg = Color(0xFFFFF9EC);
  static const Color planSelectedBorder = Color(0xFFFFCE5D);

  /// 选中卡标题文字。
  static const Color planSelectedTitle = Color(0xFF202020);

  /// 选中卡价格（¥ + 数字）。
  static const Color planSelectedPrice = Color(0xFFC18729);

  /// 选中卡价格下副文案（删除线），#202020 @60%。
  static const Color planSelectedSecondary = Color(0x99202020);

  /// 选中卡底栏背景与文字（累计能量条）。
  static const Color planSelectedFooterBg = Color(0xFFFFCE5D);
  static const Color planSelectedFooterText = Color(0xFF672E00);

  /// 未选中卡价格下副文案（删除线原价）。
  static const Color planOriginalPrice = Color(0xFF919191);

  // ── 套餐卡：未选中态（玻璃面板） ──
  static const Color planUnselectedBg = Color(0x0AFFFFFF);
  static const Color planUnselectedBorder = Color(0x0AFFFFFF);

  // ── 开通 CTA（金色渐变，Figma 1059:2358） ──
  static const Color ctaGradientStart = Color(0xFFFFE794);
  static const Color ctaGradientEnd = Color(0xFFFFCD5A);
  static const Color ctaText = Color(0xFF202020);

  /// CTA 扫光：透明 → 高亮 → 透明。
  static const Color ctaSweepEdge = Color(0x00FFFFFF);
  static const Color ctaSweepHighlight = Color(0x80FFFFFF);

  // ── 权益网格 ──
  static const Color benefitIconBg = Color(0x0DFFFFFF);

  /// 权益图标着色（品牌粉；切图渐变含 display-p3，flutter_svg 无法解析，故统一着色）。
  static const Color benefitIconTint = Color(0xFFF393DC);

  // ── 协议链接文字（高亮态，非 muted） ──
  static const Color agreementLink = Color(0xFFFFFFFF);
}
