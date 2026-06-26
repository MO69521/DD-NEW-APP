import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/domain/entities/member_account.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_network_avatar.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 会员页用户卡（毛玻璃）：头像 + 昵称 + 会员状态副标题。
class MembershipUserCard extends StatelessWidget {
  const MembershipUserCard({super.key, required this.account});

  final MemberAccount account;

  String get _subtitle {
    if (!account.isVip) return '您还不是VIP会员，开通享受VIP特权吧～';
    final expire = account.vipExpireAt;
    if (expire == null) return '尊贵的VIP会员，畅享专属特权';
    final y = expire.year.toString().padLeft(4, '0');
    final m = expire.month.toString().padLeft(2, '0');
    final d = expire.day.toString().padLeft(2, '0');
    return '会员有效期至 $y.$m.$d';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.membershipCard),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSizes.welfareCurrencyBlurSigma,
          sigmaY: AppSizes.welfareCurrencyBlurSigma,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.membershipCard),
            border: Border.all(
              color: AppColors.borderGlass,
              width: AppSizes.hairline,
            ),
          ),
          child: Row(
            children: [
              AppNetworkAvatar(
                imageUrl: account.avatarUrl,
                size: AppSizes.membershipUserAvatarSize,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      account.nickname,
                      style: AppTextStyles.membershipUserName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AppText(
                      _subtitle,
                      style: AppTextStyles.membershipUserSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
