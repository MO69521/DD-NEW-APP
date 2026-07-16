import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/image_picker_service.dart';
import '../../../core/services/service_locator.dart';
import '../data/datasources/help_feedback_mock_datasource.dart';
import '../data/repositories/help_feedback_repository_impl.dart';
import '../domain/entities/help_feedback_tab.dart';
import '../domain/repositories/help_feedback_repository.dart';
import 'help_feedback_state.dart';

class HelpFeedbackCubit extends Cubit<HelpFeedbackState> {
  HelpFeedbackCubit({
    HelpFeedbackRepository? repository,
    ImagePickerService? imagePicker,
  }) : _repository =
           repository ??
           const HelpFeedbackRepositoryImpl(HelpFeedbackMockDataSource()),
       _imagePicker = imagePicker ?? ServiceLocator.imagePicker,
       super(const HelpFeedbackState());

  final HelpFeedbackRepository _repository;
  final ImagePickerService _imagePicker;

  Future<void> load() async {
    emit(
      state.copyWith(
        phase: HelpFeedbackPhase.loading,
        clearErrorMessage: true,
        clearSubmitMessage: true,
      ),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          phase: HelpFeedbackPhase.loaded,
          content: content,
          selectedIssueTypeId: content.issueTypes.first.id,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          phase: HelpFeedbackPhase.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void selectTab(HelpFeedbackTab tab) {
    emit(
      state.copyWith(
        selectedTab: tab,
        clearErrorMessage: true,
        clearSubmitMessage: true,
      ),
    );
  }

  void selectIssueType(String id) {
    emit(
      state.copyWith(
        selectedIssueTypeId: id,
        clearErrorMessage: true,
        clearSubmitMessage: true,
      ),
    );
  }

  void updateDescription(String value) {
    emit(
      state.copyWith(
        description: value,
        clearErrorMessage: true,
        clearSubmitMessage: true,
      ),
    );
  }

  void updateBookName(String value) {
    emit(state.copyWith(bookName: value, clearSubmitMessage: true));
  }

  void updatePhone(String value) {
    emit(state.copyWith(phone: value, clearSubmitMessage: true));
  }

  void updateQq(String value) {
    emit(state.copyWith(qq: value, clearSubmitMessage: true));
  }

  /// 调起系统相册，追加所选问题截图（总数不超过上限）。
  Future<void> pickScreenshots() async {
    final remaining =
        HelpFeedbackState.maxScreenshots - state.screenshotPaths.length;
    if (remaining <= 0) return;

    final picked = await _imagePicker.pickImages(limit: remaining);
    if (picked.isEmpty) return;

    final combined = [
      ...state.screenshotPaths,
      ...picked,
    ].take(HelpFeedbackState.maxScreenshots).toList();
    emit(state.copyWith(screenshotPaths: combined, clearSubmitMessage: true));
  }

  void removeScreenshot(String path) {
    emit(
      state.copyWith(
        screenshotPaths: state.screenshotPaths
            .where((item) => item != path)
            .toList(),
      ),
    );
  }

  Future<void> submitFeedback() async {
    if (state.description.trim().isEmpty) {
      emit(state.copyWith(errorMessage: '请先填写问题描述'));
      return;
    }

    try {
      await _repository.submitFeedback(
        issueTypeId: state.selectedIssueTypeId,
        description: state.description,
        bookName: state.bookName,
        phone: state.phone,
        qq: state.qq,
        screenshotPaths: state.screenshotPaths,
      );
      emit(
        state.copyWith(submitMessage: '反馈已记录，我们会尽快处理', clearErrorMessage: true),
      );
    } catch (error) {
      emit(state.copyWith(errorMessage: '提交失败，请稍后重试'));
    }
  }
}
