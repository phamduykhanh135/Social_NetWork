import 'package:flutter/material.dart';

class NavBarItemWidget extends StatelessWidget {
  final Widget icon; // Icon thường
  final Widget iconGradient; // Icon gradient
  final int index;
  final int currentPageIndex;
  final ValueChanged<int> onTap;

  const NavBarItemWidget({
    super.key,
    required this.icon,
    required this.iconGradient,
    required this.index,
    required this.currentPageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width; // Lấy chiều rộng màn hình

    return InkWell(
      onTap: () => onTap(index), // Gọi callback khi nhấn vào item
      borderRadius: BorderRadius.circular(16.0), // Tạo hiệu ứng chạm tròn
      child: Container(
        constraints: BoxConstraints(
          minWidth: screenWidth /
              6, // Chia chiều rộng màn hình để tăng vùng chạm theo chiều ngang
          minHeight: 60, // Tăng vùng chạm theo chiều dọc
        ),
        alignment: Alignment.center, // Đảm bảo icon ở giữa
        child: currentPageIndex == index
            ? iconGradient // Hiển thị icon gradient khi được chọn
            : icon, // Hiển thị icon thường khi không được chọn
      ),
    );
  }
}
