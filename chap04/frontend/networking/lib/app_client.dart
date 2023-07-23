import 'package:dio/dio.dart';
import 'package:networking/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// 自定义的 Dio 实例，用于访问 APP 接口
/// 该实例会自动添加日志拦截器, 缓存拦截器和错误拦截器
/// 该实例会自动添加 Content-Type 和 Accept 头
/// 该实例会自动将后台返回的 Problem 对象转换为 DioError
///
/// DioMixin 是一个 Mixin，它会自动实现 Dio 的所有方法
/// Mixin 的好处是可以在不改变原有类的情况下，为类添加新的功能
/// 具体的实现原理可以参考：https://dart.dev/guides/language/language-tour#mixins
class AppClient with DioMixin implements Dio {
  static final AppClient _singleton = AppClient._();

  factory AppClient() => _singleton;

  AppClient._() {
    options = BaseOptions(
      baseUrl: Constants.lowCodeBaseUrl,
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );
    interceptors.add(PrettyDioLogger());
    httpClientAdapter = HttpClientAdapter();
  }
}
