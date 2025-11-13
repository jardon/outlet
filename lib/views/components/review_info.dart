import 'package:flutter/material.dart';

class ReviewInfo extends StatelessWidget {
  final List<dynamic> reviews;

  const ReviewInfo({
    super.key,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
          boxShadow: [
            const BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text("No reviews available.")),
      ),
    );
  }
}
