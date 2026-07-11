import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_async_page_body.dart';
import '../../../../shared/layouts/app_scaffold.dart';
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
          final info = state.domain.info;
          return AppAsyncPageBody(
            isLoading: state.ui.isLoading,
            errorMessage: state.ui.errorMessage,
            onRetry: () => context.read<HomeCubit>().load(),
            isEmpty: info == null,
            child: info == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: HomeHeader(
                      appName: info.appName,
                      tagline: info.tagline,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
