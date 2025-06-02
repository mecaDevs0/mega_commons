import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../../mega_commons.dart';

class PhotoContainer extends StatelessWidget {
  const PhotoContainer({
    super.key,
    this.profilePhoto,
    this.photo,
    required this.onPhotoChanged,
    this.outlineColor,
  });

  final String? profilePhoto;
  final File? photo;
  final Function(XFile) onPhotoChanged;
  final Color? outlineColor;

  @override
  Widget build(BuildContext context) {
    if (profilePhoto != null && photo == null) {
      return MegaCachedNetworkImage(
        imageUrl: profilePhoto,
        height: 108,
        width: 108,
        radius: 80,
      ).fadeIn;
    }
    if (photo == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.user,
            size: 20,
            color: outlineColor ?? context.theme.colorScheme.secondary,
          ),
          const SizedBox(height: 8),
          Text(
            'Foto',
            style: TextStyle(
              color: outlineColor ?? context.theme.colorScheme.secondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ).fadeIn;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(54),
      child: Image.file(
        photo!,
        fit: BoxFit.cover,
      ),
    ).fadeIn;
  }
}
