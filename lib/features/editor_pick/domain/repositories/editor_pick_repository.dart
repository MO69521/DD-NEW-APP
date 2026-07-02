import '../entities/editor_pick_page_content.dart';

/// 编辑推荐详情页仓储抽象（domain 契约）。
abstract interface class EditorPickRepository {
  Future<EditorPickPageContent> fetchPageContent();
}
