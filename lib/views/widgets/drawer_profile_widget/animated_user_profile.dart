import 'package:flutter/material.dart';
import 'package:network/views/screens/user_profile_screen.dart';

class AnimatedPositionedWidget extends StatelessWidget {
  final AnimationController drawerController;
  final Animation<double> scaleAnimation;
  final Animation<Offset> translateAnimation;
  final bool isDrawerOpen;
  final bool isShadow;
  final Function onHorizontalDragStart;
  final Function onHorizontalDragUpdate;
  final Function onTapBody;

  const AnimatedPositionedWidget({
    super.key,
    required this.drawerController,
    required this.scaleAnimation,
    required this.translateAnimation,
    required this.isDrawerOpen,
    required this.isShadow,
    required this.onHorizontalDragStart,
    required this.onHorizontalDragUpdate,
    required this.onTapBody,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: isDrawerOpen ? 20 : 0,
      child: GestureDetector(
        onHorizontalDragStart: (details) => onHorizontalDragStart(details),
        onHorizontalDragUpdate: (details) => onHorizontalDragUpdate(details),
        onTap: () => onTapBody(),
        child: AnimatedBuilder(
          animation: drawerController,
          builder: (context, child) {
            return Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: translateAnimation.value *
                    (isShadow
                        ? (MediaQuery.of(context).size.width - 70)
                        : MediaQuery.of(context).size.width),
                child: Transform.scale(
                  scale: scaleAnimation.value + (isShadow ? -0.05 : 0.0),
                  child: Opacity(
                    opacity: isShadow ? 0.5 : 1.0, // Điều chỉnh độ mờ
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          color: isShadow
                              ? Colors.black.withOpacity(0.7)
                              : Colors.white,
                        ),
                        child:
                            isShadow ? Container() : const UserProfileScreen(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
