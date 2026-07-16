import 'package:image_picker/image_picker.dart';

/// 系统相册图片选择服务（封装平台插件），供跨 feature 复用。
///
/// 仅暴露领域友好的接口（返回本地文件路径列表），
/// 上层无需感知 [ImagePicker] / [XFile] 等平台细节。
class ImagePickerService {
  ImagePickerService([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// 调起系统相册多选，返回所选图片的本地路径（用户取消时为空列表）。
  /// [limit] 限制单次最多可选数量。
  Future<List<String>> pickImages({int limit = 4}) async {
    if (limit <= 0) return const [];
    final files = await _picker.pickMultiImage(limit: limit);
    return files.map((file) => file.path).toList();
  }
}
