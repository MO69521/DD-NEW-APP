import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_benefit_detail.dart';

/// 会员特权详情页（横向滑动展示各项特权）。
class MembershipBenefitsDetailPage extends StatefulWidget {
  const MembershipBenefitsDetailPage({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<MembershipBenefitsDetailPage> createState() =>
      _MembershipBenefitsDetailPageState();
}

class _MembershipBenefitsDetailPageState
    extends State<MembershipBenefitsDetailPage> {
  late final PageController _pageController;
  late int _currentIndex;

  // Mock 数据 - 实际应从 Cubit/Repository 获取
  final List<MembershipBenefitDetail> _benefits = const [
    MembershipBenefitDetail(
      id: 'checkin',
      iconAsset: 'assets/icons/membership/benefit_checkin.png',
      label: '签到奖励',
      description: '每日登录可以额外领取100能量。',
      exampleImageAsset: 'assets/images/membership/benefit_checkin_example.png',
    ),
    MembershipBenefitDetail(
      id: 'reading',
      iconAsset: 'assets/icons/membership/benefit_reading.png',
      label: '阅读奖励',
      description: '每日阅读获得奖励，比普通用户多获得双倍奖励，让阅读更有效率。',
      exampleImageAsset: 'assets/images/membership/benefit_reading_example.png',
    ),
    MembershipBenefitDetail(
      id: 'energy',
      iconAsset: 'assets/icons/membership/benefit_energy.png',
      label: '能量加成',
      description: '每日任务能量加成，让你更快积累能量。',
      exampleImageAsset: 'assets/images/membership/benefit_energy_example.png',
    ),
    MembershipBenefitDetail(
      id: 'outfit',
      iconAsset: 'assets/icons/membership/benefit_outfit.png',
      label: '专属服装',
      description: '解锁专属会员服装，展示你的独特身份。',
      exampleImageAsset: 'assets/images/membership/benefit_outfit_example.png',
    ),
    MembershipBenefitDetail(
      id: 'theatre',
      iconAsset: 'assets/icons/membership/benefit_theatre.png',
      label: '专属小剧场',
      description: '独享专属小剧场内容，更多精彩等你探索。',
      exampleImageAsset:
          'assets/images/membership/benefit_theatre_example.png',
    ),
    MembershipBenefitDetail(
      id: 'nickname',
      iconAsset: 'assets/icons/membership/benefit_nickname.png',
      label: '金色昵称',
      description: '获得金色昵称显示，彰显尊贵身份。',
      exampleImageAsset:
          'assets/images/membership/benefit_nickname_example.png',
    ),
    MembershipBenefitDetail(
      id: 'badge',
      iconAsset: 'assets/icons/membership/benefit_badge.png',
      label: '会员标识',
      description: '专属会员标识，让你在社区中脱颖而出。',
      exampleImageAsset: 'assets/images/membership/benefit_badge_example.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _benefits.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '会员特权',
          onBack: AppRouter.pop,
        ),
        body: Column(
          children: [
            SizedBox(height: AppLayout.chromeTopHeight(context)),
            // 顶部图标导航
            _BenefitIconNav(
              benefits: _benefits,
              currentIndex: _currentIndex,
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            // 滑动卡片区
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _benefits.length,
                itemBuilder: (context, index) {
                  return _BenefitDetailCard(benefit: _benefits[index]);
                },
              ),
            ),
            // 页面指示器
            _PageIndicator(
              count: _benefits.length,
              currentIndex: _currentIndex,
            ),
            const SizedBox(height: AppSpacing.lg),
            // 底部开通按钮
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: AppButton(
                label: '立即开通会员',
                variant: AppButtonVariant.accent,
                isExpanded: true,
                onPressed: () {
                  // TODO: 导航到会员页
                  AppRouter.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 顶部图标导航栏。
class _BenefitIconNav extends StatelessWidget {
  const _BenefitIconNav({
    required this.benefits,
    required this.currentIndex,
    required this.onTap,
  });

  final List<MembershipBenefitDetail> benefits;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF4E0),
            Color(0xFFFFE8C8),
          ],
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        itemCount: benefits.length,
        itemBuilder: (context, index) {
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xFFFFBF5F)
                          : Colors.white.withValues(alpha: 0.6),
                      border: isSelected
                          ? Border.all(
                              color: const Color(0xFFFF9800),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Icon(
                        _getIconData(benefits[index].id),
                        size: 32,
                        color: const Color(0xFFD97706),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  AppText(
                    benefits[index].label,
                    style: AppTextStyles.captionMd.copyWith(
                      color: isSelected
                          ? const Color(0xFFD97706)
                          : const Color(0xFF92400E),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconData(String id) {
    switch (id) {
      case 'checkin':
        return Icons.calendar_today_rounded;
      case 'reading':
        return Icons.menu_book_rounded;
      case 'energy':
        return Icons.bolt_rounded;
      case 'outfit':
        return Icons.checkroom_rounded;
      case 'theatre':
        return Icons.theater_comedy_rounded;
      case 'nickname':
        return Icons.badge_rounded;
      case 'badge':
        return Icons.verified_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}

/// 特权详情卡片。
class _BenefitDetailCard extends StatelessWidget {
  const _BenefitDetailCard({required this.benefit});

  final MembershipBenefitDetail benefit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 白色卡片
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题
                AppText(
                  benefit.label,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                // 描述
                AppText(
                  benefit.description,
                  style: AppTextStyles.bodyMediumDark.copyWith(
                    color: const Color(0xFF6B7280),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // 示例图片占位
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          AppText(
                            '示例图占位',
                            style: AppTextStyles.captionMd.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 页面指示器。
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentIndex ? 16 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == currentIndex
                ? const Color(0xFFFFBF5F)
                : AppColors.white20,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
      ),
    );
  }
}
