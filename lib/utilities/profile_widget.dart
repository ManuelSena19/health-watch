import 'dart:io';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget(
      {Key? key,
      required this.imagePath,
      required this.onClicked,
      required this.isEdit})
      : super(key: key);

  Widget buildImage() {
    final image = imagePath.contains('https://')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image as ImageProvider,
          fit: BoxFit.contain,
          width: 200,
          height: 200,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
        ],
      ),
    );
  }
}
