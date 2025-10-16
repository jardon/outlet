import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/navigation.dart';
import 'views/components/sidebar.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));

  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outlet',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: Navigation(
        child: views["outlet"]?["widget"] as Widget,
        title: views["outlet"]?["title"] as String,
      ),
    );
  }
}
