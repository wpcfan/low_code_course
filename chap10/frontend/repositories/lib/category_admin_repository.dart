import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class CategoryAdminRepository {
  final String path;
  final Dio client;

  CategoryAdminRepository({
    Dio? client,
    this.path = '/categories',
  }) : client = client ?? AdminClient();

  Future<List<Category>> search({required String keyword}) async {
    final response = await client.get('$path/search?keyword=$keyword');
    final result = (response.data as List<dynamic>)
        .map((json) => Category.fromJson(json))
        .toList();
    return result;
  }
}
