import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/my_messages_mock_datasource.dart';
import '../data/repositories/my_messages_repository_impl.dart';
import '../domain/entities/my_message_tab.dart';
import '../domain/repositories/my_messages_repository.dart';
import 'my_messages_state.dart';

class MyMessagesCubit extends Cubit<MyMessagesState> {
  MyMessagesCubit({MyMessagesRepository? repository})
    : _repository =
          repository ??
          const MyMessagesRepositoryImpl(MyMessagesMockDataSource()),
      super(const MyMessagesState());

  final MyMessagesRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final content = await _repository.fetchPageContent();
    emit(state.copyWith(content: content, isLoading: false));
  }

  void onTabSelected(MyMessageTab tab) {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedTab: tab),
      ),
    );
  }
}
