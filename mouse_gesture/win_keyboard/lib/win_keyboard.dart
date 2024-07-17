
import 'win_keyboard_platform_interface.dart';

class WinKeyboard {
  Future<String?> getPlatformVersion() {
    return WinKeyboardPlatform.instance.getPlatformVersion();
  }
}
