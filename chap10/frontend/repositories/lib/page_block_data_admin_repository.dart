import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageBlockDataAdminRepository {
  final Dio client;
  final String baseUrl;

  PageBlockDataAdminRepository({
    Dio? client,
    this.baseUrl = '/layouts',
  }) : client = client ?? AdminClient();

  /// 创建页面区块数据
  /// [id] 页面ID
  /// [blockId] 区块ID
  /// [data] 区块数据
  Future<PageBlockData> create(int id, int blockId, PageBlockData data) async {
    final url = '$baseUrl/$id/blocks/$blockId/data';

    final response = await client.post(
      url,
      data: data.toJson(),
    );

    return convertBlockData(response);
  }

  /// 更新页面区块数据
  /// [id] 页面ID
  /// [blockId] 区块ID
  /// [dataId] 区块数据ID
  /// [data] 区块数据
  Future<PageBlockData> update(
      int id, int blockId, int dataId, PageBlockData data) async {
    final url = '$baseUrl/$id/blocks/$blockId/data/$dataId';

    final response = await client.put(
      url,
      data: data.toJson(),
    );

    return convertBlockData(response);
  }

  /// 删除页面区块数据
  /// [id] 页面ID
  /// [blockId] 区块ID
  /// [dataId] 区块数据ID
  Future<void> delete(int id, int blockId, int dataId) async {
    final url = '$baseUrl/$id/blocks/$blockId/data/$dataId';

    await client.delete(url);
  }

  /// 移动页面区块数据
  /// [id] 页面ID
  /// [blockId] 区块ID
  /// [fromId] 起始区块数据ID
  /// [toId] 目标区块数据ID
  Future<void> move(int id, int blockId, int fromId, int toId) async {
    final url = '$baseUrl/$id/blocks/$blockId/data/$fromId/sort/$toId';

    await client.put(url);
  }

  PageBlockData<BlockData> convertBlockData(Response<dynamic> response) {
    final res = response.data;
    if (res is Map<String, dynamic> && res.containsKey('content')) {
      final content = res['content'];
      if (content is Map<String, dynamic> && content.containsKey('price')) {
        return PageBlockData.fromJson(res, Product.fromJson);
      }
      if (content is Map<String, dynamic> && content.containsKey('image')) {
        return PageBlockData.fromJson(res, ImageData.fromJson);
      }
      if (content is Map<String, dynamic> && content.containsKey('code')) {
        return PageBlockData.fromJson(res, Category.fromJson);
      }
    }
    throw Exception('未知区块数据类型');
  }
}
