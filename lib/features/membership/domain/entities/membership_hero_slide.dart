import 'package:equatable/equatable.dart';

/// Hero 头图轮播单页的主张文案。
///
/// 例：每月 / 3000 / 能量 ；每天只要 0.2元。
class MembershipHeroSlide extends Equatable {
  const MembershipHeroSlide({
    required this.titlePrefix,
    required this.titleHighlight,
    required this.titleSuffix,
    required this.subtitlePrefix,
    required this.subtitleValue,
  });

  final String titlePrefix;
  final String titleHighlight;
  final String titleSuffix;
  final String subtitlePrefix;
  final String subtitleValue;

  @override
  List<Object?> get props => [
    titlePrefix,
    titleHighlight,
    titleSuffix,
    subtitlePrefix,
    subtitleValue,
  ];
}
