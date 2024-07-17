import 'package:flutter_test/flutter_test.dart';
import 'package:win_keyboard/win_keyboard.dart';
import 'package:win_keyboard/win_keyboard_platform_interface.dart';
import 'package:win_keyboard/win_keyboard_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWinKeyboardPlatform
    with MockPlatformInterfaceMixin
    implements WinKeyboardPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WinKeyboardPlatform initialPlatform = WinKeyboardPlatform.instance;

  test('$MethodChannelWinKeyboard is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWinKeyboard>());
  });

  test('getPlatformVersion', () async {
    WinKeyboard winKeyboardPlugin = WinKeyboard();
    MockWinKeyboardPlatform fakePlatform = MockWinKeyboardPlatform();
    WinKeyboardPlatform.instance = fakePlatform;

    expect(await winKeyboardPlugin.getPlatformVersion(), '42');
  });
}
