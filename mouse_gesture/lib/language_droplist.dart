// 切换三国语言
import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final void Function(String) onLanguageChange;

  const LanguageDropdown({super.key, required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: Localizations.localeOf(context).languageCode,
      items: const [
        DropdownMenuItem(
          value: 'en',
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: 'zh-cn',
          child: Text('中文'),
        ),
        DropdownMenuItem(
          value: 'es',
          child: Text('Español'),
        ),
      ],
      onChanged: (String? newValue) {
        if (newValue != null) {
          onLanguageChange(newValue);
        }
      },
    );
  }
}
