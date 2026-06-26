import 'package:equatable/equatable.dart';

import '../domain/entities/book_detail.dart';

/// 书籍详情页领域状态。
class BookDetailDomainState extends Equatable {
  const BookDetailDomainState({this.detail});

  final BookDetail? detail;

  BookDetailDomainState copyWith({BookDetail? detail}) {
    return BookDetailDomainState(detail: detail ?? this.detail);
  }

  @override
  List<Object?> get props => [detail];
}
