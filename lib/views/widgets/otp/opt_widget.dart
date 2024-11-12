import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptWidget extends StatelessWidget {
  const OptWidget({
    super.key,
    required this.otpController,
  });

  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200], // Màu nền của vòng tròn
        ),
        child: TextFormField(
          controller: otpController,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty) {
              FocusScope.of(context).previousFocus();
            }
          },
          decoration: const InputDecoration(
            hintText: '0', // Hiện '0' như là hint text
            hintStyle: TextStyle(
              color: Colors.grey, // Màu chữ hiển thị '0'
              fontSize: 24, // Kích thước chữ
            ),
            border: InputBorder.none, // Không viền
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0), // Padding bên trong
            isDense: true, // Để giảm khoảng cách bên trong
          ),
          // onTap: () {
          //   if (otpController.text == '0') {
          //     otpController.clear(); // Xóa số '0' khi chạm vào
          //   }
          // },
          // onEditingComplete: () {
          //   if (otpController.text.isEmpty) {
          //     otpController.text =
          //         '0'; // Gán lại '0' nếu trường trống khi mất focus
          //   }
          // },
        ),
      ),
    );
  }
}
