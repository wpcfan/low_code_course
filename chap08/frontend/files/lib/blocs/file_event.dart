import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

abstract class FileEvent extends Equatable {}

class FileEventLoad extends FileEvent {
  FileEventLoad() : super();

  @override
  List<Object?> get props => [];
}

class FileEventUpload extends FileEvent {
  FileEventUpload(this.file) : super();
  final UploadFile file;

  @override
  List<Object?> get props => [file];
}

class FileEventUploadMultiple extends FileEvent {
  FileEventUploadMultiple(this.files) : super();
  final List<UploadFile> files;

  @override
  List<Object?> get props => [files];
}

class FileEventDelete extends FileEvent {
  FileEventDelete() : super();

  @override
  List<Object?> get props => [];
}

class FileEventToggleEditable extends FileEvent {
  FileEventToggleEditable() : super();

  @override
  List<Object?> get props => [];
}

class FileEventToggleSelected extends FileEvent {
  FileEventToggleSelected(this.key) : super();
  final String key;

  @override
  List<Object?> get props => [key];
}
