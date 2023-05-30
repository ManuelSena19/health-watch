import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getUserData(String email) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(email);
  final userSnapshot = await userRef.get();
  if (userSnapshot.exists) {
    return userSnapshot.data() as Map<String, dynamic>;
  }
  return {};
}

Future<DocumentSnapshot<Map<String, dynamic>>?> getPharmacistInfo(
    String name) async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection('pharmacists')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
  if (querySnapshot.size > 0) {
    return querySnapshot.docs[0];
  } else {
    return null;
  }
}
