import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import '../widgets/widgets.dart';
import 'blocs/blocs.dart';

class ImageExplorer extends StatelessWidget {
  final Function()? onCancel;
  final Function(FileVM)? onTap;
  final bool cancelDisplayed;

  const ImageExplorer({
    super.key,
    this.onCancel,
    this.onTap,
    this.cancelDisplayed = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FileBloc(
            fileRepo: FileUploadRepository(),
            fileAdminRepo: FileAdminRepository())
          ..add(FileEventLoad()),
        child: BlocBuilder<FileBloc, FileState>(
          builder: (context, state) {
            if (state.loading) {
              return const CircularProgressIndicator().center();
            }

            if (state.error.isNotEmpty) {
              return Text(state.error).center();
            }

            if (state.files.isEmpty) {
              return const Text('没有图片资源').center();
            }
            return [
              TitleWidget(
                isChecked: state.editable,
                onCheckboxChanged: (value) =>
                    context.read<FileBloc>().add(FileEventToggleEditable()),
              ),
              ImageGridWidget(
                editable: state.editable,
                images: state.files,
                selectedKeys: state.selectedKeys,
                onTap: (file) => onTap?.call(file),
                onToggleSelected: (key) =>
                    context.read<FileBloc>().add(FileEventToggleSelected(key)),
              ).expanded(),
              BottomWidget(
                cancelDisplayed: cancelDisplayed,
                deleteEnabled: state.editable,
                onDelete: () => context.read<FileBloc>().add(FileEventDelete()),
                onUpload: () => _uploadImages(context.read<FileBloc>()),
                onCancel: () => onCancel?.call(),
              ),
            ].toColumn();
          },
        ));
  }

  Future<void> _uploadImages(FileBloc bloc) async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    final List<UploadFile> images = [];
    for (var image in pickedImages) {
      final bytes = await image.readAsBytes();
      images.add(UploadFile(
        name: image.name,
        bytes: bytes,
      ));
    }

    if (images.isNotEmpty) {
      bloc.add(FileEventUploadMultiple(images));
    }
  }
}
