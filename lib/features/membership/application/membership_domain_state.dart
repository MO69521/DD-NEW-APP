import 'package:equatable/equatable.dart';

import '../domain/entities/membership_page_content.dart';

/// 会员页领域状态。
class MembershipDomainState extends Equatable {
  const MembershipDomainState({this.content});

  final MembershipPageContent? content;

  MembershipDomainState copyWith({MembershipPageContent? content}) {
    return MembershipDomainState(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}
