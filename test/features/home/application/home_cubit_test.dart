import 'package:diandian_chuanshu/features/home/application/home_cubit.dart';
import 'package:diandian_chuanshu/features/home/domain/entities/home_info.dart';
import 'package:diandian_chuanshu/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// 手写 fake 仓储：可返回成功数据或抛错，无需额外 mock 依赖。
class _FakeHomeRepository implements HomeRepository {
  _FakeHomeRepository.success(this._info) : _error = null;
  _FakeHomeRepository.failure(this._error) : _info = null;

  final HomeInfo? _info;
  final Object? _error;

  @override
  Future<HomeInfo> getHomeInfo() async {
    if (_error != null) throw _error;
    return _info!;
  }
}

void main() {
  group('HomeCubit', () {
    const info = HomeInfo(appName: '点点穿书', tagline: 'slogan');

    test('初始状态：未加载、无数据、无错误', () {
      final cubit = HomeCubit(repository: _FakeHomeRepository.success(info));
      addTearDown(cubit.close);

      expect(cubit.state.ui.isLoading, isFalse);
      expect(cubit.state.ui.errorMessage, isNull);
      expect(cubit.state.domain.info, isNull);
    });

    test('load 成功：先进入 loading，最终写入数据且结束 loading', () async {
      final cubit = HomeCubit(repository: _FakeHomeRepository.success(info));
      addTearDown(cubit.close);

      final emitted = <bool>[];
      final sub = cubit.stream.listen((s) => emitted.add(s.ui.isLoading));

      await cubit.load();
      await sub.cancel();

      expect(emitted.first, isTrue, reason: '应先切到 loading=true');
      expect(cubit.state.ui.isLoading, isFalse);
      expect(cubit.state.ui.errorMessage, isNull);
      expect(cubit.state.domain.info, equals(info));
    });

    test('load 失败：结束 loading 并写入错误信息', () async {
      final cubit = HomeCubit(
        repository: _FakeHomeRepository.failure(Exception('boom')),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.ui.isLoading, isFalse);
      expect(cubit.state.ui.errorMessage, contains('boom'));
      expect(cubit.state.domain.info, isNull);
    });
  });
}
