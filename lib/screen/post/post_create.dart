import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pro_23/core_translation/Value/app_color.dart';
import 'package:pro_23/core_translation/Value/app_text_style.dart';
import 'package:pro_23/model/post_daa_model.dart';
import '../../controller/post_controller.dart';

class PostCreateScreen extends StatefulWidget {
  /// Pass an existing post to edit it; leave null to create a new one.
  final Data? post;

  const PostCreateScreen({super.key, this.post});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final PostController controller = Get.find<PostController>(); // ✅ បន្ថែម

  late final titleController = TextEditingController(text: widget.post?.title ?? '');
  late final contentController = TextEditingController(text: widget.post?.content ?? '');
  late bool isPublished = widget.post?.published ?? true;
  File? selectedImage;

  bool get isEditing => widget.post != null;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surface,
      appBar: AppBar(
        backgroundColor: AppColor.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEditing ? 'Edit Page' : 'New Page',
          style: AppTextStyle.heading,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image picker box
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColor.primaryLight.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildImagePreview(),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                isEditing
                    ? 'Tap to change the picture'
                    : 'new Picture After Created',
                style: AppTextStyle.caption.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Title field label
            Text(
              'Title',
              style: AppTextStyle.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title, color: AppColor.textSecondary),
                  hintText: 'My Title',
                  hintStyle: TextStyle(color: AppColor.textDisabled),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Content label
            Text(
              'Content',
              style: AppTextStyle.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.border),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: contentController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Writing here...',
                  hintStyle: TextStyle(color: AppColor.textDisabled),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Publish toggle row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'posted',
                        style: AppTextStyle.body.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'everybody can see here',
                        style: AppTextStyle.caption.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isPublished,
                  activeColor: AppColor.surface,
                  activeTrackColor: AppColor.primary,
                  onChanged: (value) {
                    setState(() => isPublished = value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            Obx(() {
              if (controller.createErrorMessage.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    controller.createErrorMessage.value,
                    style: AppTextStyle.error,
                  ),
                );
              }
              return const SizedBox();
            }),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(
                    () => ElevatedButton.icon(
                  onPressed: controller.isCreating.value
                      ? null
                      : () async {
                    final bool success = isEditing
                        ? await controller.editPostSubmit(
                      existingPost: widget.post!,
                      title: titleController.text,
                      content: contentController.text,
                      published: isPublished,
                      image: selectedImage,
                    )
                        : await controller.createPost(
                      title: titleController.text,
                      content: contentController.text,
                      published: isPublished,
                      image: selectedImage,
                    );
                    if (success) {
                      Get.back(); // ត្រឡប់ទៅ Post List Screen វិញ
                    }
                  },
                  icon: controller.isCreating.value
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.surface,
                    ),
                  )
                      : Icon(Icons.check, color: AppColor.surface),
                  label: Text(
                    isEditing ? 'Update Page' : 'Create Page',
                    style: AppTextStyle.button,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    // A newly picked image always takes priority over whatever was there.
    if (selectedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          selectedImage!,
          width: double.infinity,
          height: 160,
          fit: BoxFit.cover,
        ),
      );
    }

    // Editing an existing post that already has an image — show it via
    // network until the user picks a replacement.
    final String? existingUrl = widget.post?.imageUrl;
    if (existingUrl != null && existingUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          existingUrl,
          width: double.infinity,
          height: 160,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              Icons.add_photo_alternate_outlined,
              size: 40,
              color: AppColor.primary,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Icon(
        Icons.add_photo_alternate_outlined,
        size: 40,
        color: AppColor.primary,
      ),
    );
  }
}