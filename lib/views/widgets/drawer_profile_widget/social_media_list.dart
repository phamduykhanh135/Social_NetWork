import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/texts.dart';
import 'package:network/data/services/auth_service.dart';
import 'package:network/views/widgets/custom_icons.dart';

class SocialMediaList extends StatelessWidget {
  const SocialMediaList({super.key});

  void _handleSignOut(BuildContext context) async {
    AuthService authService = AuthService();

    await authService.signOutUser(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            TitleButton(
              text: ButtonTexts.email,
              onPressed: () {},
            ),
            TitleButton(
              text: ButtonTexts.instagram,
              onPressed: () {},
            ),
            TitleButton(
              text: ButtonTexts.twitter,
              onPressed: () {},
            ),
            TitleButton(
              text: ButtonTexts.website,
              onPressed: () {},
            ),
            TitleButton(
              text: ButtonTexts.paypal,
              onPressed: () {},
            ),
            TitleButton(
              text: ButtonTexts.changePasword,
              onPressed: () {
                context.push('/change_password');
              },
            ),
            TitleButton(
              text: ButtonTexts.aboutICLick,
              onPressed: () {},
            ),
            TitleButton(
              text: ButtonTexts.termAndPrivacy,
              onPressed: () {},
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 150),
              width: 140,
              height: 40,
              child: Transform.translate(
                offset: const Offset(-40, 0),
                child: ElevatedButton(
                  onPressed: () {
                    _handleSignOut(context);
                  },
                  child: Row(
                    children: [
                      CustomIcons.logOut(),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text(ButtonTexts.logOut),
                    ],
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

class TitleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const TitleButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 270,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              color: Colors.white.withOpacity(0.2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: IconButton(
                      onPressed: onPressed,
                      icon: CustomIcons.arrowRight(size: 15)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
