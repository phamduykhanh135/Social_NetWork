import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopicViewMoreScreen extends StatefulWidget {
  const TopicViewMoreScreen({super.key});

  @override
  State<TopicViewMoreScreen> createState() => _TopicViewMoreScreenState();
}

class _TopicViewMoreScreenState extends State<TopicViewMoreScreen> {
  List<Map<String, dynamic>> allTopics = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAllTopics();
  }

  Future<void> fetchAllTopics() async {
    setState(() {
      isLoading = true;
    });

    // Fetch all topics from Firestore (replace 'topic' with your actual collection name)
    final snapshot = await FirebaseFirestore.instance.collection('topic').get();
    setState(() {
      allTopics = snapshot.docs.map((doc) => doc.data()).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Topics'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: allTopics.length,
              itemBuilder: (context, index) {
                return TopicCard(
                  title: allTopics[index]['name'],
                  background: allTopics[index]['background'],
                );
              },
            ),
    );
  }
}

class TopicCard extends StatelessWidget {
  final String title;
  final String background;

  const TopicCard({
    super.key,
    required this.title,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            background.isNotEmpty
                ? background
                : 'https://firebasestorage.googleapis.com/v0/b/ac-social-fd7f8.appspot.com/o/image_post%2Ftest_post.png?alt=media&token=f98b2974-8a79-43b8-a4f2-7c38935cdd50', // Display background image or a placeholder
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
