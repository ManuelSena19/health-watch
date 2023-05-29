import 'package:flutter/material.dart';

Widget stackWidget(String assetName, String text){
  return Stack(
    children: [
      Image(
        image: AssetImage(assetName),
        width: double.infinity,
        height: 350,
        fit: BoxFit.cover,
      ),
      Positioned(
        bottom: 10,
        left: 10,
        right: 10,
        child: Container(
          width: 600,
          color: Colors.white,
          padding: const EdgeInsets.all(10),
          child: Text(
            text,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ],
  );
}