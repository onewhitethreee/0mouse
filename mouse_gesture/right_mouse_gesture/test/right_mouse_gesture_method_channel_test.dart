import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:right_mouse_gesture/right_mouse_gesture_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelRightMouseGesture platform = MethodChannelRightMouseGesture();
  const MethodChannel channel = MethodChannel('right_mouse_gesture');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
