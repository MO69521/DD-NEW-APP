import 'package:flutter/material.dart';

import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/components/app_toast.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/share_bottom_sheet.dart';

/// 详情页顶部悬浮栏：滚动进入内容区后显示毛玻璃底 + 标题，含分享入口。
class BookDetailTopBar extends StatelessWidget {
  const BookDetailTopBar({
    super.key,
    required this.statusBarHeight,
    required this.blurEnabled,
    required this.title,
  });

  final double statusBarHeight;
  final bool blurEnabled;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBlurredChromeBar(
        enabled: blurEnabled,
        child: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: blurEnabled ? title : null,
          showScrim: true,
          chromeBlurEnabled: false,
          onBack: () => AppRouter.pop(),
          actions: [
            AppTopBarAction(
              iconAsset: 'assets/icons/ranking/share.svg',
              onTap: () => ShareBottomSheet.show(
                context,
                onChannelTap: (channel) =>
                    AppToast.show(context, '分享到$channel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
