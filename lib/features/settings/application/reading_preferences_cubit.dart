import 'package:flutter_bloc/flutter_bloc.dart';

import 'reading_preferences_state.dart';

class ReadingPreferencesCubit extends Cubit<ReadingPreferencesState> {
  ReadingPreferencesCubit() : super(const ReadingPreferencesState());

  void selectGender(ReadingPreferenceGender gender) {
    emit(state.copyWith(gender: gender));
  }

  void selectAge(ReadingPreferenceAge age) {
    emit(state.copyWith(age: age));
  }
}
