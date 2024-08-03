import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'right_mouse_gesture_method_channel.dart';

abstract class RightMouseGesturePlatform extends PlatformInterface {
  /// Constructs a RightMouseGesturePlatform.
  RightMouseGesturePlatform() : super(token: _token);

  static final Object _token = Object();

  static RightMouseGesturePlatform _instance = MethodChannelRightMouseGesture();

  /// The default instance of [RightMouseGesturePlatform] to use.
  ///
  /// Defaults to [MethodChannelRightMouseGesture].
  static RightMouseGesturePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RightMouseGesturePlatform] when
  /// they register themselves.
  static set instance(RightMouseGesturePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
