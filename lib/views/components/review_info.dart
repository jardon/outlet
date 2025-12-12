import 'theme.dart';
import 'package:flutter/material.dart';

class ReviewInfo extends StatelessWidget {
  final List<dynamic> reviews;

  const ReviewInfo({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = fgColor(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text("No reviews available.")),
      ),
    );
  }
}
