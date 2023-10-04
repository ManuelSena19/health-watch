import 'package:flutter/material.dart';

Widget stackWidget(String assetName, String text) {
  return Container(
    height: 350,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
          colors: [Colors.lightBlue, Colors.lightBlueAccent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight),
    ),
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image(
            image: AssetImage(assetName),
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
