import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_search/search_bloc.dart';
import 'package:network/viewmodels/blocs/bloc_search/search_event.dart';
import 'package:network/views/widgets/custom_icons.dart';

class CustomSearch extends StatefulWidget {
  const CustomSearch({super.key});

  @override
  State<CustomSearch> createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  late TextEditingController _searchController;
  Timer? _debounce; // Declare a Timer for debounce functionality

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel(); // Cancel the Timer when the widget is disposed
    super.dispose();
  }

  // This function is called whenever the text input changes
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false)
      _debounce?.cancel(); // Cancel the previous timer

    // Start a new timer
    _debounce = Timer(const Duration(seconds: 2), () {
      // Add the event to your bloc or logic to trigger the search

      context.read<SearchBloc>().add(SearchFollowers(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              prefixIcon: Transform.scale(
                scale: 0.5,
                child: CustomIcons.searchBlue(),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              fillColor: Colors.grey[200],
              filled: true,
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        Material(
          color: Colors.grey[200],
          shape: const CircleBorder(),
          child: IconButton(
            icon: CustomIcons.send(),
            iconSize: 24,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
            onPressed: () {
              context
                  .read<SearchBloc>()
                  .add(SearchAll(_searchController.text.trim()));
            },
          ),
        ),
      ],
    );
  }
}
