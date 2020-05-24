import 'dart:io' show Platform;

import 'package:g2hv1/assets/config_builder.dart';
import 'package:g2hv1/common_functions.dart';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';

Future<void> checkUpdateAvailable() async {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    double currentVersion =
        double.parse(packageInfo.version.trim().replaceAll(".", ""));
    double newVersion = double.parse(
        ConfigsController.to.appVersion.trim().replaceAll(".", ""));

    if (newVersion > currentVersion) {
      showSimpleAlertDialog(
          title: 'New version [${ConfigsController.to.appVersion}] available',
          details: 'You need to upgrade to latest version to use the app');
      if (Platform.isAndroid) StoreRedirect.redirect();
    }
  });
}
