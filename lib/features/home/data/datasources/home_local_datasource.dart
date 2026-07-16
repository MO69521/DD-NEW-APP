import '../../domain/entities/home_info.dart';
import 'home_data_source.dart';

/// 本地数据源，仅负责数据获取与 DTO 映射。
class HomeLocalDataSource implements HomeDataSource {
  const HomeLocalDataSource();

  @override
  Future<HomeInfo> fetchHomeInfo() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const HomeInfo(appName: '点点穿书', tagline: 'Feature-First 架构已就绪');
  }
}
