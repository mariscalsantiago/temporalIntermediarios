import 'package:cotizador_agente/EnvironmentVariablesSetup/app_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigHandler {
  static Future<RemoteConfig> setupConfiguration(BuildContext context) async {
    var config = AppConfig.of(context);
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    if (config.ambient == Ambient.prod) {
      remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: false));
    } else {
      remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    }
    try {
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      return remoteConfig;
    } on FetchThrottledException catch (ex) {
      return remoteConfig;
    } catch (ex) {
      return remoteConfig;
    }
  }
}
