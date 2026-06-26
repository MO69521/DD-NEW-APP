import 'package:equatable/equatable.dart';

/// 交互状态：各筛选组当前选中项下标（groupId → index）。
class CategoryInteractionState extends Equatable {
  const CategoryInteractionState({this.selectedIndices = const {}});

  final Map<String, int> selectedIndices;

  int selectedIndexFor(String groupId) => selectedIndices[groupId] ?? 0;

  CategoryInteractionState copyWith({Map<String, int>? selectedIndices}) {
    return CategoryInteractionState(
      selectedIndices: selectedIndices ?? this.selectedIndices,
    );
  }

  @override
  List<Object?> get props => [selectedIndices];
}
