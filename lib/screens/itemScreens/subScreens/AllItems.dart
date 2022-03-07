import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/auth.dart';
import 'package:takas_app/models/item.dart';

import '../../../Utils/Constants.dart';
import '../../../Utils/itemCard.dart';

allItems() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('items').where("userId", isNotEqualTo: Auth().currentUserId()).snapshots(),
    builder:
        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

      if (!snapshot.hasData) {
        return Container();
      }

      if (snapshot.hasError) {
        return Text('Something went wrong');
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading");
      }

      return ListView(
        children: snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
          Map<String, dynamic> data =
          document.data()! as Map<String, dynamic>;



          Item item = Item(
              name: data["name"],
              userId: data["userId"],
              userName: data["userName"],
              time: (data["time"] as Timestamp).toDate(),
              imageUrl: data["imageUrl"],
              feature_1: data["feature_1"],
              feature_2: data["feature_2"],
              feature_3: data["feature_3"],
              getRequest: data["getRequest"],
              sendRequest: data["sendRequest"]);

          return ItemCard(data: item, docId: document.id);
        }).toList(),
      );
    },
  );
}
