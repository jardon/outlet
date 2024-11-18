import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import './download_queue.dart';

class Sidebar extends StatelessWidget {
  final List<String> entries = [
    'Your Device',
    'Bazaar',
    'Play',
    'Work',
    'Build',
    'Socialize',
    'Relax',
  ];

  void _onItemTap(BuildContext context, String entry) {
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.0,
      decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                        Colors.grey[300]!,
                        Colors.white,
                    ],
                    tileMode: TileMode.mirror,
                ),
            ),
      child: Column(
        children: <Widget>[
          WindowTitleBarBox(child: MoveWindow()),
          Expanded(
              child: Container(
                  // color: Colors.red,
                  child: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                          return ListTile(
                          title: Text(entries[index]),
                          onTap: () => _onItemTap(context, entries[index]),
                          );
                      },
                  ),
              )
          ),
          Container(
              height: 150,
              // color: Colors.yellow,
              child: DownloadQueue(),
          ),
        ]
      )
    );
  }
}