import 'package:flutter/material.dart';

class BitCircleAvatar extends StatelessWidget {
  const BitCircleAvatar({
    super.key,
    this.image,
    this.height = 40.0,
    this.width = 40,
  });

  final String? image;
  final double height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.white),
          color: Colors.black,
          shape: BoxShape.circle,
          image: image != null
              ? DecorationImage(image: NetworkImage(image!), fit: BoxFit.cover)
              : null),
    );
  }
}
