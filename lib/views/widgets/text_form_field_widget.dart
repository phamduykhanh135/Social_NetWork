import 'package:flutter/material.dart';

import 'colors.dart';
import 'custom_icons.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({
    this.backgroundColor = BackgroundColor.inputBackgroundColor,
    this.borderRadius,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 13,
    ),
    this.controller,
    this.errorText,
    this.hintText,
    this.hintTextColor = TextColor.hintTextColor,
    this.keyboardType,
    this.isPasswordField = false,
    super.key,
  });

  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;
  final Color? hintTextColor;
  final String? errorText;
  final bool isPasswordField;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();

    if (widget.isPasswordField) {
      _obscureText = true;
    } else {
      _obscureText = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: _obscureText,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                    contentPadding: widget.contentPadding,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: widget.hintTextColor,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              widget.isPasswordField
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: _obscureText
                          ? CustomIcons.show()
                          : CustomIcons.hide(),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.errorText ?? '',
            style: const TextStyle(color: TextColor.errorTextColor),
          ),
        ),
      ],
    );
  }
}
