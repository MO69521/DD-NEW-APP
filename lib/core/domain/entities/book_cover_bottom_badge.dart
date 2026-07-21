import 'package:equatable/equatable.dart';

enum BookCoverBottomBadgeType { popularity, promotion }

/// 服务端驱动的封面右下角运营标签。
class BookCoverBottomBadge extends Equatable {
  const BookCoverBottomBadge({required this.type, required this.label});

  final BookCoverBottomBadgeType type;
  final String label;

  @override
  List<Object?> get props => [type, label];
}
