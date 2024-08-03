import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'right_mouse_gesture_platform_interface.dart';

/// An implementation of [RightMouseGesturePlatform] that uses method channels.
class MethodChannelRightMouseGesture extends RightMouseGesturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('right_mouse_gesture');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
