import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      // color: Colors.orange,
      child: Stack(children: <Widget>[
        WindowTitleBarBox(child: MoveWindow()),
        Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 40,
                  // color: Colors.purple,
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Navigator.canPop(context)
                            ? Colors.black
                            : Colors.black12,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                    // color: Colors.blue,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                WindowTitleBarBox(child: MoveWindow()),
                Expanded(
                  child: Align(
                    alignment: Alignment
                        .centerRight, // Align the container to the right
                    child: WindowTitleBarBox(child: MoveWindow()),
                  ),
                ),
                Container(
                  width: 200,
                  height: double.infinity,
                  margin: const EdgeInsets.only(right: 40),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(45.0),
                      boxShadow: [
                        const BoxShadow(color: Colors.black12, blurRadius: 15.0)
                      ]),
                  child: const Center(
                    child: const TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search apps',
                          icon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.only(bottom: 10)),
                    ),
                  ),
                ),
                CloseWindowButton(
                    colors: WindowButtonColors(
                        mouseOver: const Color(0xFFD32F2F),
                        mouseDown: const Color(0xFFB71C1C),
                        iconNormal: const Color(0xFF805306),
                        iconMouseOver: Colors.white)),
              ],
            ))
      ]),
    );
  }
}
