import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:network/views/widgets/topic_view_more.dart';

class TopicSection extends StatefulWidget {
  const TopicSection({super.key});

  @override
  State<TopicSection> createState() => _TopicSectionState();
}

class _TopicSectionState extends State<TopicSection> {
  List<Map<String, dynamic>> topics = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchInitialTopics();
  }

  Future<void> fetchInitialTopics() async {
    setState(() {
      isLoading = true;
    });

    // Fetch topics from Firestore (replace 'topic' with your actual collection name)
    final snapshot =
        await FirebaseFirestore.instance.collection('topic').limit(2).get();
    setState(() {
      topics = snapshot.docs.map((doc) => doc.data()).toList();
      isLoading = false;
    });
  }

  void navigateToViewMore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TopicViewMoreScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Topic',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: navigateToViewMore,
              child: const Text('View more'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return TopicCard(
                    title: topics[index]['name'],
                    background: topics[index]['background'],
                  );
                },
              ),
      ],
    );
  }
}
