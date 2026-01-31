import 'package:flutter/material.dart';
import 'package:outlet/appstream.dart/lib/src/url.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/views/components/theme.dart';
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
    List<Map<String, String>> links = app.urls.map((link) {
      return switch (link.type) {
        AppstreamUrlType.homepage => {"title": "Homepage", "url": link.url},
        AppstreamUrlType.bugtracker => {
            "title": "Bug Tracker",
            "url": link.url
          },
        AppstreamUrlType.faq => {"title": "FAQ", "url": link.url},
        AppstreamUrlType.help => {"title": "Help", "url": link.url},
        AppstreamUrlType.donation => {"title": "Donate", "url": link.url},
        AppstreamUrlType.translate => {"title": "Translate", "url": link.url},
        AppstreamUrlType.contact => {"title": "Contact", "url": link.url},
        AppstreamUrlType.vcsBrowser => {
            "title": "VCS Browser",
            "url": link.url
          },
        AppstreamUrlType.contribute => {"title": "Contribute", "url": link.url},
      };
    }).toList();

    final Color color = fgColor(context);

    return Container(
        decoration: BoxDecoration(
            color: color,
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
                                  style: const TextStyle(
                                    fontSize: 12,
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
