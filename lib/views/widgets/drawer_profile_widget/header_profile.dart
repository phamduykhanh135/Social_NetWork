import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/messages.dart';
import 'package:network/views/widgets/custom_icons.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_state.dart';

class HeaderProfile extends StatelessWidget {
  const HeaderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserError) {
          // Hiển thị thông báo lỗi, không dùng Scaffold ở đây
          return Center(child: Text(state.message));
        } else if (state is UserLoaded) {
          final user = state.user;
          return Container(
            margin: const EdgeInsets.fromLTRB(20, 50, 20, 35),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: user.avatarUrl.isNotEmpty
                        ? NetworkImage(user.avatarUrl)
                        : const AssetImage('assets/images/default_avatar.png'),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.45, // Giới hạn độ rộng của name
                            child: Text(
                              user.userName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                context.push('/edit_profile');
                              },
                              icon: CustomIcons.edit(size: 40)),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.6, // Giới hạn độ rộng của email
                        child: Text(
                          user.email,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text(Messages.noUsersAvailable));
      },
    );
  }
}
