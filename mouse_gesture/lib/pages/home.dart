import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';

const _kIconTypeDefault = 'default';
const _kIconTypeOriginal = 'original';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TrayListener {
  String _iconType = _kIconTypeOriginal;
  Menu? _menu;

  Timer? _timer;

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

  void _startIconFlashing() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _handleSetIcon(
        _iconType == _kIconTypeOriginal
            ? _kIconTypeDefault
            : _kIconTypeOriginal,
      );
    });
    setState(() {});
  }

  void _stopIconFlashing() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    setState(() {});
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('destroy'),
          onTap: () {
            trayManager.destroy();
          },
        ),
        const Divider(height: 0),
        ListTile(
          title: const Text('setIcon'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (_) {
                  bool isFlashing = (_timer != null && _timer!.isActive);
                  return TextButton(
                    onPressed:
                        isFlashing ? _stopIconFlashing : _startIconFlashing,
                    child: isFlashing
                        ? const Text('stop flash')
                        : const Text('start flash'),
                  );
                },
              ),
              TextButton(
                child: const Text('Default'),
                onPressed: () => _handleSetIcon(_kIconTypeDefault),
              ),
              TextButton(
                child: const Text('Original'),
                onPressed: () => _handleSetIcon(_kIconTypeOriginal),
              ),
            ],
          ),
          onTap: () => _handleSetIcon(_kIconTypeDefault),
        ),
        const Divider(height: 10),
        ListTile(
          title: const Text('popUpContextMenu'),
          onTap: () async {
            await trayManager.popUpContextMenu();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _buildBody(context),
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
    }
    _menu ??= Menu(
      items: [
        MenuItem.checkbox(
          label: '开机自启',
          checked: false,
          onClick: (menuItem) {
            if (kDebugMode) {
              print('click item 1');
            }
            menuItem.checked = !(menuItem.checked == true);
          },
        ),
        MenuItem.separator(),
        MenuItem(
          label: '打开配置文件',
        ),
        MenuItem.separator(),
        MenuItem.checkbox(
          label: '暂停使用',
          checked: false,
          onClick: (menuItem) {
            if (kDebugMode) {
              print('click item 1');
            }
            menuItem.checked = !(menuItem.checked == true);
          },
        ),
        MenuItem.submenu(
          label: '帮助',
          submenu: Menu(
            items: [
              MenuItem(
                label: '关于',
                onClick: (menuItem) {
                  if (kDebugMode) {
                    print('click item 1');
                  }
                },
              ),
              MenuItem(
                label: '帮助',
                onClick: (menuItem) {
                  if (kDebugMode) {
                    print('click item 2');
                  }
                },
              ),
            ],
          ),
        ),
        MenuItem.separator(),
        MenuItem(
          label: '退出',
          onClick: (menuItem) {
            if (kDebugMode) {
              print('click item 2');
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
