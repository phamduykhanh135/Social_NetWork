import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const PostImage({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 4 / 3, // Tỷ lệ 1:1 để hiển thị hình ảnh vuông
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
