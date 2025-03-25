import 'package:flappy/widget/app_style.dart';
import 'package:flutter/material.dart';
class BoxOverlay extends StatelessWidget {
  const BoxOverlay({super.key,required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppColors.boxbgColor,
      decoration: BoxDecoration(
        color: AppColors.boxbgColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 16.0,
      ),
      child: child,
    );
  }
}
