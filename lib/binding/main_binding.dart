import 'package:get/get.dart';
import 'package:pro_23/binding/post_binding.dart';

/// Dependencies for the tabbed shell.
///
/// The tabs are built inside `MainScreen`, not reached through their own
/// routes, so whatever they need has to be registered here.
class MainBinding extends Bindings {
  @override
  void dependencies() {
    PostBinding().dependencies();
  }
}