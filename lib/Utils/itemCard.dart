import 'package:flutter/material.dart';
import 'package:takas_app/models/item.dart';

import 'ItemCardImage.dart';

class ItemCard extends StatefulWidget {
  ItemCard({Key? key, required this.data}) : super(key: key);

  Item data;

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            trailing: const Icon(Icons.favorite, color: Colors.red,),
            title: Text(widget.data.name),
            subtitle: Text(
              widget.data.feature_1,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.data.feature_2,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('Takas'),
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('Takas'),
              ),
            ],
          ),
          ItemCardImage(imageUrl: widget.data.imageUrl),
        ],
      ),
    );
  }
}