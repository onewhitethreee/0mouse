import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class SettingItem {
  final String title;
  final String description;
  bool value;
  bool originalValue;
  final Function(bool) onChange;

  SettingItem({
    required this.title,
    required this.description,
    required this.value,
    required this.onChange,
  }) : originalValue = value;

  bool get isChanged => value != originalValue;

  void resetOriginalValue() {
    originalValue = value;
  }
}

class MouseIncSettingsPage extends StatefulWidget {
  @override
  _MouseIncSettingsPageState createState() => _MouseIncSettingsPageState();
}

class _MouseIncSettingsPageState extends State<MouseIncSettingsPage> {
  List<SettingItem> _settings = [];
  Map<String, bool> _hoverStates = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
    _loadSettings();
  }

  void _initializeSettings() async {
    _settings = [
      SettingItem(
        title: '鼠标手势',
        description: '按住鼠标右键并绘制移动图形样式，放开右键即可触发对应动作',
        value: false,
        onChange: (value) {
          // 在这里实现鼠标手势功能的开启或关闭逻辑
          print('鼠标手势设置已更改为: $value');
        },
      ),
      SettingItem(
        title: '边缘滚动',
        description: '鼠标滚轮在屏幕四个边缘滚动，按下可触发的功能',
        value: false,
        onChange: (value) {
          // 在这里实现边缘滚动功能的开启或关闭逻辑
          print('边缘滚动设置已更改为: $value');
        },
      ),
      SettingItem(
        title: '触发角',
        description: '鼠标移动到屏幕四个角触发的功能',
        value: false,
        onChange: (value) {
          // 在这里实现触发角功能的开启或关闭逻辑
          print('触发角设置已更改为: $value');
        },
      ),
      SettingItem(
        title: '按键回显',
        description: '在屏幕上显示键盘按键，方便录制教程',
        value: false,
        onChange: (value) {
          // 在这里实现按键回显功能的开启或关闭逻辑
          print('按键回显设置已更改为: $value');
        },
      ),
      SettingItem(
        title: '忽略全屏',
        description: '当前程序如果是一个全屏程序，会自动暂停Mouse功能',
        value: false,
        onChange: (value) {
          // 在这里实现忽略全屏功能的开启或关闭逻辑
          print('忽略全屏设置已更改为: $value');
        },
      ),
      SettingItem(
          title: "自动关闭大小写",
          description: "在键盘大写开启的情况下，1分钟后自动关闭",
          value: false,
          onChange: (value) {
            // 在这里实现自动关闭大小写功能的开启或关闭逻辑
            print('自动关闭大小写设置已更改为: $value');
          }),
      SettingItem(
        title: '启动时隐藏',
        description: '开机启动时自动隐藏到系统托盘',
        value: false,
        onChange: (value) async {
          // 在这里实现启动时隐藏功能的开启或关闭逻辑
          print('隐藏设置已更改为: $value');

          if (value && await isFirstLaunchSinceBoot()) {
            windowManager.hide();
          } else {
            windowManager.show();
          }
        },
      ),
    ];
  }

  // 判断是否是第一次启动
  Future<bool> isFirstLaunchSinceBoot() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? hasLaunched = prefs.getBool('hasLaunchedSinceBoot');

    if (hasLaunched == null || !hasLaunched) {
      await prefs.setBool('hasLaunchedSinceBoot', true);
      return true;
    } else {
      return false;
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var setting in _settings) {
        setting.value = prefs.getBool(setting.title) ?? setting.value;
        setting.resetOriginalValue();
      }
      _loading = false;
    });
  }

  Future<void> _saveSettings(String s) async {
    final prefs = await SharedPreferences.getInstance();
    for (var setting in _settings) {
      await prefs.setBool(setting.title, setting.value);
      if (setting.isChanged) {
        setting.onChange(setting.value);
        setting.resetOriginalValue();
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('设置已$s')),
    );

    // 打印所有设置的当前值
    print('保存后的设置值:');
    for (var setting in _settings) {
      print('${setting.title}: ${setting.value}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('功能开关'),
          backgroundColor: const Color.fromARGB(255, 219, 216, 216),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('功能开关'),
        backgroundColor: const Color.fromARGB(255, 219, 216, 216),
        actions: [
          TextButton(
            child: Text('保存',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            onPressed: () => _saveSettings("保存"),
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: _loadSettings,
          ),
          IconButton(
            icon: Icon(Icons.undo),
            tooltip: '重置所有为false',
            onPressed: () {
              setState(() {
                for (var setting in _settings) {
                  setting.value = false;
                }
              });
              _saveSettings("重置");
            },
          ),
        ],
      ),
      body: ListView(
        children: _buildSettingsRows(),
      ),
    );
  }

  List<Widget> _buildSettingsRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _settings.length; i += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildSettingItem(_settings[i])),
              if (i + 1 < _settings.length)
                Expanded(child: _buildSettingItem(_settings[i + 1]))
              else
                Expanded(child: Container()),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  Widget _buildSettingItem(SettingItem setting) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _hoverStates[setting.title] = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hoverStates[setting.title] = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            setting.value = !setting.value;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _hoverStates[setting.title] == true
                ? Colors.grey[300]
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _hoverStates[setting.title] == true
                ? [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4))
                  ]
                : [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2))
                  ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      setting.title,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Switch(
                    value: setting.value,
                    onChanged: (bool newValue) {
                      setState(() {
                        setting.value = newValue;
                      });
                    },
                    activeColor: Colors.blue,
                    inactiveThumbColor: Colors.grey,
                    activeTrackColor: Colors.blue.withOpacity(0.5),
                    inactiveTrackColor: Colors.white10,
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                setting.description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
