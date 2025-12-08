import '../../core/application.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchURL(String url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

class AppLinks extends StatelessWidget {
  final Application app;

  const AppLinks({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> links = [
      if (app.homepage != null) {"title": "Homepage", "url": app.homepage!},
      if (app.help != null) {"title": "Help", "url": app.help!},
      if (app.translate != null)
        {"title": "Translation", "url": app.translate!},
      if (app.vcs != null) {"title": "Source Code", "url": app.vcs!},
    ];
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 20.0)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: links.isEmpty
              ? const Center(child: Text("No links available."))
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 12,
                      children: links.map((item) {
                        return Row(children: [
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(item["title"]!),
                                Text(
                                  item["url"]!,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ])),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () => _launchURL(item["url"]!),
                            style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll<Color>(Colors.black),
                            ),
                            child: const Text('Visit',
                                style: TextStyle(color: Colors.white)),
                          )
                        ]);
                      }).toList())),
        ));
  }
}
