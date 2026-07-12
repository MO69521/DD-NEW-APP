part of 'component_gallery_page.dart';

class _FoundationGallery extends StatelessWidget {
  const _FoundationGallery();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _GallerySection(title: '颜色', child: _ColorSpecSection()),
        _GallerySection(title: '字号 / 行高 / 字重', child: _TypeSpecSection()),
        _GallerySection(title: '间距', child: _SpacingSpecSection()),
        _GallerySection(title: '圆角', child: _RadiusSpecSection()),
      ],
    );
  }
}

class _ColorSpecSection extends StatelessWidget {
  const _ColorSpecSection();

  @override
  Widget build(BuildContext context) {
    return const _SpecCard(
      child: Column(
        children: [
          _ColorTokenRow(
            name: 'backgroundDark',
            value: '#090E17',
            usage: '全局深色背景',
            color: AppColors.backgroundDark,
          ),
          _ColorTokenRow(
            name: 'accentYellow',
            value: '#FFE847',
            usage: '主 CTA / 选中强调',
            color: AppColors.accentYellow,
          ),
          _ColorTokenRow(
            name: 'surfaceCard',
            value: 'white04',
            usage: '卡片 / 玻璃底',
            color: AppColors.surfaceCard,
          ),
          _ColorTokenRow(
            name: 'dialogBackground',
            value: '#131820',
            usage: '弹窗底色',
            color: AppColors.dialogBackground,
          ),
          _ColorTokenRow(
            name: 'overlayScrim80',
            value: 'black80',
            usage: '居中弹窗遮罩',
            color: AppColors.overlayScrim80,
          ),
          _ColorTokenRow(
            name: 'success / warning / error',
            value: 'semantic',
            usage: '状态语义色',
            color: AppColors.success,
            extraColors: [AppColors.warning, AppColors.error],
          ),
        ],
      ),
    );
  }
}

class _TypeSpecSection extends StatelessWidget {
  const _TypeSpecSection();

  @override
  Widget build(BuildContext context) {
    return _SpecCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TypeRow(
            label: 'Display',
            value: '32 / tight / bold',
            style: AppTextStyles.displayLarge,
          ),
          _TypeRow(
            label: 'Headline',
            value: '24 / tight / semibold',
            style: AppTextStyles.headlineMedium,
          ),
          _TypeRow(
            label: 'Title',
            value: '18 / normal / semibold',
            style: AppTextStyles.titleMediumDark,
          ),
          _TypeRow(
            label: 'Body',
            value: '14 / normal / regular',
            style: AppTextStyles.bodyMediumDark,
          ),
          _TypeRow(
            label: 'Label',
            value: '12 / normal / medium',
            style: AppTextStyles.labelMediumDark,
          ),
          _CaptionNote(text: '≥18px 的文字样式自动使用 TCloudNumber 数字字体。'),
        ],
      ),
    );
  }
}

class _SpacingSpecSection extends StatelessWidget {
  const _SpacingSpecSection();

  @override
  Widget build(BuildContext context) {
    return const _SpecCard(
      child: Column(
        children: [
          _MetricTokenRow(
            name: 'xxsHalf',
            value: '2',
            width: AppSpacing.xxsHalf,
          ),
          _MetricTokenRow(name: 'xxs', value: '4', width: AppSpacing.xxs),
          _MetricTokenRow(name: 'xs', value: '8', width: AppSpacing.xs),
          _MetricTokenRow(name: 'sm', value: '12', width: AppSpacing.sm),
          _MetricTokenRow(name: 'md', value: '16', width: AppSpacing.md),
          _MetricTokenRow(name: 'lg', value: '24', width: AppSpacing.lg),
          _MetricTokenRow(name: 'xl', value: '32', width: AppSpacing.xl),
          _MetricTokenRow(name: 'xxl', value: '48', width: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _RadiusSpecSection extends StatelessWidget {
  const _RadiusSpecSection();

  @override
  Widget build(BuildContext context) {
    return const _SpecCard(
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          _RadiusTokenTile(name: 'xs', value: '4', radius: AppRadius.xs),
          _RadiusTokenTile(name: 'md', value: '12', radius: AppRadius.md),
          _RadiusTokenTile(name: 'lg', value: '16', radius: AppRadius.lg),
          _RadiusTokenTile(name: 'xl', value: '24', radius: AppRadius.xl),
          _RadiusTokenTile(name: 'full', value: '999', radius: AppRadius.full),
        ],
      ),
    );
  }
}
