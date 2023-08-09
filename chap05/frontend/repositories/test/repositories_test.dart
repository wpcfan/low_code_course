import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('FileUploadRepository', () {
    // 测试单个文件上传
    test('uploadFile', () async {
      final client = MockDio();
      final repository = FileUploadRepository(client: client);
      final file = UploadFile(
        bytes: Uint8List.fromList([1, 2, 3]),
        name: 'test.txt',
      );
      const fileVM = FileVM(
        key: 'test.txt',
        url: 'http://test.com/test.txt',
      );
      when(() => client.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: '/file'),
              data: fileVM.toJson(),
              statusCode: 200));
      final result = await repository.uploadFile(file);
      expect(result, fileVM);
    });

    // 测试多个文件上传
    test('uploadFiles', () async {
      final client = MockDio();
      final repository = FileUploadRepository(client: client);
      final files = [
        UploadFile(
          bytes: Uint8List.fromList([1, 2, 3]),
          name: 'test.txt',
        ),
        UploadFile(
          bytes: Uint8List.fromList([4, 5, 6]),
          name: 'test2.txt',
        ),
      ];
      const fileVMs = [
        FileVM(
          key: 'test.txt',
          url: 'http://test.com/test.txt',
        ),
        FileVM(
          key: 'test2.txt',
          url: 'http://test.com/test2.txt',
        ),
      ];
      when(() => client.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: '/files'),
              data: fileVMs.map((e) => e.toJson()).toList(),
              statusCode: 200));
      final result = await repository.uploadFiles(files);
      expect(result, fileVMs);
    });
  });

  group('FileAdminRepository', () {
    // 测试获取文件列表
    test('getFiles', () async {
      final client = MockDio();
      final repository = FileAdminRepository(client: client);
      const fileVMs = [
        FileVM(
          key: 'test.txt',
          url: 'http://test.com/test.txt',
        ),
        FileVM(
          key: 'test2.txt',
          url: 'http://test.com/test2.txt',
        ),
      ];
      when(() => client.get(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/files'),
          data: fileVMs.map((e) => e.toJson()).toList(),
          statusCode: 200));
      final result = await repository.getFiles();
      expect(result, fileVMs);
    });

    // 测试删除单个文件
    test('deleteFile', () async {
      final client = MockDio();
      final repository = FileAdminRepository(client: client);
      const key = 'test.txt';
      when(() => client.delete(any())).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: '/files/$key'),
          statusCode: 200));
      await repository.deleteFile(key);
    });

    // 测试删除多个文件
    test('deleteFiles', () async {
      final client = MockDio();
      final repository = FileAdminRepository(client: client);
      const keys = ['test.txt', 'test2.txt'];
      when(() => client.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
              requestOptions: RequestOptions(path: '/files/batch-delete'),
              statusCode: 200));
      await repository.deleteFiles(keys);
    });
  });
}
