import 'package:flutter/material.dart';

class AppointmentModel with ChangeNotifier{
  final DateTime date;
  final String patient;
  final String pharmacist;
  final String pharmacy;
  final String status;

  AppointmentModel({
    required this.date,
    required this.patient,
    required this.pharmacist,
    required this.pharmacy,
    required this.status,
});
}