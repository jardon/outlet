import 'package:flutter/material.dart';

class ReviewScore extends StatelessWidget {
  const ReviewScore({
    required this.score,
    required this.size,
  });

  final double score;
  final double size;

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [];

    int rounded = (score).round();
    int roundedDown = (score).floor();

    for (int i = 0; i < 5; i++) {
      if (i + 1 <= roundedDown) {
        icons.add(Icon(
          Icons.star,
          color: Colors.amberAccent[400],
          size: size / 2,
        ));
      } else if (i + 1 == rounded) {
        icons.add(Icon(
          Icons.star_half,
          color: Colors.amberAccent[400],
          size: size / 2,
        ));
      } else {
        icons.add(Icon(
          Icons.star_border,
          color: Colors.amberAccent[400],
          size: size / 2,
        ));
      }
    }

    return Container(
        height: size,
        width: size * 5,
        child: Row(
          children: icons,
        ));
  }
}
