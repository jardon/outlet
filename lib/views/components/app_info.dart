import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/providers/action_queue.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/components/theme.dart';
import 'package:outlet/views/components/app_icon_loader.dart';
import 'package:outlet/views/components/badges.dart';

class AppInfo extends ConsumerWidget {
  final String id;

  const AppInfo({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(liveApplicationProvider(id));
    final Color color = fgColor(context);

    if (app != null) {
      ref.watch(isAppActionQueuedProvider(app.id));
    }

    return (app != null)
        ? Container(
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
                      Row(spacing: 5, children: [
                        Text((app.getLocalizedDeveloperName() != ""
                            ? "by ${app.getLocalizedDeveloperName()}"
                            : "")),
                        app.verified
                            ? const VerifiedBadge(size: 20)
                            : Container(),
                      ]),
                      Expanded(child: Container()),
                      if (app.installed)
                        TextButton(
                          onPressed: () async {
                            var launch = app.launchCommand();
                            await Process.start(
                              launch.split(' ').first,
                              launch.split(' ').sublist(1),
                              mode: ProcessStartMode.detached,
                            );
                          },
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll<Color>(Colors.black),
                          ),
                          child: const Text("Open",
                              style: TextStyle(color: Colors.white)),
                        ),
                    ],
                  )),
                ],
              ),
            ),
          )
        : Container();
  }
}
