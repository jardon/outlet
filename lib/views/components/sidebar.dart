import '../../core/application.dart';
import '../../providers/application_provider.dart';
import '../navigation.dart';
import 'app_list.dart';
import 'badges.dart';
import 'dart:io';
import 'download_queue.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Map<String, String> env = Platform.environment;

late Map<String, Map<String, Object>> views;

final List<String> appSupport = (() {
  List<String> supportList = [];
  if (env['FLATPAK_ENABLED'] != null) {
    supportList.add('flatpak');
  }
  return supportList;
})();

class Sidebar extends ConsumerWidget {
  Sidebar({
    super.key,
  });

  final List<String> entries = const [
    'device',
    'outlet',
    'play',
    'work',
    'build',
    'socialize',
    'relax',
  ];

  final Map<String, List<String>> categories = {
    'device': appSupport,
    'outlet': const ['featured'],
    'play': const ['audio', 'video', 'game'],
    'work': const ['development', 'network', 'graphics'],
    'build': const ['development', 'graphics'],
    'socialize': const ['game'],
    'relax': const ['audio', 'video'],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Application> installed = ref.watch(installedAppListProvider);
    AsyncValue<List<Application>> apps = ref.watch(appListProvider);
    views = {
      "outlet": {
        "widget": AppList(
          apps: apps.value ?? [],
        ),
        "title": "Featured",
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
          apps: installed,
          details: false,
        ),
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
    return Container(
        width: 300.0,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(45.0),
              bottomRight: Radius.circular(45.0),
            ),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20.0)]),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(45.0),
              bottomRight: Radius.circular(45.0),
            ),
            child: Column(children: <Widget>[
              WindowTitleBarBox(child: MoveWindow()),
              Expanded(
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
                                  style: const TextStyle(
                                    fontSize: 20,
                                  )),
                            ],
                          ),
                          onTap: () {
                            Scaffold.of(context).closeDrawer();
                            Navigator.push(
                              context,
                              NoAnimationPageRoute(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        Navigation(
                                  title:
                                      views[entries[index]]?["title"] as String,
                                  child: views[entries[index]]?["widget"]
                                      as Widget,
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
              ),
              GestureDetector(
                  onTap: () {
                    Scaffold.of(context).closeDrawer();
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        pageBuilder: (context, animation1, animation2) =>
                            Navigation(
                          title: views["downloads"]?["title"] as String,
                          child: views["downloads"]?["widget"] as Widget,
                        ),
                      ),
                    );
                  },
                  child: const SizedBox(
                    height: 150,
                    // color: Colors.yellow,
                    child: DownloadQueue(),
                  )),
            ])));
  }
}
