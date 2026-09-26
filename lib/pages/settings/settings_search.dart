part of 'settings_page.dart';

class SettingsSearchPage extends StatefulWidget {
  const SettingsSearchPage({super.key});

  @override
  State<SettingsSearchPage> createState() => _SettingsSearchPageState();
}

class _SettingsSearchPageState extends State<SettingsSearchPage> {
  String query = "";

  List<SettingsEntryRef> get results {
    if (query.trim().isEmpty) {
      return const [];
    }
    return settingsIndex
        .where(
          (e) => matchesSearchQuery(query, [
            e.title,
            e.title.tl,
            settingsSectionNames[e.section].tl,
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
                    subtitle: Text(settingsSectionNames[entry.section].tl),
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
