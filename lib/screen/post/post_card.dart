import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  final String date;
  final bool isDraft;
  final Color? color;
  final String? imageUrl;

  final VoidCallback onEdit;
  final VoidCallback onUnpublish;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const PostCard({
    super.key,
    required this.title,
    required this.description,
    required this.author,
    required this.date,
    this.isDraft = false,
    this.color,
    this.imageUrl,
    required this.onEdit,
    required this.onUnpublish,
    required this.onDelete,
    this.onTap,
  });

  // =====================================================
  // BUILD
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              _buildThumbnail(),

              const SizedBox(width: 12),

              // TITLE + DESCRIPTION + AUTHOR
              Expanded(
                child: _buildContent(context),
              ),

              // 3 DOT MENU
              _buildMenuButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // IMAGE
  // =====================================================
  Widget _buildThumbnail() {
    const double size = 56.0;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _colorBox(size);
          },
        ),
      );
    }

    return _colorBox(size);
  }

  Widget _colorBox(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.article_outlined,
        color: Colors.white,
      ),
    );
  }

  // =====================================================
  // CONTENT
  // =====================================================
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // DRAFT LABEL
            if (isDraft) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Draft',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 4),

        Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          '$author · $date',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // =====================================================
  // THREE-DOT MENU
  // =====================================================
  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      onSelected: (String value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;

          case 'publish':
            onUnpublish();
            break;

          case 'delete':
            onDelete();
            break;
        }
      },

      itemBuilder: (context) => [
        // EDIT
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 20,
              ),
              SizedBox(width: 10),
              Text('Edit'),
            ],
          ),
        ),

        // PUBLISH / UNPUBLISH
        PopupMenuItem<String>(
          value: 'publish',
          child: Row(
            children: [
              Icon(
                isDraft
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                isDraft
                    ? 'Publish'
                    : 'Unpublish',
              ),
            ],
          ),
        ),

        // DELETE
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline,
                size: 20,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}