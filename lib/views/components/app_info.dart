import 'package:flutter/material.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/views/components/theme.dart';
import 'package:outlet/views/components/app_icon_loader.dart';
import 'package:outlet/views/components/badges.dart';

class AppInfo extends StatelessWidget {
  final Application app;

  const AppInfo({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = fgColor(context);

    return Container(
      height: 150,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
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
                    app.getLocalizedName(),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                ]),
                Expanded(
                    child: Text(
                  app.getLocalizedSummary(),
                  style: const TextStyle(fontSize: 16),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
                Row(spacing: 5, children: [
                  Text((app.getLocalizedDeveloperName() != ""
                      ? "by ${app.getLocalizedDeveloperName()}"
                      : "")),
                  app.verified ? const VerifiedBadge(size: 20) : Container(),
                ]),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
