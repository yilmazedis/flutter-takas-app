import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:takas_app/models/item.dart';

class ItemCard extends StatefulWidget {
  ItemCard({Key? key, required this.data}) : super(key: key);

  Item data;

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {

  Widget _sizedContainer(Widget child) {
    return SizedBox(
      width: 100.0,
      child: Center(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
              child: _sizedContainer(CachedNetworkImage(
            imageUrl: widget.data.imageUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ))),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    trailing: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
