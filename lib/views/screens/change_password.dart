import 'package:flutter/material.dart';
import 'package:network/app/colors.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/texts.dart';
import 'package:network/data/services/auth_service.dart';
import 'package:network/views/widgets/custom_elevated_button.dart';
import 'package:network/views/widgets/text_form_field_widget.dart';
import 'package:network/views/widgets/validate_input.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _currentpasswordErrorText;
  late String _newPasswordErrorText;
  late String _confirmErrorText;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmController;
  final AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _currentpasswordErrorText = '';
    _newPasswordErrorText = '';
    _confirmErrorText = '';
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmController = TextEditingController();

    _currentPasswordController.addListener(() {
      setState(() {
        _currentpasswordErrorText =
            validatePassword(password: _currentPasswordController.text);
      });
    });

    _newPasswordController.addListener(() {
      setState(() {
        _newPasswordErrorText =
            validatePassword(password: _newPasswordController.text);
      });
    });

    _confirmController.addListener(() {
      setState(() {
        _confirmErrorText = validateConfirmPassword(
          password: _newPasswordController.text,
          confirmPassword: _confirmController.text,
        );
      });
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _changePassword(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (validatePassword(
                password: _currentPasswordController.text,
              ) ==
              '' &&
          validatePassword(
                password: _newPasswordController.text,
              ) ==
              '' &&
          validateConfirmPassword(
                password: _newPasswordController.text,
                confirmPassword: _confirmController.text,
              ) ==
              '') {
        await _authService.changePassword(
          context: context,
          currentPassword: _currentPasswordController.text.trim(),
          newPassword: _newPasswordController.text.trim(),
        );

        clearTextFields();
      } else {
        setState(() {
          _currentpasswordErrorText =
              validatePassword(password: _currentPasswordController.text);
          _newPasswordErrorText =
              validatePassword(password: _newPasswordController.text);
          _confirmErrorText = validateConfirmPassword(
            password: _newPasswordController.text,
            confirmPassword: _confirmController.text,
          );
        });
      }
    }
  }

  void clearTextFields() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  ImagePaths.verifyHeaderPath,
                  fit: BoxFit.contain,
                  width: screenSize.width,
                ),
              ],
            ),
            Positioned.fill(
              top: screenSize.height / 5,
              child: Container(
                height: screenSize.height * 4 / 5,
                decoration: const BoxDecoration(
                  color: BackgroundColor.backgroundWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (screenSize.width - 343) / 2),
                    child: Column(
                      children: [
                        const Text(
                          TitleTexts.setNewPasswordTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryLight,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                            color: BackgroundColor.descriptionBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            DescriptionTexts.typeNewPassword,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          ),
                        ),
                        SizedBox(height: screenSize.height / 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Column(
                            children: [
                              TextFormFieldWidget(
                                borderRadius: BorderRadius.circular(30),
                                isPasswordField: true,
                                controller: _currentPasswordController,
                                hintText: "Mật khẩu hiện tại",
                                errorText: _currentpasswordErrorText,
                              ),
                              TextFormFieldWidget(
                                borderRadius: BorderRadius.circular(30),
                                isPasswordField: true,
                                controller: _newPasswordController,
                                hintText: "Mật khẩu mới",
                                errorText: _newPasswordErrorText,
                              ),
                              TextFormFieldWidget(
                                borderRadius: BorderRadius.circular(30),
                                isPasswordField: true,
                                controller: _confirmController,
                                hintText: "Xác nhận mật khẩu",
                                errorText: _confirmErrorText,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenSize.height / 30),
                        CustomElevatedButton(
                          height: 52,
                          width: 315,
                          text: "Đổi mật khẩu",
                          onPressed: () {
                            _changePassword(context);
                          },
                        ),
                        SizedBox(height: screenSize.height / 10),
                        Image.asset(
                          ImagePaths.verifyFooterPath,
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
