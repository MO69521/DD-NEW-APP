import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/ranking_channel.dart';
import '../../domain/entities/ranking_dimension.dart';
import '../../domain/entities/ranking_page_content.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class RankingMockDataSource {
  const RankingMockDataSource();

  static const String _brandTitle = '点点穿书';

  Future<RankingPageContent> fetchPageContent() async {
    return RankingPageContent(
      brandTitle: _brandTitle,
      booksByDimensionChannel: {
        for (final dimension in RankingDimension.values)
          dimension: _channelsFor(dimension),
      },
    );
  }

  Map<RankingChannel, List<Book>> _channelsFor(RankingDimension dimension) {
    final all = _booksFor(dimension);
    return {
      RankingChannel.all: all,
      // 女频 / 男频先以子集模拟，接真实接口时替换为分频道返回。
      RankingChannel.female: _subset(all, RankingChannel.female),
      RankingChannel.male: _subset(all, RankingChannel.male),
    };
  }

  /// 频道子集：女频取偶数位、男频取奇数位，保证两列表视觉不同。
  List<Book> _subset(List<Book> source, RankingChannel channel) {
    final offset = channel == RankingChannel.female ? 0 : 1;
    return [
      for (var i = offset; i < source.length; i += 2) source[i],
    ];
  }

  List<Book> _booksFor(RankingDimension dimension) {
    final prefix = dimension.name;
    return [
      for (var i = 0; i < _templates.length; i++)
        Book(
          id: '${prefix}_${i + 1}',
          title: _templates[i].$1,
          category: _templates[i].$2,
          coverAsset: _templates[i].$3,
        ),
    ];
  }

  /// (title, category, coverAsset) 模板，循环复用本地封面资源。
  static const List<(String, String, String)> _templates = [
    ('病态沉溺：少将军柔软可妻', '病娇总裁', 'assets/covers/cover_01.png'),
    ('穿书后我成了团宠', '穿书甜宠', 'assets/covers/cover_02.png'),
    ('重生之嫡女归来', '古言重生', 'assets/covers/cover_03.png'),
    ('偏执大佬的掌心宠', '病娇总裁', 'assets/covers/cover_04.png'),
    ('豪门千金她不装了', '豪门爽文', 'assets/covers/cover_05.png'),
    ('我在异世开酒楼', '玄幻种田', 'assets/covers/cover_06.png'),
    ('清冷仙尊他破戒了', '仙侠言情', 'assets/covers/cover_01.png'),
    ('退婚后我惊艳全场', '豪门爽文', 'assets/covers/cover_05.png'),
    ('闪婚后大佬他真香了', '先婚后爱', 'assets/covers/cover_04.png'),
    ('离婚后前夫他后悔了', '追妻火葬场', 'assets/covers/cover_03.png'),
  ];
}
