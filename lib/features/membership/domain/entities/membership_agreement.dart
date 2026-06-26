import 'package:equatable/equatable.dart';

/// 购买协议链接项。
class MembershipAgreement extends Equatable {
  const MembershipAgreement({required this.title, required this.url});

  final String title;
  final String url;

  @override
  List<Object?> get props => [title, url];
}
