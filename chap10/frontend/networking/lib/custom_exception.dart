import 'package:dio/dio.dart';

class CustomException extends DioException {
  CustomException(String message, String detail, {required Response response})
      : super(
            requestOptions: response.requestOptions,
            response: response,
            message: message,
            error: detail);

  @override
  String toString() {
    return '$message';
  }
}
