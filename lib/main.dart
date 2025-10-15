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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outlet',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          const double breakpoint = 800.0;
          final bool isWide = constraints.maxWidth > breakpoint;

          return Scaffold(
            drawer: isWide ? 
              null : 
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(45.0),
                  bottomRight: Radius.circular(45.0),
                ),
                child: Drawer(child: Sidebar())
              ),
            body: isWide ? 
              Row(
                  children: [
                    SizedBox(
                      width: 250, 
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: 20,
                              child: WindowTitleBarBox(child: MoveWindow()),
                            ),
                            Expanded(child: Sidebar()),
                          ],
                        ),
                        margin: const EdgeInsets.only(bottom: 20.0),
                      ),
                    ),
                    Expanded(
                      child: ViewBox(),
                    ),
                  ],
                )
              : 
              ViewBox(),
            floatingActionButton: isWide ?
              null :
              Builder(
                builder: (context) => FloatingActionButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.menu, color: Colors.white),
                ),
            ),
          );
        },
      ),
    );
  }
}