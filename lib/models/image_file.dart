import 'dart:io';

class ImageFile {
  int? id = 0;
  File? file;
  String? filePath = "";
  String uniqueId;
  bool? isRequest = false;
  bool? isLoading = false;
  bool? isDeleteLoading = false;

  ImageFile({this.id, this.file, this.filePath, required this.uniqueId, this.isRequest, this.isLoading, this.isDeleteLoading});
}