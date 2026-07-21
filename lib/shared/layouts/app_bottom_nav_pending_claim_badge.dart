part of 'app_bottom_nav.dart';

class _PendingClaimBadge extends StatelessWidget {
  const _PendingClaimBadge({super.key, required this.energy});

  final int energy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxs,
            vertical: AppSpacing.xxs,
          ),
          decoration: BoxDecoration(
            color: AppWelfareColors.hotSaleBadge,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: AppText(
            '$energy能量待领取',
            style: AppTextStyles.welfareHotSaleBadge,
            maxLines: 1,
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -AppSpacing.xxsHalf),
          child: const ClipPath(
            clipper: _DownTriangleClipper(),
            child: SizedBox(
              width: AppSpacing.sm,
              height: AppSpacing.xxs,
              child: ColoredBox(color: AppWelfareColors.hotSaleBadge),
            ),
          ),
        ),
      ],
    );
  }
}

class _DownTriangleClipper extends CustomClipper<Path> {
  const _DownTriangleClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
  }

  @override
  bool shouldReclip(_DownTriangleClipper oldClipper) => false;
}
