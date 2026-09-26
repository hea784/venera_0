/// Section display names, in the order the settings main page renders them.
/// Shared by the main page and the search index so they can never drift.
const settingsSectionNames = <String>[
  "Explore",
  "Reading",
  "Appearance",
  "Local Favorites",
  "APP",
  "Network",
  "About",
  "Debug",
];

class SettingsEntryRef {
  const SettingsEntryRef(this.title, this.section);

  /// The English title key of the setting, same string as in the page code.
  final String title;

  /// Index into [settingsSectionNames].
  final int section;
}

// ponytail: curated static index - when adding a new setting worth finding,
// append it here. Deep-linking to the exact entry inside a section page is
// intentionally skipped; landing on the right section is enough. Kept in its
// own library (not a `part`) so a test can guard section bounds.
const settingsIndex = <SettingsEntryRef>[
  // Explore
  SettingsEntryRef("Display mode of comic tile", 0),
  SettingsEntryRef("Size of comic tile", 0),
  SettingsEntryRef("Explore Pages", 0),
  SettingsEntryRef("Category Pages", 0),
  SettingsEntryRef("Network Favorite Pages", 0),
  SettingsEntryRef("Search Sources", 0),
  SettingsEntryRef("Show favorite status on comic tile", 0),
  SettingsEntryRef("Show history on comic tile", 0),
  SettingsEntryRef("Reverse default chapter order", 0),
  SettingsEntryRef("Keyword blocking", 0),
  SettingsEntryRef("Comment keyword blocking", 0),
  SettingsEntryRef("Default Search Target", 0),
  SettingsEntryRef("Auto Language Filters", 0),
  SettingsEntryRef("Initial Page", 0),
  SettingsEntryRef("Display mode of comic list", 0),
  // Reading
  SettingsEntryRef("Tap to turn Pages", 1),
  SettingsEntryRef("Reverse tap to turn Pages", 1),
  SettingsEntryRef("Page animation", 1),
  SettingsEntryRef("Reading mode", 1),
  SettingsEntryRef("Page display", 1),
  SettingsEntryRef("Night filter", 1),
  SettingsEntryRef("Filter opacity", 1),
  SettingsEntryRef("Auto page turning interval", 1),
  SettingsEntryRef("Show single image on first page", 1),
  SettingsEntryRef("Mouse scroll speed", 1),
  SettingsEntryRef("Long press zoom position", 1),
  SettingsEntryRef("Double tap to zoom", 1),
  SettingsEntryRef("Limit image width", 1),
  SettingsEntryRef("Turn page by volume keys", 1),
  SettingsEntryRef("Display time & battery info in reader", 1),
  SettingsEntryRef("Show system status bar", 1),
  SettingsEntryRef("Quick collect image", 1),
  SettingsEntryRef("Custom Image Processing", 1),
  SettingsEntryRef("Number of images preloaded", 1),
  SettingsEntryRef("Show Page Number", 1),
  SettingsEntryRef("Show Chapter Comments", 1),
  SettingsEntryRef("Show Comments at Chapter End", 1),
  // Appearance
  SettingsEntryRef("Theme Mode", 2),
  SettingsEntryRef("Theme Color", 2),
  // Local Favorites
  SettingsEntryRef("Show local favorites before network favorites", 3),
  SettingsEntryRef("Auto close favorite panel after operation", 3),
  SettingsEntryRef("Add new favorite to", 3),
  SettingsEntryRef("Move favorite after reading", 3),
  SettingsEntryRef("Quick Favorite", 3),
  SettingsEntryRef("Delete all unavailable local favorite items", 3),
  SettingsEntryRef("Click favorite", 3),
  // APP
  SettingsEntryRef("Data", 4),
  SettingsEntryRef("Set New Storage Path", 4),
  SettingsEntryRef("Clear Cache", 4),
  SettingsEntryRef("Cache Limit", 4),
  SettingsEntryRef("Export App Data", 4),
  SettingsEntryRef("Import App Data", 4),
  SettingsEntryRef("Data Sync", 4),
  SettingsEntryRef("User", 4),
  SettingsEntryRef("Language", 4),
  SettingsEntryRef("Authorization Required", 4),
  // Network
  SettingsEntryRef("Proxy", 5),
  SettingsEntryRef("Enable DNS Overrides", 5),
  SettingsEntryRef("DNS Overrides", 5),
  SettingsEntryRef("Download Threads", 5),
  SettingsEntryRef("Server Name Indication", 5),
  // About
  SettingsEntryRef("Check for updates", 6),
  SettingsEntryRef("Check for updates on startup", 6),
  SettingsEntryRef("Github", 6),
];
