

import 'package:flutter/material.dart';

addAvatar(url) {
  return CircleAvatar(
    radius: 25,
    backgroundColor: const Color(0xffFDCF09),
    child: url != null
        ? ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child:
        Image.network(
          url,
          fit: BoxFit.fill,
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