import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/currency_config.dart';
import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_swipe_tab_switcher.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/elastic_tab_indicator.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../application/energy_records_cubit.dart';
import '../../application/energy_records_state.dart';
import '../../domain/entities/currency_wallet_page_content.dart';

class EnergyRecordsPage extends StatefulWidget {
  const EnergyRecordsPage({super.key});

  @override
  State<EnergyRecordsPage> createState() => _EnergyRecordsPageState();
}

class _EnergyRecordsPageState extends State<EnergyRecordsPage> {
  late final ValueNotifier<double> _tabSwipeProgress;

  @override
  void initState() {
    super.initState();
    _tabSwipeProgress = ValueNotifier<double>(0);
  }

  @override
  void dispose() {
    _tabSwipeProgress.dispose();
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
          title: '充值记录',
          onBack: AppRouter.pop,
        ),
        body: BlocBuilder<EnergyRecordsCubit, EnergyRecordsState>(
          builder: (context, state) {
            if (state.phase == EnergyRecordsPhase.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return EmptyState(
                title: '加载失败',
                description: state.errorMessage,
                action: AppButton(
                  label: '重试',
                  onPressed: () => context.read<EnergyRecordsCubit>().load(),
                ),
              );
            }

            final content = state.content;
            if (content == null) {
              return const EmptyState(title: '暂无记录');
            }

            const tabs = EnergyRecordsTab.values;

            return Padding(
              padding: EdgeInsets.only(top: AppLayout.chromeTopHeight(context)),
              child: Column(
                children: [
                  EnergyRecordsTabBar(
                    selectedTab: state.selectedTab,
                    onTabTap: context.read<EnergyRecordsCubit>().selectTab,
                    swipeProgress: _tabSwipeProgress,
                  ),
                  Expanded(
                    child: AppSwipeTabSwitcher(
                      selectedIndex: tabs.indexOf(state.selectedTab),
                      onSwipeProgressChanged: (progress) =>
                          _tabSwipeProgress.value = progress,
                      onIndexChanged: (index) => context
                          .read<EnergyRecordsCubit>()
                          .selectTab(tabs[index]),
                      children: [
                        content.rechargeRecords.isEmpty
                            ? const EnergyRecordsEmptyView()
                            : EnergyRecordsList(
                                records: content.rechargeRecords,
                              ),
                        content.otherRecords.isEmpty
                            ? const EnergyRecordsEmptyView()
                            : EnergyRecordsList(records: content.otherRecords),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class EnergyRecordsTabBar extends StatelessWidget {
  const EnergyRecordsTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabTap,
    this.swipeProgress,
  });

  final EnergyRecordsTab selectedTab;
  final ValueChanged<EnergyRecordsTab> onTabTap;

  /// 内容区左右滑动的连续进度（0..tabCount-1），驱动指示器跟手位移。
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    const tabs = EnergyRecordsTab.values;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderGlass,
            width: AppSizes.hairline,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slotWidth = constraints.maxWidth / tabs.length;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  for (final tab in tabs)
                    Expanded(
                      child: _EnergyRecordsTabItem(
                        tab: tab,
                        isSelected: tab == selectedTab,
                        onTap: () => onTabTap(tab),
                      ),
                    ),
                ],
              ),
              ElasticTabIndicator(
                selectedIndex: tabs.indexOf(selectedTab),
                slotWidth: slotWidth,
                slotPitch: slotWidth,
                swipeProgress: swipeProgress,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EnergyRecordsTabItem extends StatelessWidget {
  const _EnergyRecordsTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final EnergyRecordsTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: SizedBox(
        height: AppSizes.topBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppText(
              tab.label,
              style:
                  (isSelected
                          ? AppTextStyles.bodyMediumDark
                          : AppTextStyles.bodyMediumDarkMuted)
                      .copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnergyRecordsList extends StatelessWidget {
  const EnergyRecordsList({super.key, required this.records});

  final List<CurrencyLedgerRecord> records;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      itemBuilder: (context, index) {
        return EnergyRecordRow(record: records[index]);
      },
      separatorBuilder: (context, index) =>
          const Divider(height: AppSpacing.lg, color: AppColors.borderGlass),
      itemCount: records.length,
    );
  }
}

class EnergyRecordRow extends StatelessWidget {
  const EnergyRecordRow({super.key, required this.record});

  final CurrencyLedgerRecord record;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(record.title, style: AppTextStyles.bodyMediumDark),
              const SizedBox(height: AppSpacing.xxs),
              AppText(
                record.timeLabel,
                style: AppTextStyles.bodyMediumDarkMuted,
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              record.amountDelta > 0
                  ? '+${record.amountDelta}'
                  : '${record.amountDelta}',
              style: AppTextStyles.titleMediumDark.copyWith(
                color: AppColors.bookDetailUpdateTextHighlighted,
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            AppAssetImage(
              assetPath: CurrencyConfig.iconAsset(CurrencyType.energy),
              width: AppSizes.welfareCurrencyIconSize,
              height: AppSizes.welfareCurrencyIconSize,
            ),
          ],
        ),
      ],
    );
  }
}

class EnergyRecordsEmptyView extends StatelessWidget {
  const EnergyRecordsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.myMessagesEmptyIllustrationSize,
            height: AppSizes.myMessagesEmptyIllustrationSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderGlass),
            ),
            child: AppText(
              '!',
              style: AppTextStyles.displayLarge.copyWith(
                color: AppColors.accentYellow,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppText('暂无记录', style: AppTextStyles.bodyMediumDarkMuted),
        ],
      ),
    );
  }
}
