import 'package:equatable/equatable.dart';

/// 一组可单选的筛选项（纯 Dart）。
///
/// 选中项不在此模型内，由 application 层 interaction state 维护。
class CategoryFilterGroup extends Equatable {
  const CategoryFilterGroup({required this.id, required this.options});

  final String id;
  final List<String> options;

  @override
  List<Object?> get props => [id, options];
}
