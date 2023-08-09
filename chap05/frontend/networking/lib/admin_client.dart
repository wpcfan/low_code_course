import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'constants.dart';

class AdminClient with DioMixin implements Dio {
  static final AdminClient _singleton = AdminClient._();

  factory AdminClient() => _singleton;

  AdminClient._() {
    options = BaseOptions(
      baseUrl: '${Constants.lowCodeBaseUrl}/app',
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );
    interceptors.add(PrettyDioLogger());
    httpClientAdapter = HttpClientAdapter();
  }
}
