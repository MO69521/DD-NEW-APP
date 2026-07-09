# Lottie 动画资源目录

把 Lottie 动画 JSON 放在此目录（如 `assets/lottie/empty_bookshelf.json`），
然后用 `AppLottie`（`lib/shared/components/app_lottie.dart`）引用：

```dart
AppLottie(asset: 'assets/lottie/empty_bookshelf.json')
```

该目录已在 `pubspec.yaml` 的 `flutter/assets` 中声明；本 README 仅为占位，
使目录非空，避免构建时报「空资源目录」。放入真实 JSON 后可删除或保留本文件。
