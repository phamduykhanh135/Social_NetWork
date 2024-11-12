import 'package:flutter/material.dart';

class PostDescription extends StatelessWidget {
  final String description;

  const PostDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        description,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
