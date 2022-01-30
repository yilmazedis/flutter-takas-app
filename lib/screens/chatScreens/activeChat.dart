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
    stream: FirebaseFirestore.instance.collection('users')
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
                builder: (_) => ChatScreen(id: document.id,
                  name: chatMenu.name,
                  isOnline: chatMenu.isOnline,
                imageUrl: chatMenu.imageUrl,),
              ),
            ),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    buildProfileImage(chatMenu.imageUrl, 50),
                    Expanded(
                      child: Card(
                        color: chatMenu.isRead ? null : Colors.green,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(7),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(data['name']),
                            const SizedBox(width: 50),

                            Text(data['text']),

                            const SizedBox(width: 50),

                            Text(data['isOnline'] == true ? "Online" : "Offline"),
                            const SizedBox(width: 50),
                            Text(
                              d24,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black45, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //subtitle: Text(data['email']),

            ),
          );
        }).toList(),
      );
    },
  );
}