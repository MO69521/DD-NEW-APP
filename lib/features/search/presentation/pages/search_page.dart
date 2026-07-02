import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../application/search_cubit.dart';
import '../../application/search_domain_state.dart';
import '../../application/search_state.dart';
import '../../application/search_ui_state.dart';
import '../components/search_app_bar.dart';
import '../components/search_recommendation_list.dart';
import '../components/search_result_list.dart';

/// 搜索页（深色态）：仅渲染 state、触发 action。
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  static const String _placeholder = '多个关键词用空格隔开';
  static const String _emptyCaption = '搜索您想要的作品吧';
  static const String _noResultTitle = '没有找到相关作品';
  static const String _noResultDescription = '换个关键词试试吧';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final cubit = context.read<SearchCubit>();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      resizeToAvoidBottomInset: false,
      body: AppPageChrome(
        topBar: SearchAppBar(
          statusBarHeight: statusBarHeight,
          placeholder: _placeholder,
          onBack: AppRouter.pop,
          onSubmit: cubit.search,
          onCleared: cubit.clear,
        ),
        body: const _SearchBody(),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) =>
          previous.ui != current.ui || previous.domain != current.domain,
      builder: (context, state) {
        switch (state.ui.phase) {
          case SearchPhase.loading:
            return const Center(child: CircularProgressIndicator());
          case SearchPhase.results:
            return _ResultList(domain: state.domain);
          case SearchPhase.noResult:
            return const EmptyState(
              title: SearchPage._noResultTitle,
              description: SearchPage._noResultDescription,
            );
          case SearchPhase.empty:
            return _EmptyBody(
              domain: state.domain,
              isRecommendationsLoading: state.ui.isRecommendationsLoading,
              emptyCaption: SearchPage._emptyCaption,
            );
        }
      },
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.domain});

  final SearchDomainState domain;

  @override
  Widget build(BuildContext context) {
    return SearchResultList(
      items: domain.results,
      onItemTap: AppRouter.goBookDetail,
      onAddToShelf: ServiceLocator.bookshelfMembership.add,
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({
    required this.domain,
    required this.isRecommendationsLoading,
    required this.emptyCaption,
  });

  final SearchDomainState domain;
  final bool isRecommendationsLoading;
  final String emptyCaption;

  @override
  Widget build(BuildContext context) {
    if (isRecommendationsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (domain.recommendations.isNotEmpty) {
      return SearchRecommendationList(
        items: domain.recommendations,
        onItemTap: AppRouter.goBookDetail,
      );
    }

    return EmptyState(title: emptyCaption);
  }
}
