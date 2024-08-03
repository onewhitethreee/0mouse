// right_mouse_gesture_plugin_c_api.cpp
#include "include/right_mouse_gesture/right_mouse_gesture_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "right_mouse_gesture_plugin.h"

void RightMouseGesturePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
    right_mouse_gesture::RightMouseGesturePlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
            ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}