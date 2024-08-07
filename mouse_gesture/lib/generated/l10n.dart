// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Open at Startup`
  String get appTitle {
    return Intl.message(
      'Open at Startup',
      name: 'appTitle',
      desc: 'Label for startup setting checkbox',
      args: [],
    );
  }

  /// `Open Config File`
  String get openConfig {
    return Intl.message(
      'Open Config File',
      name: 'openConfig',
      desc: '打开配置文件按钮的标签',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '暂停使用按钮的标签',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '帮助按钮的标签',
      args: [],
    );
  }

  /// `About Me`
  String get aboutMe {
    return Intl.message(
      'About Me',
      name: 'aboutMe',
      desc: '关于按钮的标签',
      args: [],
    );
  }

  /// `Use`
  String get use {
    return Intl.message(
      'Use',
      name: 'use',
      desc: '使用按钮的标签',
      args: [],
    );
  }

  /// `Quit`
  String get quit {
    return Intl.message(
      'Quit',
      name: 'quit',
      desc: '退出按钮的标签',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '退出按钮的标签',
      args: [],
    );
  }

  /// `Setting`
  String get settings {
    return Intl.message(
      'Setting',
      name: 'settings',
      desc: '设置按钮的标签',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '主页按钮的标签',
      args: [],
    );
  }

  /// `0Mouse is running`
  String get mouseRunning {
    return Intl.message(
      '0Mouse is running',
      name: 'mouseRunning',
      desc: '0Mouse正在运行的提示',
      args: [],
    );
  }

  /// `0Mouse is paused`
  String get mousePaused {
    return Intl.message(
      '0Mouse is paused',
      name: 'mousePaused',
      desc: '0Mouse暂停的提示',
      args: [],
    );
  }

  /// `Mouse Gesture`
  String get mouseGesture {
    return Intl.message(
      'Mouse Gesture',
      name: 'mouseGesture',
      desc:
          'Hold down the right mouse button and draw the movement pattern, release the right button to trigger the corresponding action.',
      args: [],
    );
  }

  /// `Edge Scrolling`
  String get EdgeScrolling {
    return Intl.message(
      'Edge Scrolling',
      name: 'EdgeScrolling',
      desc:
          'Functions that can be triggered by scrolling the mouse wheel over the four edges of the screen',
      args: [],
    );
  }

  /// `Corner of Screen`
  String get cornerOfScreen {
    return Intl.message(
      'Corner of Screen',
      name: 'cornerOfScreen',
      desc:
          'Functions that can be triggered by moving the mouse to the four corners of the screen',
      args: [],
    );
  }

  /// `Show Keyborad`
  String get showKeyborad {
    return Intl.message(
      'Show Keyborad',
      name: 'showKeyborad',
      desc: 'Show the keyboard on the screen',
      args: [],
    );
  }

  /// `Ignore FullScreen`
  String get ignoreFullScreen {
    return Intl.message(
      'Ignore FullScreen',
      name: 'ignoreFullScreen',
      desc: 'Ignore the mouse gesture when the window is in full screen mode',
      args: [],
    );
  }

  /// `Show Icon`
  String get showIcon {
    return Intl.message(
      'Show Icon',
      name: 'showIcon',
      desc: 'Show the icon in the system tray',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
