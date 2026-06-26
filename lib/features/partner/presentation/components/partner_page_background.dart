import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';

/// 伙伴页全屏上下渐变背景（Figma 1022:1062）。
class PartnerPageBackground extends StatelessWidget {
  const PartnerPageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppPartnerColors.pageBackgroundTop,
              AppPartnerColors.pageBackgroundBottom,
            ],
          ),
        ),
      ),
    );
  }
}
