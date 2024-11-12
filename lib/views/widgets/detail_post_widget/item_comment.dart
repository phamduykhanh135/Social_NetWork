// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:network/utils/time_util.dart';
import 'package:network/views/widgets/custom_icons.dart';

class ItemComment extends StatelessWidget {
  final String imageUser;
  final String message;
  final String nameUser;
  final DateTime createdAt;

  const ItemComment({
    super.key,
    required this.imageUser,
    required this.message,
    required this.nameUser,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(imageUser),
            ),
            title: Text(
              nameUser,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(message),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      DateTimeUtils.timeAgo(createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Like',
                          style: TextStyle(fontSize: 13),
                        ))
                  ],
                ),
                Row(
                  children: [
                    const Text('4'),
                    IconButton(onPressed: () {}, icon: CustomIcons.heartBlue())
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
