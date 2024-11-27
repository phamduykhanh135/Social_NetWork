// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:network/app/texts.dart';

class CustomCommentWidget extends StatefulWidget {
  final Function(String) onCommentSubmitted;

  const CustomCommentWidget({super.key, required this.onCommentSubmitted});

  @override
  _CustomCommentWidgetState createState() => _CustomCommentWidgetState();
}

class _CustomCommentWidgetState extends State<CustomCommentWidget> {
  late TextEditingController _commnentController;
  @override
  void initState() {
    _commnentController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _commnentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commnentController,
              decoration: const InputDecoration(
                hintText: HintTexts.enterCommenthHint,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_commnentController.text.isNotEmpty) {
                widget.onCommentSubmitted(_commnentController.text);
                _commnentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
