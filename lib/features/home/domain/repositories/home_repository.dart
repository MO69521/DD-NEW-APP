import '../entities/home_info.dart';

/// 领域层仓储契约，data 层实现此接口。
abstract interface class HomeRepository {
  Future<HomeInfo> getHomeInfo();
}
