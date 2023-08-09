import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:networking/custom_exception_interceptor.dart';
import 'package:networking/networking.dart';

void main() {
  // 测试 AdminClient 的配置是否正确
  test('AdminClient', () {
    final client = AdminClient();
    expect(client.options.baseUrl, 'http://localhost:8080/api/v1/admin');
    expect(client.options.headers['Content-Type'], 'application/json');
    expect(client.options.headers['Accept'], 'application/json');
    expect(client.interceptors.length, 3);
    expect(client.httpClientAdapter, isA<HttpClientAdapter>());
  });

  // 测试 AppClient 的配置是否正确
  test('AppClient', () {
    final client = AppClient();
    expect(client.options.baseUrl, 'http://localhost:8080/api/v1/app');
    expect(client.options.headers['Content-Type'], 'application/json');
    expect(client.options.headers['Accept'], 'application/json');
    expect(client.interceptors.length, 3);
    expect(client.httpClientAdapter, isA<HttpClientAdapter>());
  });

  // 测试 FileUploadClient 的配置是否正确
  test('FileUploadClient', () {
    final client = FileUploadClient();
    expect(client.options.baseUrl, 'http://localhost:8080/api/v1/admin');
    expect(client.options.headers['Content-Type'], 'multipart/form-data');
    expect(client.options.headers['Accept'], 'application/json');
    expect(client.interceptors.length, 3);
    expect(client.httpClientAdapter, isA<HttpClientAdapter>());
  });

  // 测试 CustomExceptionInterceptor 是否可以正确处理 DioException
  test('CustomExceptionInterceptor', () {
    final interceptor = CustomExceptionInterceptor();
    final handler = ErrorInterceptorHandler();
    final err = DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: Response(
        requestOptions: RequestOptions(path: '/test'),
        data: {
          'title': 'Test error',
          'status': 400,
          'type': 'https://example.com/test',
          'detail': 'Test error detail',
          'instance': 'https://example.com/test/1',
        },
      ),
    );
    expect(() => interceptor.onError(err, handler),
        throwsA(isA<CustomException>()));
  });
}
