import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.photo, required this.onTap});

  final File? photo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        height: 100,
        child: photo == null ? placeholder() : withPhoto(photo!),
      ),
    );
  }

  Widget placeholder() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset('assets/icons/avatar_placeholder.svg'),
        SvgPicture.asset('assets/icons/avatar_camera.svg'),
      ],
    );
  }

  Widget withPhoto(File file) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset('assets/icons/avatar_ring.svg'),
        ClipOval(
          child: Image.file(file, width: 94, height: 94, fit: BoxFit.cover),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: SvgPicture.asset('assets/icons/avatar_edit.svg'),
          ),
        ),
      ],
    );
  }
}
