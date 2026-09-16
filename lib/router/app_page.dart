import 'package:get/get.dart';
import 'package:pro_23/binding/auth_binding.dart';
import 'package:pro_23/binding/main_binding.dart';
import 'package:pro_23/binding/post_binding.dart';
import 'package:pro_23/router/app_route.dart';
import 'package:pro_23/screen/auth/login_screen.dart';
import 'package:pro_23/screen/main_screen.dart';
import 'package:pro_23/screen/post/post_create.dart';
import 'package:pro_23/screen/post/post_list_screen.dart';

class AppPage {
  const AppPage._();

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<void>(
      name: AppRoute.login,
      page: LoginScreen.new,
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),

    GetPage<void>(
      name: AppRoute.main,
      page: MainScreen.new,
      binding: MainBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage<void>(
      name: AppRoute.postList,
      page: PostListScreen.new,
      binding: PostBinding(),
    ),
    GetPage<void>(
      name: AppRoute.postForm,
      page: PostCreateScreen.new,
      binding: PostBinding(),
    ),
  ];
}
