import 'package:dio/dio.dart';
import 'package:models/models.dart';

import 'custom_exception.dart';

class CustomExceptionInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final problem = Problem.fromJson(err.response!.data);
      throw CustomException(
        problem.title ?? err.message ?? 'Unknown error',
        problem.detail ?? 'Unknown Error',
        response: err.response!,
      );
    }
    super.onError(err, handler);
  }
}
