import 'package:equatable/equatable.dart';

class NotificationSettingsState extends Equatable {
  const NotificationSettingsState({
    this.receiveMessages = true,
    this.bookUpdates = true,
    this.welfareReminders = true,
  });

  final bool receiveMessages;
  final bool bookUpdates;
  final bool welfareReminders;

  NotificationSettingsState copyWith({
    bool? receiveMessages,
    bool? bookUpdates,
    bool? welfareReminders,
  }) {
    return NotificationSettingsState(
      receiveMessages: receiveMessages ?? this.receiveMessages,
      bookUpdates: bookUpdates ?? this.bookUpdates,
      welfareReminders: welfareReminders ?? this.welfareReminders,
    );
  }

  @override
  List<Object?> get props => [receiveMessages, bookUpdates, welfareReminders];
}
