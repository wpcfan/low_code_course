import 'package:dio/dio.dart';
import 'package:models/models.dart';

import 'custom_exception.dart';

class CustomExceptionInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final problem = Problem.fromJson(err.response!.data);
      throw CustomException(problem.title ?? 'Unknown error');
    }
    super.onError(err, handler);
  }
}
