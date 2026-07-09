import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_blurred_dialog.dart';
import '../../../../shared/components/dialog_close_button.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/currency_wallet_page_content.dart';

class CurrencyInfoDialog extends StatelessWidget {
  const CurrencyInfoDialog({
    super.key,
    required this.title,
    required this.sections,
    required this.onClose,
  });

  final String title;
  final List<CurrencyInfoSection> sections;
  final VoidCallback onClose;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<CurrencyInfoSection> sections,
  }) {
    return showAppBlurredDialog<void>(
      context: context,
      builder: (context) => CurrencyInfoDialog(
        title: title,
        sections: sections,
        onClose: () => AppRouter.pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.72;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: AppColors.dialogBackground,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AppText(
                        title,
                        style: AppTextStyles.titleMediumDark,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    for (var i = 0; i < sections.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.md),
                      _CurrencyInfoSectionView(section: sections[i]),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(
                      label: '我知道了',
                      variant: AppButtonVariant.accent,
                      isExpanded: true,
                      onPressed: onClose,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.lg,
            right: AppSpacing.lg,
            child: DialogCloseButton(onTap: onClose),
          ),
        ],
      ),
    );
  }
}

class _CurrencyInfoSectionView extends StatelessWidget {
  const _CurrencyInfoSectionView({required this.section});

  final CurrencyInfoSection section;

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
