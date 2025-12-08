import '../../core/application.dart';
import 'badges.dart';
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
            Row(
              children: [
                const Expanded(
                    child: Text('Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))),
                CategoryList(categories: app.categories, size: 30),
              ],
            ),
            const SizedBox(height: 8),
            ExpandableContainer(
                maxHeight: 150,
                child: Html(
                    data: app.description ?? "No description available.",
                    style: {
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

class ExpandableContainer extends StatefulWidget {
  final Widget child;
  final double maxHeight;

  const ExpandableContainer({
    super.key,
    required this.child,
    this.maxHeight = 150.0,
  });

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool _isExpanded = false;
  bool _showExpandButton = false;

  final GlobalKey _contentKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _measureContentHeight());
  }

  void _measureContentHeight() {
    final RenderBox? renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null && renderBox.hasSize) {
      final double actualHeight = renderBox.size.height;

      if (actualHeight - widget.maxHeight > 20 && !_showExpandButton) {
        setState(() {
          _showExpandButton = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxConstraint =
        _isExpanded || !_showExpandButton ? double.infinity : widget.maxHeight;

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxConstraint,
          ),
          child: KeyedSubtree(
            key: _contentKey,
            child: widget.child,
          ),
        ),
        if (_showExpandButton)
          Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.black),
                ),
                child: Text(
                  _isExpanded ? 'Show Less' : 'Show More',
                  style: const TextStyle(color: Colors.white),
                ),
              )),
      ],
    );
  }
}
