import 'package:flutter_test/flutter_test.dart';
import 'package:right_mouse_gesture/right_mouse_gesture.dart';
import 'package:right_mouse_gesture/right_mouse_gesture_platform_interface.dart';
import 'package:right_mouse_gesture/right_mouse_gesture_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRightMouseGesturePlatform
    with MockPlatformInterfaceMixin
    implements RightMouseGesturePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RightMouseGesturePlatform initialPlatform = RightMouseGesturePlatform.instance;

  test('$MethodChannelRightMouseGesture is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRightMouseGesture>());
  });

  test('getPlatformVersion', () async {
    RightMouseGesture rightMouseGesturePlugin = RightMouseGesture();
    MockRightMouseGesturePlatform fakePlatform = MockRightMouseGesturePlatform();
    RightMouseGesturePlatform.instance = fakePlatform;

    expect(await rightMouseGesturePlugin.getPlatformVersion(), '42');
  });
}
