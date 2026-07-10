import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/settings_document.dart';

class SettingsDocumentPage extends StatelessWidget {
  const SettingsDocumentPage({super.key, required this.document});

  final SettingsDocument document;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: document.type.title,
          onBack: AppRouter.pop,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppLayout.chromeTopHeight(context) + AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            AppText(
              document.heading,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textOnDark,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppText(
              document.updatedAt,
              style: AppTextStyles.captionMdDarkMuted,
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final section in document.sections) ...[
              _DocumentSection(section: section),
              if (section != document.sections.last)
                const SizedBox(height: AppSpacing.lg),
            ],
          ],
        ),
      ),
    );
  }
}

class _DocumentSection extends StatelessWidget {
  const _DocumentSection({required this.section});

  final SettingsDocumentSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          section.title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnDark,
            fontWeight: AppFontWeights.semibold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          section.body,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnDarkMuted,
          ),
        ),
      ],
    );
  }
}
