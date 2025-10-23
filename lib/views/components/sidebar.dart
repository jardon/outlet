import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './download_queue.dart';
import 'app_list.dart';
import '../navigation.dart';
import 'badges.dart';

final Map<String, Map<String, Object>> views = {
  "outlet": {
    "widget": Container(),
    "title": "Outlet",
  },
  "play": {
    "widget": Container(),
    "title": "Play",
  },
  "work": {
    "widget": Container(),
    "title": "Work",
  },
  "build": {
    "widget": Container(),
    "title": "Build",
  },
  "socialize": {
    "widget": Container(),
    "title": "Socialize",
  },
  "relax": {
    "widget": Container(),
    "title": "Relax",
  },
  "device": {
    "widget": AppList(
        details: false, showFeaturedBadge: false, showInstalledBadge: false),
    "title": "This Device",
  },
  "search": {
    "widget": Container(),
    "title": "Search",
  },
  "downloads": {
    "widget": Container(),
    "title": "Downloads",
  },
};

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
    'device': ['flatpak'],
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
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20.0)]),
        child: Column(children: <Widget>[
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
                          Text(views[entries[index]]?["title"] as String,
                              style: TextStyle(
                                fontSize: 20,
                              )),
                        ],
                      ),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.push(
                          context,
                          NoAnimationPageRoute(
                            pageBuilder: (context, animation1, animation2) =>
                                Navigation(
                              child: views[entries[index]]?["widget"] as Widget,
                              title: views[entries[index]]?["title"] as String,
                            ),
                          ),
                        );
                      },
                      trailing: IntrinsicWidth(
                          child: CategoryList(
                        size: 30,
                        categories: categories[entries[index]] ?? [],
                      )),
                    ));
              },
            ),
          )),
          GestureDetector(
              onTap: () {
                Scaffold.of(context).closeDrawer();
                Navigator.push(
                  context,
                  NoAnimationPageRoute(
                    pageBuilder: (context, animation1, animation2) =>
                        Navigation(
                      child: views["downloads"]?["widget"] as Widget,
                      title: views["downloads"]?["title"] as String,
                    ),
                  ),
                );
              },
              child: Container(
                height: 150,
                // color: Colors.yellow,
                child: DownloadQueue(),
              )),
        ]));
  }
}
