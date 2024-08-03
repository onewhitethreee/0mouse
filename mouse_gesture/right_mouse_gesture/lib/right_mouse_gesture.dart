
import 'right_mouse_gesture_platform_interface.dart';

class RightMouseGesture {
  Future<String?> getPlatformVersion() {
    return RightMouseGesturePlatform.instance.getPlatformVersion();
  }
}
