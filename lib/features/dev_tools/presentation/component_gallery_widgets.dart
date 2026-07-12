part of 'component_gallery_page.dart';

class _GalleryIntro extends StatelessWidget {
  const _GalleryIntro();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText('真实 Flutter 组件陈列室', style: AppTextStyles.titleMediumDark),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              '分为「基础规范」和「组件」两部分：前者看 token 全局规则，后者看产品组件的真实渲染与交互状态。',
              style: AppTextStyles.bodyMediumDarkMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(title, style: AppTextStyles.sectionTitleDark),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  const _SpecCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow({
    required this.label,
    required this.value,
    required this.style,
  });

  final String label;
  final String value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              label,
              style: style.copyWith(color: AppColors.textOnDark),
            ),
          ),
          AppText(value, style: AppTextStyles.captionMdDarkMuted),
        ],
      ),
    );
  }
}

class _ColorTokenRow extends StatelessWidget {
  const _ColorTokenRow({
    required this.name,
    required this.value,
    required this.usage,
    required this.color,
    this.extraColors = const [],
  });

  final String name;
  final String value;
  final String usage;
  final Color color;
  final List<Color> extraColors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          _ColorPreview(color: color, extraColors: extraColors),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(name, style: AppTextStyles.labelMediumDark),
                const SizedBox(height: AppSpacing.xxs),
                AppText(usage, style: AppTextStyles.captionMdDarkMuted),
              ],
            ),
          ),
          AppText(value, style: AppTextStyles.captionMdDarkMuted),
        ],
      ),
    );
  }
}

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({required this.color, required this.extraColors});

  final Color color;
  final List<Color> extraColors;

  @override
  Widget build(BuildContext context) {
    final colors = [color, ...extraColors];
    return SizedBox(
      width: AppSpacing.xxl,
      height: AppSpacing.xl,
      child: Row(
        children: [
          for (final item in colors)
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: item,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                  border: Border.all(
                    color: AppColors.borderGlass,
                    width: AppSizes.hairline,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricTokenRow extends StatelessWidget {
  const _MetricTokenRow({
    required this.name,
    required this.value,
    required this.width,
  });

  final String name;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.xxl,
            child: AppText(name, style: AppTextStyles.labelMediumDark),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.accentYellow,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: SizedBox(width: width, height: AppSpacing.xs),
              ),
            ),
          ),
          AppText('$value px', style: AppTextStyles.captionMdDarkMuted),
        ],
      ),
    );
  }
}

class _RadiusTokenTile extends StatelessWidget {
  const _RadiusTokenTile({
    required this.name,
    required this.value,
    required this.radius,
  });

  final String name;
  final String value;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.xxl + AppSpacing.xl,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: AppColors.borderGlass,
                width: AppSizes.hairline,
              ),
            ),
            child: const SizedBox(
              width: AppSpacing.xxl,
              height: AppSpacing.xxl,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(name, style: AppTextStyles.labelMediumDark),
          AppText('$value px', style: AppTextStyles.captionMdDarkMuted),
        ],
      ),
    );
  }
}

class _CaptionNote extends StatelessWidget {
  const _CaptionNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppText(text, style: AppTextStyles.captionMdDarkMuted);
  }
}
