import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';

class AppointmentProvider with ChangeNotifier {
  final List<AppointmentModel> _appointments = [];
  final List<AppointmentModel> _filteredAppointments = [];
  final List<DateTime> _dates = [];

  List<AppointmentModel> get appointments => _appointments;
  List<AppointmentModel> get filteredAppointments => _filteredAppointments;
  List<DateTime> get dates => _dates;

  Future<void> getUserAppointments(String patient) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('appointments')
          .where('patient', isEqualTo: patient)
          .get();

      _appointments.clear();

      for (final doc in snapshot.docs) {
        AppointmentModel appointmentModel = AppointmentModel(
          date: (doc['date'] as Timestamp).toDate(),
          patient: doc['patient'] as String,
          pharmacist: doc['pharmacist'] as String,
          pharmacy: doc['pharmacy'] as String,
          status: doc['status'] as String,
        );

        if(appointmentModel.date.isBefore(DateTime.now()) && appointmentModel.status == 'upcoming'){
          updateStatus(appointmentModel, 'canceled');
        }

        _appointments.add(appointmentModel);
        notifyListeners();
      }
    } catch (error) {
      log('$error');
    }
  }

  Future<void> updateStatus(
      AppointmentModel appointmentModel, String status) async {
    try {
      final appointmentRef =
          FirebaseFirestore.instance.collection('appointments');

      QuerySnapshot querySnapshot = await appointmentRef
          .where('patient', isEqualTo: appointmentModel.patient)
          .where('pharmacy', isEqualTo: appointmentModel.pharmacy)
          .where('pharmacist', isEqualTo: appointmentModel.pharmacist)
          .where('date', isEqualTo: appointmentModel.date)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final appointmentDoc = querySnapshot.docs.first;
        await appointmentDoc.reference.update({'status': status});
        notifyListeners();
        getUserAppointments(appointmentModel.patient);
      }
    } catch (error) {
      log('$error');
    }
  }

  Future<void> rescheduleAppointment(
      AppointmentModel appointmentModel, DateTime date) async {
    try {
      final appointmentRef =
          FirebaseFirestore.instance.collection('appointments');

      QuerySnapshot querySnapshot = await appointmentRef
          .where('patient', isEqualTo: appointmentModel.patient)
          .where('pharmacy', isEqualTo: appointmentModel.pharmacy)
          .where('pharmacist', isEqualTo: appointmentModel.pharmacist)
          .where('date', isEqualTo: appointmentModel.date)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final appointmentDoc = querySnapshot.docs.first;
        await appointmentDoc.reference.update({
          'date': date,
        });
        notifyListeners();
        getUserAppointments(appointmentModel.patient);
      }
    } catch (error) {
      log('$error');
    }
  }

  List<AppointmentModel> filterAppointments(List<AppointmentModel> appointments, String status) {
    _filteredAppointments.clear();
    if (appointments.isNotEmpty) {
      for(AppointmentModel appointmentModel in appointments){
        if(appointmentModel.status == status){
          _filteredAppointments.add(appointmentModel);
          notifyListeners();
        }
        else{
          continue;
        }
      }
    }
    return _filteredAppointments;
  }

  void getAppointmentDates(){
    for(AppointmentModel appointmentModel in _appointments){
      DateTime date = appointmentModel.date;
      _dates.add(date);
      notifyListeners();
    }
  }

  Future<void> bookAppointment(AppointmentModel newAppointment) async {
    final CollectionReference appointments =
    FirebaseFirestore.instance.collection('appointments');
    try {
      await appointments.doc().set({
        'date': newAppointment.date,
        'patient': newAppointment.patient,
        'pharmacist': newAppointment.pharmacist,
        'pharmacy': newAppointment.pharmacy,
        'status': newAppointment.status,
      });
      getUserAppointments(newAppointment.patient);
    } catch (error) {
      rethrow;
    }
  }
}
