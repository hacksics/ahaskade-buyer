import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:g2hv1/assets/config_builder.dart';
import 'package:g2hv1/common_functions.dart';
import 'dart:developer' as logger;

import 'package:get/get.dart';

const String apiUrl = 'https://api-dev.ahaskade.com';
const String imageBucketUrl = 'https://g2h-assets.s3.amazonaws.com';
enum ConfigMode { Firebase, Local }

// NOTE: If you are contributing to this project Firebase configurations won't work
// unless you import your own google-services.json file in to your local project
// To use local configurations, switch the mode to ConfigMode.Local
const configurationMode = ConfigMode.Firebase;

Future<void> loadConfigs() async {
  ConfigsController configsController = Get.put(ConfigsController());

  if (configurationMode == ConfigMode.Firebase) {
    await loadFirebaseRemoteConfigs();
  } else {
    /*
    Using firebase is only valid for production app. contributors should request
    the values from project authors via contribute@ahaskade.com and configure the
    keys received by the authors of the app.
     */
    ConfigsController.to.setS3Credentials(
      url: imageBucketUrl,
      id: '',
      key: '',
      bucket: '',
    );
    ConfigsController.to.setApiKeys(
      url: apiUrl,
      gwKey: '',
      serKey: '',
      mapsKey: '',
    );
    ConfigsController.to.setAppSettings(version: '');
  }
}

Future<void> loadFirebaseRemoteConfigs() async {
  /*
    TODO: All Project contributors read this
    Using firebase is only valid for production app. contributors should request
    the values from project authors via contribute@ahaskade.com and set the values
    here by commenting all the firebase code and assign static values given by the
    project authors to ConfigsController
     */
  try {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    // TODO: only for debugging the app need remove once app is published.
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

    await remoteConfig.fetch(expiration: Duration(minutes: 60));
    await remoteConfig.activateFetched();
    ConfigsController.to.setS3Credentials(
      url: imageBucketUrl,
      id: '',
      key: '',
      bucket: '',
    );
    ConfigsController.to.setApiKeys(
      url: apiUrl,
      gwKey: remoteConfig.getString('dev_api_key'),
      serKey: remoteConfig.getString('dev_app_key'),
      mapsKey: '',
    );
    ConfigsController.to.setAppSettings(
        version: remoteConfig.getString('dev_force_update_version'));
  } catch (e) {
    logger.log('firebase config failure! $e');
    showAlertDialog(
        error: e.toString(),
        errorDetails:
            'Looks like application cannot download configurations!. Check if your device has latest version of Google Services available');
    return;
  }
}
