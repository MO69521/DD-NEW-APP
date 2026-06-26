import 'package:flutter/material.dart';

import 'app_brand_colors.dart';
import 'app_colors.dart';

/// 全局语义色方案，通过 [ThemeExtension] 注入，支持运行时切换预设。
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  const AppColorScheme({
    required this.background,
    required this.surfaceCard,
    required this.surfaceGlass,
    required this.accent,
    required this.onAccent,
    required this.textPrimary,
    required this.textMuted,
    required this.textPlaceholder,
    required this.borderGlass,
    required this.iconMuted,
    required this.error,
    required this.coverBorder,
    required this.overlayScrim,
    required this.onLightPanel,
    required this.navBarBackground,
    required this.navActiveBackground,
    required this.onNavActive,
    required this.gradientFadeStart,
    required this.gradientFadeMid,
    required this.gradientFadeEnd,
    required this.heroScrimMid,
    required this.statusBadgeBackground,
    required this.brandPrimary,
    required this.onBrandPrimary,
    required this.heroImageMaskOpaque,
    required this.heroImageMaskSoft,
    required this.heroImageMaskTransparent,
  });

  final Color background;
  final Color surfaceCard;
  final Color surfaceGlass;
  final Color accent;
  final Color onAccent;
  final Color textPrimary;
  final Color textMuted;
  final Color textPlaceholder;
  final Color borderGlass;
  final Color iconMuted;
  final Color error;
  final Color coverBorder;
  final Color overlayScrim;
  final Color onLightPanel;
  final Color navBarBackground;
  final Color navActiveBackground;
  final Color onNavActive;
  final Color gradientFadeStart;
  final Color gradientFadeMid;
  final Color gradientFadeEnd;
  final Color heroScrimMid;
  final Color statusBadgeBackground;
  final Color brandPrimary;
  final Color onBrandPrimary;
  final Color heroImageMaskOpaque;
  final Color heroImageMaskSoft;
  final Color heroImageMaskTransparent;

  /// 当前默认深色方案（与 Figma 书城深色态一致）。
  static const dark = AppColorScheme(
    background: AppBrandColors.backgroundDark,
    surfaceCard: AppColors.surfaceCard,
    surfaceGlass: AppColors.surfaceGlass,
    accent: AppBrandColors.accent,
    onAccent: AppBrandColors.backgroundDark,
    textPrimary: AppBrandColors.textOnDark,
    textMuted: AppColors.textOnDarkMuted,
    textPlaceholder: AppColors.textOnDarkPlaceholder,
    borderGlass: AppColors.borderGlass,
    iconMuted: AppBrandColors.iconMutedSecondary,
    error: AppBrandColors.error,
    coverBorder: AppColors.coverBorder,
    overlayScrim: AppColors.overlayScrim,
    onLightPanel: AppBrandColors.textOnLightPanel,
    navBarBackground: AppColors.navBarBackground,
    navActiveBackground: AppBrandColors.textOnDark,
    onNavActive: AppBrandColors.backgroundDark,
    gradientFadeStart: AppColors.gradientFadeStart,
    gradientFadeMid: AppColors.gradientFadeMid,
    gradientFadeEnd: AppBrandColors.backgroundDark,
    heroScrimMid: AppColors.rankingHeroScrimMid,
    statusBadgeBackground: AppColors.searchStatusBadgeBackground,
    brandPrimary: AppBrandColors.primaryPurple,
    onBrandPrimary: AppBrandColors.textOnDark,
    heroImageMaskOpaque: AppColors.profileHeroImageMaskOpaque,
    heroImageMaskSoft: AppColors.profileHeroImageMaskSoft,
    heroImageMaskTransparent: AppColors.profileHeroImageMaskTransparent,
  );

  /// 蓝色品牌预设示例。
  static const brandBlue = AppColorScheme(
    background: AppBrandColors.brandBlueBackground,
    surfaceCard: AppColors.surfaceCard,
    surfaceGlass: AppColors.surfaceGlass,
    accent: AppBrandColors.brandBlueAccent,
    onAccent: AppBrandColors.brandBlueBackground,
    textPrimary: AppBrandColors.textOnDark,
    textMuted: AppColors.textOnDarkMuted,
    textPlaceholder: AppColors.textOnDarkPlaceholder,
    borderGlass: AppColors.borderGlass,
    iconMuted: AppBrandColors.iconMutedSecondary,
    error: AppBrandColors.error,
    coverBorder: AppColors.coverBorder,
    overlayScrim: AppColors.overlayScrim,
    onLightPanel: AppBrandColors.textOnLightPanel,
    navBarBackground: AppColors.navBarBackground,
    navActiveBackground: AppBrandColors.textOnDark,
    onNavActive: AppBrandColors.brandBlueBackground,
    gradientFadeStart: Color(0x000A1628),
    gradientFadeMid: Color(0xE60A1628),
    gradientFadeEnd: AppBrandColors.brandBlueBackground,
    heroScrimMid: Color(0x8C0A1628),
    statusBadgeBackground: Color(0x990A1628),
    brandPrimary: AppBrandColors.brandBlueAccent,
    onBrandPrimary: AppBrandColors.textOnDark,
    heroImageMaskOpaque: AppColors.profileHeroImageMaskOpaque,
    heroImageMaskSoft: AppColors.profileHeroImageMaskSoft,
    heroImageMaskTransparent: AppColors.profileHeroImageMaskTransparent,
  );

  @override
  AppColorScheme copyWith({
    Color? background,
    Color? surfaceCard,
    Color? surfaceGlass,
    Color? accent,
    Color? onAccent,
    Color? textPrimary,
    Color? textMuted,
    Color? textPlaceholder,
    Color? borderGlass,
    Color? iconMuted,
    Color? error,
    Color? coverBorder,
    Color? overlayScrim,
    Color? onLightPanel,
    Color? navBarBackground,
    Color? navActiveBackground,
    Color? onNavActive,
    Color? gradientFadeStart,
    Color? gradientFadeMid,
    Color? gradientFadeEnd,
    Color? heroScrimMid,
    Color? statusBadgeBackground,
    Color? brandPrimary,
    Color? onBrandPrimary,
    Color? heroImageMaskOpaque,
    Color? heroImageMaskSoft,
    Color? heroImageMaskTransparent,
  }) {
    return AppColorScheme(
      background: background ?? this.background,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      surfaceGlass: surfaceGlass ?? this.surfaceGlass,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      textPlaceholder: textPlaceholder ?? this.textPlaceholder,
      borderGlass: borderGlass ?? this.borderGlass,
      iconMuted: iconMuted ?? this.iconMuted,
      error: error ?? this.error,
      coverBorder: coverBorder ?? this.coverBorder,
      overlayScrim: overlayScrim ?? this.overlayScrim,
      onLightPanel: onLightPanel ?? this.onLightPanel,
      navBarBackground: navBarBackground ?? this.navBarBackground,
      navActiveBackground: navActiveBackground ?? this.navActiveBackground,
      onNavActive: onNavActive ?? this.onNavActive,
      gradientFadeStart: gradientFadeStart ?? this.gradientFadeStart,
      gradientFadeMid: gradientFadeMid ?? this.gradientFadeMid,
      gradientFadeEnd: gradientFadeEnd ?? this.gradientFadeEnd,
      heroScrimMid: heroScrimMid ?? this.heroScrimMid,
      statusBadgeBackground:
          statusBadgeBackground ?? this.statusBadgeBackground,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      onBrandPrimary: onBrandPrimary ?? this.onBrandPrimary,
      heroImageMaskOpaque: heroImageMaskOpaque ?? this.heroImageMaskOpaque,
      heroImageMaskSoft: heroImageMaskSoft ?? this.heroImageMaskSoft,
      heroImageMaskTransparent:
          heroImageMaskTransparent ?? this.heroImageMaskTransparent,
    );
  }

  @override
  AppColorScheme lerp(covariant ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(
      background: Color.lerp(background, other.background, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceGlass: Color.lerp(surfaceGlass, other.surfaceGlass, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      borderGlass: Color.lerp(borderGlass, other.borderGlass, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      error: Color.lerp(error, other.error, t)!,
      coverBorder: Color.lerp(coverBorder, other.coverBorder, t)!,
      overlayScrim: Color.lerp(overlayScrim, other.overlayScrim, t)!,
      onLightPanel: Color.lerp(onLightPanel, other.onLightPanel, t)!,
      navBarBackground: Color.lerp(navBarBackground, other.navBarBackground, t)!,
      navActiveBackground:
          Color.lerp(navActiveBackground, other.navActiveBackground, t)!,
      onNavActive: Color.lerp(onNavActive, other.onNavActive, t)!,
      gradientFadeStart:
          Color.lerp(gradientFadeStart, other.gradientFadeStart, t)!,
      gradientFadeMid: Color.lerp(gradientFadeMid, other.gradientFadeMid, t)!,
      gradientFadeEnd: Color.lerp(gradientFadeEnd, other.gradientFadeEnd, t)!,
      heroScrimMid: Color.lerp(heroScrimMid, other.heroScrimMid, t)!,
      statusBadgeBackground:
          Color.lerp(statusBadgeBackground, other.statusBadgeBackground, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      onBrandPrimary: Color.lerp(onBrandPrimary, other.onBrandPrimary, t)!,
      heroImageMaskOpaque:
          Color.lerp(heroImageMaskOpaque, other.heroImageMaskOpaque, t)!,
      heroImageMaskSoft:
          Color.lerp(heroImageMaskSoft, other.heroImageMaskSoft, t)!,
      heroImageMaskTransparent: Color.lerp(
        heroImageMaskTransparent,
        other.heroImageMaskTransparent,
        t,
      )!,
    );
  }
}
