import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_durations.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashInitial());

  Future<void> start() async {
    await Future<void>.delayed(AppDurations.splashHold);
    if (isClosed) return;
    emit(const SplashCompleted());
  }
}
