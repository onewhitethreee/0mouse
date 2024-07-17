import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, Map<String, dynamic>> _settings = {
    '鼠标手势': {'value': false, 'description': '按住鼠标右键并绘制移动图形样式，放开右键即可触发对应动作'},
    '滚轮快切': {'value': false, 'description': '按住鼠标右键时，滚动滚轮可以执行切换动作（依赖鼠标手势）'},
    '边缘滚动': {'value': false, 'description': '鼠标滚轮在屏幕四个边缘滚动，按下可触发的功能'},
    '触发角': {'value': false, 'description': '鼠标移动到屏幕四个角触发的功能'},
    '小键盘always on': {'value': false, 'description': '电脑小键盘永远保持开启状态'}
    // ... 添加其他设置项
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置')),
      body: ListView(
        children: _buildSettingsRows(),
      ),
    );
  }

  List<Widget> _buildSettingsRows() {
    List<Widget> rows = [];
    for (int i = 0; i < _settings.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: _buildSettingItem(_settings.keys.elementAt(i))),
            Expanded(
              child: i + 1 < _settings.length
                  ? _buildSettingItem(_settings.keys.elementAt(i + 1))
                  : Container(), // 如果是最后一个奇数项，添加空容器
            ),
          ],
        ),
      );
    }
    return rows;
  }

  Widget _buildSettingItem(String title) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Switch(
                value: _settings[title]!['value'],
                onChanged: (bool newValue) {
                  setState(() {
                    _settings[title]!['value'] = newValue;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            _settings[title]!['description'],
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
