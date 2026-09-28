import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:venera/foundation/app.dart';
import 'package:venera/foundation/appdata.dart';
import 'package:venera/foundation/log.dart';
import 'package:venera/utils/io.dart';

/// Persists unhandled errors across sessions so the next launch can offer to
/// export a diagnostic bundle. Real bugs (e.g. markAsRead's null dereference)
/// only ever show up in the log of the session that hit them - the user would
/// otherwise have to notice and export logs by hand.
class CrashRecorder {
  static File get _file =>
      File(FilePath.join(App.dataPath, 'last_crash.txt'));

  static void record(Object error, StackTrace? stack) {
    try {
      if (_file.existsSync() && _file.lengthSync() > 64 * 1024) {
        _file.deleteSync();
      }
      _file.writeAsStringSync(
        '${DateTime.now()}\n$error\n${stack ?? ''}\n\n',
        mode: FileMode.append,
        flush: true,
      );
    } catch (_) {
      // the crash recorder must never crash
    }
  }

  /// Returns and clears the pending crash text, or null when there is none.
  static String? take() {
    try {
      if (!_file.existsSync()) return null;
      var text = _file.readAsStringSync();
      _file.deleteSync();
      return text.trim().isEmpty ? null : text.trim();
    } catch (_) {
      return null;
    }
  }

  /// A copy-pasteable report for bug reports: environment + the pending crash
  /// + the tail of the current session log.
  static Future<String> buildBundle(String? pendingCrash) async {
    var info = await PackageInfo.fromPlatform();
    var abi = '-';
    if (App.isAndroid) {
      try {
        abi =
            await const MethodChannel(
              'venera/method_channel',
            ).invokeMethod<String>('getAbi') ??
            '-';
      } catch (_) {}
    }
    var logLines = Log().toString().split('\n');
    var tail = logLines.length > 200
        ? logLines.sublist(logLines.length - 200)
        : logLines;
    var buf = StringBuffer()
      ..writeln('=== Venera diagnostic bundle ===')
      ..writeln('generated: ${DateTime.now()}')
      ..writeln('app version: ${info.version} (${info.buildNumber})')
      ..writeln('platform: ${Platform.operatingSystem} '
          '${Platform.operatingSystemVersion}')
      ..writeln('abi: $abi')
      ..writeln('locale: ${appdata.settings['language']}')
      ..writeln('proxy: ${appdata.settings['proxy']}')
      ..writeln()
      ..writeln('=== Last unhandled error ===')
      ..writeln(pendingCrash ?? '(none)')
      ..writeln()
      ..writeln('=== Recent log (last ${tail.length} lines) ===');
    buf.writeAll(tail, '\n');
    return buf.toString();
  }
}
