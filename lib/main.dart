import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/loading.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));

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
      home: const Scaffold(backgroundColor: Colors.black, body: Loading()),
    );
  }
}
