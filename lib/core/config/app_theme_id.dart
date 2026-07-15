/// 编译期主题包 id（纯 Dart，无 Flutter 依赖）。
///
/// `--dart-define=THEME=<id>`，默认 `yellow_dark`。供 domain 层与资源路径解析使用；
/// UI 颜色分支仍走 [AppBrandColors]。
abstract final class AppThemeId {
  static const String value = String.fromEnvironment(
    'THEME',
    defaultValue: 'yellow_dark',
  );

  static const String pinkLight = 'pink_light';
  static const String yellowLight = 'yellow_light';
  static const String yellowDark = 'yellow_dark';

  /// 资源包目录名：仅识别已知三包，其余回退 yellow_dark。
  static const String assetPack = value == pinkLight
      ? pinkLight
      : value == yellowLight
      ? yellowLight
      : yellowDark;
}
