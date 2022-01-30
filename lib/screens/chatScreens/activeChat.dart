import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/Utils/common.dart';
import 'package:takas_app/models/chatMenu.dart';
import 'package:takas_app/models/user.dart';
import 'package:takas_app/screens/chatScreens/chat.dart';
import '../../auth.dart';
import 'package:intl/intl.dart';

activeChat() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(Auth().currentUserId())
        .collection("chatMenu")
        .orderBy("time", descending: true)
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("yükleniyor");
      }

      if (snapshot.data!.docs.isEmpty) {
        return Center(
          child: Container(
            margin: const EdgeInsets.only(top: 100),
            child: Column(
              children: const <Widget>[
                Text(
                  "Aktif konuşma yok",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

          ChatMenu chatMenu = ChatMenu(
            name: data["name"],
            text: data["text"],
            time: (data['time'] as Timestamp).toDate(),
            imageUrl: data["imageUrl"],
            isOnline: data["isOnline"],
            isRead: data["isRead"],
          );

          //var imagePath = data["imageUrl"];

          //print("imagePath $imagePath");
          //
          DateTime dt = (data['time'] as Timestamp).toDate();
          var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt);

          return GestureDetector(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        id: document.id,
                        name: chatMenu.name,
                        isOnline: chatMenu.isOnline,
                        imageUrl: chatMenu.imageUrl,
                      ),
                    ),
                  ),
              child: conversation(chatMenu.imageUrl, chatMenu.name,
                  chatMenu.text, d24, !chatMenu.isRead));
        }).toList(),
      );
    },
  );
}

Widget conversation(
    String url, String name, String message, String time, bool messageSeen) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildProfileImage(url, 50),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(time),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Expanded(child: Text(message)),
                  if (messageSeen)
                    const Icon(
                      Icons.check_circle,
                      size: 16.0,
                      color: Colors.green,
                    ),
                  if (!messageSeen)
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
