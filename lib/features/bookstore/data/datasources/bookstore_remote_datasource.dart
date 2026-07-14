import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/entities/bookstore_page_content.dart';
import '../models/bookstore_page_dto.dart';
import 'bookstore_data_source.dart';

/// 书城真实接口数据源：调用 [ApiClient]，解析 `data` 信封为 DTO 再映射为领域模型。
/// 接入范式参考，其它 feature 可照此实现。
class BookstoreRemoteDataSource implements BookstoreDataSource {
  const BookstoreRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<BookstorePageContent> fetchPageContent() async {
    final json = await _client.getJson('/bookstore/home');
    final data = json['data'];
    if (data is! Map<String, Object?>) {
      throw const ApiException(ApiErrorType.parse, '书城首页响应缺少 data 字段');
    }
    return BookstorePageDto.fromJson(data).toEntity();
  }
}
