class Item {
  final String name;
  final String userId;
  final DateTime time;
  final String imageUrl;
  final String feature_1;
  final String feature_2;
  final String feature_3;

  Item({
    required this.name,
    required this.userId,
    required this.time,
    required this.imageUrl,
    required this.feature_1,
    required this.feature_2,
    required this.feature_3,
  });

  Map<String, dynamic> getDataMap() {
    return {
      "name": name,
      "userId": userId,
      "time": time,
      "imageUrl": imageUrl,
      "feature_1": feature_1,
      "feature_2": feature_2,
      "feature_3": feature_3,
    };
  }
}