import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:session_storage/session_storage.dart';

import 'constants.dart';
import 'custom_exception_interceptor.dart';

class FileUploadClient with DioMixin implements Dio {
  static final FileUploadClient _singleton = FileUploadClient._();

  factory FileUploadClient() => _singleton;

  FileUploadClient._() {
    final session = SessionStorage();
    final token = session['token'];
    options = BaseOptions(
      baseUrl: '${Constants.lowCodeBaseUrl}/admin',
      headers: Map.from({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );
    interceptors.add(CustomExceptionInterceptor());
    interceptors.add(PrettyDioLogger());
    httpClientAdapter = HttpClientAdapter();
  }
}
