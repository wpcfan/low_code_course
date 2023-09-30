import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:networking/networking.dart';

class AuthRepository {
  final String path;
  final Dio client;

  AuthRepository({Dio? client, this.path = '/token'})
      : client = client ?? AuthClient();

  Future<String> login({
    required String username,
    required String password,
  }) async {
    final response = await client.post(path,
        options: Options(
          headers: {
            'Authorization':
                'Basic ${base64.encoder.convert('$username:$password'.codeUnits)}',
          },
        ));
    final result = response.data;
    debugPrint('login result: $result');
    return result;
  }
}
