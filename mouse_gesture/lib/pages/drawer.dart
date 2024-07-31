import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mouse_gesture/pages/about_page.dart';
import 'settings_page.dart';
import '../generated/l10n.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(S.of(context).home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(S.of(context).settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MouseIncSettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(S.of(context).aboutMe),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(S.of(context).exit),
            onTap: () {
              Navigator.pop(context);
              exit(0);
            },
          ),
          // 添加一个分割线
          const Divider(),
        ],
      ),
    );
  }
}
