import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/views/widgets/custom_icons.dart';
import 'package:network/views/widgets/home_widget/post_list_following.dart';
import 'package:network/views/widgets/home_widget/post_list_populer.dart';
import 'package:network/views/widgets/home_widget/post_list_trending.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                              child: Search(),
                            ),
                            IconButton(
                                onPressed: () {}, icon: CustomIcons.chatBlue()),
                          ],
                        ),
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.15,
                        pinned: true,
                        floating: true,
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(50),
                          child: Container(
                            color: Colors.white,
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFF1F1FE),
                              ),
                              tabs: const [
                                SizedBox(
                                    width: 200, child: Tab(text: 'Popular')),
                                SizedBox(
                                    width: 200, child: Tab(text: 'Trending')),
                                SizedBox(
                                    width: 200, child: Tab(text: 'Following')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: const TabBarView(children: [
                    PostListPopular(),
                    PostListTrending(),
                    PostListFollowing(),
                  ])),
            )));
  }
}

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/search');
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            CustomIcons.searchBlue(),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Search',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
