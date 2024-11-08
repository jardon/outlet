import 'package:flutter/material.dart';

class ReviewScore extends StatelessWidget {

    final double score;
    final double size;

    ReviewScore({
        required this.score,
        required this.size,
    });

    @override
    Widget build(BuildContext context) {
        List<Widget> icons = [];

        int rounded = (this.score).round();
        int rounded_down = (this.score).floor();

        for (int i = 0; i < 5; i++) {
            if (i + 1 <= rounded_down) {
                icons.add(
                    Icon(
                        Icons.star,
                        color: Colors.black,
                        size: this.size / 2,
                    )
                );
            }
            else if (i + 1 == rounded) {
                icons.add(
                    Icon(
                        Icons.star_half,
                        color: Colors.black,
                        size: this.size / 2,
                    )
                );
            }
            else {
                icons.add(
                    Icon(
                        Icons.star_border,
                        color: Colors.black,
                        size: this.size / 2,
                    )
                );
            }
        }

        return Container(
            height: this.size,
            width: this.size * 5,
            child: Row(
                children: icons,
            )
        );
    }
}
