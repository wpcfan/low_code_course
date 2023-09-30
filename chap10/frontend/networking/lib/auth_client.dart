import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'constants.dart';
import 'custom_exception_interceptor.dart';

class AuthClient with DioMixin implements Dio {
  static final AuthClient _singleton = AuthClient._();

  factory AuthClient() => _singleton;

  AuthClient._() {
    options = BaseOptions(
      baseUrl: '${Constants.lowCodeBaseUrl}/auth',
      headers: Map.from({
        'Accept': '*/*',
      }),
    );
    interceptors.add(CustomExceptionInterceptor());
    interceptors.add(PrettyDioLogger());
    httpClientAdapter = HttpClientAdapter();
  }
}
