import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:telechat/core/config/app_log.dart';

class RemoteConfig {
  const RemoteConfig._();

  static final _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> init() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 60),
          minimumFetchInterval: const Duration(seconds: 60),
        ),
      );
      await _remoteConfig.fetchAndActivate().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          logger.e("fetchAndActivate=timeout(60s)");
          return false;
        },
      );
    } catch (e) {
      logger.e(e);
    }
    _getRemoteConfig();
  }

  static void _getRemoteConfig() {
    defaultUserProfilePicUrl = _remoteConfig.getString("defaultUserProfilePicUrl");
    otpTimeOutInSeconds = _remoteConfig.getInt("otpTimeOutInSeconds");
    maxVideoLengthInMins = _remoteConfig.getInt("maxVideoLengthInMins");
    giphyApiKey = _remoteConfig.getString("giphyApiKey");
    agoraAppID = _remoteConfig.getString("agoraAppID");
    agoraPrimaryCertificate = _remoteConfig.getString("agoraPrimaryCertificate");
    callTokenUrl = _remoteConfig.getString("callTokenUrl");
  }

  static String defaultUserProfilePicUrl =
      "https://firebasestorage.googleapis.com/v0/b/telechat-4cdd0.appspot.com/o/app%2Fuser_default_avatar.png?alt=media&token=a7b4ef6f-6dc7-423d-a8e6-6f7e82be5e8c";

  static int otpTimeOutInSeconds = 60;

  static int maxVideoLengthInMins = 3;

  static String giphyApiKey = "";

  static String agoraAppID = "";

  static String agoraPrimaryCertificate = "";

  static String callTokenUrl = "";
}
