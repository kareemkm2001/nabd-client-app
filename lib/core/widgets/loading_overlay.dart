import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AbsorbPointer(
        absorbing: true,
        child: LoadingAnimationWidget.dotsTriangle(
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }
}