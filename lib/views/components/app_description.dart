import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/views/components/expandable_container.dart';
import 'package:outlet/views/components/theme.dart';
import 'package:outlet/views/components/badges.dart';

class AppDescription extends StatelessWidget {
  final Application app;

  const AppDescription({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = fgColor(context);

    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 20.0)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child: Text(app.getLocalizedSummary(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))),
                const SizedBox(width: 10),
                CategoryList(categories: app.categories, size: 30),
              ],
            ),
            const SizedBox(height: 8),
            ExpandableContainer(
                maxHeight: 150,
                child: Html(data: app.getLocalizedDescription(), style: {
                  "h1": Style(
                    fontSize: FontSize.xxLarge,
                    textAlign: TextAlign.center,
                  ),
                  "p": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    lineHeight: const LineHeight(1.5),
                  ),
                  "ul": Style(
                    padding: HtmlPaddings.only(left: 20),
                    margin: Margins.only(top: 8, bottom: 8),
                  ),
                })),
          ],
        ),
      ),
    );
  }
}
