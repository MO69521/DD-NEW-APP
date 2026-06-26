import 'package:equatable/equatable.dart';

import '../domain/entities/home_info.dart';

/// 业务数据状态，与 UI 状态分离。
class HomeDomainState extends Equatable {
  const HomeDomainState({this.info});

  final HomeInfo? info;

  HomeDomainState copyWith({HomeInfo? info}) {
    return HomeDomainState(info: info ?? this.info);
  }

  @override
  List<Object?> get props => [info];
}
