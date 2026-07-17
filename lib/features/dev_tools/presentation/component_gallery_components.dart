part of 'component_gallery_page.dart';

class _ComponentGallery extends StatelessWidget {
  const _ComponentGallery({
    required this.topTabIndex,
    required this.segmentedIndex,
    required this.switchValue,
    required this.onTopTabSelected,
    required this.onSegmentedChanged,
    required this.onSwitchChanged,
    required this.onToast,
    required this.onDialog,
  });

  final int topTabIndex;
  final int segmentedIndex;
  final bool switchValue;
  final ValueChanged<int> onTopTabSelected;
  final ValueChanged<int> onSegmentedChanged;
  final ValueChanged<bool> onSwitchChanged;
  final VoidCallback onToast;
  final VoidCallback onDialog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GallerySection(title: '按钮', child: _buildButtons()),
        _GallerySection(title: '导航与切换', child: _buildNavigation()),
        _GallerySection(title: '列表与表单', child: _buildListAndForm()),
        _GallerySection(title: '反馈与空状态', child: _buildFeedback()),
        _GallerySection(title: '书籍卡片', child: _buildBookCards()),
        _GallerySection(title: '业务组件', child: _buildFeatureBlocks()),
      ],
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppButton(
          label: '主按钮 Accent',
          variant: AppButtonVariant.accent,
          onPressed: onToast,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: '次按钮 Secondary',
                variant: AppButtonVariant.secondary,
                onPressed: onToast,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: '高亮态 VIP',
                variant: AppButtonVariant.vip,
                onPressed: onToast,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Small',
                variant: AppButtonVariant.accent,
                size: AppButtonSize.small,
                onPressed: onToast,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppButton(
                label: 'Compact',
                variant: AppButtonVariant.secondary,
                size: AppButtonSize.compact,
                onPressed: onToast,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const Row(
          children: [
            AppButton(
              label: '加载中',
              variant: AppButtonVariant.accent,
              isLoading: true,
            ),
            SizedBox(width: AppSpacing.sm),
            AppButton(label: '禁用态', variant: AppButtonVariant.accent),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: '带图标按钮',
          variant: AppButtonVariant.accent,
          size: AppButtonSize.small,
          onPressed: onToast,
          leadingIcon: const AppAssetImage(
            assetPath: 'assets/icons/welfare/energy.svg',
            width: AppSizes.bookshelfClaimWelfareIconSize,
            height: AppSizes.bookshelfClaimWelfareIconSize,
          ),
          iconLabelGap: AppSizes.buttonIconLabelGapTight,
        ),
        const SizedBox(height: AppSpacing.xs),
        const _CaptionNote(text: '覆盖主按钮、次按钮、高亮态、不同尺寸、带图标、loading、disabled。'),
      ],
    );
  }

  Widget _buildNavigation() {
    const tabs = [
      AppTopTabItem(label: '推荐'),
      AppTopTabItem(label: '消息', badgeCount: 3),
      AppTopTabItem(label: '关注'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: AppTopTabBar(
            items: tabs,
            selectedIndex: topTabIndex,
            onSelected: onTopTabSelected,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppText('Tab 数字角标', style: AppTextStyles.labelMediumDark),
            const AppTabCountBadge(count: 3),
            const AppTabCountBadge(count: 128),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        AppSegmentedSwitch(
          itemCount: 3,
          selectedIndex: segmentedIndex,
          onChanged: onSegmentedChanged,
          itemBuilder: (context, index, isSelected) {
            final labels = ['全部', '男频', '女频'];
            return AppText(
              labels[index],
              style:
                  (isSelected
                          ? AppTextStyles.labelMediumDark
                          : AppTextStyles.labelMediumDark.copyWith(
                              color: AppColors.textOnDarkMuted,
                            ))
                      .copyWith(
                        color: isSelected ? AppColors.accentYellow : null,
                      ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListAndForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppDigitCodeInput(
          value: '12',
          length: 4,
          obscureText: true,
          autoFocus: false,
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSpacing.md),
        AppGroupedListCard(
          title: '设置列表',
          children: [
            const AppNavigationListRow(label: '阅读偏好', trailingText: '默认'),
            AppNavigationListRow(
              label: '推送通知',
              subtitle: '展示副标题和右侧控件',
              trailing: AppSwitch(
                value: switchValue,
                onChanged: onSwitchChanged,
              ),
              showChevron: false,
            ),
            const AppNavigationListRow(label: '帮助与反馈', trailingText: '去看看'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedback() {
    return Column(
      children: [
        EmptyState(
          title: '暂无内容',
          description: '这里展示通用空状态的标题、说明与行动按钮。',
          action: AppButton(
            label: '刷新试试',
            variant: AppButtonVariant.accent,
            size: AppButtonSize.small,
            onPressed: onToast,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: '查看统一弹窗遮罩',
          variant: AppButtonVariant.secondary,
          isExpanded: true,
          onPressed: onDialog,
        ),
      ],
    );
  }

  Widget _buildBookCards() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BookGridCard(
            title: '星河入梦时',
            category: '幻想言情',
            coverAsset: 'assets/covers/cover_01.png',
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: BookGridCard(
            title: '长标题书名用于检查换行边界',
            category: '都市脑洞',
            coverAsset: 'assets/covers/cover_02.png',
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureBlocks() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: AppGradientCtaButton(
            gradientColors: const [
              AppMembershipColors.ctaGradientStart,
              AppMembershipColors.ctaGradientEnd,
            ],
            height: AppSizes.membershipCtaHeight,
            borderRadius: AppRadius.membershipCta,
            sweepHighlight: AppMembershipColors.ctaSweepHighlight,
            sweepEdge: AppMembershipColors.ctaSweepEdge,
            loadingColor: AppMembershipColors.ctaText,
            onTap: onToast,
            child: AppText(
              '强 CTA · 呼吸 + 扫光 + 液态边缘',
              style: AppTextStyles.buttonLabel16.copyWith(
                color: AppMembershipColors.ctaText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DailyReadingBanner(todayReadingMinutes: 48, onClaimWelfareTap: onToast),
        const SizedBox(height: AppSpacing.md),
        const _AssetPreviewCard(),
      ],
    );
  }
}
