/// 编译期主题包 id（纯 Dart，无 Flutter 依赖）。
///
/// `--dart-define=THEME=<id>`，默认 `dark`。供 domain 层与资源路径解析使用；
/// UI 颜色分支仍走 [AppBrandColors]。
abstract final class AppThemeId {
  static const String value = String.fromEnvironment(
    'THEME',
    defaultValue: 'dark',
  );

  static const String pinkLight = 'pink_light';
  static const String yellowLight = 'yellow_light';
  static const String dark = 'dark';

  /// 资源包目录名：仅识别已知三包，其余回退 dark。
  static const String assetPack = value == pinkLight
      ? pinkLight
      : value == yellowLight
      ? yellowLight
      : dark;
}
