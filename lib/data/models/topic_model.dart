class TopicModel {
  final String id;
  final String? name;
  final String? background;
  TopicModel({
    required this.id,
    required this.name,
    required this.background,
  });
  factory TopicModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TopicModel(
        id: id, name: data['name'] ?? '', background: data['background'] ?? '');
  }
}
