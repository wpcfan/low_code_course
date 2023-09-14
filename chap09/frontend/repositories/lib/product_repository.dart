import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class ProductRepository {
  final String path;
  final Dio client;

  ProductRepository({Dio? client, this.path = '/products'})
      : client = client ?? AppClient();

  Future<SliceWrapper<Product>> getProductsByCategoryId({
    required int categoryId,
    required int pageNum,
    required int pageSize,
  }) async {
    final response = await client
        .get('$path/by-category/$categoryId?page=$pageNum&size=$pageSize');
    final slice = SliceWrapper.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Product.fromJson(json),
    );
    return slice;
  }
}
