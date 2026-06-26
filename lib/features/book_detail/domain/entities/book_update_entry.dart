import 'package:equatable/equatable.dart';

/// 更新 tab 单条记录。
class BookUpdateEntry extends Equatable {
  const BookUpdateEntry({
    required this.id,
    required this.dateLabel,
    required this.title,
    this.detail,
    this.isHighlighted = false,
  });

  final String id;
  final String dateLabel;
  final String title;
  final String? detail;
  final bool isHighlighted;

  @override
  List<Object?> get props => [id, dateLabel, title, detail, isHighlighted];
}
