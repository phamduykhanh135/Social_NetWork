import 'package:bloc/bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // Tab đầu tiên được chọn là Home

  void setPage(int pageIndex) {
    emit(pageIndex); // Phát sự kiện khi người dùng chọn tab
  }
}
