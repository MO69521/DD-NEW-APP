/// 消息列表时间展示规则（纯 Dart，无 Flutter 依赖）。
abstract final class PartnerMessageTimestampFormatter {
  /// 将 [messageAt] 格式化为设计稿约定的时间文案。
  ///
  /// 示例：`08:32`、`前天`、`3天前`、`1个月前`。
  static String format(DateTime messageAt, {DateTime? reference}) {
    final now = reference ?? DateTime.now();
    final localMessage = DateTime(
      messageAt.year,
      messageAt.month,
      messageAt.day,
      messageAt.hour,
      messageAt.minute,
    );
    final localNow = DateTime(now.year, now.month, now.day);

    if (_isSameDay(localMessage, localNow)) {
      final hour = messageAt.hour.toString().padLeft(2, '0');
      final minute = messageAt.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    final dayDiff = localNow.difference(localMessage).inDays;

    if (dayDiff == 1) {
      return '昨天';
    }
    if (dayDiff == 2) {
      return '前天';
    }
    if (dayDiff < 30) {
      return '$dayDiff天前';
    }

    final months = (dayDiff / 30).floor();
    if (months < 12) {
      return '$months个月前';
    }

    final years = (dayDiff / 365).floor();
    return '$years年前';
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
