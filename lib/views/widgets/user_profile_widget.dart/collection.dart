import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/app/messages.dart';
import 'package:network/data/services/post_service.dart';
import 'package:network/utils/get_user_id.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_title/title_state.dart';
import 'package:network/views/widgets/user_profile_widget.dart/item_collection_user.dart';

class Collections extends StatefulWidget {
  const Collections({super.key});

  @override
  State<Collections> createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections>
    with AutomaticKeepAliveClientMixin {
  String? userId = getUserId();

  final PostService postService = PostService();
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TitleBloc, TitleState>(
      builder: (context, state) {
        if (state is TitlesLoading) {
          return Container();
        } else if (state is TitlesError) {
          return const Center(
            child: Text(Messages.errorOccurred),
          );
        } else if (state is TitlesLoaded) {
          final titles = state.titles;
          if (titles.isEmpty) {
            return Center(
                child: Image.asset(
              ImagePaths.noShotPath,
              width: 300,
              height: 300,
            ));
          }
          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
              ),
              itemCount: titles.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemCollectionUser(
                  title: titles[index].name,
                  titleId: titles[index].id!,
                );
              },
            ),
          );
        }
        return const Center(child: Text(Messages.noCollectionsAvailable));
      },
    );
  }
}
