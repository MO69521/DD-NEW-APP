import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_swipe_tab_switcher.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../application/help_feedback_cubit.dart';
import '../../application/help_feedback_state.dart';
import '../../domain/entities/help_feedback_tab.dart';
import '../components/help_feedback_faq_view.dart';
import '../components/help_feedback_form_view.dart';
import '../components/help_feedback_tab_bar.dart';

/// L3 页面 — 帮助与反馈（深色主题）。
class HelpFeedbackPage extends StatefulWidget {
  const HelpFeedbackPage({super.key});

  @override
  State<HelpFeedbackPage> createState() => _HelpFeedbackPageState();
}

class _HelpFeedbackPageState extends State<HelpFeedbackPage> {
  late final ValueNotifier<double> _tabSwipeProgress;

  @override
  void initState() {
    super.initState();
    _tabSwipeProgress = ValueNotifier<double>(0);
  }

  @override
  void dispose() {
    _tabSwipeProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTopBar(
              statusBarHeight: statusBarHeight,
              title: '帮助与反馈',
              onBack: AppRouter.pop,
            ),
            const SizedBox(height: AppSpacing.sm),
            BlocSelector<HelpFeedbackCubit, HelpFeedbackState, HelpFeedbackTab>(
              selector: (state) => state.selectedTab,
              builder: (context, selectedTab) {
                return HelpFeedbackTabBar(
                  selected: selectedTab,
                  onSelected: context.read<HelpFeedbackCubit>().selectTab,
                  swipeProgress: _tabSwipeProgress,
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
        body: _HelpFeedbackBody(swipeProgress: _tabSwipeProgress),
      ),
    );
  }
}

class _HelpFeedbackBody extends StatelessWidget {
  const _HelpFeedbackBody({required this.swipeProgress});

  final ValueNotifier<double> swipeProgress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top:
            AppLayout.chromeTopHeight(context) +
            AppSizes.helpFeedbackTabBarReserveHeight,
      ),
      child: BlocBuilder<HelpFeedbackCubit, HelpFeedbackState>(
        builder: (context, state) {
          return switch (state.phase) {
            HelpFeedbackPhase.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            HelpFeedbackPhase.failure => EmptyState(
              title: '加载失败',
              description: state.errorMessage,
            ),
            HelpFeedbackPhase.loaded => _LoadedHelpFeedbackBody(
              state: state,
              swipeProgress: swipeProgress,
            ),
          };
        },
      ),
    );
  }
}

class _LoadedHelpFeedbackBody extends StatelessWidget {
  const _LoadedHelpFeedbackBody({
    required this.state,
    required this.swipeProgress,
  });

  final HelpFeedbackState state;
  final ValueNotifier<double> swipeProgress;

  @override
  Widget build(BuildContext context) {
    final content = state.content;
    if (content == null) {
      return const EmptyState(title: '暂无内容');
    }

    final cubit = context.read<HelpFeedbackCubit>();
    const tabs = HelpFeedbackTab.values;

    return AppSwipeTabSwitcher(
      selectedIndex: tabs.indexOf(state.selectedTab),
      onSwipeProgressChanged: (progress) => swipeProgress.value = progress,
      onIndexChanged: (index) => cubit.selectTab(tabs[index]),
      children: [
        HelpFeedbackFaqView(
          groups: content.faqGroups,
          onQuestionTap: (question) => AppRouter.pushNamed(
            AppRoutes.helpFeedbackFaqDetailName,
            extra: question,
          ),
        ),
        HelpFeedbackFormView(
          issueTypes: content.issueTypes,
          selectedIssueTypeId: state.selectedIssueTypeId,
          description: state.description,
          screenshotPaths: state.screenshotPaths,
          errorMessage: state.errorMessage,
          submitMessage: state.submitMessage,
          onIssueTypeSelected: cubit.selectIssueType,
          onDescriptionChanged: cubit.updateDescription,
          onBookNameChanged: cubit.updateBookName,
          onPhoneChanged: cubit.updatePhone,
          onQqChanged: cubit.updateQq,
          onPickScreenshot: cubit.pickScreenshots,
          onRemoveScreenshot: cubit.removeScreenshot,
          onSubmit: cubit.submitFeedback,
        ),
      ],
    );
  }
}
