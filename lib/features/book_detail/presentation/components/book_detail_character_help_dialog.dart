import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/dialog_close_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 角色玩法说明弹窗。
class BookDetailCharacterHelpDialog extends StatelessWidget {
  const BookDetailCharacterHelpDialog({super.key});

  static const List<_HelpSection> _sections = [
    _HelpSection(
      title: '1. 表白角色有什么用？',
      body:
          '（1）助力角色解锁更高级的写真，新写真将展示在简介页、角色主页，并有机会展示在角色榜和心动角色评选活动、APP开屏、首页展位等位置。\n'
          '（2）提高你与角色的亲密度。亲密度等级提升将与角色成为伙伴，并解锁多种有趣的互动。\n'
          '（3）助力角色登上角色榜。每月1日将选取上月月榜Top30角色，举办心动角色评选活动。当选心动角色将获得重要资源位曝光，并为粉丝送出超多福利。敬请关注！',
    ),
    _HelpSection(
      title: '2. 成为伙伴有什么用？',
      body:
          '（1）与角色成为伙伴，可以带回自己的世界进行互动、换装、每日免费表白1次。\n'
          '（2）随着你与TA的亲密度升级，未来还有机会解锁更多互动玩法，如触摸、聊天、语音、动作、表情；还有机会获得专属角色卡，与TA约会哦～',
    ),
    _HelpSection(
      title: '如何成为伙伴？',
      body: '向角色表白或达成伙伴解锁条件，就可以将TA收集为伙伴啦～伙伴解锁条件可以在角色主页的亲密度进度条左侧【?】查看。',
    ),
    _HelpSection(
      title: '角色写真升级规则',
      body:
          '角色写真初始等级为半颗星⭐\n'
          '角色累计获得10万颗心，写真升级为⭐\n'
          '角色累计获得50万颗心，写真升级为⭐⭐\n'
          '角色累计获得100万颗心，写真升级为⭐⭐⭐\n'
          '角色累计获得300万颗心，写真升级为⭐⭐⭐⭐\n'
          '角色累计获得1000万颗心，写真升级为⭐⭐⭐⭐⭐',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: AppSizes.bookDetailCharacterHelpDialogWidthRatio,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.sizeOf(context).height *
              AppSizes.bookDetailCharacterHelpDialogMaxHeightRatio,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.dialogBackground,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(
                    color: AppColors.borderGlass,
                    width: AppSizes.hairline,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      '角色玩法说明',
                      style: AppTextStyles.titleMediumDark,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < _sections.length; i++) ...[
                              if (i > 0) const SizedBox(height: AppSpacing.md),
                              _HelpSectionBlock(section: _sections[i]),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            DialogCloseButton(onTap: AppRouter.pop),
          ],
        ),
      ),
    );
  }
}

class _HelpSectionBlock extends StatelessWidget {
  const _HelpSectionBlock({required this.section});

  final _HelpSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(section.title, style: AppTextStyles.bodyMediumDark),
        const SizedBox(height: AppSpacing.xs),
        AppText(section.body, style: AppTextStyles.bodyMediumDarkMuted),
      ],
    );
  }
}

class _HelpSection {
  const _HelpSection({required this.title, required this.body});

  final String title;
  final String body;
}
