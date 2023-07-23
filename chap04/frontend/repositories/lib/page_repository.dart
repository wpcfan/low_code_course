import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageRepository {
  final String path;
  final Dio client;

  PageRepository({Dio? client, this.path = '/pages'})
      : client = client ?? AppClient();

  Future<PageLayout> getPageLayout(String pageId) async {
    final response = await client.get('$path/$pageId');
    return PageLayout.fromJson(response.data);
  }
}
