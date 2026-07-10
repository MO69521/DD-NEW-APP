import 'package:diandian_chuanshu/features/home/domain/entities/home_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeInfo', () {
    test('相同字段的两个实例相等（Equatable 值相等）', () {
      const a = HomeInfo(appName: '点点穿书', tagline: 'slogan');
      const b = HomeInfo(appName: '点点穿书', tagline: 'slogan');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('任一字段不同则不相等', () {
      const a = HomeInfo(appName: '点点穿书', tagline: 'slogan');
      const b = HomeInfo(appName: '点点穿书', tagline: '另一句');

      expect(a, isNot(equals(b)));
    });
  });
}
