import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/entities/my_message_tab.dart';
import 'my_messages_state.dart';

class MyMessagesCubit extends Cubit<MyMessagesState> {
  MyMessagesCubit() : super(const MyMessagesState());

  void onTabSelected(MyMessageTab tab) {
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedTab: tab),
      ),
    );
  }
}
