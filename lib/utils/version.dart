/// return true if version1 > version2.
///
/// Handles versions like "1.6.4" and "1.6.3-fork.5" by comparing the numeric
/// part of each dot-separated segment ("3-fork" compares as 3). Missing
/// segments compare as 0, so "1.6.4" > "1.6.3-fork.5" and "1.6.4" < "1.6.4.1".
bool compareVersion(String version1, String version2) {
  int numPart(String segment) =>
      int.tryParse(segment.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  var v1 = version1.split(".");
  var v2 = version2.split(".");
  for (var i = 0; i < v1.length; i++) {
    var a = numPart(v1[i]);
    var b = i < v2.length ? numPart(v2[i]) : 0;
    if (a > b) {
      return true;
    }
    if (a < b) {
      return false;
    }
  }
  return false;
}
