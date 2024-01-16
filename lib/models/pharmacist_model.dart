import 'package:flutter/material.dart';

class PharmacistModel with ChangeNotifier {
  final String about;
  final String certification;
  final String email;
  final String experience;
  final int id;
  final String name;
  final String patients;
  final String pharmacy;
  final String phoneNumber;
  final double rating;

  PharmacistModel({
    required this.about,
    required this.certification,
    required this.email,
    required this.experience,
    required this.id,
    required this.name,
    required this.patients,
    required this.pharmacy,
    required this.phoneNumber,
    required this.rating,
  });
}
