import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:session_storage/session_storage.dart';

import 'constants.dart';
import 'custom_exception_interceptor.dart';

class AdminClient with DioMixin implements Dio {
  static final AdminClient _singleton = AdminClient._();

  factory AdminClient() => _singleton;

  AdminClient._() {
    final session = SessionStorage();
    final token = session['token'];
    options = BaseOptions(
      baseUrl: '${Constants.lowCodeBaseUrl}/admin',
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    interceptors.add(CustomExceptionInterceptor());
    interceptors.add(PrettyDioLogger());
    httpClientAdapter = HttpClientAdapter();
  }
}
