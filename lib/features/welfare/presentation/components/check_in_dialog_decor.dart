import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shared_assets.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_asset_image.dart';

/// L3 — 签到类弹窗统一装饰（每日签到 / 签到成功共用）。
///
/// - 顶边 [CheckInDialogTopAccent]：`primary` 色条
/// - 内侧 [CheckInDialogSideStripes]：斜纹贴边 + 自上而下渐隐
/// - 外侧 [CheckInDialogOuterSparkles]：须放在 [ClipRRect] 外层 Stack
/// - 标题旁 [CheckInDialogTitleSparkles]：小四角星点缀

/// 顶边主色条（高 [AppSizes.welfareCheckInSuccessTopAccentHeight]）。
class CheckInDialogTopAccent extends StatelessWidget {
  const CheckInDialogTopAccent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: AppSizes.welfareCheckInSuccessTopAccentHeight,
      child: IgnorePointer(
        child: ColoredBox(color: AppColors.primary),
      ),
    );
  }
}

/// 两侧斜条纹：贴内边、自上而下渐隐。
class CheckInDialogSideStripes extends StatelessWidget {
  const CheckInDialogSideStripes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: AppSizes.welfareCheckInSuccessSideStripeOpacity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SideStripe(mirrored: false),
              Spacer(),
              _SideStripe(mirrored: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _SideStripe extends StatelessWidget {
  const _SideStripe({required this.mirrored});

  final bool mirrored;

  @override
  Widget build(BuildContext context) {
    Widget stripe = const ColorFiltered(
      colorFilter: ColorFilter.mode(
        AppColors.primary,
        BlendMode.srcIn,
      ),
      child: SizedBox(
        width: AppSpacing.sm,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppSharedAssets.checkInSuccessSideStripe),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              repeat: ImageRepeat.repeatY,
            ),
          ),
        ),
      ),
    );

    if (mirrored) {
      stripe = Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(-1, 1, 1),
        child: stripe,
      );
    }

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.white100, AppColors.white00],
          stops: [0.15, 0.65],
        ).createShader(bounds);
      },
      child: stripe,
    );
  }
}

/// 弹窗外飘四角星（左中 1、右上 2；须放在 [ClipRRect] 外层 Stack）。
class CheckInDialogOuterSparkles extends StatelessWidget {
  const CheckInDialogOuterSparkles({super.key});

  static const Alignment _leftMid = Alignment(-1.12, 0.08);
  static const Alignment _rightUpper = Alignment(1.14, -0.58);
  static const Alignment _rightMidUpper = Alignment(1.18, -0.22);

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: AppSizes.welfareCheckInSuccessSparkleOpacity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: _leftMid,
                child: _SparkleStar(
                  size: AppSizes.welfareCheckInSuccessSparkleSizeMd,
                ),
              ),
              Align(
                alignment: _rightUpper,
                child: _SparkleStar(
                  size: AppSizes.welfareCheckInSuccessSparkleSizeLg,
                ),
              ),
              Align(
                alignment: _rightMidUpper,
                child: _SparkleStar(
                  size: AppSizes.welfareCheckInSuccessSparkleSizeSm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 标题旁小星星点缀。
class CheckInDialogTitleSparkles extends StatelessWidget {
  const CheckInDialogTitleSparkles({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        child,
        const Positioned(
          left: -AppSpacing.md,
          top: -AppSpacing.xxs,
          child: Opacity(
            opacity: AppSizes.welfareCheckInSuccessSparkleOpacity,
            child: _SparkleStar(
              size: AppSizes.welfareCheckInSuccessSparkleSizeSm,
            ),
          ),
        ),
        const Positioned(
          right: -AppSpacing.sm,
          top: -AppSpacing.xs,
          child: Opacity(
            opacity: AppSizes.welfareCheckInSuccessSparkleOpacity,
            child: _SparkleStar(
              size: AppSizes.welfareCheckInSuccessSparkleSizeSm,
            ),
          ),
        ),
      ],
    );
  }
}

class _SparkleStar extends StatelessWidget {
  const _SparkleStar({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        AppColors.primary,
        BlendMode.srcIn,
      ),
      child: AppAssetImage(
        assetPath: AppSharedAssets.checkInSuccessSparkle,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
