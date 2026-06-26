import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/ranking_cubit.dart';
import '../../application/ranking_state.dart';
import '../components/ranking_book_list.dart';
import '../components/ranking_channel_segmented.dart';
import '../components/ranking_dimension_rail.dart';
import '../components/ranking_hero_banner.dart';

/// 多维度榜单详情页（Figma 220:8376）：仅渲染 state、触发 action。
class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RankingCubit, RankingState>(
      builder: (context, state) {
        if (state.ui.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.ui.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: EmptyState(
              title: '加载失败',
              description: state.ui.errorMessage,
              action: AppButton(
                label: '重试',
                onPressed: () => context.read<RankingCubit>().load(),
              ),
            ),
          );
        }

        return _RankingView(state: state);
      },
    );
  }
}

class _RankingView extends StatelessWidget {
  const _RankingView({required this.state});

  final RankingState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RankingCubit>();
    final topInset = MediaQuery.paddingOf(context).top;
    final statusBar =
        topInset > 0 ? topInset : AppSizes.statusBarPlaceholderHeight;

    final heroHeight = statusBar + AppSizes.rankingHeroContentHeight;
    final segmentedTop = statusBar + AppSizes.rankingSegmentedTopOffset;
    final bodyTop = statusBar + AppSizes.rankingBodyTopOffset;

    final dimension = state.interaction.selectedDimension;
    final channel = state.interaction.selectedChannel;
    final books = state.domain.booksFor(dimension, channel);
    final title = '${state.domain.brandTitle} ${dimension.titleSuffix}';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: RankingHeroBanner(
              title: title,
              subtitle: dimension.subtitle,
            ),
          ),
          Positioned(
            top: bodyTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RankingDimensionRail(
                  selected: dimension,
                  onSelected: cubit.selectDimension,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: RankingBookList(
                    books: books,
                    onBookTap: AppRouter.goBookDetail,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: segmentedTop,
            left: AppSpacing.sm,
            right: AppSpacing.sm,
            child: RankingChannelSegmented(
              selected: channel,
              onSelected: cubit.selectChannel,
            ),
          ),
          Positioned(
            top: statusBar,
            left: 0,
            right: 0,
            child: AppTopBar(
              onBack: () => AppRouter.pop(),
              actions: [
                AppTopBarAction(
                  iconAsset: 'assets/icons/ranking/share.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
