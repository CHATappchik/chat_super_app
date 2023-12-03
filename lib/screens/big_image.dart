import 'package:flutter/material.dart';

class BigImage extends StatelessWidget {
  const BigImage( {super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.network(image);
  }
}
