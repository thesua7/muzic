import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const CustomLoadingIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitPianoWave(
      color: color,
      size: size,
    );
  }
}
