import 'package:flutter/material.dart';
import 'package:mega_commons_dependencies/mega_commons_dependencies.dart';

import '../../mega_commons.dart';

class MegaCachedNetworkImage extends StatelessWidget {
  const MegaCachedNetworkImage({
    super.key,
    this.imageUrl,
    this.radius,
    this.width,
    this.height,
    this.fit,
    this.progressIndicatorColor,
    this.progressIndicatorStrokeWidth,
    this.borderWidth,
    this.borderColor,
  });

  final String? imageUrl;
  final double? radius;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? progressIndicatorColor;
  final double? progressIndicatorStrokeWidth;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height ?? 200,
      width: width ?? context.width,
      imageUrl: _validImage,
      imageBuilder: (context, imageProvider) => Container(
        padding: EdgeInsets.all(borderWidth ?? 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? context.theme.colorScheme.secondary,
            width: borderWidth ?? 0,
            style: borderWidth != null ? BorderStyle.solid : BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(radius ?? 0),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
      placeholder: (_, __) => Skeletonizer(
        child: Container(
          height: height ?? 200,
          width: width ?? context.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 0),
            color: Colors.white,
          ),
        ).leaf,
      ),
      errorWidget: (_, __, ___) => Container(
        height: height ?? 200,
        width: width ?? context.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 0),
          color: const Color(0xFFBFBFBF),
          border: Border.all(
            color: borderColor ?? context.theme.colorScheme.secondary,
            width: borderWidth ?? 0,
            style: borderWidth != null ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Center(
          child: Icon(
            FontAwesomeIcons.image,
            color: Colors.white,
            size: _getSizeIcon(),
          ),
        ),
      ),
    );
  }

  String get _validImage {
    if (imageUrl.isNullOrEmpty) {
      return _getDefaultImage;
    }
    return imageUrl!;
  }

  double _getSizeIcon() {
    if (width != null && height != null) {
      return width! > height! ? height! / 2 : width! / 2;
    } else if (width != null) {
      return width! / 2;
    } else if (height != null) {
      return height! / 2;
    } else {
      return 24;
    }
  }

  String get _getDefaultImage => 'https://i.ibb.co/3SbWpXn/no-image.png';
}
