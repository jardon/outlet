import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:outlet/core/application.dart';
import 'package:outlet/core/category.dart';
import 'package:outlet/providers/application_provider.dart';
import 'package:outlet/views/app_view.dart';
import 'package:outlet/views/components/app_card.dart';
import 'package:outlet/views/components/theme.dart';
import 'package:outlet/views/navigation.dart';

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

class FilteredAppList extends ConsumerStatefulWidget {
  final Category? initialCategory;

  const FilteredAppList({
    super.key,
    this.initialCategory,
  });

  @override
  ConsumerState<FilteredAppList> createState() => _FilteredAppListState();
}

class _FilteredAppListState extends ConsumerState<FilteredAppList> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController verifiedController = TextEditingController();
  final TextEditingController featuredController = TextEditingController();

  Category? selectedCategory;
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
    final apps = ref.watch(appListProvider).values.toList();
    final List<Application> filteredApps = apps.where((app) {
      final bool matchesCategory = selectedCategory == null ||
          app.categories.contains(selectedCategory!.value);

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
                  child: DropdownMenu<Category>(
                    controller: categoryController,
                    initialSelection: selectedCategory,
                    label: const Text('Category'),
                    inputDecorationTheme: inputTheme,
                    onSelected: (Category? category) {
                      setState(() => selectedCategory = category);
                    },
                    dropdownMenuEntries: entries,
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

typedef CategoryEntry = DropdownMenuEntry<Category>;

final List<CategoryEntry> entries = UnmodifiableListView<CategoryEntry>(
  Category.values.map<CategoryEntry>(
    (Category category) => CategoryEntry(
      value: category,
      label: category.label,
    ),
  ),
);
