import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  /// Optional widget to show when the image fails to load.
  /// If null, a default asset image is shown.
  final Widget? errorWidget;

  const CustomImageWidget({
    super.key,
    required this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      // Fallback if URL is null or empty
      return Image.asset(
        "assets/images/no-image.jpg",
        fit: fit,
        width: width,
        height: height,
      );
    }

    if (imageUrl!.startsWith('http') || imageUrl!.startsWith('https')) {
      // Network image
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        errorWidget: (context, url, error) =>
            errorWidget ??
            Image.asset(
              "assets/images/no-image.jpg",
              fit: fit,
              width: width,
              height: height,
            ),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    } else {
      // Local asset image
      return Image.asset(
        imageUrl!,
        fit: fit,
        width: width,
        height: height,
      );
    }
  }
}
