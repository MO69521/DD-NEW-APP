import '../../domain/entities/book_catalog_chapter.dart';
import '../../domain/entities/book_detail.dart';
import '../../domain/entities/book_discussion_filter.dart';
import '../../domain/entities/book_discussion_post.dart';
import '../../domain/entities/book_update_entry.dart';

/// Mock 数据源：Phase 1 静态数据，Phase 2 替换为 API datasource。
class BookDetailMockDataSource {
  const BookDetailMockDataSource();

  /// TODO(real-data): 按 [bookId] 请求接口；当前返回设计稿示例数据。
  Future<BookDetail> fetchDetail(String bookId) async {
    return BookDetail(
      id: bookId,
      title: '被病娇囚禁后：我混成了团宠',
      author: '白色云海',
      authorAvatarAsset: 'assets/covers/cover_02.png',
      coverAsset: 'assets/covers/cover_01.png',
      tags: const ['纯爱', '古代', '仙侠', '中式恐怖', '虐恋'],
      shelfCount: '5376',
      popularity: '235.6',
      wordCount: '5.3',
      intro:
          '作为一位古代的千金小姐，你的生活本是无忧无虑，享受着富贵与闲适。然而，'
          '某个夜晚，你意外遇见了一个名为"系统君"的神秘存在，他竟然宣称要帮助你成为女帝！'
          '你心中暗想：成为女帝的事情可以先放一边，今晚我只想继续沉浸在这份悠闲的生活中，'
          '享受这一刻的宁静与美好。',
      serialStatus: '连载中 · 更新至142章',
      discussionCount: 925,
      discussionPosts: const [
        BookDiscussionPost(
          id: 'd1',
          authorName: '衍风来',
          authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
          publishMeta: '06-21 23:32·江苏省',
          likeCount: 39,
          title: '关于现代abo的表哥建议（朝尧是下位，鸟男女皆可）',
          content:
              'A鸟 × O哥（以下只是我激情四射下的产出，ooc致歉）\\n'
              '某狼的发*期总是像他本人一样放纵随意，不按套路出牌，'
              '上个月晚了三天，这个月则提前了两天。冰冷冷的梅花味似乎正在融化，'
              '露出底下凹甘的茶香，在密闭的空调房里盘旋。\\n'
              '“表哥？你还好吗”\\n'
              '你靠在门上，细微的动静被压抑下去，渐渐没了个响。想要更深入'
              '地了解里面的情况。抱着这...',
          replyCount: 11,
          filters: [BookDiscussionFilter.all, BookDiscussionFilter.featured],
          replies: [
            BookDiscussionReply(
              id: 'd1-r1',
              authorName: '衍风来',
              authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
              publishMeta: '06-21 23:58·江苏省',
              content:
                  '生物的本能让一切理智退后，六月的蝉鸣时而高亢，时而低沉。'
                  '或许这就是生命之夏。',
              likeCount: 17,
            ),
            BookDiscussionReply(
              id: 'd1-r2',
              authorName: '朝尧会一直幸福',
              authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
              publishMeta: '06-22 07:55·江苏省',
              content: '回复 衍风来：可是鸟狼真的很香啊😋',
              likeCount: 5,
            ),
          ],
          highlightTag: '精选',
          replyPreview: BookDiscussionReplyPreview(
            authorName: '衍风来',
            content:
                '生物的本能让一切理智退后，六月的蝉鸣时而高亢，时而低沉。'
                '或许这就是生命之夏。',
          ),
        ),
        BookDiscussionPost(
          id: 'd2',
          authorName: 'misa',
          authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
          publishMeta: '06-07 19:27·陕西省',
          likeCount: 312,
          title: '第一次写长评，也不知道会不会被同推和说书友们看到',
          content:
              '看不到的话就当我随便写的碎碎念吧。\\n'
              '我其实觉得心姐姐真的是一个特别细心的人，从前期见月性格方面来写'
              '就是一个沉闷小草，不爱说话。前期其实我对他的感觉是比较一般的，'
              '因为感觉他前期真的是他的嘴毒，但是边框格各种细节其实感觉他真的是'
              '在后边默默保护你的那种...',
          replyCount: 0,
          filters: [BookDiscussionFilter.all],
          replies: [],
        ),
        BookDiscussionPost(
          id: 'd3',
          authorName: '运营小助手',
          authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
          publishMeta: '06-24 10:00·官方',
          likeCount: 12,
          title: '【公告】讨论区发言规范与活动说明',
          content:
              '欢迎大家在讨论区交流剧情、角色和同人内容。请勿发布违规信息，'
              '文明发言，互相尊重。每周将从精选帖中抽取福利发放。',
          replyCount: 3,
          filters: [BookDiscussionFilter.all, BookDiscussionFilter.notice],
          replies: [
            BookDiscussionReply(
              id: 'd3-r1',
              authorName: '运营小助手',
              authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
              publishMeta: '06-24 10:05·官方',
              content: '活动奖励将在每周五统一发放，请耐心等待。',
              likeCount: 2,
            ),
          ],
          highlightTag: '公告',
        ),
        BookDiscussionPost(
          id: 'd4',
          authorName: '读书攻略组',
          authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
          publishMeta: '06-20 21:18·攻略',
          likeCount: 88,
          title: '新读者快速入坑路线（无剧透版）',
          content:
              '先读第一卷主线，再补角色番外，可以快速建立人物关系网。'
              '怕虐可以先看第 58 章后再回补前情，体验更连贯。',
          replyCount: 6,
          filters: [BookDiscussionFilter.all, BookDiscussionFilter.guide],
          replies: [
            BookDiscussionReply(
              id: 'd4-r1',
              authorName: '读书攻略组',
              authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
              publishMeta: '06-20 21:20·攻略',
              content: '补充：第 76 章后建议先看番外 3，人物关系更清晰。',
              likeCount: 10,
            ),
          ],
        ),
      ],
      updateEntries: const [
        BookUpdateEntry(
          id: 'u1',
          dateLabel: '2026-06-24',
          title: '已全书配乐完毕，背景全部替换除了31章的别墅和结局的背景未替换',
          detail: '等剩余这些优化完毕会更新新的番外',
          isHighlighted: true,
        ),
        BookUpdateEntry(
          id: 'u1-1',
          dateLabel: '2026-06-20',
          title: '修复第121章与第122章衔接处的人名显示错误',
          detail: '已同步替换相关插图文案，阅读记录不受影响。',
        ),
        BookUpdateEntry(
          id: 'u1-2',
          dateLabel: '2026-06-17',
          title: '新增「燕然·夜宴」剧情插图 4 张',
          detail: '本次为高清重绘版本，夜景光影细节优化。',
        ),
        BookUpdateEntry(
          id: 'u2',
          dateLabel: '2026-03-11',
          title: '燕然表白千万心福利番外更新，千万心福利套装上线',
          detail: '金丝雀开启全书优化，因为工程量比较大，预计要很长时间，会新增N张插图CG。',
        ),
        BookUpdateEntry(
          id: 'u2-1',
          dateLabel: '2026-02-18',
          title: '优化章节内长按菜单交互，新增「复制段落」功能',
          detail: 'iOS 与 Android 双端已同步，老版本请升级后体验。',
        ),
        BookUpdateEntry(
          id: 'u2-2',
          dateLabel: '2026-01-30',
          title: '新增春节限定番外《雪夜归舟》',
          detail: '番外共 3 章，活动期间可免费阅读。',
        ),
        BookUpdateEntry(
          id: 'u2-3',
          dateLabel: '2025-12-28',
          title: '全书正文完成第三轮错别字校对',
          detail: '本轮共修正 143 处错别字与标点问题。',
        ),
        BookUpdateEntry(
          id: 'u3',
          dateLabel: '2025-11-21',
          title: '全线完结，后续番外不定期更新',
        ),
        BookUpdateEntry(
          id: 'u3-1',
          dateLabel: '2025-11-03',
          title: '主线正文完结倒计时公告发布',
          detail: '感谢一路追更，完结活动将于次周开启。',
        ),
        BookUpdateEntry(
          id: 'u3-2',
          dateLabel: '2025-10-15',
          title: '新增角色关系图（无剧透版）',
        ),
        BookUpdateEntry(
          id: 'u3-3',
          dateLabel: '2025-09-08',
          title: '修复夜间模式下章节页末尾留白异常',
        ),
        BookUpdateEntry(
          id: 'u3-4',
          dateLabel: '2025-07-26',
          title: '上架作品首月热度破千万，感谢支持',
        ),
      ],
      catalogChapters: _mockCatalogChapters(),
      giftCount: '668',
      characters: const [
        BookCharacter(
          id: 'c1',
          name: '林初',
          coverAsset: 'assets/covers/cover_03.png',
        ),
        BookCharacter(
          id: 'c2',
          name: '沈砚',
          coverAsset: 'assets/covers/cover_04.png',
        ),
        BookCharacter(
          id: 'c3',
          name: '苏黎',
          coverAsset: 'assets/covers/cover_05.png',
        ),
        BookCharacter(
          id: 'c4',
          name: '顾辞',
          coverAsset: 'assets/covers/cover_06.png',
        ),
      ],
    );
  }

  static List<BookCatalogChapter> _mockCatalogChapters() {
    const chapterNames = [
      '收割天命之子',
      '荒古第一世家',
      '太古遗族青萝',
      '初入宗门',
      '暗潮涌动',
      '天命之争',
      '师门试炼',
      '秘境开启',
    ];
    const chapterNumbers = [
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
      '九',
      '十',
      '十一',
      '十二',
      '十三',
      '十四',
      '十五',
      '十六',
      '十七',
      '十八',
      '十九',
      '二十',
      '二十一',
      '二十二',
      '二十三',
      '二十四',
      '二十五',
      '二十六',
      '二十七',
      '二十八',
      '二十九',
      '三十',
      '三十一',
      '三十二',
      '三十三',
      '三十四',
      '三十五',
      '三十六',
      '三十七',
      '三十八',
      '三十九',
      '四十',
    ];

    return List.generate(chapterNumbers.length, (index) {
      final name = chapterNames[index % chapterNames.length];
      return BookCatalogChapter(
        id: 'ch${index + 1}',
        title: '第${chapterNumbers[index]}章 $name',
        isLocked: index > 0,
      );
    });
  }
}
