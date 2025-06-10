import 'package:flutter/material.dart';
import 'views/components/sidebar.dart';
import 'views/components/view_box.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outlet',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            Sidebar(),
            Expanded(
              child: ViewBox(),
            ),
          ],
        ),
      )
    );
  }
}
