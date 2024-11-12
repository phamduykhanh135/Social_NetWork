import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch; // Callback function for search

  const SearchBarWidget({super.key, required this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode(); // FocusNode to control focus state

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose(); // Dispose of the FocusNode
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    widget.onSearch(query); // Trigger the callback with the search query
    _focusNode.unfocus(); // Dismiss the keyboard after searching
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus the TextField when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode, // Attach the FocusNode
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) => _performSearch(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _performSearch, // Perform search when icon is tapped
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
