import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'win_keyboard_method_channel.dart';

abstract class WinKeyboardPlatform extends PlatformInterface {
  /// Constructs a WinKeyboardPlatform.
  WinKeyboardPlatform() : super(token: _token);

  static final Object _token = Object();

  static WinKeyboardPlatform _instance = MethodChannelWinKeyboard();

  /// The default instance of [WinKeyboardPlatform] to use.
  ///
  /// Defaults to [MethodChannelWinKeyboard].
  static WinKeyboardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WinKeyboardPlatform] when
  /// they register themselves.
  static set instance(WinKeyboardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
