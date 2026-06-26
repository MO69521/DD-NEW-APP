import 'package:equatable/equatable.dart';

import '../domain/entities/welfare_page_content.dart';

/// 福利页领域状态。
class WelfareDomainState extends Equatable {
  const WelfareDomainState({this.content});

  final WelfarePageContent? content;

  WelfareDomainState copyWith({WelfarePageContent? content}) {
    return WelfareDomainState(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}
