import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:network/app/image_paths.dart';
import 'package:network/viewmodels/blocs/bloc_search/search_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_search/search_state.dart';
import 'package:network/views/widgets/custom_icons.dart';
import 'package:network/views/widgets/search_widget/custom_search.dart';
import 'package:network/views/widgets/search_widget/search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: CustomIcons.arrowBack(size: 30)),
        title: const CustomSearch(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is UsersFound) {
                      return SearchResults(users: state.users);
                    } else if (state is UserError) {
                      return Text(state.error);
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                // const ListCategory(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListCategory extends StatelessWidget {
  const ListCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ItemCategory(
          nameText: 'PHOTOGRAPHY',
          imageCategory: ImagePaths.categoryPhotographyPath,
        ),
        ItemCategory(
          nameText: 'ILLUSTRATION',
          imageCategory: ImagePaths.categoryIllustrationPath,
          isLeftAligned: false,
        ),
        ItemCategory(
          nameText: 'DESIGN ',
          imageCategory: ImagePaths.categoryDesignPath,
        ),
        ItemCategory(
          nameText: 'MAKING VIDEO',
          imageCategory: ImagePaths.categoryMakingVideoPath,
          isLeftAligned: false,
        )
      ],
    );
  }
}

class ItemCategory extends StatelessWidget {
  final bool isLeftAligned; // Flag to determine left or right alignment
  final String imageCategory;
  final String nameText;
  const ItemCategory({
    super.key,
    this.isLeftAligned = true,
    required this.imageCategory,
    required this.nameText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageCategory,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                ImagePaths.headerBackgroundPath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment:
                isLeftAligned ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                nameText,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
