import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../application/splash_cubit.dart';
import '../../application/splash_state.dart';
import '../components/splash_logo.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (previous, current) => current is SplashCompleted,
      listener: (context, state) {
        AppRouter.go(AppRoutes.home);
      },
      child: const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: SplashLogo()),
      ),
    );
  }
}
