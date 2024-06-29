import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/l10n.dart';

const _kIconTypeDefault = 'default';
const _kIconTypeOriginal = 'original';
const _AboutURL = 'https://0mouse.com/about';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _handleSetIcon(_kIconTypeDefault);
              },
              child: const Text('Set Default Icon'),
            ),
            ElevatedButton(
              onPressed: () {
                _handleSetIcon(_kIconTypeOriginal);
              },
              child: const Text('Set Original Icon'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onTrayIconMouseDown() {
    if (kDebugMode) {
      print('onTrayIconMouseDown');
    }
    // trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconMouseUp() {
    if (kDebugMode) {
      print('onTrayIconMouseUp');
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    if (kDebugMode) {
      print('onTrayIconRightMouseDown');
      print('Current locale: ${Localizations.localeOf(context)}');
    }

    _menu ??= Menu(
      items: [
        MenuItem.checkbox(
          label: S.of(context).appTitle,
          checked: false,
          onClick: (menuItem) {
            if (kDebugMode) {
              print('auto start');
            }
            menuItem.checked = !(menuItem.checked == true);
          },
        ),
        MenuItem.separator(),
        MenuItem(
          label: S.of(context).openConfig,
        ),
        MenuItem.separator(),
        MenuItem.checkbox(
          label: S.of(context).pause,
          checked: false,
          onClick: (menuItem) {
            if (kDebugMode) {
              print('pause use');
            }
            menuItem.checked = !(menuItem.checked == true);
            if (menuItem.checked == true) {
              _setPauseIcon();
            } else {
              _setNormalIcon();
            }
          },
        ),
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
