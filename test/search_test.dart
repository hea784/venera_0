import 'package:flutter_test/flutter_test.dart';
import 'package:venera/utils/search.dart';

void main() {
  test("empty query matches everything", () {
    expect(matchesSearchQuery("", ["anything"]), isTrue);
    expect(matchesSearchQuery("   ", ["anything"]), isTrue);
  });

  test("single keyword matches title case-insensitively", () {
    expect(matchesSearchQuery("star", ["星海航线 Star Voyage"]), isTrue);
    expect(matchesSearchQuery("STAR", ["星海航线 star voyage"]), isTrue);
    expect(matchesSearchQuery("star", ["夜行者手记"]), isFalse);
  });

  test("multiple keywords require AND across any field", () {
    // both tokens hit different fields -> match
    expect(
      matchesSearchQuery("星海 voyage", ["星海航线 Star Voyage", "本地漫画"]),
      isTrue,
    );
    // one token missing -> no match
    expect(matchesSearchQuery("星海 缺词", ["星海航线 Star Voyage"]), isFalse);
  });

  test("tokens are whitespace separated", () {
    expect(matchesSearchQuery("  星海  航线  ", ["星海航线"]), isTrue);
  });

  test("splitSearchTokens lowercases and dedupes nothing", () {
    expect(splitSearchTokens(" Abc  def "), ["abc", "def"]);
    expect(splitSearchTokens(""), isEmpty);
  });

  test("escapeLike neutralizes LIKE wildcards", () {
    expect(escapeLike("100%"), r"100\%");
    expect(escapeLike("a_b"), r"a\_b");
    expect(escapeLike(r"c\path"), r"c\\path");
    expect(escapeLike("normal"), "normal");
  });
}
