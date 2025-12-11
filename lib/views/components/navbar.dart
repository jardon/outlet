import '../../providers/application_provider.dart';
import '../app_view.dart';
import '../navigation.dart';
import 'app_icon_loader.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      // color: Colors.orange,
      child: Stack(children: <Widget>[
        WindowTitleBarBox(child: MoveWindow()),
        Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 40,
                  // color: Colors.purple,
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Navigator.canPop(context)
                            ? Colors.black
                            : Colors.black12,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                    // color: Colors.blue,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                WindowTitleBarBox(child: MoveWindow()),
                Expanded(
                  child: Align(
                    alignment: Alignment
                        .centerRight, // Align the container to the right
                    child: WindowTitleBarBox(child: MoveWindow()),
                  ),
                ),
                const SearchBarApp(),
                const SizedBox(width: 40),
                CloseWindowButton(
                    colors: WindowButtonColors(
                        mouseOver: const Color(0xFFD32F2F),
                        mouseDown: const Color(0xFFB71C1C),
                        iconNormal: const Color(0xFF805306),
                        iconMouseOver: Colors.white)),
              ],
            ))
      ]),
    );
  }
}

class SearchBarApp extends ConsumerStatefulWidget {
  const SearchBarApp({super.key});

  @override
  ConsumerState<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends ConsumerState<SearchBarApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 280,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 20.0)
            ]),
        child: SearchAnchor(
          viewBackgroundColor: Colors.white,
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              controller: controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              backgroundColor:
                  const WidgetStatePropertyAll<Color>(Colors.white),
              elevation: const WidgetStatePropertyAll<double>(0.0),
              hintText: 'Search apps',
              onTap: () {
                controller.openView();
              },
              onChanged: (_) {
                controller.openView();
              },
              leading: const Icon(Icons.search),
            );
          },
          suggestionsBuilder:
              (BuildContext context, SearchController controller) {
            final searchKeywords = ref.read(searchKeywordsProvider);
            final query = controller.text.toLowerCase();

            final results = extractTop(
              query: query,
              choices: searchKeywords.keys.toList(),
              limit: 10,
              cutoff: 50,
            );
            return results.isNotEmpty
                ? results.map((result) {
                    final appId = searchKeywords[result.choice]!;
                    final app = ref.read(liveApplicationProvider(appId));
                    return ListTile(
                      title: Text(app!.name ?? app.id),
                      leading: SizedBox(
                          width: 45, child: AppIconLoader(icon: app.icon)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      onTap: () {
                        controller.closeView(query);
                        Navigator.push(
                          context,
                          NoAnimationPageRoute(
                            pageBuilder: (context, animation1, animation2) =>
                                Navigation(
                              title: "App Info",
                              child: AppView(app: app) as Widget,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList()
                : [
                    const ListTile(
                      title: Text("No results found."),
                    )
                  ];
          },
        ));
  }
}
