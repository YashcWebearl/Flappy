import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class TapToPlay extends StatelessWidget {
  const TapToPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: const Text(
        "TAP To Start",
        style: TextStyle(
          color: Colors.blueGrey,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      )
          .animate() // Add animation here
          .fadeIn(duration: 500.ms) // Fade in over 1 second
          .scaleXY(begin: 0.5, end: 1.0, duration: 800.ms),
    );
  }
}
