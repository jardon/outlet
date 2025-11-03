import 'package:flutter/material.dart';

class ScreenshotsView extends StatelessWidget {
  final String screenshot;

  const ScreenshotsView({
    super.key,
    required this.screenshot,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Stack(children: [
          Center(
              child: Image.network(
            screenshot,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Text('Error loading image');
            },
          )),
          Positioned(
            top: 30,
            left: 30,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: CloseButton(
                  color: Colors.white,
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                )),
          ),
        ]));
  }
}
