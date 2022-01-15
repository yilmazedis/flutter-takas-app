
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/models/message.dart';

import '../auth.dart';

Widget sendMessageArea(BuildContext context, String toUserId) {
  final messageText = TextEditingController();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    height: 70,
    color: Colors.white,
    child: Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.photo),
          iconSize: 25,
          color: Theme.of(context).primaryColor,
          onPressed: () {

          },
        ),
        Expanded(
          child: TextField(
            controller: messageText,
            decoration: const InputDecoration.collapsed(
              hintText: 'Send a message..',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          iconSize: 25,
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Message message = Message(
              fromUser: Auth().currentUser(),
              toUser: toUserId,
              time: DateTime.now(),
              text: messageText.text,
            );
            //messages.add(message);
            Auth().sendMessage(message.getDataMap());
            messageText.text = "";
          },
        ),
      ],
    ),
  );
}