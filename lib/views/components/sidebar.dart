import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './download_queue.dart';
import '../../providers/page_provider.dart';
import 'badges.dart';

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

  final Map<String, List<String>> categories = {
    'device': [],
    'outlet': ['featured'],
    'play': ['audio', 'video', 'game'],
    'work': ['development', 'network', 'graphics'],
    'build': ['development', 'graphics'],
    'socialize': ['game'],
    'relax': ['audio', 'video'],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 300.0,
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
                          return Material(
                            color: Colors.white,
                            child: ListTile(
                              title: Row(
                                children: [
                                  const SizedBox(width: 10.0),
                                  Text(
                                    views[entries[index]]?["title"] as String,
                                    style: TextStyle(
                                      fontSize: 20,
                                    )
                                  ),
                                ],
                              ),
                              onTap: () { ref.read(pageNotifierProvider.notifier).changePage(entries[index]);},
                              trailing: IntrinsicWidth(
                                child: CategoryList(
                                  size: 30,
                                  categories: categories[entries[index]] ?? [],
                                )
                              ),
                            )
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