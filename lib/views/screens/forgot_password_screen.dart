import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:network/app/colors.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/messages.dart';
import 'package:network/app/texts.dart';
import 'package:network/views/widgets/custom_elevated_button.dart';
import 'package:network/views/widgets/show_snackbar.dart';
import 'package:network/views/widgets/text_form_field_widget.dart';
import 'package:network/views/widgets/validate_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();

  late bool _isSendEmail;
  late String _emailErrorText;
  late TextEditingController _emailController;

  void _handleSendEmail(BuildContext context) async {
    if (validateEmail(email: _emailController.text) == '') {
      try {
        setState(() {
          _isSendEmail = true;
        });

        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
      } catch (e) {
        setState(() {
          _isSendEmail = false;
        });

        if (context.mounted) {
          showSnackBar(
            context,
            message: Messages.somethingWrong,
          );
        }
      }
    } else {
      setState(() {
        _emailErrorText = validateEmail(email: _emailController.text);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _isSendEmail = false;

    _emailErrorText = '';

    _emailController = TextEditingController();

    _emailController.addListener(() {
      setState(() {
        _emailErrorText = validateEmail(email: _emailController.text);
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                child: _isSendEmail
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Form(
                        key: _forgotPasswordFormKey,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: (screenSize.width - 343) / 2,
                            right: (screenSize.width - 343) / 2,
                            top: 24,
                          ),
                          child: Column(
                            children: [
                              const Text(
                                TitleTexts.forgotPasswordTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primaryLight,
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: BackgroundColor.descriptionBackground,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  DescriptionTexts.sendLinkReset,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height / 30,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: Column(
                                    children: [
                                      TextFormFieldWidget(
                                        borderRadius: BorderRadius.circular(30),
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        hintText: HintTexts.emailHint,
                                        errorText: _emailErrorText,
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: screenSize.height / 7,
                              ),
                              CustomElevatedButton(
                                height: 52,
                                width: 315,
                                text: ButtonTexts.send,
                                onPressed: () {
                                  _handleSendEmail(context);
                                },
                              ),
                              SizedBox(
                                height: screenSize.height / 10,
                              ),
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
