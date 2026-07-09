import '../domain/entities/user_basic_info.dart';

/// 新手基础信息收集状态服务（进程内单例）。
///
/// 新用户首次进入首页时需收集性别 / 年龄；完成后本会话不再提示。
/// 后续可替换为持久化实现（本地存储 / 后端）。
class OnboardingService {
  bool _basicInfoCollected = false;
  UserGender? _gender;
  UserAgeRange? _ageRange;

  /// 是否仍需收集新手基础信息。
  bool get needsBasicInfo => !_basicInfoCollected;

  UserGender? get gender => _gender;
  UserAgeRange? get ageRange => _ageRange;

  /// 记录用户选择并标记为已完成。
  void completeBasicInfo({
    required UserGender gender,
    required UserAgeRange ageRange,
  }) {
    _gender = gender;
    _ageRange = ageRange;
    _basicInfoCollected = true;
  }
}
