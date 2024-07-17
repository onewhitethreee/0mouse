import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'win_keyboard_platform_interface.dart';

/// An implementation of [WinKeyboardPlatform] that uses method channels.
class MethodChannelWinKeyboard extends WinKeyboardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('win_keyboard');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
