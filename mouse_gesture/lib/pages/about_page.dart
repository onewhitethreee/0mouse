import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(S.of(context).aboutMe),
      ),
      body: Center(
        child: const Text('About Page'),
      ),
    );
  }
}
