import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/membership_status_service.dart';
import '../../../core/services/service_locator.dart';
import 'edit_nickname_state.dart';

class EditNicknameCubit extends Cubit<EditNicknameState> {
  EditNicknameCubit({
    required String originalNickname,
    MembershipStatusService? membership,
  }) : _membership = membership ?? ServiceLocator.membershipStatus,
       super(EditNicknameState(originalNickname: originalNickname));

  final MembershipStatusService _membership;

  void onDraftChanged(String value) {
    emit(state.copyWith(draft: value));
  }

  void submit() {
    if (!state.canSubmit) return;
    // Mock：写入共享用户状态，profile / 账号设置订阅后实时刷新。
    unawaited(_membership.updateNickname(state.draft.trim()));
    emit(state.copyWith(submitted: true));
  }
}
