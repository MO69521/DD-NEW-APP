import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/book_serialization_status.dart';
import '../../domain/entities/search_recommendation_item.dart';
import '../../domain/entities/search_result_item.dart';
import '../../domain/entities/search_suggestion.dart';

/// data 层 DTO：解析后端 JSON，再 `toEntity()` 映射为 domain 模型。
/// domain 保持纯净，后端字段/结构变化只影响本文件。

/// 搜索结果项 DTO。
class SearchResultItemDto {
  const SearchResultItemDto({
    required this.id,
    required this.title,
    required this.cover,
    required this.audienceTags,
    required this.description,
    required this.status,
  });

  factory SearchResultItemDto.fromJson(Map<String, Object?> json) {
    return SearchResultItemDto(
      id: json['id'] as String,
      title: json['title'] as String,
      cover: json['cover'] as String? ?? '',
      audienceTags: _stringList(json['audienceTags']),
      description: json['description'] as String? ?? '',
      status: json['status'] as String?,
    );
  }

  final String id;
  final String title;
  final String cover;
  final List<String> audienceTags;
  final String description;
  final String? status;

  SearchResultItem toEntity() {
    return SearchResultItem(
      book: Book(
        id: id,
        title: title,
        category: audienceTags.join(' / '),
        coverAsset: cover,
      ),
      audienceTags: audienceTags,
      description: description,
      status: _serializationStatusFromKey(status),
    );
  }

  static List<SearchResultItem> listToEntities(Object? jsonList) {
    if (jsonList is! List) return const [];
    return jsonList
        .map((e) => SearchResultItemDto.fromJson(e as Map<String, Object?>).toEntity())
        .toList();
  }
}

/// 搜索联想词条 DTO。
class SearchSuggestionDto {
  const SearchSuggestionDto({required this.keyword, this.badge});

  factory SearchSuggestionDto.fromJson(Map<String, Object?> json) {
    return SearchSuggestionDto(
      keyword: json['keyword'] as String,
      badge: json['badge'] as String?,
    );
  }

  final String keyword;
  final String? badge;

  SearchSuggestion toEntity() =>
      SearchSuggestion(keyword: keyword, badge: badge);

  static List<SearchSuggestion> listToEntities(Object? jsonList) {
    if (jsonList is! List) return const [];
    return jsonList
        .map((e) => SearchSuggestionDto.fromJson(e as Map<String, Object?>).toEntity())
        .toList();
  }
}

/// 搜索推荐项 DTO。
class SearchRecommendationItemDto {
  const SearchRecommendationItemDto({
    required this.id,
    required this.title,
    required this.cover,
    required this.badgeLabel,
    required this.tags,
    required this.description,
    required this.author,
  });

  factory SearchRecommendationItemDto.fromJson(Map<String, Object?> json) {
    return SearchRecommendationItemDto(
      id: json['id'] as String,
      title: json['title'] as String,
      cover: json['cover'] as String? ?? '',
      badgeLabel: json['badgeLabel'] as String? ?? '',
      tags: _stringList(json['tags']),
      description: json['description'] as String? ?? '',
      author: json['author'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String cover;
  final String badgeLabel;
  final List<String> tags;
  final String description;
  final String author;

  SearchRecommendationItem toEntity() {
    return SearchRecommendationItem(
      book: Book(
        id: id,
        title: title,
        category: tags.join(' · '),
        coverAsset: cover,
      ),
      badgeLabel: badgeLabel,
      tags: tags,
      description: description,
      author: author,
    );
  }

  static List<SearchRecommendationItem> listToEntities(Object? jsonList) {
    if (jsonList is! List) return const [];
    return jsonList
        .map(
          (e) => SearchRecommendationItemDto.fromJson(e as Map<String, Object?>)
              .toEntity(),
        )
        .toList();
  }
}

/// 解析后端字符串数组（热词 / 历史）。
List<String> _stringList(Object? value) {
  if (value is! List) return const [];
  return value.map((e) => e as String).toList();
}

/// 后端连载状态 key（枚举名或标签）→ [BookSerializationStatus]，无法识别按连载。
BookSerializationStatus _serializationStatusFromKey(String? key) {
  return switch (key) {
    'completed' || '完结' => BookSerializationStatus.completed,
    _ => BookSerializationStatus.serializing,
  };
}

/// 供 remote datasource 复用的字符串数组解析。
List<String> parseStringList(Object? value) => _stringList(value);
