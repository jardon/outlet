import 'package:flutter/material.dart';
import './navbar.dart';

class ViewBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
            // color: Colors.green,
            child: Column(
                children: <Widget>[
                    Navbar(),
                    Expanded(
                        child: Container(
                            // color: Colors.pink,
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                                // color: Colors.green,
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
                                    child: Text(
                                        "VIEW BOX",
                                    ),
                                ),
                            ),
                        )
                    ),
                ],
            ),
        );
    }
}
