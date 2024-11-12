import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_event.dart';
import 'package:network/viewmodels/blocs/bloc_post_user/post_user_state.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_event.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_state.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_user/user_event.dart';
import 'package:network/views/widgets/user_profile_widget.dart/collection.dart';
import 'package:network/views/widgets/user_profile_widget.dart/header_user_search.dart';
import 'package:network/views/widgets/user_profile_widget.dart/shots.dart';

import '../../viewmodels/blocs/bloc_title/title_bloc.dart';

class UserSearchScreen extends StatefulWidget {
  final String uid;

  const UserSearchScreen({super.key, required this.uid});

  @override
  State<UserSearchScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<UserSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? userId = getUserId();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<PostBloc>().add(FetchPostUsers(widget.uid));
    context.read<TitleBloc>().add(FetchTitles(widget.uid));
    context.read<UserBloc>().add(FetchUserDataEvent(widget.uid));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<PostBloc>().add(FetchPostUsers(userId!));
        context.read<TitleBloc>().add(FetchTitles(userId!));
        context.read<UserBloc>().add(FetchUserDataEvent(userId!));

        // Quay lại trang trước
        return true;
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: MediaQuery.of(context).size.height * 0.50,
                centerTitle: true,
                pinned: false,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                    background: HeaderUserSearch(
                  userId: widget.uid,
                )),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFF1F1FE),
                    ),
                    controller: _tabController,
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
                              return Text('$postCount Shots'); // Display count
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
                            return Text('$collectionCount Collections');
                          }),
                        ),
                      ),
                    ]),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [Shots(), Collections()],
          ),
        ),
      ),
    );
  }
}
