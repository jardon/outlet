import 'package:flutter/material.dart';

class DownloadQueue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45.0),
          boxShadow: [
            const BoxShadow(color: Colors.black12, blurRadius: 15.0)
          ]),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(children: <Widget>[
            Container(
                height: 50.0,
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                alignment: Alignment.topLeft,
                // color: Colors.pink,
                child: const Text(
                  "No downloads queued.",
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Expanded(
                child: Container(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 40),
                    alignment: Alignment.topLeft,
                    // color: Colors.green,
                    child: const Text(
                      "Install an application to add it to the queue.",
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    )))
          ])),
    );
  }
}
