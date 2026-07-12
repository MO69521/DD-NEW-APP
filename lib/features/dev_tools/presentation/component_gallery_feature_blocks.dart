part of 'component_gallery_page.dart';

class _AssetPreviewCard extends StatelessWidget {
  const _AssetPreviewCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const AppAssetImage(
              assetPath: 'assets/icons/welfare/stardust.png',
              width: AppSpacing.xl,
              height: AppSpacing.xl,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppText(
                '资源渲染样例：PNG / SVG 统一走 AppAssetImage。',
                style: AppTextStyles.bodyMediumDarkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
