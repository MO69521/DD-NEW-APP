import 'package:equatable/equatable.dart';

/// 纯 Dart 领域实体，禁止引入 Flutter / HTTP 依赖。
class HomeInfo extends Equatable {
  const HomeInfo({
    required this.appName,
    required this.tagline,
  });

  final String appName;
  final String tagline;

  @override
  List<Object?> get props => [appName, tagline];
}
