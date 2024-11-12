import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:network/app/colors.dart';
import 'package:network/app/texts.dart';
import 'package:network/data/services/auth_service.dart';
import 'package:network/views/widgets/custom_elevated_button.dart';
import 'package:network/views/widgets/custom_icons.dart';
import 'package:network/views/widgets/text_form_field_widget.dart';
import 'package:network/views/widgets/validate_input.dart';

import '../../app/image_paths.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  late bool _isSubmitSignIn;
  late String _emailErrorText;
  late String _passwordErrorText;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  void _handleGoToSignUp() {
    context.push('/signup');
  }

  void _handleSignIn(BuildContext context) async {
    if (validateEmail(email: _emailController.text) == '' &&
        validatePassword(password: _passwordController.text) == '') {
      setState(() {
        _isSubmitSignIn = true;
      });
      await _authService.signInUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context,
      );
      setState(() {
        _isSubmitSignIn = false;
      });
    } else {
      setState(() {
        _emailErrorText = validateEmail(email: _emailController.text);
        _passwordErrorText =
            validatePassword(password: _passwordController.text);
      });
    }
  }

  void _handleSignInWithGoogle(BuildContext context) async {
    setState(() {
      _isSubmitSignIn = true;
    });

    User? user = await _authService.signInWithGoogle(context: context);

    if (user == null) {
      setState(() {
        _isSubmitSignIn = false;
      });
    } else {
      if (context.mounted) {
        if (user.metadata.creationTime == user.metadata.lastSignInTime) {
          context.go('/select_category');
        } else {
          context.go('/home');
        }
      }
    }
  }

  void _handleGoToForgotPassword() {
    context.push('/forgot_password');
  }

  @override
  void initState() {
    super.initState();

    _isSubmitSignIn = false;
    _emailErrorText = '';
    _passwordErrorText = '';
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

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
    // _checkIfUserIsAuthenticated();
  }

  // void _checkIfUserIsAuthenticated() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null && user.emailVerified) {

  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       context.push('/home');
  //     });
  //   }
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                child: _isSubmitSignIn
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: _signInFormKey,
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
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.height / 30,
                                ),
                                child: SizedBox(
                                  height: 20,
                                  child: ElevatedButton(
                                    onPressed: _handleGoToForgotPassword,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          BackgroundColor.backgroundWhite,
                                      padding: const EdgeInsets.all(0),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      ButtonTexts.forgotPassword,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              CustomElevatedButton(
                                height: 52,
                                width: 315,
                                text: ButtonTexts.logIn,
                                onPressed: () {
                                  _handleSignIn(context);
                                },
                              ),
                              SizedBox(
                                height: screenSize.height / 30,
                              ),
                              const Text(
                                DescriptionTexts.orLogInBy,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _handleSignInWithGoogle(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        BackgroundColor.googleSignInBackground,
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  child: CustomIcons.google(),
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height / 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    DescriptionTexts.dontHaveAccount,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  SizedBox(
                                    child: ElevatedButton(
                                      onPressed: _handleGoToSignUp,
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
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
