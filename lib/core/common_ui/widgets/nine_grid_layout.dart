import 'package:flutter/material.dart';
import 'package:khazana_mutual_funds/core/common_ui/widgets/triple_rail.dart';

class NineGridLayout extends StatelessWidget {
  const NineGridLayout({
    super.key,
    this.topLeft,
    this.topCenter,
    this.topRight,
    this.middleLeft,
    this.middleCenter,
    this.middleRight,
    this.bottomLeft,
    this.bottomCenter,
    this.bottomRight,
    this.topRowFlex = 0,
    this.middleRowFlex = 0,
    this.bottomRowFlex = 0,
    this.topRowMainAxisAlignment = MainAxisAlignment.center,
    this.middleRowMainAxisAlignment = MainAxisAlignment.center,
    this.bottomRowMainAxisAlignment = MainAxisAlignment.center,
    this.topRowCrossAxisAlignment = CrossAxisAlignment.center,
    this.middleRowCrossAxisAlignment = CrossAxisAlignment.center,
    this.bottomRowCrossAxisAlignment = CrossAxisAlignment.center,
  });

  final Widget? topLeft;
  final Widget? topCenter;
  final Widget? topRight;
  final Widget? middleLeft;
  final Widget? middleCenter;
  final Widget? middleRight;
  final Widget? bottomLeft;
  final Widget? bottomCenter;
  final Widget? bottomRight;
  final int topRowFlex;
  final int middleRowFlex;
  final int bottomRowFlex;
  final MainAxisAlignment topRowMainAxisAlignment;
  final MainAxisAlignment middleRowMainAxisAlignment;
  final MainAxisAlignment bottomRowMainAxisAlignment;
  final CrossAxisAlignment topRowCrossAxisAlignment;
  final CrossAxisAlignment middleRowCrossAxisAlignment;
  final CrossAxisAlignment bottomRowCrossAxisAlignment;

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top Row
        Expanded(
          flex: topRowFlex,
          child: TripleRail(
            mainAxisAlignment: topRowMainAxisAlignment,
            crossAxisAlignment: topRowCrossAxisAlignment,
            leading: topLeft ?? Container(),
            middle: topCenter ?? Container(),
            trailing: topRight ?? Container(),
          ),
        ),

        // Middle Row
        Expanded(
          flex: middleRowFlex,
          child: TripleRail(
            mainAxisAlignment: middleRowMainAxisAlignment,
            crossAxisAlignment: middleRowCrossAxisAlignment,
            leading: middleLeft ?? Container(),
            middle: middleCenter ?? Container(),
            trailing: middleRight ?? Container(),
          ),
        ),

        // Bottom Row
        Expanded(
          flex: bottomRowFlex,
          child: TripleRail(
            mainAxisAlignment: bottomRowMainAxisAlignment,
            crossAxisAlignment: bottomRowCrossAxisAlignment,
            leading: bottomLeft ?? Container(),
            middle: bottomCenter ?? Container(),
            trailing: bottomRight ?? Container(),
          ),
        ),
      ],
    );
  }
}
