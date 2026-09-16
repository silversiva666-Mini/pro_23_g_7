import 'package:get/get.dart';

import '../model/user_model.dart';
import '../repository/user_repository.dart';

/// Single source of truth for "who's registered". [UserScreen] reads from
/// this, and [RegisterController] writes to it on a successful sign-up —
/// that's the whole mechanism that makes a new account "show up" without
/// either screen knowing about the other directly.
class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  static const int _pageSize = 20;

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxInt total = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  int _page = 1;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// First page / pull-to-refresh.
  Future<void> fetchUsers() async {
    isLoading.value = true;
    errorMessage.value = '';
    _page = 1;
    _hasMore = true;

    final (fetchedUsers, fetchedTotal, error) =
    await _userRepository.getUsers(page: _page, limit: _pageSize);

    isLoading.value = false;

    if (error != null || fetchedUsers == null) {
      errorMessage.value = error ?? 'Failed to load users';
      return;
    }

    users.assignAll(fetchedUsers);
    if (fetchedTotal != null) total.value = fetchedTotal;
    _hasMore = fetchedUsers.length >= _pageSize;
  }

  /// Called when the list scrolls near the bottom.
  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || !_hasMore) return;

    isLoadingMore.value = true;
    final int nextPage = _page + 1;

    final (fetchedUsers, fetchedTotal, error) =
    await _userRepository.getUsers(page: nextPage, limit: _pageSize);

    isLoadingMore.value = false;

    if (error != null || fetchedUsers == null) {
      // Don't clobber the existing list on a load-more failure — just stop.
      _hasMore = false;
      return;
    }

    if (fetchedUsers.isEmpty) {
      _hasMore = false;
      return;
    }

    _page = nextPage;
    users.addAll(fetchedUsers);
    if (fetchedTotal != null) total.value = fetchedTotal;
    _hasMore = fetchedUsers.length >= _pageSize;
  }

  /// Called by [RegisterController] right after a successful registration
  /// so the new user appears immediately, without waiting on a refetch.
  void addUser(UserModel user) {
    users.insert(0, user);
  }
}