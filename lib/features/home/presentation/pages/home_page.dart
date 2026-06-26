import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/home_cubit.dart';
import '../../application/home_state.dart';
import '../components/home_header.dart';

/// home 页面：仅渲染 state、触发 action。
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '首页',
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state.ui.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.ui.errorMessage != null) {
            return EmptyState(
              title: '加载失败',
              description: state.ui.errorMessage,
              action: AppButton(
                label: '重试',
                onPressed: () => context.read<HomeCubit>().load(),
              ),
            );
          }

          final info = state.domain.info;
          if (info == null) {
            return const EmptyState(title: '暂无数据');
          }

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: HomeHeader(
              appName: info.appName,
              tagline: info.tagline,
            ),
          );
        },
      ),
    );
  }
}
