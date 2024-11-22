import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './navbar.dart';
import '../../providers/page_provider.dart';

class ViewBox extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
            // color: Colors.green,
            child: Column(
                children: <Widget>[
                    Navbar(),
                    Expanded(
                        child: ref.watch(pageNotifierProvider)["widget"] as Widget,
                    ),
                ],
            ),
        );
    }
}
