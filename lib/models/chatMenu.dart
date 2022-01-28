

class ChatMenu {
  final DateTime time;
  final String text;
  final String name;
  final String imageUrl;
  final bool isOnline;


  ChatMenu({
    required this.time,
    required this.text,
    required this.name,
    required this.imageUrl,
    required this.isOnline,
  });

  Map<String, dynamic> getDataMap() {
    return {
      "time": time,
      "text": text,
      "name": name,
      "imageUrl": imageUrl,
      "isOnline": isOnline,
    };
  }
}