import 'dart:io';

class ImageFile {
  int? id = 0;
  File? file;
  String uniqueId;
  bool? isLoading = false;
  bool? isDeleteLoading = false;

  ImageFile({this.id, this.file, required this.uniqueId, this.isLoading, this.isDeleteLoading});
}