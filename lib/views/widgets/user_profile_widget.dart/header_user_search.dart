// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/messages.dart';
import 'package:network/app/texts.dart';
import 'package:network/data/models/user_model.dart';
import 'package:network/data/services/user_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_event.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_event.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_event.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_state.dart';
import 'package:network/views/widgets/custom_clipper.dart';
import 'package:network/views/widgets/custom_elevated_button.dart';
import 'package:network/views/widgets/custom_icons.dart';

class HeaderUserSearch extends StatefulWidget {
  final String userId;
  const HeaderUserSearch({
    super.key,
    required this.userId,
  });

  @override
  State<HeaderUserSearch> createState() => _HeaderUserProfileState();
}

class _HeaderUserProfileState extends State<HeaderUserSearch> {
  final UserService _userService = UserService();

  String? getCurrentUserId = getUserId();

  Future<void> _toggleFollow(bool isFollowing) async {
    if (isFollowing) {
      await _userService.unfollowUser(getCurrentUserId!, widget.userId);
    } else {
      await _userService.followUser(getCurrentUserId!, widget.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else if (state is UserError) {
          return Scaffold(
            body: Center(
              child: SnackBar(content: Text(state.message)),
            ),
          );
        } else if (state is UserLoaded) {
          final user = state.user;
          return Stack(
            children: [
              ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagePaths.headerBackgroundPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    user.userName,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  onPressed: () {
                    context.pop();
                    String? userId = getUserId();
                    context.read<PostBloc>().add(FetchPostUsers(userId!));
                    context.read<TitleBloc>().add(FetchTitles(userId));
                    context.read<UserBloc>().add(FetchUserDataEvent(userId));
                  },
                  icon: CustomIcons.arrowLeft(),
                ),
              ),
              if (widget.userId != getCurrentUserId)
                Positioned(
                  top: 40,
                  right: 20,
                  child: StreamBuilder<bool>(
                    stream: _userService.isFollowingStream(
                        getCurrentUserId!, widget.userId),
                    builder: (context, snapshot) {
                      bool isFollowing = snapshot.data ?? false;
                      return CustomElevatedButton(
                        text: isFollowing
                            ? ButtonTexts.unfollow
                            : ButtonTexts.follow,
                        onPressed: () => _toggleFollow(isFollowing),
                        width: isFollowing ? 120 : 100,
                        gradientColors: isFollowing
                            ? [Colors.blue, Colors.blue]
                            : [Colors.white, Colors.white],
                        textColor: isFollowing ? Colors.white : Colors.blue,
                      );
                    },
                  ),
                ),
              Positioned(
                top: 110,
                left: MediaQuery.of(context).size.width / 2 -
                    50, // Căn giữa avatar
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 5),
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: user.avatarUrl.isNotEmpty
                        ? NetworkImage(user.avatarUrl)
                        : const AssetImage(ImagePaths.defaultAvatarPath),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.27), // Điều chỉnh để nội dung dưới avatar
                  Text(
                    user.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Da Nang, Vietnam',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),

                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: _userService.getUserStream(widget.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                              child: Text(Messages.noDataAvailable));
                        }

                        final user = UserModel.fromDocument(
                            snapshot.data!); // Chuyển đổi từ snapshot
                        return Container(
                          margin: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                          padding: const EdgeInsets.all(10),
                          color: const Color(0xFFF6F7F9),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${user.followersTotal}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 5),
                                      const Text(TitleTexts.followers),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${user.followingTotal}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 5),
                                      const Text(TitleTexts.following),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: CustomIcons.globe(),
                          onPressed: () {},
                        ),
                        CustomIcons.ellipse(size: 6),
                        IconButton(
                          icon: CustomIcons.instagram(),
                          onPressed: () {},
                        ),
                        CustomIcons.ellipse(size: 6),
                        IconButton(
                          icon: CustomIcons.facebook(),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const Scaffold(
            body: Center(child: Text(Messages.noUserDataAvailable)));
      },
    );
  }
}
