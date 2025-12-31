import 'package:flutter/material.dart';
import 'package:outlet/views/components/download_queue.dart';

class DownloadsView extends StatelessWidget {
  const DownloadsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      SliverToBoxAdapter(
          child: SizedBox(height: 150, child: CurrentDownload())),
      SliverToBoxAdapter(child: PendingDownloads()),
      SliverToBoxAdapter(child: CompletedDownloads()),
      SliverToBoxAdapter(child: SizedBox(height: 20)),
      SliverToBoxAdapter(child: DownloadsFooterMessage()),
      SliverToBoxAdapter(child: SizedBox(height: 50)),
    ]);
  }
}
