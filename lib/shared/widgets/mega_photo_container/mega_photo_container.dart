import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../../mega_commons.dart';
import 'photo_container.dart';

enum TypeModal { dialog, bottomSheet }

class MegaPhotoContainer extends StatelessWidget {
  const MegaPhotoContainer({
    super.key,
    this.profilePhoto,
    this.photo,
    required this.onPhotoChanged,
    this.outlineColor,
    this.buttonColor,
    this.titleColor,
    this.typeModal = TypeModal.dialog,
  });

  final String? profilePhoto;
  final File? photo;
  final Function(XFile) onPhotoChanged;
  final Color? outlineColor;
  final Color? buttonColor;
  final Color? titleColor;
  final TypeModal typeModal;

  void showModal(BuildContext context) {
    MegaFilePicker.showModalChooser(
      context,
      onFileSelected: (file) {
        if (file == null) {
          return;
        }
        onPhotoChanged(XFile(file.path));
      },
      cameraColor: buttonColor ?? context.theme.primaryColor,
      galleryColor: buttonColor ?? context.theme.primaryColor,
    );
  }

  void showDialog(BuildContext context) {
    MegaFilePicker.showDialogChooser(
      context,
      onFileSelected: (file) {
        if (file == null) {
          return;
        }
        onPhotoChanged(XFile(file.path));
      },
      cameraColor: buttonColor ?? context.theme.primaryColor,
      galleryColor: buttonColor ?? context.theme.primaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return switch (typeModal) {
          TypeModal.dialog => showDialog(context),
          TypeModal.bottomSheet => showModal(context),
        };
      },
      child: SizedBox(
        height: 108,
        width: 108,
        child: Center(
          child: Stack(
            children: [
              Container(
                height: 108,
                width: 108,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(54),
                  border: Border.all(
                    color: outlineColor ?? context.theme.colorScheme.secondary,
                    width: 1,
                  ),
                ),
                child: PhotoContainer(
                  profilePhoto: profilePhoto,
                  photo: photo,
                  onPhotoChanged: onPhotoChanged,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: buttonColor ?? context.theme.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ).fadeInAndScale(),
            ],
          ),
        ),
      ),
    );
  }
}
