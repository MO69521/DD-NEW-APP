import 'package:equatable/equatable.dart';

import '../domain/entities/my_messages_page_content.dart';
import 'my_messages_interaction_state.dart';

class MyMessagesState extends Equatable {
  const MyMessagesState({
    this.interaction = const MyMessagesInteractionState(),
    this.content,
    this.isLoading = true,
  });

  final MyMessagesInteractionState interaction;

  /// 页面内容，加载完成前为空。
  final MyMessagesPageContent? content;

  final bool isLoading;

  MyMessagesState copyWith({
    MyMessagesInteractionState? interaction,
    MyMessagesPageContent? content,
    bool? isLoading,
  }) {
    return MyMessagesState(
      interaction: interaction ?? this.interaction,
      content: content ?? this.content,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [interaction, content, isLoading];
}
