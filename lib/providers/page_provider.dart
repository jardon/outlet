import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../views/app_list.dart';
import '../views/app_info.dart';

Map<String, Map<String, Object>> views = {
      "bazaar": {
            "widget": AppList(),
            "title": "Bazaar",
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
            "widget": Container(),
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
        "app_info": {
            "widget": AppInfo(),
            "title": "App Info",
        }
    };

class PageNotifier extends Notifier<Map<String, Object>> {

    @override
    Map<String, Object> build() {
        return views["bazaar"] ?? {};
    }

    void changePage(String page) {
        if (views.containsKey(page)) {
            state = views[page] ?? {};
        }
    }

}


final pageNotifierProvider = NotifierProvider<PageNotifier, Map<String, Object>>(() {return PageNotifier();});
