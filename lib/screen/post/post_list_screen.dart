import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_23/core_translation/Value/app_color.dart';
import 'package:pro_23/core_translation/Value/app_text_style.dart';
import 'package:pro_23/model/post_daa_model.dart';
import 'package:pro_23/screen/post/post_card.dart';
import 'package:pro_23/screen/post/post_create.dart';

import '../../controller/post_controller.dart';


class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final PostController controller = Get.put(PostController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final nearBottom =
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200;
      if (nearBottom) {
        controller.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts'.tr), backgroundColor: AppColor.primaryLight,),

      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: 'Search by title'.tr,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColor.background,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          Obx(
                () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${controller.posts.length} of ${controller.total} shown',
                  style: AppTextStyle.caption,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // List
          Expanded(
            child: Obx(() {
              // Loading (first page only — don't hide the list during loadMore)
              if (controller.isLoading.value && controller.posts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error (only full-screen if we have nothing to show)
              if (controller.errorMessage.value.isNotEmpty && controller.posts.isEmpty) {
                return Center(child: Text(controller.errorMessage.value));
              }

              // Empty
              if (controller.posts.isEmpty) {
                return const Center(child: Text('No posts found'));
              }

              //List//
              return ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 90),
                itemCount:
                controller.posts.length +
                    (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.posts.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final Data post = controller.posts[index];

                  return PostCard(
                    title: post.title ?? '',
                    description: post.content ?? '',
                    author: post.author?.nickName ?? post.author?.username ?? '',
                    date: _formatDate(post.createdAt),
                    isDraft: post.published == false,
                    imageUrl: post.imageUrl,
                    color: post.imageUrl == null ? AppColor.warning : null,

                    onEdit: () {
                      Get.to(() => PostCreateScreen(post: post));
                    },

                    onUnpublish: () {
                      controller.togglePublishPost(post);
                    },

                    onDelete: () {
                      controller.deletePost(post);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/post_create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}