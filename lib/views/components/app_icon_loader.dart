import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Requires flutter_svg dependency

class AppIconLoader extends StatelessWidget {
  AppIconLoader({
    super.key,
    required this.icon,
  });

  final String icon;

  @override
  Widget build(BuildContext context) {
    final isRemote = icon.startsWith('http://') || icon.startsWith('https://');
    final isSvg = icon.toLowerCase().endsWith('.svg');

    if (isRemote) {
      if (isSvg) {
        return SvgPicture.network(
          icon,
          fit: BoxFit.contain,
          semanticsLabel: 'App Icon',
          colorFilter: ColorFilter.mode(Colors.black12, BlendMode.srcIn),
        );
      } else {
        return Image.network(
          icon,
          fit: BoxFit.contain,
        );
      }
    } else {
      if (isSvg) {
        return SvgPicture.asset(
          icon,
          fit: BoxFit.contain,
          semanticsLabel: 'App Icon',
          colorFilter: ColorFilter.mode(Colors.black12, BlendMode.srcIn),
        );
      } else {
        return Image.asset(
          icon,
          fit: BoxFit.contain,
        );
      }
    }
  }
}
