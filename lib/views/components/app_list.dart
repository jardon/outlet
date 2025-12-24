import '../../../core/application.dart';
import '../app_view.dart';
import '../navigation.dart';
import 'app_card.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'theme.dart';

class AppList extends StatelessWidget {
  const AppList({
    super.key,
    required this.apps,
    this.details = true,
    this.scrollable = true,
    this.rows,
    this.shrinkWrap = false,
  });

  final List<Application> apps;
  final bool details;
  final bool scrollable;
  final int? rows;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        int crossAxisCount = (width / 160).floor();

        crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 3 / 3.4,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
            ),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            itemCount: rows != null ? crossAxisCount * rows! : apps.length,
            shrinkWrap: shrinkWrap,
            physics: scrollable
                ? const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics())
                : const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).closeDrawer();
                  Navigator.push(
                    context,
                    NoAnimationPageRoute(
                      pageBuilder: (context, animation1, animation2) =>
                          Navigation(
                        title: "App Info",
                        child: AppView(app: apps[index]) as Widget,
                      ),
                    ),
                  );
                },
                child: AppCard(
                  app: apps[index],
                  details: details,
                ),
              );
            });
      },
    );
  }
}

class FilteredAppList extends StatefulWidget {
  final List<Application> apps;
  final CategoryLabel? initialCategory;

  const FilteredAppList({
    super.key,
    required this.apps,
    this.initialCategory,
  });

  @override
  State<FilteredAppList> createState() => _FilteredAppListState();
}

class _FilteredAppListState extends State<FilteredAppList> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController verifiedController = TextEditingController();
  final TextEditingController featuredController = TextEditingController();

  CategoryLabel? selectedCategory;
  bool? isVerifiedFilter;
  bool? isFeaturedFilter;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      selectedCategory = widget.initialCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Application> filteredApps = widget.apps.where((app) {
      final bool matchesCategory = selectedCategory == null ||
          app.categories.contains(selectedCategory!.category);

      final bool matchesVerified =
          isVerifiedFilter == null || app.verified == isVerifiedFilter;

      final bool matchesFeatured =
          isFeaturedFilter == null || app.featured == isFeaturedFilter;

      return matchesCategory && matchesVerified && matchesFeatured;
    }).toList();

    final Color color = fgColor(context);

    final inputTheme = InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );

    final inputBoxDec = BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20.0)]);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                  width: 160,
                  decoration: inputBoxDec,
                  child: DropdownMenu<CategoryLabel>(
                    controller: categoryController,
                    initialSelection: selectedCategory,
                    label: const Text('Category'),
                    inputDecorationTheme: inputTheme,
                    onSelected: (CategoryLabel? category) {
                      setState(() => selectedCategory = category);
                    },
                    dropdownMenuEntries: CategoryLabel.entries,
                  )),
              const SizedBox(
                width: 10,
              ),
              Container(
                  width: 160,
                  decoration: inputBoxDec,
                  child: DropdownMenu<bool?>(
                    controller: verifiedController,
                    label: const Text('Verified'),
                    inputDecorationTheme: inputTheme,
                    onSelected: (bool? value) {
                      setState(() => isVerifiedFilter = value);
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: null, label: 'All Apps'),
                      DropdownMenuEntry(value: true, label: 'Verified Only'),
                    ],
                  )),
              const SizedBox(
                width: 10,
              ),
              Container(
                  width: 160,
                  decoration: inputBoxDec,
                  child: DropdownMenu<bool?>(
                    controller: featuredController,
                    label: const Text('Featured'),
                    inputDecorationTheme: inputTheme,
                    onSelected: (bool? value) {
                      setState(() => isFeaturedFilter = value);
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: null, label: 'All Apps'),
                      DropdownMenuEntry(value: true, label: 'Featured Only'),
                    ],
                  )),
            ],
          ),
        ),
        Expanded(
          child: AppList(apps: filteredApps),
        ),
      ],
    );
  }
}

typedef CategoryEntry = DropdownMenuEntry<CategoryLabel>;

enum CategoryLabel {
  audio('Audio', 'audio'),
  video('Video', 'video'),
  game('Gaming', 'game'),
  development('Development', 'development'),
  network('Networking', 'network'),
  utility('Utility', 'utility'),
  education('Education', 'education'),
  office('Office', 'office');

  const CategoryLabel(this.label, this.category);
  final String label;
  final String category;

  static final List<CategoryEntry> entries =
      UnmodifiableListView<CategoryEntry>(
    values.map<CategoryEntry>(
      (CategoryLabel category) => CategoryEntry(
        value: category,
        label: category.label,
      ),
    ),
  );
}
