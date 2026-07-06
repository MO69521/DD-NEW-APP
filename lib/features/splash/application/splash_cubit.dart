import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/service_locator.dart';
import '../../../core/theme/app_durations.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  Future<void> start() async {
    await Future<void>.delayed(AppDurations.splashHold);
    if (isClosed) return;
    if (ServiceLocator.authSession.isAuthenticated) {
      emit(const SplashAuthenticated());
      return;
    }
    emit(const SplashUnauthenticated());
  }
}
