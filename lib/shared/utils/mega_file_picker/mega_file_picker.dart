import 'dart:io';

import 'package:flutter/material.dart';

import 'picker_container.dart';

enum FileSourceOption {
  camera,
  gallery,
  file,
}

class MegaFilePicker {
  MegaFilePicker._();

  static Future<void> showModalChooser(
    BuildContext context, {
    bool canSelectFile = false,
    Function(File?)? onFileSelected,
    Function(List<File>?)? onFilesSelected,
    List<String>? allowedExtensions = const ['jpeg', 'jpg', 'png', 'pdf'],
    Color cameraColor = const Color(0xFFA8E6CF),
    Color galleryColor = const Color(0xFFFFD3B6),
    Color fileColor = const Color(0xFFCE93D8),
  }) async {
    assert(
      onFileSelected != null || onFilesSelected != null,
      'É necessário fornecer ao menos um callback: onFileSelected ou onFilesSelected.',
    );

    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => PickerContainer(
        canSelectFile: canSelectFile,
        allowedExtensions: allowedExtensions,
        onFileSelected: onFileSelected,
        onFilesSelected: onFilesSelected,
        cameraColor: cameraColor,
        galleryColor: galleryColor,
        fileColor: fileColor,
        isModal: true,
      ),
    );
  }

  static void showDialogChooser(
    BuildContext context, {
    bool enableFile = false,
    Function(File?)? onFileSelected,
    Function(List<File>?)? onFilesSelected,
    List<String>? allowedExtensions = const ['jpeg', 'jpg', 'png', 'pdf'],
    Color cameraColor = const Color(0xFFA8E6CF),
    Color galleryColor = const Color(0xFFFFD3B6),
    Color fileColor = const Color(0xFFCE93D8),
  }) {
    assert(
      onFileSelected != null || onFilesSelected != null,
      'É necessário fornecer ao menos um callback: onFileSelected ou onFilesSelected.',
    );
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: PickerContainer(
          canSelectFile: enableFile,
          allowedExtensions: allowedExtensions,
          onFileSelected: onFileSelected,
          onFilesSelected: onFilesSelected,
          cameraColor: cameraColor,
          galleryColor: galleryColor,
          fileColor: fileColor,
          isModal: false,
        ),
      ),
    );
  }

  // static Widget _buildPickerUI(
  //   BuildContext context, {
  //   required bool enableFile,
  //   required Function(File?)? onFileSelected,
  //   required Function(List<File>?)? onFilesSelected,
  //   required List<String>? allowedExtensions,
  //   required Color cameraColor,
  //   required Color galleryColor,
  //   required Color fileColor,
  //   bool isModal = false,
  // }) {
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //     color: context.theme.cardColor,
  //     margin: isModal
  //         ? EdgeInsets.only(
  //             left: 10,
  //             right: 10,
  //             bottom: MediaQuery.of(context).padding.bottom + 4,
  //           )
  //         : null,
  //     child: Padding(
  //       padding: const EdgeInsets.all(12),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           if (isModal)
  //             Container(
  //               width: 44,
  //               height: 4,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(2),
  //                 color: const Color(0x19000000),
  //               ),
  //             ),
  //           const SizedBox(height: 20),
  //           const Text(
  //             'Escolha uma opção',
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //           ),
  //           const SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               OptionButton(
  //                 label: 'Câmera',
  //                 icon: 'assets/ic_camera.png',
  //                 backgroundColor: cameraColor,
  //                 onTap: () async {
  //                   Navigator.pop(context);
  //                   final file = await _pickFromCamera();
  //                   _returnResult(file, onFileSelected, onFilesSelected);
  //                 },
  //               ),
  //               OptionButton(
  //                 label: 'Galeria',
  //                 icon: 'assets/ic_file_image.png',
  //                 backgroundColor: galleryColor,
  //                 onTap: () async {
  //                   Navigator.pop(context);
  //                   if (onFilesSelected != null) {
  //                     final files = await _pickMultipleFromGallery();
  //                     if (files != null && files.isNotEmpty) {
  //                       onFilesSelected(files);
  //                     }
  //                   } else {
  //                     final file = await _pickSingleFromGallery();
  //                     _returnResult(file, onFileSelected, null);
  //                   }
  //                 },
  //               ),
  //               if (enableFile)
  //                 OptionButton(
  //                   label: 'Arquivo',
  //                   icon: 'assets/ic_file.png',
  //                   backgroundColor: fileColor,
  //                   onTap: () async {
  //                     Navigator.pop(context);
  //                     final files = await _pickFromFileSystemList(
  //                       allowedExtensions: allowedExtensions,
  //                     );
  //                     _returnResult(
  //                       files?.first,
  //                       onFileSelected,
  //                       files != null && files.length > 1
  //                           ? onFilesSelected
  //                           : null,
  //                     );
  //                   },
  //                 ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
