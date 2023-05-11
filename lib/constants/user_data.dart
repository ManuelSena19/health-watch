import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;

class UserData {
  static late FirebaseFirestore _firestore;
  static late f.User? _user;
  static late String? _email,
      _name,
      _age,
      _height,
      _weight,
      _bmi,
      _bloodGroup,
      _allergies,
      _healthConditions,
      _gender;

  static final myUser = User(
    imagePath:
        'https://th.bing.com/th/id/R.e62421c9ba5aeb764163aaccd64a9583?rik=DzXjlnhTgV5CvA&riu=http%3a%2f%2fcdn.onlinewebfonts.com%2fsvg%2fimg_210318.png&ehk=952QCsChZS0znBch2iju8Vc%2fS2aIXvqX%2f0zrwkjJ3GA%3d&risl=&pid=ImgRaw&r=0',
    name: _name!,
    email: _email!,
    age: _age!,
    height: _height!,
    weight: _weight!,
    bmi: _bmi!,
    bloodGroup: _bloodGroup!,
    allergies: _allergies!,
    healthConditions: _healthConditions!,
    gender: _gender!,
  );

  static Future init() async {
    _user = f.FirebaseAuth.instance.currentUser;
    _firestore = FirebaseFirestore.instance;
    _email = _user!.email.toString();
    _name = await getNameFromFirestore(_email!);
    _age = await getAgeFromFirestore(_email!);
    _height = await getAgeFromFirestore(_email!);
    _weight = await getWeightFromFirestore(_email!);
    _bmi = await getBmiFromFirestore(_email!);
    _bloodGroup = await getBloodGroupFromFirestore(_email!);
    _allergies = await getAllergiesFromFirestore(_email!);
    _healthConditions = await getHealthConditionsFromFirestore(_email!);
    _gender = await getGenderFromFirestore(_email!);
  }

  static Future setUser(User user) async {
    final userRef = _firestore.collection("users").doc(_user!.email.toString());
    await userRef.set(user.toJson());
  }

  static Future<String?> getAgeFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? age = userData['age'] as String?;
      return age;
    } else {
      return null;
    }
  }

  static Future<String?> getNameFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? name = userData['username'] as String?;
      return name;
    } else {
      return null;
    }
  }

  static Future<String?> getHeightFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? height = userData['height'] as String?;
      return height;
    } else {
      return null;
    }
  }

  static Future<String?> getWeightFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? weight = userData['weight'] as String?;
      return weight;
    } else {
      return null;
    }
  }

  static Future<String?> getBmiFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? bmi = userData['bmi'] as String?;
      return bmi;
    } else {
      return null;
    }
  }

  static Future<String?> getBloodGroupFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? bloodGroup = userData['bloodGroup'] as String?;
      return bloodGroup;
    } else {
      return null;
    }
  }

  static Future<String?> getHealthConditionsFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? healthConditions = userData['healthConditions'] as String?;
      return healthConditions;
    } else {
      return null;
    }
  }

  static Future<String?> getAllergiesFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? allergies = userData['allergies'] as String?;
      return allergies;
    } else {
      return null;
    }
  }

  static Future<String?> getGenderFromFirestore(String email) async {
    final userRef = _firestore.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      String? gender = userData['gender'] as String?;
      return gender;
    } else {
      return null;
    }
  }
}
