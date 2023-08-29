import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class ProductRepository {
  final String path;
  final Dio client;

  ProductRepository({Dio? client, this.path = '/categories'})
      : client = client ?? AppClient();

  Future<List<Product>> getProductsByCategoryId(
      {required int categoryId,
      required int pageNum,
      required int pageSize}) async {
    final response = await client
        .get('$path/$categoryId/products?_page=$pageNum&_limit=$pageSize');
    return (response.data as List)
        .map((productJson) => Product.fromJson(productJson))
        .toList();
  }
}
