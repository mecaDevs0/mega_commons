import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';
import 'package:path/path.dart';

import 'option_button.dart';

class PickerContainer extends StatelessWidget {
  const PickerContainer({
    super.key,
    this.canSelectFile = false,
    this.onFileSelected,
    required this.onFilesSelected,
    this.allowedExtensions,
    required this.cameraColor,
    required this.galleryColor,
    required this.fileColor,
    this.isModal = false,
  });

  final bool canSelectFile;
  final Function(File?)? onFileSelected;
  final Function(List<File>?)? onFilesSelected;
  final List<String>? allowedExtensions;
  final Color cameraColor;
  final Color galleryColor;
  final Color fileColor;
  final bool isModal;

  static final _picker = ImagePicker();

  static void _handleResult(
    File? file,
    Function(File?)? onFileSelected,
    Function(List<File>?)? onFilesSelected,
  ) {
    if (file != null) {
      if (onFilesSelected != null) {
        onFilesSelected([file]);
      } else {
        onFileSelected?.call(file);
      }
    }
  }

  static Future<File?> _pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image == null) {
      return null;
    }

    final result = await _compressImage(image);
    return result != null ? File(result.path) : null;
  }

  static Future<File?> _pickSingleFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image == null) {
      return null;
    }
    final result = await _compressImage(image);
    return result != null ? File(result.path) : null;
  }

  static Future<XFile?> _compressImage(XFile image) async {
    final dir = await getTemporaryDirectory();
    final targetPath = join(
      dir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 60,
      minWidth: 1080,
      format: CompressFormat.jpeg,
    );
    return result;
  }

  static Future<List<File>?> _pickMultipleFromGallery() async {
    final images = await _picker.pickMultiImage(imageQuality: 85);
    return images.map((e) => File(e.path)).toList();
  }

  static Future<List<File>?> _pickFromFileSystemList({
    List<String>? allowedExtensions,
    bool isMultipleSelectionEnabled = false,
  }) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      allowMultiple: isMultipleSelectionEnabled,
    );
    return result?.files.map((e) => File(e.path!)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: context.theme.cardColor,
      margin: isModal
          ? EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).padding.bottom + 4,
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isModal)
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0x19000000),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Escolha uma opção',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OptionButton(
                  label: 'Câmera',
                  icon: 'assets/ic_camera.png',
                  backgroundColor: cameraColor,
                  onTap: () async {
                    Navigator.pop(context);
                    final file = await _pickFromCamera();
                    _handleResult(file, onFileSelected, onFilesSelected);
                  },
                ),
                OptionButton(
                  label: 'Galeria',
                  icon: 'assets/ic_file_image.png',
                  backgroundColor: galleryColor,
                  onTap: () async {
                    Navigator.pop(context);
                    if (onFilesSelected != null) {
                      final files = await _pickMultipleFromGallery();
                      if (files?.isNotEmpty ?? false) {
                        onFilesSelected!(files);
                      }
                      return;
                    }
                    final file = await _pickSingleFromGallery();
                    _handleResult(file, onFileSelected, null);
                  },
                ),
                if (canSelectFile)
                  OptionButton(
                    label: 'Arquivo',
                    icon: 'assets/ic_file.png',
                    backgroundColor: fileColor,
                    onTap: () async {
                      Navigator.pop(context);
                      final files = await _pickFromFileSystemList(
                        allowedExtensions: allowedExtensions,
                        isMultipleSelectionEnabled: onFilesSelected != null,
                      );
                      if (onFilesSelected != null) {
                        onFilesSelected!(files);
                        return;
                      }
                      _handleResult(files?.first, onFileSelected, null);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
