import 'dart:core';

abstract class Application {
  Application({
    required String id,
    String? name,
    String? summary,
    String? license,
    String? description,
    String? developer,
    required String icon,
    String? homepage,
    String? help,
    String? translate,
    String? vcs,
    List<String> categories = const [],
    List<Screenshot> screenshots = const [],
    List<String> keywords = const [],
    List<Release> releases = const [],
    Map<String, String> content = const {},
    bool featured = false,
    bool verified = false,
    bool installed = false,
    List<dynamic> reviews = const [],
    String? bundle,
    String? remote,
    String? version,
    String? branch,
    bool? current,
    String? arch,
  })  : _id = id,
        _name = name,
        _summary = summary,
        _license = license,
        _description = description,
        _developer = developer,
        _icon = icon,
        _homepage = homepage,
        _help = help,
        _translate = translate,
        _vcs = vcs,
        _categories = categories,
        _screenshots = screenshots,
        _keywords = keywords,
        _releases = releases,
        _content = content,
        _featured = featured,
        _verified = verified,
        _installed = installed,
        _reviews = reviews,
        _bundle = bundle,
        _remote = remote,
        _version = version,
        _branch = branch,
        _current = current,
        _arch = arch;

  final String _id;
  final String? _name;
  final String? _summary;
  final String? _license;
  final String? _description;
  final String? _developer;
  final String _icon;
  final String? _homepage;
  final String? _help;
  final String? _translate;
  final String? _vcs;
  final List<String> _categories;
  final List<Screenshot> _screenshots;
  final List<String> _keywords;
  final List<Release> _releases;
  final Map<String, String> _content;
  final bool _featured;
  final bool _verified;
  final bool _installed;
  final List<dynamic> _reviews;
  final String? _bundle;
  double? get rating;
  final String? _remote;
  final String? _version;
  String? _branch;
  bool? _current;
  String? _arch;

  String get id => _id;

  String? get name => _name;

  String? get summary => _summary;

  String? get license => _license;

  String? get description => _description;

  String? get developer => _developer;

  String get icon => _icon;

  String? get homepage => _homepage;

  String? get help => _help;

  String? get translate => _translate;

  String? get vcs => _vcs;

  List<String> get categories => _categories;

  List<Screenshot> get screenshots => _screenshots;

  List<String> get keywords => _keywords;

  List<Release> get releases => _releases;

  Map<String, String> get content => _content;

  bool get featured => _featured;

  bool get verified => _verified;

  bool get installed => _installed;

  List<dynamic> get reviews => _reviews;

  String? get bundle => _bundle;

  String? get remote => _remote;

  String? get version => _version;

  // ignore: unnecessary_getters_setters
  String? get branch => _branch;

  // ignore: unnecessary_getters_setters
  bool? get current => _current;

  // ignore: unnecessary_getters_setters
  String? get arch => _arch;

  set branch(String? value) {
    _branch = value;
  }

  set current(bool? value) {
    _current = value;
  }

  set arch(String? value) {
    _arch = value;
  }
}

class Screenshot {
  final String thumb;
  final String full;
  final String? caption;

  Screenshot({
    required this.thumb,
    required this.full,
    this.caption,
  });
}

class Release {
  final String? version;
  final String? timestamp;
  final String? type;
  final String? description;

  Release({
    this.version,
    this.timestamp,
    this.type,
    this.description,
  });
}
