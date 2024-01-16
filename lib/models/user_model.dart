import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String allergies;
  final String bloodGroup;
  final String bmi;
  final String day;
  final String email;
  final String gender;
  final String healthConditions;
  final String height;
  final String imagePath;
  final String month;
  final String username;
  final String weight;
  final String year;

  UserModel({
    required this.allergies,
    required this.bloodGroup,
    required this.bmi,
    required this.day,
    required this.email,
    required this.gender,
    required this.healthConditions,
    required this.height,
    required this.imagePath,
    required this.month,
    required this.username,
    required this.weight,
    required this.year,
  });
}
