import 'package:dio/dio.dart';
import 'package:models/models.dart';

class FileUploadRepository {
  final Dio client;

  FileUploadRepository({Dio? client}) : client = client ?? Dio();

  Future<FileVM> uploadFile(UploadFile file) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(file.bytes, filename: file.name),
    });

    final res = await client.post(
      '/file',
      data: formData,
    );

    return FileVM.fromJson(res.data);
  }

  Future<List<FileVM>> uploadFiles(List<UploadFile> files) async {
    final formData = FormData.fromMap({
      'files': files.map((file) {
        return MultipartFile.fromBytes(file.bytes, filename: file.name);
      }).toList(),
    });

    final res = await client.post(
      '/files',
      data: formData,
    );

    return (res.data as List).map((e) => FileVM.fromJson(e)).toList();
  }
}
