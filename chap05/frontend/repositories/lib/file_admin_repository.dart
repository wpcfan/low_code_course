import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class FileAdminRepository {
  final String baseUrl;
  final Dio client;

  FileAdminRepository({
    Dio? client,
    this.baseUrl = '/files',
  }) : client = client ?? AdminClient();

  Future<List<FileVM>> getFiles() async {
    final url = baseUrl;
    final res = await client.get(url);
    if (res.data is! List) {
      throw Exception(
          'FileAdminRepository.getFiles() - failed, res.data is not List');
    }

    final json = res.data as List;
    final files = json.map((e) => FileVM.fromJson(e)).toList();
    return files;
  }

  Future<void> deleteFile(String key) async {
    final url = '$baseUrl/$key';
    await client.delete(url);
  }

  Future<void> deleteFiles(List<String> keys) async {
    final url = '$baseUrl/batch-delete';
    await client.post(url, data: keys);
  }
}
