import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/texts.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_state.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_event.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_state.dart';
import 'package:network/views/widgets/user_profile_widget.dart/collection.dart';
import 'package:network/views/widgets/user_profile_widget.dart/header_user_profile.dart';
import 'package:network/views/widgets/user_profile_widget.dart/shots.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  String? userId = getUserId();
  @override
  void initState() {
    super.initState();

    //context.read<UserBloc>().add(CheckUserLoginEvent());
    context.read<PostBloc>().add(FetchPostUsers(userId!));
    context.read<TitleBloc>().add(FetchTitles(userId!));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.55,
                  flexibleSpace:
                      const FlexibleSpaceBar(background: HeaderUserProfile()),
                  pinned: true,
                  floating: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF1F1FE),
                        ),
                        tabs: [
                          Tab(
                            child: Container(
                              alignment: Alignment.center,
                              width: 300,
                              child: BlocBuilder<PostBloc, PostUserState>(
                                builder: (context, state) {
                                  int postCount = 0;
                                  if (state is PostUsersLoaded) {
                                    postCount =
                                        state.post.length; // Get the post count
                                  }
                                  return Text(
                                      '$postCount ${TitleTexts.shots}'); // Display count
                                },
                              ),
                            ),
                          ),
                          Tab(
                            child: Container(
                              alignment: Alignment.center,
                              width: 300,
                              child: BlocBuilder<TitleBloc, TitleState>(
                                  builder: (context, state) {
                                int collectionCount = 0;
                                if (state is TitlesLoaded) {
                                  collectionCount = state.titles.length;
                                }
                                return Text(
                                    '$collectionCount ${TitleTexts.collection}');
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: const TabBarView(
              children: [Shots(), Collections()],
            ),
          ),
        ),
      ),
    );
  }
}
