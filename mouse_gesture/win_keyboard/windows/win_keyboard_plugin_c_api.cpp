#include "include/win_keyboard/win_keyboard_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "win_keyboard_plugin.h"

void WinKeyboardPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  win_keyboard::WinKeyboardPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
