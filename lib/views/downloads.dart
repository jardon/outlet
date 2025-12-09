import 'components/download_queue.dart';
import 'package:flutter/material.dart';

class DownloadsView extends StatelessWidget {
  const DownloadsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(children: [
          SizedBox(height: 10),
          SizedBox(height: 150, child: CurrentDownload()),
          PendingDownloads(),
          CompletedDownloads(),
          SizedBox(height: 20),
          DownloadsFooterMessage(),
          SizedBox(height: 50),
        ]));
  }
}
