import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:takas_app/Utils/charBubble.dart';
import 'package:takas_app/Utils/sendMessage.dart';
import 'package:takas_app/models/message.dart';
import 'package:takas_app/models/user.dart';

import '../auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.userData}) : super(key: key);

  final UserData userData;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.userData.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
              const TextSpan(text: '\n'),
              widget.userData.isOnline ?
              const TextSpan(
                text: "Online",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              )
              :
              const TextSpan(
                text: 'Offline',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(

              stream: FirebaseFirestore.instance.
              collection('messages').
              orderBy('time').
              snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                if (snapshot.hasError) {
                  print( widget.userData.id);
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                // TODO: move list to bottom when new message is sent
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                    print(data["fromUser"]);
                    print(data["toUser"]);
                    print(data["time"]);
                    print(data["text"]);
                    if ((data["fromUser"] == widget.userData.id &&
                        data["toUser"] == Auth().currentUser())
                        ||
                        (data["toUser"] == widget.userData.id &&
                        data["fromUser"] == Auth().currentUser())) {
                      Message message = Message(
                        fromUser: data["fromUser"],
                        toUser: data["toUser"],
                        time: (data['time'] as Timestamp).toDate(),
                        text: data["text"],
                      );

                      final bool isMe = data["fromUser"] == Auth().currentUser();
                      return chatBubble(context, message, isMe);
                    } else {
                      return Container ();
                    }
                }).toList(),
                );
              },
            ),
          ),
          sendMessageArea(context, widget.userData.id),
        ],
      ),
    );
  }
}
