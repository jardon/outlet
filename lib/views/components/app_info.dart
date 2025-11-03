import 'package:flutter/material.dart';
import '../../core/application.dart';
import 'app_icon_loader.dart';
import 'badges.dart';

class AppInfo extends StatelessWidget {
  final Application app;

  const AppInfo({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20.0)]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10.0,
          children: <Widget>[
            AppIconLoader(
              icon: app.icon,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(spacing: 10, children: [
                  Flexible(
                      child: Text(
                    app.name ?? app.id,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ]),
                Expanded(
                    child: Container(
                        child: Text(
                  app.summary ?? "No summary available.",
                  style: const TextStyle(fontSize: 16),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ))),
                Row(spacing: 5, children: [
                  Text((app.developer != null ? "by ${app.developer}" : "")),
                  app.verified ? VerifiedBadge(size: 20) : Container(),
                ]),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
