import 'package:flutter/material.dart';
import 'components/sidebar.dart';
import 'components/navbar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Navigation extends StatelessWidget {
  const Navigation({
    super.key,
    required this.child,
    required this.title,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double breakpoint = 800.0;
        final bool isWide = constraints.maxWidth > breakpoint;

        return Scaffold(
          drawer: isWide
              ? null
              : ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(45.0),
                    bottomRight: Radius.circular(45.0),
                  ),
                  child: Drawer(child: Sidebar())),
          body: isWide
              ? Row(
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
                      child: ViewBox(
                        child: child,
                        title: title,
                      ),
                    ),
                  ],
                )
              : ViewBox(
                  child: child,
                  title: title,
                ),
          floatingActionButton: isWide
              ? null
              : Builder(
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
    );
  }
}

class ViewBox extends ConsumerWidget {
  const ViewBox({
    super.key,
    required this.child,
    required this.title,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // color: Colors.green,
      child: Column(
        children: <Widget>[
          Navbar(title: title),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class NoAnimationPageRoute<T> extends PageRouteBuilder<T> {
  NoAnimationPageRoute({required super.pageBuilder})
      : super(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );
}
