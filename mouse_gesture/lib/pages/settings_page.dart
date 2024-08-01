import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MouseIncSettingsPage extends StatefulWidget {
  @override
  _MouseIncSettingsPageState createState() => _MouseIncSettingsPageState();
}

class _MouseIncSettingsPageState extends State<MouseIncSettingsPage> {
  Map<String, Map<String, dynamic>> _settings = {
    '鼠标手势': {'value': false, 'description': '按住鼠标右键并绘制移动图形样式，放开右键即可触发对应动作'},
    '边缘滚动': {'value': false, 'description': '鼠标滚轮在屏幕四个边缘滚动，按下可触发的功能'},
    '触发角': {'value': false, 'description': '鼠标移动到屏幕四个角触发的功能'},
    '按键回显': {'value': false, 'description': '在屏幕上显示键盘按键，方便录制教程'},
    '忽略全屏': {'value': false, 'description': '当前程序如果是一个全屏程序，会自动暂停Mouse功能'},
    '显示图标': {'value': false, 'description': '是否在系统托盘显示软件图标'},
  };
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _settings.forEach((key, value) {
        value['value'] = prefs.getBool(key) ?? value['value'];
      });
      _loading = false; // 数据加载完成
    });
  }

  Future<void> _saveSettings(String s) async {
    final prefs = await SharedPreferences.getInstance();
    _settings.forEach((key, value) {
      prefs.setBool(key, value['value']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('设置已$s')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // 显示加载指示器
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
            onPressed: () {
              _saveSettings("保存"); // 保存设置
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: () {
              _loadSettings(); // 重新加载设置
            },
          ),
          IconButton(
            icon: Icon(Icons.undo),
            tooltip: '重置',
            onPressed: () {
              setState(() {
                _settings.forEach((key, value) {
                  value['value'] = false;
                });
              });
              _saveSettings("重置"); // 保存设置
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
    var entries = _settings.entries.toList();
    for (int i = 0; i < entries.length; i += 2) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _buildSettingItem(entries[i].key, entries[i].value)),
              if (i + 1 < entries.length)
                Expanded(
                    child: _buildSettingItem(
                        entries[i + 1].key, entries[i + 1].value))
              else
                Expanded(child: Container()),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  Widget _buildSettingItem(String title, Map<String, dynamic> setting) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _settings[title]?['hovered'] = true;
        });
      },
      onExit: (_) {
        setState(() {
          _settings[title]?['hovered'] = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            setting['value'] = !setting['value'];
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _settings[title]?['hovered'] == true
                ? Colors.grey[300]
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: _settings[title]?['hovered'] == true
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
                      title,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Switch(
                    value: setting['value'],
                    onChanged: (bool newValue) {
                      setState(() {
                        setting['value'] = newValue;
                      });
                      print("onChanged: $newValue");
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
                setting['description'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
