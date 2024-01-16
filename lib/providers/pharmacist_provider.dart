import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/pharmacist_model.dart';

class PharmacistProvider with ChangeNotifier {
  final List<PharmacistModel> _pharmacists = [];
  final List<PharmacistModel> _t5Pharmacists = [];
  final List<String> _names = [];

  List<PharmacistModel> get pharmacists => _pharmacists;
  List<PharmacistModel> get t5Pharmacists => _t5Pharmacists;
  List<String> get pharmacistNames => _names;

  Future<void> getPharmacists() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('pharmacists').get();

      _pharmacists.clear();

      for (final doc in snapshot.docs) {
        PharmacistModel pharmacistModel = PharmacistModel(
          about: doc['about'],
          certification: doc['certification'],
          email: doc['email'],
          experience: doc['experience'],
          id: doc['id'],
          name: doc['name'],
          patients: doc['patients'],
          pharmacy: doc['pharmacy'],
          phoneNumber: doc['phoneNumber'],
          rating: doc['rating'],
        );

        _pharmacists.add(pharmacistModel);
        notifyListeners();
      }
    } catch (error) {
      log('$error');
    }
  }

  Future<void> getT5Pharmacists() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('pharmacists').orderBy('rating', descending: true).limit(5).get();

      _t5Pharmacists.clear();

      for (final doc in snapshot.docs) {
        PharmacistModel pharmacistModel = PharmacistModel(
          about: doc['about'],
          certification: doc['certification'],
          email: doc['email'],
          experience: doc['experience'],
          id: doc['id'],
          name: doc['name'],
          patients: doc['patients'],
          pharmacy: doc['pharmacy'],
          phoneNumber: doc['phoneNumber'],
          rating: doc['rating'],
        );

        _t5Pharmacists.add(pharmacistModel);
        notifyListeners();
      }
    } catch (error) {
      log('$error');
    }
  }

  Future<void> getPharmacistNames() async {
    try {
      CollectionReference pharmacistsCollection =
      FirebaseFirestore.instance.collection('pharmacists');

      QuerySnapshot pharmacistSnapshot = await pharmacistsCollection.get();

      for (QueryDocumentSnapshot document in pharmacistSnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String name =
        data['name'];
        _names.clear();
        _names.add(name);
        notifyListeners();
      }
    } catch (e) {
      log('Error: $e');
      rethrow;
    }
  }

}
