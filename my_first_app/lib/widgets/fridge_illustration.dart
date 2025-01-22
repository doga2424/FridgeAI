import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FridgeIllustration extends StatelessWidget {
  final double screenWidth;
  final DateTime timestamp;

  const FridgeIllustration({
    Key? key,
    required this.screenWidth,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'fridge-illustration-${timestamp.millisecondsSinceEpoch}',
      child: SvgPicture.asset(
        'assets/images/fridge.svg',
        width: screenWidth * 0.3,
        height: screenWidth * 0.3,
        fit: BoxFit.contain,
        key: ValueKey(timestamp.millisecondsSinceEpoch),
      ),
    );
  }
} 