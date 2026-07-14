import '../../domain/entities/my_messages_page_content.dart';
import '../../domain/repositories/my_messages_repository.dart';
import '../datasources/my_messages_data_source.dart';

/// data 层仓储实现，仅做数据获取与映射。
class MyMessagesRepositoryImpl implements MyMessagesRepository {
  const MyMessagesRepositoryImpl(this._dataSource);

  final MyMessagesDataSource _dataSource;

  @override
  Future<MyMessagesPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();
}
