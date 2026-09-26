import 'package:flutter_test/flutter_test.dart';
import 'package:venera/foundation/settings_index.dart';

void main() {
  test("every index entry points to a valid section", () {
    for (final entry in settingsIndex) {
      expect(
        entry.section,
        inInclusiveRange(0, settingsSectionNames.length - 1),
        reason: "${entry.title} has an out-of-range section",
      );
    }
  });

  test("every index entry has a non-empty title", () {
    for (final entry in settingsIndex) {
      expect(entry.title.trim(), isNotEmpty);
    }
  });

  test("index is not accidentally empty", () {
    expect(settingsIndex.length, greaterThan(30));
  });

  test("section names are unique", () {
    expect(
      settingsSectionNames.toSet().length,
      settingsSectionNames.length,
    );
  });
}
