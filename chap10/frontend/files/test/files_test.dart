import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:files/blocs/blocs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

class MockFileUploadRepository extends Mock implements FileUploadRepository {}

class MockFileAdminRepository extends Mock implements FileAdminRepository {}

void main() {
  late MockFileUploadRepository fileUploadRepo;
  late MockFileAdminRepository fileAdminRepo;

  setUpAll(() {
    registerFallbackValue(
      UploadFile(name: 'file3', bytes: Uint8List(0)),
    );
  });

  setUp(() {
    fileUploadRepo = MockFileUploadRepository();
    fileAdminRepo = MockFileAdminRepository();
  });

  group('FileBloc', () {
    final files = [
      const FileVM(key: 'file1', url: 'url1'),
      const FileVM(key: 'file2', url: 'url2'),
    ];

    blocTest<FileBloc, FileState>(
      'emits [FileState] when FileEventLoad is added',
      build: () {
        when(() => fileAdminRepo.getFiles()).thenAnswer((_) async => files);
        return FileBloc(fileRepo: fileUploadRepo, fileAdminRepo: fileAdminRepo);
      },
      act: (bloc) => bloc.add(FileEventLoad()),
      expect: () => [
        const FileState(loading: true),
        FileState(loading: true, files: files, selectedKeys: const []),
        FileState(loading: false, files: files, selectedKeys: const []),
      ],
    );

    blocTest<FileBloc, FileState>(
      'emits [FileState] when FileEventUpload is added',
      build: () {
        when(() => fileUploadRepo.uploadFile(any()))
            .thenAnswer((_) async => files[0]);
        return FileBloc(fileRepo: fileUploadRepo, fileAdminRepo: fileAdminRepo);
      },
      act: (bloc) => bloc
          .add(FileEventUpload(UploadFile(name: 'file3', bytes: Uint8List(0)))),
      expect: () => [
        const FileState(uploading: true),
        FileState(uploading: true, files: [files[0]], selectedKeys: const []),
        FileState(uploading: false, files: [files[0]], selectedKeys: const []),
      ],
    );

    blocTest<FileBloc, FileState>(
      'emits [FileState] when FileEventDelete is added',
      build: () {
        when(() => fileAdminRepo.deleteFiles(any())).thenAnswer((_) async {});
        return FileBloc(fileRepo: fileUploadRepo, fileAdminRepo: fileAdminRepo);
      },
      seed: () => FileState(files: files, selectedKeys: const ['file1']),
      act: (bloc) => bloc.add(FileEventDelete()),
      expect: () => [
        FileState(loading: true, files: files, selectedKeys: const ['file1']),
        FileState(loading: true, files: [files[1]], selectedKeys: const []),
        FileState(loading: false, files: [files[1]], selectedKeys: const []),
      ],
    );

    blocTest<FileBloc, FileState>(
      'emits [FileState] when FileEventToggleEditable is added',
      build: () =>
          FileBloc(fileRepo: fileUploadRepo, fileAdminRepo: fileAdminRepo),
      act: (bloc) => bloc.add(FileEventToggleEditable()),
      expect: () => [
        const FileState(editable: true),
      ],
    );

    blocTest<FileBloc, FileState>(
      'emits [FileState] when FileEventToggleSelected is added',
      build: () =>
          FileBloc(fileRepo: fileUploadRepo, fileAdminRepo: fileAdminRepo),
      seed: () => FileState(files: files, selectedKeys: const ['file1']),
      act: (bloc) => bloc.add(FileEventToggleSelected('file2')),
      expect: () => [
        FileState(files: files, selectedKeys: const ['file1', 'file2']),
      ],
    );

    blocTest<FileBloc, FileState>(
      'emits [FileState] when FileEventClearError is added',
      build: () =>
          FileBloc(fileRepo: fileUploadRepo, fileAdminRepo: fileAdminRepo),
      seed: () => const FileState(error: 'Error message'),
      act: (bloc) => bloc.add(FileEventClearError()),
      expect: () => [
        const FileState(error: ''),
      ],
    );
  });
}
