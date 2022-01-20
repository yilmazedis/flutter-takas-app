import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

addAvatar(url) {
  return CircleAvatar(
    radius: 25,
    backgroundColor: const Color(0xffFDCF09),
    child: url != null
        ? ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:
        CachedNetworkImage(
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )
    )
        : Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20)),
      child: Icon(
        Icons.account_circle,
        color: Colors.grey[800],
      ),
    ),
  );
}