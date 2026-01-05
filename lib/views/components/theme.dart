import 'package:flutter/material.dart';

Color fgColor(context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF303030) // Colors.grey.shade850
      : Colors.white;
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.indigo,
  scaffoldBackgroundColor: Colors.grey.shade900,
);

final List<Color> featuredColors = <Color>[
  Colors.yellow,
  Colors.orange,
];

final List<Color> featuredColorsAlt = <Color>[
  Colors.yellow.shade700,
  Colors.orange,
];

final List<Color> videoColors = <Color>[
  Colors.green,
  Colors.blue,
];

final List<Color> audioColors = <Color>[
  Colors.red,
  Colors.orange,
];

final List<Color> devColors = <Color>[
  Colors.blue,
  Colors.purple.shade400,
];

final List<Color> gameColors = <Color>[
  Colors.green,
  Colors.yellow,
];

final List<Color> gameColorsAlt = <Color>[
  Colors.green,
  Colors.lime,
];

final List<Color> graphicsColors = <Color>[
  Colors.purple,
  Colors.pink,
];

final List<Color> networkColors = <Color>[
  Colors.pink,
  Colors.red,
];

final List<Color> utilityColors = <Color>[
  Colors.pink,
  Colors.pink.shade400,
];

final List<Color> educationColors = <Color>[
  Colors.orange,
  Colors.pink,
];

final List<Color> officeColors = <Color>[
  Colors.blue,
  Colors.cyan.shade600,
];

final List<Color> scienceColors = <Color>[
  Colors.indigo,
  Colors.purple.shade600,
];

final List<Color> settingsColors = <Color>[
  Colors.cyan,
  Colors.teal.shade400,
];

final List<Color> systemColors = <Color>[
  Colors.teal,
  Colors.green.shade600,
];
