import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageBlockAdminRepository {
  final String baseUrl;
  final Dio client;

  PageBlockAdminRepository({
    Dio? client,
    this.baseUrl = '/layouts',
  }) : client = client ?? AdminClient();

  /// 创建页面区块
  /// [id] 页面ID
  /// [block] 区块
  Future<PageBlock> create(int id, PageBlock block) async {
    final url = '$baseUrl/$id/blocks';

    final response = await client.post(
      url,
      data: block.toJson(),
    );

    final result = PageBlock.fromJson(response.data);

    return result;
  }

  /// 更新页面区块
  /// [id] 页面ID
  /// [block] 区块
  /// [blockId] 区块ID
  Future<PageBlock> update(int id, int blockId, PageBlock block) async {
    final url = '$baseUrl/$id/blocks/$blockId';

    final response = await client.put(
      url,
      data: block.toJson(),
    );

    final result = PageBlock.fromJson(response.data);

    return result;
  }

  /// 删除页面区块
  /// [id] 页面ID
  /// [blockId] 区块ID
  Future<void> delete(int id, int blockId) async {
    final url = '$baseUrl/$id/blocks/$blockId';

    await client.delete(url);
  }

  /// 移动页面区块
  /// [id] 页面ID
  /// [fromId] 起始区块ID
  /// [toId] 目标区块ID
  Future<void> move(int id, int fromId, int toId) async {
    final url = '$baseUrl/$id/blocks/$fromId/sort/$toId';

    await client.put(
      url,
    );
  }
}
