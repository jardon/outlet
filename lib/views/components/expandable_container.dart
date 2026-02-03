import 'package:flutter/material.dart';

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
