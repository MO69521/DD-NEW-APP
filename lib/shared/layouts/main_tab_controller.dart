/// 主 Tab Shell 外部切换控制器，供子页面触发 Tab 跳转（如书架「领福利」→ 福利页）。
class MainTabController {
  void Function(int index)? _switchTo;
  final List<void Function(int index)> _tabChangeListeners = [];

  void attach(void Function(int index) switchTo) {
    _switchTo = switchTo;
  }

  void detach() {
    _switchTo = null;
    _tabChangeListeners.clear();
  }

  void switchTo(int index) => _switchTo?.call(index);

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
}
