import 'package:equatable/equatable.dart';

/// 账号安全绑定类型。
enum AccountSecurityBindingType { phone, qq, wechat, douyin }

/// 安全设置绑定项（手机号 / 第三方账号）。
class AccountSecurityBinding extends Equatable {
  const AccountSecurityBinding({
    required this.type,
    required this.label,
    required this.iconAsset,
    required this.actionLabel,
    this.displayValue,
    this.isBound = false,
  });

  final AccountSecurityBindingType type;
  final String label;
  final String iconAsset;
  final String actionLabel;
  final String? displayValue;
  final bool isBound;

  @override
  List<Object?> get props => [
    type,
    label,
    iconAsset,
    actionLabel,
    displayValue,
    isBound,
  ];
}
