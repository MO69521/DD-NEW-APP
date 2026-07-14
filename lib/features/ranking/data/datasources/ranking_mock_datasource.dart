import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/ranking_channel.dart';
import '../../domain/entities/ranking_dimension.dart';
import '../../domain/entities/ranking_page_content.dart';
import 'ranking_data_source.dart';

/// Mock 数据源：Phase 1 静态数据；真实接口实现请照 bookstore/search 范例补 remote datasource。
class RankingMockDataSource implements RankingDataSource {
  const RankingMockDataSource();

  static const String _brandTitle = '点点穿书';
  static const int _pageSize = 10;

  @override
  Future<RankingPageContent> fetchPageContent() async {
    return RankingPageContent(
      brandTitle: _brandTitle,
      booksByDimensionChannel: {
        for (final dimension in RankingDimension.values)
          dimension: _channelsFor(dimension, page: 1),
      },
    );
  }

  /// 加载更多书籍（分页）。
  @override
  Future<List<Book>> fetchMoreBooks({
    required RankingDimension dimension,
    required RankingChannel channel,
    required int page,
  }) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 500));

    final allBooks = _booksFor(dimension, page: page);

    if (channel == RankingChannel.all) {
      return allBooks;
    }

    // 女频 / 男频子集
    return _subset(allBooks, channel);
  }

  Map<RankingChannel, List<Book>> _channelsFor(
    RankingDimension dimension, {
    required int page,
  }) {
    final all = _booksFor(dimension, page: page);
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
    return [for (var i = offset; i < source.length; i += 2) source[i]];
  }

  List<Book> _booksFor(RankingDimension dimension, {required int page}) {
    final prefix = dimension.name;
    final startIndex = (page - 1) * _pageSize;

    return [
      for (var i = 0; i < _pageSize; i++)
        () {
          final templateIndex = (startIndex + i) % _templates.length;
          return Book(
            id: '${prefix}_${startIndex + i + 1}',
            title: _templates[templateIndex].$1,
            category: _templates[templateIndex].$2,
            coverAsset: _templates[templateIndex].$3,
            summary: _templates[templateIndex].$4,
          );
        }(),
    ];
  }

  /// (title, category, coverAsset, summary) 模板，循环复用本地封面资源。
  static const List<(String, String, String, String)> _templates = [
    (
      '病态沉溺：少将军柔软可妻',
      '病娇总裁',
      'assets/covers/cover_01.png',
      '【追逐监禁+生存+团宠】一夜间，成为反派病娇的白月光，并被他囚禁在地下室中！',
    ),
    (
      '穿书后我成了团宠',
      '穿书甜宠',
      'assets/covers/cover_02.png',
      '意外穿进虐文后，她凭借清醒脑回路逆转剧情，被全员偏爱守护。',
    ),
    (
      '重生之嫡女归来',
      '古言重生',
      'assets/covers/cover_03.png',
      '前世错信他人含恨而终，今生归来，她要把失去的一切亲手夺回。',
    ),
    (
      '偏执大佬的掌心宠',
      '病娇总裁',
      'assets/covers/cover_04.png',
      '所有人都怕那位冷面大佬，只有她知道，他把全部温柔都藏在掌心。',
    ),
    (
      '豪门千金她不装了',
      '豪门爽文',
      'assets/covers/cover_05.png',
      '真假千金风波后，她不再隐藏实力，一路打脸逆袭成豪门焦点。',
    ),
    (
      '我在异世开酒楼',
      '玄幻种田',
      'assets/covers/cover_06.png',
      '穿到异世后，她从一间小酒楼开始，把烟火人间开成传奇。',
    ),
    (
      '清冷仙尊他破戒了',
      '仙侠言情',
      'assets/covers/cover_01.png',
      '清冷仙尊本该断情绝爱，却在一次次相护中为她破戒动心。',
    ),
    (
      '退婚后我惊艳全场',
      '豪门爽文',
      'assets/covers/cover_05.png',
      '被退婚当日，她换上礼服登场，从此让所有轻视她的人后悔。',
    ),
    (
      '闪婚后大佬他真香了',
      '先婚后爱',
      'assets/covers/cover_04.png',
      '一纸协议绑定两人，本想各取所需，却在相处中逐渐沦陷。',
    ),
    (
      '离婚后前夫他后悔了',
      '追妻火葬场',
      'assets/covers/cover_03.png',
      '离开后她光芒万丈，前夫终于明白自己错过了怎样的珍宝。',
    ),
  ];
}
