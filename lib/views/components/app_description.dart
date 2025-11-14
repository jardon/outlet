import '../../core/application.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';

class AppDescription extends StatelessWidget {
  final Application app;

  const AppDescription({
    super.key,
    required this.app,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
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
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Html(data: app.description ?? "No description available.", style: {
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
            }),
          ],
        ),
      ),
    );
  }
}
