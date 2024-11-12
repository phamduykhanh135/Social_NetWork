import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:network/data/models/user_model.dart';

class SearchResults extends StatelessWidget {
  final List<UserModel> users;

  const SearchResults({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Column(
      // Thay ListView bằng Column
      children: [
        for (var user in users)
          ListTile(
            title: Text(user.userName),
            subtitle: Text(user.fullName),
            onTap: () {
              context.push('/user_search/${user.id}');
            },
          ),
      ],
    );
  }
}
