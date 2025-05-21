import 'package:flutter/foundation.dart';
import 'package:khazana_mutual_funds/core/constants/constants.dart';
import 'package:loggy/loggy.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Urls {
  Urls._();

  static Future<void> showTermsOfService() =>
      openBrowserURL(url: termsOfServiceUrl, inApp: true);

  static Future<void> showPrivacyPolicy() =>
      openBrowserURL(url: privacyPolicyUrl, inApp: true);

  static Future<void> openBrowserURL({
    required String url,
    bool inApp = false,
  }) async {
    try {
      await launchUrlString(
        url,
        mode: inApp ? LaunchMode.inAppWebView : LaunchMode.platformDefault,
      );
    } catch (e) {
      if (kDebugMode) {
        rethrow;
      }
      logInfo(e.toString());
    }
  }
}
