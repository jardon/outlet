import '../screenshots_view.dart';
import 'package:flutter/material.dart';

class Screenshots extends StatelessWidget {
  final List<dynamic> screenshots;

  const Screenshots({
    super.key,
    required this.screenshots,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> fullSizedScreenshots =
        screenshots.where((image) => image.contains('orig')).toList();
    return Container(
      width: 400,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
          boxShadow: [
            const BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (fullSizedScreenshots.length == 0)
            ? const Center(child: const Text("No screenshots available."))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: fullSizedScreenshots.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScreenshotsView(
                                    screenshot: fullSizedScreenshots[index],
                                  ),
                                ),
                              );
                            },
                            child: Center(
                                child: Image.network(
                              fullSizedScreenshots[index],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('Error loading image');
                              },
                            )))),
                  );
                },
              ),
      ),
    );
  }
}
