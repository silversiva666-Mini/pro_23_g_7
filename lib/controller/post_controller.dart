import 'package:get/get.dart';
import 'package:pro_23/model/post_daa_model.dart';
import 'package:pro_23/repository/post_repository.dart';
import 'package:pro_23/service/storage_service.dart';

import 'dart:io';

class PostController extends GetxController {
  final PostRepository _postRepo = Get.put(PostRepository());

  final posts = <Data>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isCreating = false.obs;

  final errorMessage = ''.obs;
  final createErrorMessage = ''.obs;

  final searchTerm = ''.obs;

  int _page = 0;
  int _totalPages = 1;
  int _total = 0;

  int get total => _total;

  bool get hasMore => _page + 1 < _totalPages;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    loadFirstPage();

    debounce(
      searchTerm,
          (_) => loadFirstPage(),
      time: const Duration(
        milliseconds: 400,
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void updateSearch(String value) {
    searchTerm.value = value;
  }

  // ============================================================
  // LOAD FIRST PAGE
  // ============================================================

  Future<void> loadFirstPage() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    _page = 0;

    final (PostDataModel? page, String? error) =
    await _postRepo.getPageTest(
      page: 0,
      size: 10,
      title: searchTerm.value,
    );

    isLoading.value = false;

    if (error != null) {
      errorMessage.value = error;
      posts.clear();
      return;
    }

    if (page == null) {
      errorMessage.value = 'No data';
      posts.clear();
      return;
    }

    posts.assignAll(
      page.data ?? <Data>[],
    );

    _applyMeta(page);
  }

  // ============================================================
  // LOAD MORE
  // ============================================================

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore) {
      return;
    }

    isLoadingMore.value = true;

    final int nextPage = _page + 1;

    final (PostDataModel? page, String? error) =
    await _postRepo.getPageTest(
      page: nextPage,
      size: 10,
      title: searchTerm.value,
    );

    isLoadingMore.value = false;

    if (error != null) {
      errorMessage.value = error;
      return;
    }

    if (page == null) return;

    posts.addAll(
      page.data ?? <Data>[],
    );

    _applyMeta(page);
  }

  // ============================================================
  // CREATE POST
  // ============================================================

  Future<bool> createPost({
    required String title,
    required String content,
    required bool published,
    File? image,
  }) async {
    if (title.trim().isEmpty) {
      createErrorMessage.value =
      'Please enter a title';
      return false;
    }

    isCreating.value = true;
    createErrorMessage.value = '';

    try {
      // STEP 1:
      // Create normal post first.
      final (Data? createdPost, String? error) =
      await _postRepo.createPost(
        title: title.trim(),
        content: content.trim(),
        published: published,
      );

      if (error != null) {
        createErrorMessage.value = error;
        return false;
      }

      if (createdPost == null) {
        createErrorMessage.value =
        'Could not create post';
        return false;
      }

      Data finalPost = createdPost;

      // STEP 2:
      // Upload image separately.
      if (image != null) {
        if (createdPost.id == null) {
          createErrorMessage.value =
          'Post created but server did not return post ID.';
        } else {
          final (Data? postWithImage, String? imageError) =
          await _postRepo.uploadPostImage(
            postId: createdPost.id.toString(),
            image: image,
          );

          if (imageError != null) {
            createErrorMessage.value =
            'Post created, but image upload failed:\n'
                '$imageError';

            Get.snackbar(
              'Image upload failed',
              imageError,
            );
          } else if (postWithImage != null) {
            finalPost = postWithImage;
          }
        }
      }

      // Add the newly created post.
      posts.insert(
        0,
        finalPost,
      );

      return true;
    } finally {
      isCreating.value = false;
    }
  }

  // ============================================================
  // EDIT POST
  // ============================================================

  Future<bool> editPostSubmit({
    required Data existingPost,
    required String title,
    required String content,
    required bool published,
    File? image,
  }) async {
    if (title.trim().isEmpty) {
      createErrorMessage.value =
      'Please enter a title';
      return false;
    }

    isCreating.value = true;
    createErrorMessage.value = '';

    try {
      // STEP 1:
      // Update title/content/published only.
      final (Data? updatedPost, String? error) =
      await _postRepo.updatePost(
        id: existingPost.id.toString(),
        title: title.trim(),
        content: content.trim(),
        published: published,

        // ✅ No Base64 image here anymore.
      );

      if (error != null) {
        createErrorMessage.value = error;
        return false;
      }

      if (updatedPost == null) {
        createErrorMessage.value =
        'Could not update post';
        return false;
      }

      Data finalPost = updatedPost;

      // STEP 2:
      // User selected a new image.
      if (image != null) {
        final (Data? postWithImage, String? imageError) =
        await _postRepo.uploadPostImage(
          postId: existingPost.id.toString(),
          image: image,
        );

        if (imageError != null) {
          createErrorMessage.value =
          'Post updated, but image upload failed:\n'
              '$imageError';

          Get.snackbar(
            'Image upload failed',
            imageError,
          );
        } else if (postWithImage != null) {
          finalPost = postWithImage;
        }
      }

      // Update current list.
      final int index = posts.indexWhere(
            (Data post) =>
        post.id == existingPost.id,
      );

      if (index != -1) {
        posts[index] = finalPost;
      }

      return true;
    } finally {
      isCreating.value = false;
    }
  }

  // ============================================================
// PUBLISH / UNPUBLISH
// ============================================================

  Future<void> togglePublishPost(Data post) async {
    if (post.id == null) {
      Get.snackbar(
        'Error',
        'Post ID not found',
      );
      return;
    }

    final bool newPublishedStatus =
    !(post.published ?? false);

    final (Data? updated, String? error) =
    await _postRepo.updatePost(
      id: post.id.toString(),
      published: newPublishedStatus,
    );

    if (error != null) {
      Get.snackbar(
        newPublishedStatus
            ? 'Publish failed'
            : 'Unpublish failed',
        error,
      );
      return;
    }

    if (updated == null) return;

    final int index = posts.indexWhere(
          (Data p) => p.id == post.id,
    );

    if (index != -1) {
      posts[index] = updated;
      posts.refresh();
    }

    Get.snackbar(
      'Done',
      newPublishedStatus
          ? 'published'
          : 'Kept as a draft',
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  Future<void> deletePost(
      Data post,
      ) async {
    final (bool success, String? error) =
    await _postRepo.deletePost(
      post.id.toString(),
    );

    if (!success) {
      Get.snackbar(
        'Delete failed',
        error ?? 'Could not delete post',
      );
      return;
    }

    posts.removeWhere(
          (Data p) => p.id == post.id,
    );
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  void _applyMeta(
      PostDataModel page,
      ) {
    final Pagination? pagination =
        page.pagination;

    if (pagination == null) {
      _total = 0;
      _totalPages = 1;
      return;
    }

    _page = pagination.page ?? 0;
    _totalPages =
        pagination.totalPages ?? 1;
    _total = pagination.total ?? 0;
  }
}