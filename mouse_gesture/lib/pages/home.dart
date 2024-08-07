import 'dart:async';
import 'dart:io';

import 'dart:ffi';
import 'package:bot_toast/bot_toast.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

import '../generated/l10n.dart';
import 'drawer.dart';

const _kIconTypeDefault = 'default';
const _kIconTypeOriginal = 'original';
const _AboutURL = 'https://0mouse.com';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener {
  String _iconType = _kIconTypeOriginal;
  Menu? _menu;

  @override
  void initState() {
    trayManager.addListener(this);
    super.initState();
    _initTray();
    getOperation();
  }

  void getOperation() {
    if (Platform.isWindows) {
      print('Running on Windows');
    } else if (Platform.isAndroid) {
      print('Running on Android');
    } else if (Platform.isIOS) {
      print('Running on iOS');
    } else if (Platform.isMacOS) {
      print('Running on macOS');
    } else if (Platform.isLinux) {
      print('Running on Linux');
    } else {
      print('Running on an unknown platform');
    }
  }

  void _initTray() async {
    // 设置托盘图标
    await trayManager.setIcon('images/tray_icon_original.ico');

    // 设置托盘工具提示
    await trayManager.setToolTip('0Mouse');
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    super.dispose();
  }

  // 启用开机启动
  void enableStartUpOnWindows() {
    final hkey = HKEY_CURRENT_USER;
    final lpSubKey =
        'Software\\Microsoft\\Windows\\CurrentVersion\\Run'.toNativeUtf16();
    final dwType = REG_VALUE_TYPE.REG_SZ;
    final programName = '0Mouse'.toNativeUtf16();
    final lpData = Platform.resolvedExecutable.toNativeUtf16();

    final phkResult = calloc<HKEY>();

    try {
      final lResult = RegOpenKeyEx(
        hkey,
        lpSubKey,
        0,
        REG_SAM_FLAGS.KEY_SET_VALUE,
        phkResult,
      );

      if (lResult == WIN32_ERROR.ERROR_SUCCESS) {
        final setResult = RegSetValueEx(
          phkResult.value,
          programName,
          0,
          dwType,
          lpData.cast<Uint8>(),
          lpData.length * 2, // multiply by 2 for wide char
        );

        if (setResult != WIN32_ERROR.ERROR_SUCCESS) {
          throw WindowsException(setResult);
        }
      } else {
        throw WindowsException(lResult);
      }
    } finally {
      if (phkResult.value != NULL) {
        RegCloseKey(phkResult.value);
      }
      free(phkResult);
      free(lpSubKey);
      free(programName);
      free(lpData);
    }
  }

  // 禁用开机启动
  void disableStartUpOnWindows() {
    final hkey = HKEY_CURRENT_USER;
    final lpSubKey =
        'Software\\Microsoft\\Windows\\CurrentVersion\\Run'.toNativeUtf16();
    final programName = '0Mouse'.toNativeUtf16();

    final phkResult = calloc<HKEY>();

    try {
      final lResult = RegOpenKeyEx(
        hkey,
        lpSubKey,
        0,
        REG_SAM_FLAGS.KEY_SET_VALUE,
        phkResult,
      );

      if (lResult == WIN32_ERROR.ERROR_SUCCESS) {
        final deleteResult = RegDeleteValue(
          phkResult.value,
          programName,
        );

        if (deleteResult != WIN32_ERROR.ERROR_SUCCESS) {
          throw WindowsException(deleteResult);
        }
      } else {
        throw WindowsException(lResult);
      }
    } finally {
      if (phkResult.value != NULL) {
        RegCloseKey(phkResult.value);
      }
      free(phkResult);
      free(lpSubKey);
      free(programName);
    }
  }

  // 查找开机启动
  bool findStartUpOnWindows() {
    final hkey = HKEY_CURRENT_USER;
    final lpSubKey =
        'Software\\Microsoft\\Windows\\CurrentVersion\\Run'.toNativeUtf16();
    final programName = '0Mouse'.toNativeUtf16();

    final phkResult = calloc<HKEY>();
    final lpType = calloc<DWORD>();
    final lpcbData = calloc<DWORD>();
    bool result = false;
    try {
      final lResult = RegOpenKeyEx(
        hkey,
        lpSubKey,
        0,
        REG_SAM_FLAGS.KEY_READ,
        phkResult,
      );

      if (lResult == WIN32_ERROR.ERROR_SUCCESS) {
        // First call to get the size of the data
        RegQueryValueEx(
          phkResult.value,
          programName,
          nullptr,
          lpType,
          nullptr,
          lpcbData,
        );

        final lpData = calloc<BYTE>(lpcbData.value);

        final queryResult = RegQueryValueEx(
          phkResult.value,
          programName,
          nullptr,
          lpType,
          lpData,
          lpcbData,
        );

        if (queryResult == WIN32_ERROR.ERROR_SUCCESS) {
          final value = lpData.cast<Utf16>().toDartString();
          print('Value found: $value');
          result = true;
        } else {
          print('start up Value not found');
        }

        free(lpData);
      } else {
        throw WindowsException(lResult);
      }
    } finally {
      if (phkResult.value != NULL) {
        RegCloseKey(phkResult.value);
      }
      free(phkResult);
      free(lpType);
      free(lpcbData);
    }
    return result;
  }

  // 设置图标
  Future<void> _handleSetIcon(String iconType) async {
    _iconType = iconType;
    String iconPath =
        Platform.isWindows ? 'images/tray_icon.ico' : 'images/tray_icon.png';

    if (_iconType == 'original') {
      iconPath = Platform.isWindows
          ? 'images/tray_icon_original.ico'
          : 'images/tray_icon_original.png';
    }
    await trayManager.setIcon(iconPath);
  }

  // 暂停使用图标
  void _setPauseIcon() async {
    await _handleSetIcon(_kIconTypeDefault);
  }

  // 恢复正常图标
  void _setNormalIcon() async {
    await _handleSetIcon(_kIconTypeOriginal);
  }

  // 打开浏览器
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _sendLocalNotification(String msg) {
    final notification = LocalNotification(
      // 用来生成通用唯一识别码
      identifier: '0Mouse',
      title: "0Mouse",
      subtitle: '0Mouse',
      body: msg,
      // 用来设置是否静音
      silent: true,
    );
    notification.onShow = () {
      BotToast.showText(text: msg);
    };

    notification.show();
  }

  bool _isSwitched = true; // 开关状态
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('0Mouse'),
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Switch(
          value: _isSwitched,
          onChanged: (value) {
            setState(() {
              _isSwitched = value;
              if (_isSwitched) {
                _setNormalIcon();
                _sendLocalNotification(S.of(context).mouseRunning);
              } else {
                _setPauseIcon();
                _sendLocalNotification(S.of(context).mousePaused);
              }
            });
          },
          activeColor: Colors.green, // 开启时的颜色
          inactiveThumbColor: const Color.fromARGB(255, 151, 97, 94), // 关闭时的颜色
          activeTrackColor: Colors.green.withOpacity(0.5), // 开启时轨道的颜色
          inactiveTrackColor: Colors.red.withOpacity(0.5), // 关闭时轨道的颜色
        ),
      ),
    );
  }

  int _counter = 0;
  @override
  Future<void> onTrayIconMouseDown() async {
    if (kDebugMode) {
      print('onTrayIconMouseDown');
    }
    _counter++;
    if (_counter == 1) {
      Timer(const Duration(milliseconds: 250), () async {
        if (_counter == 1) {
          if (kDebugMode) {
            print('single click');
          }
        } else {
          if (await windowManager.isVisible()) {
            await windowManager.hide();
          } else {
            await windowManager.show();
          }
        }
        _counter = 0;
      });
    }
  }

  @override
  void onTrayIconMouseUp() {
    if (kDebugMode) {
      print('onTrayIconMouseUp');
    }
  }

  @override
  void onTrayIconRightMouseDown() async {
    if (kDebugMode) {
      print('onTrayIconRightMouseDown');
      print('Current locale: ${Localizations.localeOf(context)}');
    }

    _menu ??= Menu(
      items: [
        MenuItem.checkbox(
          label: S.of(context).appTitle,
          checked: findStartUpOnWindows(),
          onClick: (menuItem) {
            if (kDebugMode) {
              print('auto start');
            }
            menuItem.checked = !(menuItem.checked == true);
            if (menuItem.checked == true) {
              enableStartUpOnWindows();
            } else {
              disableStartUpOnWindows();
            }
          },
        ),
        MenuItem.separator(),
        MenuItem(
          label: S.of(context).openConfig,
        ),
        MenuItem.separator(),
        MenuItem.submenu(
          label: S.of(context).help,
          submenu: Menu(
            items: [
              MenuItem(
                label: S.of(context).aboutMe,
                onClick: (menuItem) {
                  if (kDebugMode) {
                    print('help about');
                  }
                  menuItem.checked = !(menuItem.checked == true);
                  // open about page
                  if (menuItem.checked == true) {
                    _launchInBrowser(Uri.parse(_AboutURL));
                  }
                },
              ),
              MenuItem(
                label: S.of(context).help,
                onClick: (menuItem) {
                  if (kDebugMode) {
                    print('help help');
                  }
                  menuItem.checked = !(menuItem.checked == true);
                  // open help page
                  if (menuItem.checked == true) {
                    _launchInBrowser(Uri.parse(_AboutURL));
                  }
                },
              ),
            ],
          ),
        ),
        MenuItem.separator(),
        MenuItem(
          label: S.of(context).exit,
          onClick: (menuItem) {
            if (kDebugMode) {
              print('exit');
            }
            exit(0);
          },
        ),
      ],
    );
    trayManager.setContextMenu(_menu!);
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {
    if (kDebugMode) {
      print('onTrayIconRightMouseUp');
    }
  }
}
