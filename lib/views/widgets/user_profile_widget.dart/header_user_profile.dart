import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/messages.dart';
import 'package:network/views/widgets/custom_icons.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_state.dart';
import 'package:network/views/widgets/custom_clipper.dart';

class HeaderUserProfile extends StatefulWidget {
  const HeaderUserProfile({super.key});

  @override
  State<HeaderUserProfile> createState() => _HeaderUserProfileState();
}

class _HeaderUserProfileState extends State<HeaderUserProfile> {
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
                      image: AssetImage(
                        ImagePaths.headerBackgroundPath,
                      ),
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
                right: 20,
                child: IconButton(
                  onPressed: () {},
                  icon: CustomIcons.settingWhite(),
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
                        : const AssetImage(
                            ImagePaths.defaultAvatarPath,
                          ),
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

                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 25, 10, 10),
                    padding: const EdgeInsets.all(10),
                    color: const Color(0xFFF6F7F9),
                    child: const Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('220',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 5),
                                Text('Followers'),
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
                                Text('150',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 5),
                                Text('Following'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
            body: Center(child: Text(Messages.noUsersAvailable)));
      },
    );
  }
}