import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

// the filled box with a grey line at the bottom used by all inputs
class InputBox extends StatelessWidget {
  const InputBox({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ColoredBox(
        color: AppColors.inputFill,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ?child,
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 1,
              child: ColoredBox(color: AppColors.lightGrey),
            ),
          ],
        ),
      ),
    );
  }
}
