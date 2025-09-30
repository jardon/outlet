import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './download_queue.dart';
import '../../providers/page_provider.dart';

class Sidebar extends ConsumerWidget {
  final List<String> entries = [
    'device',
    'outlet',
    'play',
    'work',
    'build',
    'socialize',
    'relax',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 300.0,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(45.0),
                    bottomRight: Radius.circular(45.0),
                ),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20.0
                    )
                ]
            ),
      child: Column(
        children: <Widget>[
          WindowTitleBarBox(child: MoveWindow()),
          Expanded(
              child: Container(
                  // color: Colors.red,
                  child: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                          return ListTile(
                          title: Text(views[entries[index]]?["title"] as String),
                          onTap: () { ref.read(pageNotifierProvider.notifier).changePage(entries[index]);},
                          );
                      },
                  ),
              )
          ),
          Container(
              height: 150,
              // color: Colors.yellow,
              child: DownloadQueue(),
          ),
        ]
      )
    );
  }
}