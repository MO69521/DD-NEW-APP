import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/membership_benefits_detail_cubit.dart';
import '../../application/membership_benefits_detail_state.dart';
import '../../domain/entities/membership_benefit.dart';
import '../../domain/entities/membership_benefit_detail.dart';
import '../components/membership_benefit_detail_card.dart';
import '../components/membership_benefit_item.dart';
import '../components/membership_cta_button.dart';
import '../../../../shared/components/app_page_dots.dart';

/// 会员特权详情页（横向滑动展示各项特权）。
class MembershipBenefitsDetailPage extends StatefulWidget {
  const MembershipBenefitsDetailPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MembershipBenefitsDetailPage> createState() =>
      _MembershipBenefitsDetailPageState();
}

class _MembershipBenefitsDetailPageState
    extends State<MembershipBenefitsDetailPage> {
  late final PageController _pageController;
  late int _currentIndex;

  static const double _cardSideScaleMin = 0.9;
  static const double _cardSideOpacityMin = 0.72;
  static const double _cardPerspective = 0.0012;
  static const double _cardMaxRotateY = 0.12;
  static const double _cardViewportFraction = 0.86;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: _cardViewportFraction,
    );
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
        body:
            BlocBuilder<
              MembershipBenefitsDetailCubit,
              MembershipBenefitsDetailState
            >(
              builder: (context, state) {
                if (state.isLoading || state.benefits.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildContent(context, state.benefits);
              },
            ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<MembershipBenefitDetail> benefits,
  ) {
    final currentIndex = _currentIndex.clamp(0, benefits.length - 1);

    return Column(
      children: [
        SizedBox(height: AppLayout.chromeTopHeight(context) + AppSpacing.xxl),
        // 顶部图标导航
        _BenefitIconNav(
          benefits: benefits,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            _pageController.animateToPage(
              index,
              duration: AppDurations.containerTransform,
              curve: Curves.easeOutCubic,
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // 滑动卡片区
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            onPageChanged: (index) {
              if (_currentIndex == index) return;
              setState(() => _currentIndex = index);
            },
            itemCount: benefits.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  final page = _pageController.hasClients
                      ? _pageController.page ?? currentIndex.toDouble()
                      : currentIndex.toDouble();
                  final delta = (index - page).clamp(-1.0, 1.0);
                  final distance = delta.abs();
                  final scale =
                      1 -
                      (1 - _cardSideScaleMin) *
                          Curves.easeOut.transform(distance);
                  final opacity = 1 - (1 - _cardSideOpacityMin) * distance;
                  final translateY = AppSpacing.md * distance;
                  final matrix = Matrix4.identity()
                    ..setEntry(3, 2, _cardPerspective)
                    ..rotateY(-delta * _cardMaxRotateY);

                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform(
                        transform: matrix,
                        alignment: Alignment.center,
                        child: Transform.scale(scale: scale, child: child),
                      ),
                    ),
                  );
                },
                child: MembershipBenefitDetailCard(benefit: benefits[index]),
              );
            },
          ),
        ),
        // 页面指示器（复用会员 Hero 分页器）
        AppPageDots(count: benefits.length, current: currentIndex),
        const SizedBox(height: AppSpacing.lg),
        // 底部开通按钮（复用会员开通 CTA：金色渐变 + 呼吸缩放 + 扫光）
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: MembershipCtaButton(
            onTap: AppRouter.pop,
            child: AppText('立即开通会员', style: AppTextStyles.membershipCtaLabel),
          ),
        ),
      ],
    );
  }
}

/// 顶部图标导航栏：复用会员页权益图标（[MembershipBenefitItem]），选中态加金描边。
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
    return SizedBox(
      height: AppSizes.membershipBenefitNavHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: benefits.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final detail = benefits[index];
          final selected = index == currentIndex;
          return AnimatedContainer(
            duration: AppDurations.containerTransform,
            curve: Curves.easeOutCubic,
            width:
                AppSizes.membershipBenefitIconCircle *
                (selected ? MembershipBenefitItem.selectedScale : 1),
            child: Center(
              child: MembershipBenefitItem(
                benefit: MembershipBenefit(
                  id: detail.id,
                  iconAsset: detail.iconAsset,
                  label: detail.label,
                ),
                selected: selected,
                showLabel: false,
                onTap: () => onTap(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
