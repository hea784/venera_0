import 'package:flutter_test/flutter_test.dart';
import 'package:venera/utils/version.dart';

void main() {
  test("same version is not newer", () {
    expect(compareVersion("1.6.4", "1.6.4"), isFalse);
  });

  test("plain semver compare", () {
    expect(compareVersion("1.6.4", "1.6.3"), isTrue);
    expect(compareVersion("1.6.3", "1.6.4"), isFalse);
    expect(compareVersion("2.0.0", "1.9.9"), isTrue);
  });

  test("pre-release segments compare numerically", () {
    // regression: the update check used to int.parse("3-fork") and crash
    expect(compareVersion("1.6.3-fork.6", "1.6.3-fork.5"), isTrue);
    expect(compareVersion("1.6.3-fork.5", "1.6.3-fork.6"), isFalse);
    expect(compareVersion("1.6.3-fork.5", "1.6.3-fork.5"), isFalse);
  });

  test("plain release beats older fork line", () {
    expect(compareVersion("1.6.4", "1.6.3-fork.5"), isTrue);
    expect(compareVersion("1.6.3-fork.5", "1.6.4"), isFalse);
  });

  test("different segment counts", () {
    expect(compareVersion("1.6.4.1", "1.6.4"), isTrue);
    expect(compareVersion("1.6.4", "1.6.4.1"), isFalse);
  });
}
