import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/editor_pick_cubit.dart';
import '../../application/editor_pick_state.dart';
import '../../application/editor_pick_ui_state.dart';
import '../components/editor_pick_book_list.dart';
import '../components/editor_pick_list_footer.dart';

/// 编辑推荐详情页：仅渲染 state、触发 action。
///
/// [title] 可由入口覆盖（如「限时免费」复用同款书单列表）。
class EditorPickPage extends StatelessWidget {
  const EditorPickPage({super.key, this.title = '编辑推荐'});

  final String title;

  static const String _emptyTitle = '暂无推荐';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: title,
          onBack: AppRouter.pop,
        ),
        body: const _EditorPickBody(),
      ),
    );
  }
}

class _EditorPickBody extends StatelessWidget {
  const _EditorPickBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorPickCubit, EditorPickState>(
      builder: (context, state) {
        switch (state.ui.phase) {
          case EditorPickPhase.loading:
            return const Center(child: CircularProgressIndicator());
          case EditorPickPhase.empty:
            return EmptyState(
              title: EditorPickPage._emptyTitle,
              description: state.ui.errorMessage,
              action: AppButton(
                label: '重试',
                onPressed: () => context.read<EditorPickCubit>().load(),
              ),
            );
          case EditorPickPhase.loaded:
            return _EditorPickContent(state: state);
        }
      },
    );
  }
}

class _EditorPickContent extends StatelessWidget {
  const _EditorPickContent({required this.state});

  final EditorPickState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditorPickCubit>();
    final topInset = AppLayout.chromeTopHeight(context) + AppSpacing.sm;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis == Axis.vertical) {
          cubit.onScrollNearEnd(
            notification.metrics.pixels,
            notification.metrics.maxScrollExtent,
          );
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: topInset)),
          EditorPickBookList(
            items: state.domain.items,
            onItemTap: AppRouter.goBookDetail,
          ),
          EditorPickListFooter(isLoadingMore: state.ui.isLoadingMore),
        ],
      ),
    );
  }
}
