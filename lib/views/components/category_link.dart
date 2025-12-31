import 'package:flutter/material.dart';
import 'package:outlet/core/category.dart';
import 'package:outlet/views/components/app_list.dart';
import 'package:outlet/views/navigation.dart';

class CategoryLink extends StatelessWidget {
  final String title;
  final Category category;

  const CategoryLink({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 15.0)
                    ]),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        NoAnimationPageRoute(
                          pageBuilder: (context, animation1, animation2) =>
                              Navigation(
                            title: 'Apps',
                            child: FilteredAppList(initialCategory: category),
                          ),
                        ),
                      );
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Colors.black),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text('More $title',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white)),
                    )))));
  }
}
