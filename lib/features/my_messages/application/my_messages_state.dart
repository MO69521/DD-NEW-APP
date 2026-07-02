import 'package:equatable/equatable.dart';

import 'my_messages_interaction_state.dart';

class MyMessagesState extends Equatable {
  const MyMessagesState({
    this.interaction = const MyMessagesInteractionState(),
  });

  final MyMessagesInteractionState interaction;

  MyMessagesState copyWith({MyMessagesInteractionState? interaction}) {
    return MyMessagesState(
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [interaction];
}
