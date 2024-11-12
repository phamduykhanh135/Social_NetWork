import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/views/widgets/show_snackbar.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_event.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_state.dart';
import 'package:uuid/uuid.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final PostService _postService = PostService();
  late TextEditingController _titleController;

  bool _isLoading = false;
  Uint8List? _imageBytes;
  var uuid = const Uuid();

  @override
  void initState() {
    _titleController = TextEditingController();
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(imageBytes);
      });
    }
  }

  List<String> _extractHashtags(String text) {
    final hashtagRegExp = RegExp(r'\B#\w\w+');
    final matches = hashtagRegExp.allMatches(text);
    return matches.map((match) => match.group(0)!).toList();
  }

  Future<void> _createPost() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final hashtags = _extractHashtags(_titleController.text);

      final newPost = await _postService.createPost(
        imageBytes: _imageBytes!,
        description: _titleController.text.trim(),
        hashtag: hashtags.join(' '),
      );

      if (mounted) {
        context.read<PostBloc>().add(AddPostUser(newPost));
        showSnackBar(context, message: Messages.postedSuccessfully);

        setState(() {
          _isLoading = false;
          _titleController.clear();
          _imageBytes = null;
        });

        context.pop();
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, message: Messages.errorAddingPost);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _isPostReady() {
    return _titleController.text.isNotEmpty &&
        _imageBytes != null &&
        !_isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) {
          showSnackBar(context, message: Messages.postCreationInProgress);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    color: Colors.grey.withOpacity(0.3),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                if (_isLoading) {
                                  showSnackBar(context,
                                      message: Messages.postCreationInProgress);
                                } else {
                                  context.pop();
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Tạo bài viết',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    backgroundColor: _isPostReady()
                                        ? Colors.white
                                        : Colors.grey.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed:
                                      _isPostReady() ? _createPost : null,
                                  child: const Text(
                                    'Đăng bài',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserLoading) {
                            return const Center();
                          } else if (state is UserLoaded) {
                            final user = state.user;
                            return Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(user.avatarUrl),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: Text(
                                        user.userName,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                          }
                          return const Center(
                            child: Text(Messages.noDataFound),
                          );
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            labelText: "Tiêu đề ?",
                            labelStyle: TextStyle(color: Colors.grey)),
                        controller: _titleController,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: SizedBox(
                          height: 200,
                          child: _imageBytes == null
                              ? const Center(
                                  child: Text(
                                  'Chọn ảnh',
                                  style: TextStyle(color: Colors.grey),
                                ))
                              : Image.memory(_imageBytes!, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Hiển thị AddPostScreen với hiệu ứng hoạt ảnh
void showAddPostScreen(BuildContext context) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AddPostScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Bắt đầu từ dưới
        const end = Offset.zero; // Đến vị trí cuối cùng
        const curve = Curves.easeInOut; // Đường cong hiệu ứng

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration:
          const Duration(milliseconds: 300), // Thời gian chuyển tiếp
    ),
  );
}
