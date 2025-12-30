import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A reusable loading widget that displays a Lottie animation
class LoadingWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final String? message;

  const LoadingWidget({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.message,
  });

  /// Small loading indicator for buttons
  const LoadingWidget.small({
    super.key,
    this.width = 20,
    this.height = 20,
    this.backgroundColor,
    this.message,
  });

  /// Medium loading indicator for forms
  const LoadingWidget.medium({
    super.key,
    this.width = 50,
    this.height = 50,
    this.backgroundColor,
    this.message,
  });

  /// Large loading indicator for full screen
  const LoadingWidget.large({
    super.key,
    this.width = 150,
    this.height = 150,
    this.backgroundColor,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final loadingWidget = SizedBox(
      width: width,
      height: height,
      child: Lottie.asset(
        'assets/animations/Loading.json',
        fit: BoxFit.contain,
        repeat: true,
      ),
    );

    if (message != null) {
      return Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingWidget,
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (backgroundColor != null) {
      return Container(
        color: backgroundColor,
        child: Center(child: loadingWidget),
      );
    }

    return Center(child: loadingWidget);
  }
}
