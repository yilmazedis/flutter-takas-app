import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:takas_app/models/item.dart';

import 'itemCard.dart';

allItems() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('items').snapshots(),
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
              time: (data["time"] as Timestamp).toDate(),
              imageUrl: data["imageUrl"],
              feature_1: data["feature_1"],
              feature_2: data["feature_2"],
              feature_3: data["feature_3"]);

          return ItemCard(data: item);
        }).toList(),
      );
    },
  );
}
