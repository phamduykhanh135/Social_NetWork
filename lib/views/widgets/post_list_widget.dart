// import 'package:flutter/material.dart';
// import 'package:network/data/models/social_post_model.dart';
// import 'package:network/views/screens/detail_post_screen.dart';
// import 'package:network/views/widgets/widget_post/postcard_widget.dart';

// class PostListWidget extends StatefulWidget {
//   final List<SocialPost> posts;
//   final Future<void> Function()? onRefresh; // Add refresh callback

//   const PostListWidget({
//     super.key,
//     required this.posts,
//     this.onRefresh, // Optional refresh callback
//   });

//   @override
//   State<PostListWidget> createState() => _PostListWidgetState();
// }

// class _PostListWidgetState extends State<PostListWidget>
//     with AutomaticKeepAliveClientMixin {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     if (widget.posts.isEmpty) {
//       return const Center(child: Text('No posts available.'));
//     }

//     // Use a NotificationListener to manage the scroll state
//     return NotificationListener<ScrollNotification>(
//       onNotification: (notification) {
//         // Prevent refresh if the list is still scrolling or animating
//         if (_scrollController.position.isScrollingNotifier.value) {
//           return false; // Ignore refresh if scrolling
//         }
//         return true;
//       },
//       child: RefreshIndicator(
//         onRefresh: widget.onRefresh ??
//             () async {
//               // Default empty callback if no refresh function is provided
//             },
//         child: ListView.builder(
//           controller: _scrollController,
//           itemCount: widget.posts.length,
//           itemBuilder: (context, index) {
//             final post = widget.posts[index];
//             final userId = post.userId;

//             return GestureDetector(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => DetailPostScreen(
//                       postId: post.id,
//                       userId: userId,
//                       likes: post.likes,
//                     ),
//                   ),
//                 );
//               },
//               child: PostCard(
//                 postId: post.id,
//                 onImageTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => DetailPostScreen(
//                         postId: post.id,
//                         userId: userId,
//                         likes: post.likes,
//                       ),
//                     ),
//                   );
//                 },
//                 userId: userId,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
