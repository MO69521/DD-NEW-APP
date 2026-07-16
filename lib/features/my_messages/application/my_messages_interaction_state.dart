import 'package:equatable/equatable.dart';

import '../domain/entities/my_message_tab.dart';

class MyMessagesInteractionState extends Equatable {
  const MyMessagesInteractionState({this.selectedTab = MyMessageTab.reply});

  final MyMessageTab selectedTab;

  MyMessagesInteractionState copyWith({MyMessageTab? selectedTab}) {
    return MyMessagesInteractionState(
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [selectedTab];
}
