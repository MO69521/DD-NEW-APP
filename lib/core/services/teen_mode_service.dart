/// 青少年模式共享状态。
///
/// 当前原型仅在应用进程内保存开启状态；密码本身不在内存中持久化。
class TeenModeService {
  bool _isEnabled = false;

  bool get isEnabled => _isEnabled;

  void enable() {
    _isEnabled = true;
  }
}
