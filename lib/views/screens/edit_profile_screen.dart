import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/messages.dart';
import 'package:network/app/texts.dart';
import 'package:network/views/widgets/show_snackbar.dart';
import 'package:network/views/widgets/custom_elevated_button.dart';
import 'package:network/views/widgets/custom_icons.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/views/widgets/validate_input.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_state.dart';
import 'package:network/views/widgets/custom_clipper.dart';
import 'package:network/views/widgets/custom_text_form_fiel.dart';

import '../../data/services/image_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ImageService imageStorageService = ImageService();
  final ImagePicker _picker = ImagePicker();
  String? _avatarUrl;
  final _formKey = GlobalKey<FormState>();
  late UserService userService;
  late TextEditingController _nameController;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  bool isInitialized = false; // Biến kiểm tra khởi tạo
  Uint8List? _imageBytes;
  bool _isLoading = false;

  @override
  void initState() {
    userService = UserService();
    _nameController = TextEditingController();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarUrl = pickedFile.path;
        _imageBytes = File(pickedFile.path).readAsBytesSync();
      });
    }
  }

  Future<void> _editUser() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      String imageURL;

      if (_imageBytes != null) {
        imageURL = await imageStorageService.uploadImageUser(_imageBytes!);
      } else {
        imageURL = _avatarUrl ?? '';
      }
      String finalImageUrl = imageURL.isEmpty ? '' : imageURL;
      await userService.editUser(
        finalImageUrl,
        _emailController.text.trim(),
        _nameController.text.trim(),
        _fullNameController.text.trim(),
        context,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isLoading) {
          showSnackBar(context, message: Messages.profileUpdateInProgress);
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
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return Container();
                } else if (state is UserError) {
                  return Center(child: Text(state.message));
                } else if (state is UserLoaded) {
                  final user = state.user;
                  if (!isInitialized) {
                    _nameController.text = user.userName;
                    _emailController.text = user.email;
                    _fullNameController.text = user.fullName;
                    _avatarUrl = user.avatarUrl;

                    isInitialized = true; // Đánh dấu đã khởi tạo
                  }
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Stack(
                          children: [
                            ClipPath(
                              clipper: MyCustomClipper(),
                              child: Container(
                                height: 200,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        ImagePaths.headerBackgroundPath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                child: IconButton(
                                  onPressed: () {
                                    if (_isLoading) {
                                      showSnackBar(context,
                                          message:
                                              Messages.profileUpdateInProgress);
                                    } else {
                                      context.pop();
                                    }
                                  },
                                  icon: CustomIcons.arrowLeft(),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: const Text(
                                  TitleTexts.editProfileTitle,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 5),
                                    ),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: _imageBytes != null
                                          ? Image.memory(_imageBytes!).image
                                          : (user.avatarUrl.isNotEmpty
                                                  ? NetworkImage(user.avatarUrl)
                                                  : const AssetImage(ImagePaths
                                                      .defaultAvatarPath))
                                              as ImageProvider,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 160,
                              right: 130,
                              child: IconButton(
                                icon: CustomIcons.cameraBlue(size: 30),
                                onPressed: _pickImage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFormFiel(
                                  textName: TitleTexts.nameTitle,
                                  controller: _nameController,
                                  lableText: HintTexts.enterYourNameHint,
                                  validator: Validators.validateName),
                              CustomTextFormFiel(
                                textName: TitleTexts.fullnameTitle,
                                controller: _fullNameController,
                                lableText: HintTexts.enterYourFullnameHint,
                                validator: Validators.validateName,
                              ),
                              CustomTextFormFiel(
                                textName: TitleTexts.emailTitle,
                                controller: _emailController,
                                lableText: HintTexts.enterYourEmailHint,
                                validator: Validators.validateEmail,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              Opacity(
                                opacity: _isLoading ? 0.5 : 1.0,
                                child: CustomElevatedButton(
                                  text: ButtonTexts.saveChange,
                                  onPressed: _isLoading
                                      ? () {}
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _editUser();
                                          }
                                        },
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: Text(Messages.noUserDataAvailable));
              },
            ),
          ),
        ),
      ),
    );
  }
}
