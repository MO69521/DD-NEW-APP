import 'package:flutter/material.dart';

import '../../../../shared/components/book_cover_badge.dart';
import '../../domain/entities/book_serialization_status.dart';

/// L3 — 封面「连载 / 完结」角标：把状态枚举映射到共享 [BookCoverBadge]。
class BookStatusBadge extends StatelessWidget {
  const BookStatusBadge({super.key, required this.status});

  final BookSerializationStatus status;

  @override
  Widget build(BuildContext context) {
    return BookCoverBadge(label: status.label);
  }
}
