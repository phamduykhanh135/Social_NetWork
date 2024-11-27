import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/texts.dart';
import 'package:network/data/services/auth_service.dart';
import 'package:network/views/widgets/custom_elevated_button.dart';
import 'package:network/views/widgets/text_form_field_widget.dart';
import 'package:network/views/widgets/validate_input.dart';
import '../widgets/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  late bool _isSendEmail;
  late String _emailErrorText;
  late String _passwordErrorText;
  late String _confirmErrorText;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmController;

  void _handleGoToSignIn() {
    context.go('/signin');
  }

  Future<void> _handleSignUp(BuildContext context) async {
    if (validateEmail(
              email: _emailController.text,
            ) ==
            '' &&
        validatePassword(
              password: _passwordController.text,
            ) ==
            '' &&
        validateConfirmPassword(
              password: _passwordController.text,
              confirmPassword: _confirmController.text,
            ) ==
            '') {
      AuthService authService = AuthService();

      setState(() {
        _isSendEmail = true;
      });
      await authService.signUpUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context,
      );
      setState(() {
        _isSendEmail = false;
      });
    } else {
      setState(() {
        _emailErrorText = validateEmail(email: _emailController.text);
        _passwordErrorText =
            validatePassword(password: _passwordController.text);
        _confirmErrorText = validateConfirmPassword(
          password: _passwordController.text,
          confirmPassword: _confirmController.text,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _isSendEmail = false;
    _emailErrorText = '';
    _passwordErrorText = '';
    _confirmErrorText = '';
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();

    _emailController.addListener(() {
      setState(() {
        _emailErrorText = validateEmail(email: _emailController.text);
      });
    });

    _passwordController.addListener(() {
      setState(() {
        _passwordErrorText =
            validatePassword(password: _passwordController.text);
      });
    });

    _confirmController.addListener(() {
      setState(() {
        _confirmErrorText = validateConfirmPassword(
          confirmPassword: _confirmController.text,
          password: _passwordController.text,
        );
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
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
                  ImagePaths.authHeaderPath,
                  fit: BoxFit.contain,
                  width: screenSize.width,
                ),
              ],
            ),
            Positioned.fill(
              top: screenSize.height / 3.5,
              child: Container(
                height: screenSize.height * 5 / 7,
                decoration: const BoxDecoration(
                  color: BackgroundColor.backgroundWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: _isSendEmail
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: _signUpFormKey,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: (screenSize.width - 315) / 2,
                            right: (screenSize.width - 315) / 2,
                            top: screenSize.height / 30,
                          ),
                          child: Column(
                            children: [
                              TextFormFieldWidget(
                                borderRadius: BorderRadius.circular(30),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                hintText: HintTexts.emailHint,
                                errorText: _emailErrorText,
                              ),
                              TextFormFieldWidget(
                                borderRadius: BorderRadius.circular(30),
                                isPasswordField: true,
                                controller: _passwordController,
                                hintText: HintTexts.passwordHint,
                                errorText: _passwordErrorText,
                              ),
                              TextFormFieldWidget(
                                borderRadius: BorderRadius.circular(30),
                                isPasswordField: true,
                                controller: _confirmController,
                                hintText: HintTexts.confirmPasswordHint,
                                errorText: _confirmErrorText,
                              ),
                              SizedBox(
                                height: screenSize.height / 30,
                              ),
                              CustomElevatedButton(
                                height: 52,
                                width: 315,
                                text: ButtonTexts.signUp,
                                onPressed: () {
                                  _handleSignUp(context);
                                },
                              ),
                              SizedBox(
                                height: screenSize.height / 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    DescriptionTexts.alreadyHaveAccount,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  SizedBox(
                                    child: ElevatedButton(
                                      onPressed: _handleGoToSignIn,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            BackgroundColor.backgroundWhite,
                                        padding: const EdgeInsets.all(0),
                                        shadowColor:
                                            ShadowColor.transparentShadow,
                                      ),
                                      child: const Text(
                                        ButtonTexts.signUp,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
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
