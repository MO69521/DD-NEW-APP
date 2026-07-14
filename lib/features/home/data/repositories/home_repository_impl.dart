import '../../domain/entities/home_info.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_data_source.dart';

/// data 层仓储实现，仅做数据获取与映射。
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._localDataSource);

  final HomeDataSource _localDataSource;

  @override
  Future<HomeInfo> getHomeInfo() => _localDataSource.fetchHomeInfo();
}
