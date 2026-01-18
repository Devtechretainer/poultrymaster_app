import 'package:flutter/material.dart';

/// Reusable Asset Image Widget
/// A customizable widget for displaying asset images with error handling
class AssetImageWidget extends StatelessWidget {
  /// The path to the asset image (e.g., 'assets/icons/egg.png')
  final String assetPath;

  /// Width of the image
  final double? width;

  /// Height of the image
  final double? height;

  /// How the image should be fitted within its bounds
  final BoxFit fit;

  /// Color to blend with the image (optional)
  final Color? color;

  /// Color filter for blending (overrides color if both are provided)
  final ColorFilter? colorFilter;

  /// Optional placeholder widget to show while loading
  final Widget? placeholder;

  /// Optional error widget to show if image fails to load
  final Widget? errorWidget;

  /// Alignment of the image within its bounds
  final AlignmentGeometry alignment;

  /// Whether to repeat the image
  final ImageRepeat repeat;

  /// Filter quality for the image
  final FilterQuality filterQuality;

  /// Padding around the image
  final EdgeInsetsGeometry? padding;

  /// Optional semantic label for accessibility
  final String? semanticLabel;

  const AssetImageWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.colorFilter,
    this.placeholder,
    this.errorWidget,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.low,
    this.padding,
    this.semanticLabel,
  });

  /// Creates a square AssetImageWidget
  const AssetImageWidget.square({
    super.key,
    required this.assetPath,
    required double size,
    this.fit = BoxFit.contain,
    this.color,
    this.colorFilter,
    this.placeholder,
    this.errorWidget,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.low,
    this.padding,
    this.semanticLabel,
  })  : width = size,
        height = size;

  /// Creates an AssetImageWidget with icon-like dimensions (for use in icon containers)
  const AssetImageWidget.icon({
    super.key,
    required this.assetPath,
    double size = 24,
    this.fit = BoxFit.contain,
    this.color,
    this.colorFilter,
    this.placeholder,
    this.errorWidget,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.low,
    this.padding,
    this.semanticLabel,
  })  : width = size,
        height = size;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      color: colorFilter != null ? null : color,
      alignment: alignment,
      repeat: repeat,
      filterQuality: filterQuality,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) {
        if (errorWidget != null) {
          return errorWidget!;
        }
        // Default error widget
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Icon(
            Icons.broken_image,
            size: (width != null && height != null)
                ? (width! < height! ? width! * 0.5 : height! * 0.5)
                : 24,
            color: Colors.grey[400],
          ),
        );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        // Show placeholder while loading
        if (placeholder != null) {
          return placeholder!;
        }
        // Default loading placeholder
        return Container(
          width: width,
          height: height,
          color: Colors.grey[100],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );

    // Apply color filter if provided (wraps the image widget)
    if (colorFilter != null) {
      imageWidget = ColorFiltered(
        colorFilter: colorFilter!,
        child: imageWidget,
      );
    }

    if (padding != null) {
      return Padding(
        padding: padding!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

