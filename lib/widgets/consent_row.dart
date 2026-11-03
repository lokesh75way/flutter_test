import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import 'input_box.dart';

class ConsentRow extends StatelessWidget {
  const ConsentRow({super.key, required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.04),
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 24.916,
              height: 24.916,
              child: InputBox(
                child: checked
                    ? const Icon(Icons.check, size: 16, color: AppColors.brand)
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12.084),
        const Expanded(
          child: Text.rich(
            TextSpan(
              style: AppText.consent,
              children: [
                TextSpan(text: 'I consent to the '),
                TextSpan(text: 'Terms of Service', style: AppText.link),
                TextSpan(text: ', '),
                TextSpan(text: 'Privacy Policy', style: AppText.link),
                TextSpan(text: ',\nand '),
                TextSpan(
                  text: 'Payment & Cancellation Policy',
                  style: AppText.link,
                ),
                TextSpan(text: ' of ABAPRO'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
