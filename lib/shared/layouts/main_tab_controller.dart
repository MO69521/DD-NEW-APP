import '../../core/constants/main_tab_config.dart';

/// 主 Tab Shell 外部切换控制器，供子页面触发 Tab 跳转（如书架「领福利」→ 福利页）。
class MainTabController {
  void Function(int index)? _switchTo;
  final List<void Function(int index)> _tabChangeListeners = [];
  final List<void Function(String tabIntent)> _bookshelfTabIntentListeners = [];
  final List<void Function()> _bookstoreCategoryIntentListeners = [];

  void attach(void Function(int index) switchTo) {
    _switchTo = switchTo;
  }

  void detach() {
    _switchTo = null;
    _tabChangeListeners.clear();
    _bookshelfTabIntentListeners.clear();
    _bookstoreCategoryIntentListeners.clear();
  }

  void switchTo(int index) => _switchTo?.call(index);

  /// 跳转书架 Tab，并切换到指定子 Tab（书架 / 阅读历史）。
  void openBookshelfTab(String tabIntent) {
    for (final listener in List<void Function(String tabIntent)>.of(
      _bookshelfTabIntentListeners,
    )) {
      listener(tabIntent);
    }
    switchTo(MainTabConfig.bookshelfIndex);
  }

  /// 跳转书城 Tab，并切换到「分类」子 Tab。
  void openBookstoreCategoryTab() {
    for (final listener in List<void Function()>.of(
      _bookstoreCategoryIntentListeners,
    )) {
      listener();
    }
    switchTo(MainTabConfig.bookstoreIndex);
  }

  void notifyTabChanged(int index) {
    for (final listener in List.of(_tabChangeListeners)) {
      listener(index);
    }
  }

  void addTabChangeListener(void Function(int index) listener) {
    _tabChangeListeners.add(listener);
  }

  void removeTabChangeListener(void Function(int index) listener) {
    _tabChangeListeners.remove(listener);
  }

  void addBookshelfTabIntentListener(void Function(String tabIntent) listener) {
    _bookshelfTabIntentListeners.add(listener);
  }

  void removeBookshelfTabIntentListener(
    void Function(String tabIntent) listener,
  ) {
    _bookshelfTabIntentListeners.remove(listener);
  }

  void addBookstoreCategoryIntentListener(void Function() listener) {
    _bookstoreCategoryIntentListeners.add(listener);
  }

  void removeBookstoreCategoryIntentListener(void Function() listener) {
    _bookstoreCategoryIntentListeners.remove(listener);
  }
}
