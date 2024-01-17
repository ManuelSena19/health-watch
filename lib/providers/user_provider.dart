import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
    allergies: "allergies",
    bloodGroup: ' bloodGroup',
    bmi: 'bmi',
    day: 'day',
    email: 'email',
    gender: 'gender',
    healthConditions: 'healthConditions',
    height: 'height',
    imagePath: 'https://th.bing.com/th/id/R.e62421c9ba5aeb764163aaccd64a9583?rik=DzXjlnhTgV5CvA&riu=http%3a%2f%2fcdn.onlinewebfonts.com%2fsvg%2fimg_210318.png&ehk=952QCsChZS0znBch2iju8Vc%2fS2aIXvqX%2f0zrwkjJ3GA%3d&risl=&pid=ImgRaw&r=0',
    month: 'month',
    username: 'username',
    weight: 'weight',
    year: 'year',
  );

  UserModel get user => _user;

  Future<void> getUserData(String email) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(email);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        UserModel userModel = UserModel(
          allergies: userSnapshot['allergies'],
          bloodGroup: userSnapshot['bloodGroup'],
          bmi: userSnapshot['bmi'],
          day: userSnapshot['day'],
          email: userSnapshot['email'],
          gender: userSnapshot['gender'],
          healthConditions: userSnapshot['healthConditions'],
          height: userSnapshot['height'],
          imagePath: userSnapshot['imagePath'],
          month: userSnapshot['month'],
          username: userSnapshot['username'],
          weight: userSnapshot['weight'],
          year: userSnapshot['year'],
        );
        _user = userModel;
        notifyListeners();
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<void> editUserData(String email, UserModel newUserModel) async {
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'imagePath': newUserModel.imagePath,
      'username': newUserModel.username,
      'height': newUserModel.height,
      'weight': newUserModel.weight,
      'bmi': newUserModel.bmi,
      'allergies': newUserModel.allergies,
      'healthConditions': newUserModel.healthConditions,
    });
    _user = newUserModel;
    notifyListeners();
  }

  Future<void> addUser(UserModel newUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.email)
          .set({
        'allergies': newUser.allergies,
        'bloodGroup': newUser.bloodGroup,
        'bmi': newUser.bmi,
        'day': newUser.day,
        'email': newUser.email,
        'gender': newUser.gender,
        'healthConditions': newUser.healthConditions,
        'height': newUser.height,
        'imagePath': newUser.imagePath,
        'month': newUser.month,
        'username': newUser.username,
        'weight': newUser.weight,
        'year': newUser.year,
      });
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }
}
