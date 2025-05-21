import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressHudIndicator extends StatelessWidget {
  const ProgressHudIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SpinKitFoldingCube(
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
