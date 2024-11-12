import 'package:flutter/material.dart';
import 'package:network/app/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final double fontSize;
  final List<Color> gradientColors;
  final Color textColor;
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 350,
    this.height = 50,
    this.fontSize = 16,
    this.textColor = Colors.white,
    this.gradientColors = const [
      AppColor.primaryDark,
      AppColor.primaryLight,
    ], // Sử dụng List<Color> thay cho Color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Sửa BackgroundColor thành Colors
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}

// class CustomElevatedButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed; // Cho phép null
//   final double width;
//   final double height;
//   final double fontSize;

//   const CustomElevatedButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.width = 350,
//     this.height = 50,
//     this.fontSize = 16,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: height,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColor.primaryDark,
//             AppColor.primaryLight,
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.all(Radius.circular(30)),
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: BackgroundColor.transparentBackground,
//           elevation: 0,
//         ),
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(
//             color: TextColor.textWhite,
//             fontSize: fontSize,
//           ),
//         ),
//       ),
//     );
//   }
// }
