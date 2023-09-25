import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

import 'constants.dart';

class ProductAdminRepository {
  final String path;
  final Dio client;

  ProductAdminRepository({Dio? client, this.path = '/products'})
      : client = client ?? AdminClient();

  Future<PageWrapper<Product>> search({
    required String keyword,
    int pageNum = 0,
    int pageSize = Constants.pageSize,
  }) async {
    final response = await client
        .get('$path/search?keyword=$keyword&page=$pageNum&size=$pageSize');
    final page = PageWrapper.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Product.fromJson(json),
    );
    return page;
  }
}
