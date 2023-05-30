import 'package:flutter/material.dart';

PreferredSizeWidget appbarWidget(String title){
  return AppBar(
    backgroundColor: Colors.lightBlue,
    elevation: 0,
    title: Text(title),
    centerTitle: true,
    actions: [
      IconButton(
          onPressed: () {}, icon: const Icon(Icons.notifications_outlined))
    ],
  );
}