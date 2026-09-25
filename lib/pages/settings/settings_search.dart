part of 'settings_page.dart';

class _SettingsEntry {
  const _SettingsEntry(this.title, this.section);

  /// The English title key of the setting, same string as in the page code.
  final String title;

  /// Index into the settings categories.
  final int section;
}

// ponytail: curated static index - when adding a new setting worth finding,
// append it here. Deep-linking to the exact entry inside a section page is
// intentionally skipped; landing on the right section is enough.
const _settingsIndex = <_SettingsEntry>[
  // Explore
  _SettingsEntry("Display mode of comic tile", 0),
  _SettingsEntry("Size of comic tile", 0),
  _SettingsEntry("Explore Pages", 0),
  _SettingsEntry("Category Pages", 0),
  _SettingsEntry("Network Favorite Pages", 0),
  _SettingsEntry("Search Sources", 0),
  _SettingsEntry("Show favorite status on comic tile", 0),
  _SettingsEntry("Show history on comic tile", 0),
  _SettingsEntry("Reverse default chapter order", 0),
  _SettingsEntry("Keyword blocking", 0),
  _SettingsEntry("Comment keyword blocking", 0),
  _SettingsEntry("Default Search Target", 0),
  _SettingsEntry("Auto Language Filters", 0),
  _SettingsEntry("Initial Page", 0),
  _SettingsEntry("Display mode of comic list", 0),
  // Reading
  _SettingsEntry("Tap to turn Pages", 1),
  _SettingsEntry("Reverse tap to turn Pages", 1),
  _SettingsEntry("Page animation", 1),
  _SettingsEntry("Reading mode", 1),
  _SettingsEntry("Page display", 1),
  _SettingsEntry("Night filter", 1),
  _SettingsEntry("Filter opacity", 1),
  _SettingsEntry("Auto page turning interval", 1),
  _SettingsEntry("Show single image on first page", 1),
  _SettingsEntry("Mouse scroll speed", 1),
  _SettingsEntry("Long press zoom position", 1),
  _SettingsEntry("Double tap to zoom", 1),
  _SettingsEntry("Limit image width", 1),
  _SettingsEntry("Turn page by volume keys", 1),
  _SettingsEntry("Display time & battery info in reader", 1),
  _SettingsEntry("Show system status bar", 1),
  _SettingsEntry("Quick collect image", 1),
  _SettingsEntry("Custom Image Processing", 1),
  _SettingsEntry("Number of images preloaded", 1),
  _SettingsEntry("Show Page Number", 1),
  _SettingsEntry("Show Chapter Comments", 1),
  _SettingsEntry("Show Comments at Chapter End", 1),
  // Appearance
  _SettingsEntry("Theme Mode", 2),
  _SettingsEntry("Theme Color", 2),
  // Local Favorites
  _SettingsEntry("Show local favorites before network favorites", 3),
  _SettingsEntry("Auto close favorite panel after operation", 3),
  _SettingsEntry("Add new favorite to", 3),
  _SettingsEntry("Move favorite after reading", 3),
  _SettingsEntry("Quick Favorite", 3),
  _SettingsEntry("Delete all unavailable local favorite items", 3),
  _SettingsEntry("Click favorite", 3),
  // APP
  _SettingsEntry("Data", 4),
  _SettingsEntry("Set New Storage Path", 4),
  _SettingsEntry("Clear Cache", 4),
  _SettingsEntry("Cache Limit", 4),
  _SettingsEntry("Export App Data", 4),
  _SettingsEntry("Import App Data", 4),
  _SettingsEntry("Data Sync", 4),
  _SettingsEntry("User", 4),
  _SettingsEntry("Language", 4),
  _SettingsEntry("Authorization Required", 4),
  // Network
  _SettingsEntry("Proxy", 5),
  _SettingsEntry("Enable DNS Overrides", 5),
  _SettingsEntry("DNS Overrides", 5),
  _SettingsEntry("Download Threads", 5),
  _SettingsEntry("Server Name Indication", 5),
  // About
  _SettingsEntry("Check for updates", 6),
  _SettingsEntry("Check for updates on startup", 6),
  _SettingsEntry("Github", 6),
];

class SettingsSearchPage extends StatefulWidget {
  const SettingsSearchPage({super.key});

  @override
  State<SettingsSearchPage> createState() => _SettingsSearchPageState();
}

class _SettingsSearchPageState extends State<SettingsSearchPage> {
  String query = "";

  List<_SettingsEntry> get results {
    if (query.trim().isEmpty) {
      return const [];
    }
    return _settingsIndex
        .where(
          (e) => matchesSearchQuery(query, [
            e.title,
            e.title.tl,
            _SettingsPageState.categories[e.section].tl,
          ]),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var matched = results;
    return Scaffold(
      body: SmoothCustomScrollView(
        slivers: [
          SliverAppbar(
            leading: Tooltip(
              message: "Back".tl,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: context.pop,
              ),
            ),
            title: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search settings".tl,
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          if (query.trim().isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Type keywords to find a setting".tl,
                  style: ts.s14.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else if (matched.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "No matching settings".tl,
                  style: ts.s14.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var entry = matched[index];
                  return ListTile(
                    title: Text(entry.title.tl),
                    subtitle: Text(_SettingsPageState.categories[entry.section].tl),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: () {
                      context.to(
                        () => _SettingsDetailPage(pageIndex: entry.section),
                      );
                    },
                  );
                },
                childCount: matched.length,
              ),
            ),
        ],
      ),
    );
  }
}
