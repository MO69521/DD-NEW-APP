import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/main_tab_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../components/app_blurred_chrome_bar.dart';
import '../widgets/app_nav_icon.dart';
import '../widgets/app_text.dart';

enum AppBottomNavStyle { fullWidthSolid, glassCapsule }

/// App Shell 底部 5 Tab 导航栏。
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    this.items = MainTabConfig.items,
    this.selectedIndex = 0,
    this.onTabChanged,
    this.style = AppBottomNavStyle.fullWidthSolid,
    this.blurEnabled = true,
  });

  final List<MainTabItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onTabChanged;
  final AppBottomNavStyle style;
  final bool blurEnabled;

  static const double barHeight = AppSizes.bottomNavBarHeight;

  static const List<Color> _bottomFadeColors = [
    AppColors.gradientFadeStart,
    AppColors.gradientFadeMid,
    AppColors.gradientFadeEnd,
    AppColors.backgroundDark,
  ];

  static const List<double> _bottomFadeStops = [0.0, 0.4, 0.7, 1.0];

  @override
  Widget build(BuildContext context) {
    final capsuleRadius = BorderRadius.circular(AppRadius.navOuter);
    final navCapsule = _buildNavCapsule(capsuleRadius);

    final bottomBar = switch (style) {
      AppBottomNavStyle.fullWidthSolid => _buildSolidBottomBar(navCapsule),
      AppBottomNavStyle.glassCapsule => _buildGlassCapsuleBottomBar(
        capsuleRadius,
        navCapsule,
      ),
    };

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(width: double.infinity, child: bottomBar),
    );
  }

  Widget _buildNavCapsule(BorderRadius capsuleRadius) {
    final isGlassCapsule = style == AppBottomNavStyle.glassCapsule;

    return Container(
      width: double.infinity,
      height: AppSizes.bottomNavCapsuleHeight,
      padding: isGlassCapsule
          ? const EdgeInsets.all(AppSpacing.xxs)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isGlassCapsule ? AppColors.navBarBackground : Colors.transparent,
        borderRadius: capsuleRadius,
        border: isGlassCapsule
            ? Border.all(color: AppColors.borderGlass, width: AppSizes.hairline)
            : null,
      ),
      child: Row(
        children: [
          for (var index = 0; index < items.length; index++)
            Expanded(
              child: _NavTabItem(
                item: items[index],
                isSelected: index == selectedIndex,
                onTap: () => onTabChanged?.call(index),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSolidBottomBar(Widget navCapsule) {
    return AppBlurredChromeBar(
      enabled: blurEnabled,
      blurSigma: AppSizes.bottomNavBlurSigma,
      scrimColor: AppColors.bottomNavScrim,
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            navCapsule,
            const SizedBox(height: AppSizes.bottomNavBottomInset),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCapsuleBottomBar(
    BorderRadius capsuleRadius,
    Widget navCapsule,
  ) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _bottomFadeColors,
          stops: _bottomFadeStops,
        ),
      ),
      child: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.bottomNavHorizontalInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: capsuleRadius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: AppSizes.bottomNavBlurSigma,
                    sigmaY: AppSizes.bottomNavBlurSigma,
                  ),
                  child: navCapsule,
                ),
              ),
              const SizedBox(height: AppSizes.bottomNavBottomInset),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  const _NavTabItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final MainTabItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: AppSizes.bottomNavItemHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSizes.bottomNavItemContentTopInset,
            bottom: AppSizes.bottomNavItemContentBottomInset,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppNavIcon(item: item, isSelected: isSelected),
                SizedBox(height: AppSizes.bottomNavIconLabelGap),
                AppText(
                  item.label,
                  style: isSelected
                      ? AppTextStyles.navLabelActiveDark
                      : AppTextStyles.navLabelInactiveDark,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
