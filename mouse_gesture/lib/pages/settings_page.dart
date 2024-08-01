import 'package:flutter/material.dart';
import 'package:mouse_gesture/generated/l10n.dart';

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
    '按键音效': {'value': false, 'description': '在你打字时发出悦耳的声音'},
    '输入法状态显示': {'value': false, 'description': '显示当前窗口输入法的中英文状态'},
    '忽略全屏': {'value': false, 'description': '当前程序如果是一个全屏程序，会自动暂停Mouse功能'},
    '显示图标': {'value': false, 'description': '是否在系统托盘显示Mouse图标'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // 保留灰色背景，使白色卡片更加突出
      appBar: AppBar(
        title: Text('功能开关'),
        backgroundColor: const Color.fromARGB(255, 219, 216, 216),
        actions: [
          TextButton(
            child: Text('保存',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('设置已保存')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: () {
              // 实现刷新逻辑
            },
          ),
          IconButton(
            icon: Icon(Icons.undo),
            tooltip: '重置',
            onPressed: () {
              // 实现重置逻辑
            },
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'zh') {
                Locale locale = Locale('zh', 'CN');
                S.load(locale);
              } else if (result == 'en') {
                Locale locale = Locale('en', 'US');
                S.load(locale);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'zh',
                child: Text('中文'),
              ),
              const PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
            ],
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
          // Set the hover state to true when the mouse enters
          _settings[title]?['hovered'] = true;
        });
      },
      onExit: (_) {
        setState(() {
          // Set the hover state to false when the mouse leaves
          _settings[title]?['hovered'] = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            // Toggle the switch value
            setting['value'] = !setting['value'];
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200), // Animation duration
          curve: Curves.easeInOut, // Animation curve
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
