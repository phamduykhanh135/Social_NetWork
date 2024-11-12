import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/models/titlle_model.dart';
import 'package:network/views/widgets/show_snackbar.dart';

import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_event.dart';

class TitleService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? userId = getUserId();

  Future<List<TitleModel>> fetchTitles(String userId) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('collection_user')
          .doc(userId)
          .collection('titles')
          .get();

      List<TitleModel> titles =
          snapshot.docs.map((doc) => TitleModel.fromDocument(doc)).toList();
      return titles;
    } catch (e) {
      throw Exception(Messages.errorLoadingCollection);
    }
  }

  Future<void> addTitle(TitleModel title, BuildContext context) async {
    try {
      // Firestore tự động tạo ID cho mỗi document
      await firestore
          .collection('collection_user')
          .doc(userId)
          .collection('titles')
          .add({
        'name': title.name,
        'post': [],
        'totalPosts': 0,
      });

      final titleBloc = context.read<TitleBloc>();
      titleBloc.add(AddTitle(title));

      showSnackBar(context, message: Messages.successAddingTitle);
    } catch (e) {
      // Hiển thị thông báo lỗi nếu có sự cố
      showSnackBar(context, message: Messages.errorAddingCollection);
      throw Exception(Messages.errorAddingCollection);
    }
  }

  Future<void> addPostToCollection({
    required String titleId,
    required String postId,
    required BuildContext context,
  }) async {
    try {
      // Tham chiếu tới tài liệu của title
      final titleDocRef = FirebaseFirestore.instance
          .collection('collection_user')
          .doc(userId)
          .collection('titles')
          .doc(titleId);

      // Lấy dữ liệu của title để kiểm tra mảng post
      final snapshot = await titleDocRef.get();
      List<String> postList = List<String>.from(snapshot['post'] ?? []);

      // Kiểm tra xem idPost đã tồn tại trong mảng chưa
      if (!postList.contains(postId)) {
        postList.add(postId);
        await titleDocRef.update({'post': postList});

        // Hiển thị thông báo thành công
        showSnackBar(context, message: Messages.successSavedToCollection);
      } else {
        // Hiển thị thông báo nếu post đã tồn tại
        showSnackBar(context,
            message: Messages.errorPostAlreadyExistsInCollection);
      }
    } catch (e) {
      showSnackBar(context, message: Messages.errorSavingToCollection);
    }
  }
}
