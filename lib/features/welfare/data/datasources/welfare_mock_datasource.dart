import '../../../../core/constants/currency_mock_data.dart';
import '../../domain/entities/welfare_models.dart';
import '../../domain/entities/welfare_page_content.dart';
import 'welfare_data_source.dart';

part 'welfare_mock_recharge.dart';
part 'welfare_mock_check_in.dart';
part 'welfare_mock_tasks.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
///
/// 静态样本数据按主题拆分到同库 part 文件：
/// - 充值套餐 → `welfare_mock_recharge.dart`
/// - 签到 / 阅读福利 / 吃饭签到 → `welfare_mock_check_in.dart`
/// - 精选阅读奖励 / 任务列表 → `welfare_mock_tasks.dart`
class WelfareMockDataSource implements WelfareDataSource {
  const WelfareMockDataSource();

  @override
  Future<WelfarePageContent> fetchPageContent() async {
    return const WelfarePageContent(
      currencyBalances: CurrencyMockData.welfareBalances,
      vipMonthlyEnergy: _vipMonthlyEnergy,
      vipPriceYuan: _vipPriceYuan,
      rechargePackages: _rechargePackages,
      checkInSummary: _checkInSummary,
      readingWelfareSummary: _readingWelfareSummary,
      mealCheckInSummary: _mealCheckInSummary,
      featuredReadingReward: _featuredReadingReward,
      taskListSummary: _taskListSummary,
    );
  }
}

const int _vipMonthlyEnergy = 1000;
const double _vipPriceYuan = 4.9;
