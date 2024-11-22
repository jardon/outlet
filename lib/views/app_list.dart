import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './components/app_card.dart';
import '../../providers/application_provider.dart';


class AppList extends ConsumerWidget {

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final apps = ref.watch(appListProvider);
        // return Container(
        return LayoutBuilder(
        builder: (context, constraints) {
            // Calculate how many columns based on the available width
            double width = constraints.maxWidth;
            int crossAxisCount = (width / 150).floor(); // Each grid item is 300px wide

            // Ensure at least 1 column
            crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 3/4,
                    crossAxisSpacing: 0.0,
                    mainAxisSpacing: 0.0,
                ),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                itemCount: apps.length,
                itemBuilder: (context, index) {
                    return AppCard(
                        featured: apps[index]["featured"],
                        verified: apps[index]["verified"],
                        installed: apps[index]["installed"],
                        details: true,
                        name: apps[index]["name"],
                        iconUrl: apps[index]["icon"],
                        description: apps[index]["description"],
                        categories: apps[index]["categories"],
                        rating: apps[index]["rating"],
                    );
                },
            );
        },
      );
    }
}