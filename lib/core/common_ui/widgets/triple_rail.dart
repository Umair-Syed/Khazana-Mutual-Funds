import 'package:flutter/material.dart';

class TripleRail extends StatelessWidget {
  const TripleRail({
    super.key,
    this.leading,
    this.middle,
    this.trailing,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: leading,
          ),
        ),
        if (middle != null) middle!,
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: trailing,
          ),
        ),
      ],
    );
  }
}
