import 'package:flutter/material.dart';

class CustomTextFormFiel extends StatelessWidget {
  final String textName;
  final String lableText;

  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomTextFormFiel(
      {super.key,
      required this.textName,
      required this.controller,
      this.validator,
      required this.lableText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              textName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
                labelText: lableText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none)),
            keyboardType: TextInputType.emailAddress,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
