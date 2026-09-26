/// Splits a search query into whitespace-separated, lowercased tokens.
List<String> splitSearchTokens(String query) =>
    query.trim().toLowerCase().split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

/// Escapes LIKE wildcards so a user searching "100%" does not match
/// everything. Use with a matching `ESCAPE '\'` clause in the SQL.
String escapeLike(String token) =>
    token.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');

/// Returns true when every token in [query] matches at least one of [fields]
/// (case-insensitive substring match). An empty query matches everything, so
/// callers can pipe their full list through it unconditionally.
bool matchesSearchQuery(String query, Iterable<String> fields) {
  var tokens = splitSearchTokens(query);
  if (tokens.isEmpty) return true;
  var haystacks = fields.map((f) => f.toLowerCase()).toList(growable: false);
  return tokens.every((token) => haystacks.any((f) => f.contains(token)));
}
