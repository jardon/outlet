import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class Navbar extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Container(
            height: 60,
            // color: Colors.orange,
            child: Stack(
                children: <Widget>[
                    Container(
                        // color: Colors.pink,
                        child: WindowTitleBarBox(child: MoveWindow()),
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                            children: <Widget>[
                                Container(
                                    width: 40,
                                    // color: Colors.purple,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: IconButton(
                                            icon: Icon(
                                                Icons.arrow_back,
                                                color: Colors.black12,
                                            ),
                                            onPressed: () {},
                                        ),
                                    ),
                                ),
                                Container(
                                    // color: Colors.blue,
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Text(
                                        "Page Name",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    )
                                ),
                                WindowTitleBarBox(child: MoveWindow()),
                                Expanded(
                                    child: Container(
                                        // color: Colors.yellow,
                                        child: Align(
                                            alignment: Alignment.centerRight, // Align the container to the right
                                            child: WindowTitleBarBox(child: MoveWindow()),
                                        ),
                                    ),
                                ),
                                Container(
                                    width: 200,
                                    height: double.infinity,
                                    margin: EdgeInsets.only(right: 40),
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(45.0),
                                        boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 15.0
                                            )
                                        ]
                                    ),
                                    child: Center(
                                        child: TextField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Search apps',
                                                icon: Icon(Icons.search),
                                                contentPadding: EdgeInsets.only(bottom: 10)
                                            ),
                                        ),
                                    ),
                                ),
                                const WindowButtons(),
                            ],
                        )
                    )
                ]
            ),
        );

    }
}


class WindowButtons extends StatefulWidget {
  const WindowButtons({super.key});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}


final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white);

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              )
            : MaximizeWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
