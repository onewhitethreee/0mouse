#ifndef FLUTTER_PLUGIN_RIGHT_MOUSE_GESTURE_PLUGIN_H_
#define FLUTTER_PLUGIN_RIGHT_MOUSE_GESTURE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace right_mouse_gesture {

class RightMouseGesturePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  RightMouseGesturePlugin();

  virtual ~RightMouseGesturePlugin();

  // Disallow copy and assign.
  RightMouseGesturePlugin(const RightMouseGesturePlugin&) = delete;
  RightMouseGesturePlugin& operator=(const RightMouseGesturePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace right_mouse_gesture

#endif  // FLUTTER_PLUGIN_RIGHT_MOUSE_GESTURE_PLUGIN_H_
