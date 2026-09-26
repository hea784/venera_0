part of 'settings_page.dart';

class AboutSettings extends StatefulWidget {
  const AboutSettings({super.key});

  @override
  State<AboutSettings> createState() => _AboutSettingsState();
}

class _AboutSettingsState extends State<AboutSettings> {
  bool isCheckingUpdate = false;

  @override
  Widget build(BuildContext context) {
    return SmoothCustomScrollView(
      slivers: [
        SliverAppbar(title: Text("About".tl)),
        SizedBox(
          height: 112,
          width: double.infinity,
          child: Center(
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(136),
              ),
              clipBehavior: Clip.antiAlias,
              child: const Image(
                image: AssetImage("assets/app_icon.png"),
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
        ).paddingTop(16).toSliver(),
        Column(
          children: [
            const SizedBox(height: 8),
            Text(
              "V${App.version}",
              style: const TextStyle(fontSize: 16),
            ),
            Text("Venera is a free and open-source app for comic reading.".tl),
            const SizedBox(height: 8),
          ],
        ).toSliver(),
        ListTile(
          title: Text("Check for updates".tl),
          trailing: Button.filled(
            isLoading: isCheckingUpdate,
            child: Text("Check".tl),
            onPressed: () {
              setState(() {
                isCheckingUpdate = true;
              });
              checkUpdateUi().then((value) {
                setState(() {
                  isCheckingUpdate = false;
                });
              });
            },
          ).fixHeight(32),
        ).toSliver(),
        _SwitchSetting(
          title: "Check for updates on startup".tl,
          settingKey: "checkUpdateOnStart",
        ).toSliver(),
        ListTile(
          title: const Text("Github"),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            launchUrlString("https://github.com/hea784/venera_0");
          },
        ).toSliver(),
        ListTile(
          title: Text("Feedback".tl),
          subtitle: Text("Feedback, suggestions and help".tl),
          trailing: const Icon(Icons.open_in_new),
          onTap: () {
            launchUrlString("https://github.com/hea784/venera_0/discussions");
          },
        ).toSliver(),
      ],
    );
  }
}

/// Returns the newer version found on the remote, or null when the installed
/// version is up to date / the check failed.
Future<String?> checkUpdate() async {
  var res = await AppDio()
      .get("https://cdn.jsdelivr.net/gh/hea784/venera_0@master/pubspec.yaml");
  if (res.statusCode == 200) {
    var data = loadYaml(res.data);
    if (data["version"] != null) {
      var remote = data["version"].split("+")[0];
      if (compareVersion(remote, App.version)) {
        return remote;
      }
    }
  }
  return null;
}

/// Downloads the release APK for [version] and opens the system installer.
///
/// ponytail: the apk url is derived from this fork's release asset naming
/// (`venera-<version>-<abi>.apk` on tag `v<version>`); if the asset is missing
/// (release not published yet) the error path falls back to the releases page.
Future<void> _downloadAndInstallUpdate(String version) async {
  var cancelToken = CancelToken();
  var controller = showLoadingDialog(
    App.rootContext,
    withProgress: true,
    allowCancel: true,
    message: "Downloading update".tl,
    onCancel: () => cancelToken.cancel(),
  );
  try {
    var abi = await const MethodChannel("venera/method_channel")
        .invokeMethod<String>("getAbi");
    var asset = "venera-$version-${abi ?? "universal"}.apk";
    var url =
        "https://github.com/hea784/venera_0/releases/download/v$version/$asset";
    var dir = App.externalStoragePath ?? App.cachePath;
    var path = FilePath.join(dir, "update_$version.apk");
    await AppDio().download(
      url,
      path,
      cancelToken: cancelToken,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          controller.setProgress(received / total);
        }
      },
    );
    // Corruption guard: a truncated download (or an HTML error body saved as
    // the APK) would otherwise be handed to the installer. Real integrity is
    // still enforced by Android: the installer refuses packages whose
    // signature differs from the installed app.
    var apk = File(path);
    var header = await apk.openRead(0, 2).fold<List<int>>(
      <int>[],
      (acc, chunk) => acc..addAll(chunk),
    );
    if (header.length < 2 || header[0] != 0x50 || header[1] != 0x4B) {
      throw "Downloaded file is not a valid APK";
    }
    if (await apk.length() < 1024 * 1024) {
      throw "Downloaded APK is too small";
    }
    controller.close();
    await const MethodChannel("venera/method_channel")
        .invokeMethod("installApk", {"path": path});
  } catch (e) {
    if (!cancelToken.isCancelled) {
      controller.close();
      App.rootContext.showMessage(message: "Failed to download update".tl);
      launchUrlString("https://github.com/hea784/venera_0/releases");
    }
  }
}

Future<void> checkUpdateUi([bool showMessageIfNoUpdate = true, bool delay = false]) async {
  try {
    var remote = await checkUpdate();
    if (remote != null) {
      if (delay) {
        await Future.delayed(const Duration(seconds: 2));
      }
      showDialog(
          context: App.rootContext,
          builder: (context) {
            return ContentDialog(
              title: "New version available".tl,
              content: Text(
                      "A new version is available. Do you want to update now?"
                          .tl)
                  .paddingHorizontal(16),
              actions: [
                Button.text(
                  onPressed: () {
                    Navigator.pop(context);
                    launchUrlString(
                        "https://github.com/hea784/venera_0/releases");
                  },
                  child: Text("Releases page".tl),
                ),
                Button.filled(
                  onPressed: () {
                    Navigator.pop(context);
                    if (App.isAndroid) {
                      _downloadAndInstallUpdate(remote);
                    } else {
                      launchUrlString(
                          "https://github.com/hea784/venera_0/releases");
                    }
                  },
                  child: Text("Update".tl),
                ),
              ],
            );
          });
    } else if (showMessageIfNoUpdate) {
      App.rootContext.showMessage(message: "No new version available".tl);
    }
  } catch (e, s) {
    Log.error("Check Update", e.toString(), s);
    if (showMessageIfNoUpdate) {
      App.rootContext.showMessage(message: "Update check failed".tl);
    }
  }
}
