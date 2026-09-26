import 'package:flutter_test/flutter_test.dart';
import 'package:venera/components/components.dart';
import 'package:venera/utils/translations.dart';

void main() {
  // `.tl` reads the translation table, normally loaded from assets at app
  // start. An empty table makes it fall back to the original English text.
  setUpAll(() {
    AppTranslation.translations = {"en_US": {}};
  });

  // Real-world sample from a comic source with a dead domain list
  const jsError =
      "TypeError: cannot read property of undefined at get baseUrl (JM:39:63) "
      "at loadInfo (JM:770:34) at <eval> (<eval>:1:39)";
  // Real-world sample from an unreachable source server
  const connectError =
      "null Error: [RhttpConnectionException] Connection error. URL: "
      "https://www.cdnsha.org/album?id=508237 "
      "(hyper_util::client::legacy::Error(Connect, ...";

  test("classifies comic source script errors", () {
    expect(NetworkError.isSourceScriptError(jsError), isTrue);
    expect(NetworkError.explainError(jsError), isNotNull);
  });

  test("classifies connection errors", () {
    expect(NetworkError.isConnectError(connectError), isTrue);
    expect(NetworkError.explainError(connectError), isNotNull);
  });

  test("classifies other observed network failures", () {
    // seen on emulator: a relative cover url hit the http layer
    expect(
      NetworkError.isConnectError(
        "DioException [unknown]: [RhttpUnknownException] relative URL without a base",
      ),
      isTrue,
    );
    // case-insensitive matching
    expect(NetworkError.isConnectError("SOCKETEXCEPTION: broken"), isTrue);
    expect(NetworkError.isConnectError("CONNECTION RESET BY PEER"), isTrue);
    expect(
      NetworkError.isConnectError("Failed host lookup: example.com"),
      isTrue,
    );
  });

  test("unrelated errors stay raw", () {
    const generic = "Something else went wrong";
    expect(NetworkError.isSourceScriptError(generic), isFalse);
    expect(NetworkError.isConnectError(generic), isFalse);
    expect(NetworkError.explainError(generic), isNull);
  });

  test("friendlyMessage unwraps Dio and truncates", () {
    var msg = NetworkError.friendlyMessage(
      "DioException [connection error]: Connection reset by peer",
    );
    expect(msg, "Connection reset by peer");
    var long = NetworkError.friendlyMessage("x" * 500);
    expect(long.length, 160);
  });
}
