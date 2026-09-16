/// Route names, as constants so a typo is a compile error rather than a
/// blank screen at runtime.
class AppRoute {
  const AppRoute._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  /// The tabbed shell — what login and splash land on.
  static const String main = '/';
  static const String postList = '/posts-list';
  static const String postForm = '/posts-create';
}
