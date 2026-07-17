import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_layout.dart';
import '../../../core/theme/app_membership_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_sizes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../features/bookshelf/presentation/components/daily_reading_banner.dart';
import '../../../shared/components/app_blurred_dialog.dart';
import '../../../shared/components/app_confirm_dialog.dart';
import '../../../shared/components/app_gradient_cta_button.dart';
import '../../../shared/components/app_grouped_list_card.dart';
import '../../../shared/components/app_navigation_list_row.dart';
import '../../../shared/components/app_segmented_switch.dart';
import '../../../shared/components/app_tab_count_badge.dart';
import '../../../shared/components/app_toast.dart';
import '../../../shared/components/app_top_bar.dart';
import '../../../shared/components/app_top_tab_bar.dart';
import '../../../shared/components/book_grid_card.dart';
import '../../../shared/components/empty_state.dart';
import '../../../shared/widgets/app_asset_image.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_digit_code_input.dart';
import '../../../shared/widgets/app_switch.dart';
import '../../../shared/widgets/app_text.dart';

part 'component_gallery_widgets.dart';
part 'component_gallery_foundation.dart';
part 'component_gallery_components.dart';
part 'component_gallery_feature_blocks.dart';

/// 开发期真实 Flutter 组件总览，用于从组件维度检查产品内最终渲染样式。
class ComponentGalleryPage extends StatefulWidget {
  const ComponentGalleryPage({super.key});

  @override
  State<ComponentGalleryPage> createState() => _ComponentGalleryPageState();
}

class _ComponentGalleryPageState extends State<ComponentGalleryPage> {
  int _sectionIndex = 0;
  int _topTabIndex = 0;
  int _segmentedIndex = 0;
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          AppTopBar(
            statusBarHeight: statusBarHeight,
            title: '组件总览',
            actions: [AppTopBarAction(label: 'Toast', onTap: _showToast)],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.xxl,
              ),
              children: [
                const _GalleryIntro(),
                const SizedBox(height: AppSpacing.lg),
                AppSegmentedSwitch(
                  itemCount: 2,
                  selectedIndex: _sectionIndex,
                  onChanged: (index) => setState(() => _sectionIndex = index),
                  itemBuilder: (context, index, isSelected) {
                    final labels = ['基础规范', '组件'];
                    return AppText(
                      labels[index],
                      style:
                          (isSelected
                                  ? AppTextStyles.labelMediumDark
                                  : AppTextStyles.labelMediumDark.copyWith(
                                      color: AppColors.textOnDarkMuted,
                                    ))
                              .copyWith(
                                color: isSelected
                                    ? AppColors.accentYellow
                                    : null,
                              ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_sectionIndex == 0)
                  const _FoundationGallery()
                else
                  _ComponentGallery(
                    topTabIndex: _topTabIndex,
                    segmentedIndex: _segmentedIndex,
                    switchValue: _switchValue,
                    onTopTabSelected: (index) =>
                        setState(() => _topTabIndex = index),
                    onSegmentedChanged: (index) =>
                        setState(() => _segmentedIndex = index),
                    onSwitchChanged: (value) =>
                        setState(() => _switchValue = value),
                    onToast: _showToast,
                    onDialog: _showDialogSample,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showToast() {
    AppToast.show(context, '组件交互已触发');
  }

  void _showDialogSample() {
    showAppBlurredDialog<void>(
      context: context,
      builder: (_) => const AppConfirmDialog(
        title: '确认弹窗',
        message: '这里展示真实弹窗本体和统一 80% 黑色遮罩。',
        primaryLabel: '知道了',
        showCloseButton: true,
      ),
    );
  }
}
