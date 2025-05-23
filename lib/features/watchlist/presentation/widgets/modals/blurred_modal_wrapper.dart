import 'package:flutter/material.dart';
import 'dart:ui';

class BlurredModalWrapper extends StatelessWidget {
  final Widget child;
  final bool isScrollControlled;
  final Color? barrierColor;
  final double sigmaX;
  final double sigmaY;

  const BlurredModalWrapper({
    super.key,
    required this.child,
    this.isScrollControlled = true,
    this.barrierColor,
    this.sigmaX = 10,
    this.sigmaY = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Blur backdrop
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: Container(
            color: barrierColor ?? Colors.black.withValues(alpha: 0.3),
          ),
        ),
        // Modal content
        child,
      ],
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
    Color? barrierColor,
    double sigmaX = 10,
    double sigmaY = 10,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BlurredModalWrapper(
            isScrollControlled: isScrollControlled,
            barrierColor: barrierColor,
            sigmaX: sigmaX,
            sigmaY: sigmaY,
            child: child,
          ),
    );
  }
}
