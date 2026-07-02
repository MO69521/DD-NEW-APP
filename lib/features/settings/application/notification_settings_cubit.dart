import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit() : super(const NotificationSettingsState());

  void setReceiveMessages(bool value) {
    emit(state.copyWith(receiveMessages: value));
  }

  void setBookUpdates(bool value) {
    emit(state.copyWith(bookUpdates: value));
  }

  void setWelfareReminders(bool value) {
    emit(state.copyWith(welfareReminders: value));
  }
}
