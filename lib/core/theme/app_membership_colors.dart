import 'package:flutter/material.dart';

import 'app_brand_colors.dart';
import 'app_colors.dart';

/// 会员页（Figma 927:725）专用色 token。品牌色引用 [AppBrandColors]、
/// 中性叠加色引用 [AppColors] 中性阶；仅会员页独有色保留字面量。
abstract final class AppMembershipColors {
  /// 浅色实验包判定：深色分支保持原值，浅色分支翻到浅底可读的实体语义 token。
  static const bool _isLight = AppBrandColors.isLightExperiment;

  // ── 套餐卡：选中态（深色暖底 + 金描边 + 金渐变文字，Figma 1059:2298） ──
  /// 选中卡底色：金 8%（叠在深色页面上呈暖色深底）。
  static const Color planSelectedBg = Color(
    0x14FFE794,
  ); // light-audit: keep-dark 金 8% 选中底（金恒定）
  static const Color planSelectedBorder = Color(
    0xFFFFE794,
  ); // light-audit: keep-dark 金描边

  /// 选中卡标题 / 价格 / 底栏金色渐变（与开通 CTA 同金）。
  static const Color planSelectedGoldStart = ctaGradientStart;
  static const Color planSelectedGoldEnd = ctaGradientEnd;

  /// 选中卡价格下副文案（删除线）：深色 60% 白 / 浅色二级墨字。
  static const Color planSelectedSecondary = _isLight
      ? AppColors.textSecondary
      : AppColors.white60;

  /// 选中卡底栏文字（金色渐变底上的深字，金底恒定，两态皆深字）。
  static const Color planSelectedFooterText = AppBrandColors.textOnLightPanel;

  /// 未选中卡价格下副文案（删除线原价）。
  static const Color planOriginalPrice = AppBrandColors.planOriginalPrice;

  // ── 套餐卡：未选中态（玻璃面板；浅色翻实体面 + 浅描边） ──
  static const Color planUnselectedBg = _isLight
      ? AppColors.surfaceSoft
      : AppColors.white04;
  static const Color planUnselectedBorder = AppColors.borderSubtle;

  // ── 开通 CTA（金色渐变，Figma 1059:2358） ──
  static const Color ctaGradientStart = Color(
    0xFFFFE794,
  ); // light-audit: keep-dark 开通金渐变（金恒定）
  static const Color ctaGradientEnd = Color(
    0xFFFFCD5A,
  ); // light-audit: keep-dark 开通金渐变
  static const Color ctaText = AppBrandColors.textOnLightPanel;

  /// CTA 扫光：透明 → 高亮 → 透明。
  static const Color ctaSweepEdge = AppColors.white00;
  static const Color ctaSweepHighlight = AppColors.white50;

  // ── 权益网格 ──
  static const Color benefitIconBg = _isLight
      ? AppColors.surfaceSoft
      : AppColors.white05;

  /// 权益图标着色（品牌粉；切图渐变含 display-p3，flutter_svg 无法解析，故统一着色）。
  static const Color benefitIconTint = AppBrandColors.vipGradientEnd;

  // ── 协议链接文字（高亮态，非 muted）：深色亮白 / 浅色一级墨字 ──
  static const Color agreementLink = _isLight
      ? AppColors.textPrimary
      : AppColors.white100;
}
