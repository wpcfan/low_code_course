import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class PageRepository {
  final String path;
  final Dio client;

  PageRepository({Dio? client, this.path = '/layouts'})
      : client = client ?? AppClient();

  Future<PageLayout> getPageLayout(PageType pageType) async {
    final response =
        await client.get('$path?platform=APP&pageType=${pageType.value}');
    await Future.delayed(const Duration(seconds: 2));
    return PageLayout.fromJson(response.data);
  }
}
