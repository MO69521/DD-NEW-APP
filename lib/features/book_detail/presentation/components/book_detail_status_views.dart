import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import 'book_detail_hero_cover.dart';

/// 详情加载态：有入口封面时先渲染头图让 Hero 有落点，其余内容加载中；
/// 无封面则整屏居中转圈。
class BookDetailLoadingView extends StatelessWidget {
  const BookDetailLoadingView({
    super.key,
    required this.coverAsset,
    required this.heroTag,
  });

  final String? coverAsset;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    final cover = coverAsset;
    if (cover == null) {
      return const Scaffold(
        backgroundColor: AppColors.bookDetailPageBackground,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.bookDetailPageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BookDetailHeroCover(coverAsset: cover, heroTag: heroTag),
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}

/// 详情加载失败态：空状态 + 重试。
class BookDetailErrorView extends StatelessWidget {
  const BookDetailErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bookDetailPageBackground,
      body: EmptyState(
        title: '加载失败',
        description: errorMessage,
        action: AppButton(label: '重试', onPressed: onRetry),
      ),
    );
  }
}
