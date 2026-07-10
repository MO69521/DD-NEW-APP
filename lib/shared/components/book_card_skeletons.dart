import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/app_shimmer.dart';

/// 骨架条：细高光占位条（宽度按比例，圆角小）。
class _Bar extends StatelessWidget {
  const _Bar({required this.widthFactor, required this.height});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: AppShimmerBox(height: height),
      ),
    );
  }
}

/// 大图横向书卡骨架（对齐 [BookCardLargeRow]：96×128 封面 + 右侧文本条）。
class BookCardLargeRowSkeleton extends StatelessWidget {
  const BookCardLargeRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.bookCardLargeRowVerticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerBox(
            width: AppSizes.bookCardLargeCoverWidth,
            height: AppSizes.bookCardLargeCoverHeight,
            radius: AppRadius.bookCover,
          ),
          const SizedBox(width: AppSizes.bookCardLargeCoverToTextGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Bar(widthFactor: 0.75, height: AppSpacing.sm),
                SizedBox(height: AppSpacing.sm),
                _Bar(widthFactor: 0.4, height: AppSpacing.xs),
                SizedBox(height: AppSpacing.md),
                _Bar(widthFactor: 1, height: AppSpacing.xs),
                SizedBox(height: AppSpacing.xs),
                _Bar(widthFactor: 0.9, height: AppSpacing.xs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 竖版网格书卡骨架（对齐 [BookCardVertical]：56/76 封面 + 标题 / 分类条）。
class BookCardVerticalSkeleton extends StatelessWidget {
  const BookCardVerticalSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        AspectRatio(
          aspectRatio: AppSizes.bookCoverGridAspectRatio,
          child: AppShimmerBox(radius: AppRadius.bookCover),
        ),
        SizedBox(height: AppSizes.bookGridCoverToTextGap),
        _Bar(widthFactor: 0.9, height: AppSpacing.sm),
        SizedBox(height: AppSpacing.xs),
        _Bar(widthFactor: 0.5, height: AppSpacing.xs),
      ],
    );
  }
}

/// 大图列表骨架：整组共享一次扫光。
class BookLargeRowListSkeleton extends StatelessWidget {
  const BookLargeRowListSkeleton({
    super.key,
    this.count = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md),
  });

  final int count;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // 作为整屏加载占位：视口高度不足以容纳全部行时，多余行裁剪而非溢出报错
    // （占位不需要滚动，仅需在有界高度内安全绘制）。
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < count; i++) const BookCardLargeRowSkeleton(),
          ],
        ),
      ),
    );
  }
}

/// 竖版网格骨架：整组共享一次扫光。
class BookGridSkeleton extends StatelessWidget {
  const BookGridSkeleton({
    super.key,
    this.count = 9,
    this.columns = 3,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final int count;
  final int columns;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: GridView.builder(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: AppSizes.bookCoverGridAspectRatio * 0.72,
        ),
        itemCount: count,
        itemBuilder: (context, index) => const BookCardVerticalSkeleton(),
      ),
    );
  }
}
