import 'package:flutter/foundation.dart';

/// True when the app runs on a desktop platform (Windows, macOS or Linux).
///
/// Desktop builds use a custom window title bar and skip the mobile bottom
/// navigation bar, so the check is needed in several unrelated widgets. Keep it
/// here instead of repeating the three-way platform comparison at each call
/// site.
///
/// This answers "is this a desktop build?". If you need "is this Android?"
/// (for example to pick a WebView or asset-loading strategy), compare against
/// [TargetPlatform.android] directly: the two questions differ on web, where
/// [defaultTargetPlatform] reports the host OS rather than a desktop target.
bool get isDesktopPlatform {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;
}
