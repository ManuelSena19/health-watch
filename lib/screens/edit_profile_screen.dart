import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:health_watch/constants/user_data.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/user_preferences.dart';

String _email = FirebaseAuth.instance.currentUser!.email.toString();

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController heightController = TextEditingController();
  late final TextEditingController weightController = TextEditingController();
  late final TextEditingController allergiesController =
      TextEditingController();
  late final TextEditingController healthConditionsController =
      TextEditingController();
  Future<void> updateField(String field, String newValue) async {
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users').doc(_email);
    await userRef.update({field: newValue});
  }

  void pushRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  void pushReplacementRoute(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  File? _imageFile;
  final user = FirebaseAuth.instance.currentUser;
  late XFile _image;
  late String _url;

  Future<void> _pickImage() async {
    _image = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
    setState(() {
      _imageFile = File(_image.path);
    });
  }

  Future<void> uploadImageToFirebase(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$fileName');
    final UploadTask uploadTask = storageReference.putFile(imageFile);
    final String downloadURL = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      _url = downloadURL;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: drawerWidget(context),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getUserData(_email),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: LinearProgressIndicator());
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            String? name = userData['username'] as String?;
            nameController.text = name!;
            String? height = userData['height'] as String?;
            heightController.text = height!;
            String? weight = userData['weight'] as String?;
            weightController.text = weight!;
            String? allergies = userData['allergies'] as String?;
            allergiesController.text = allergies!;
            String? healthConditions = userData['healthConditions'] as String?;
            healthConditionsController.text = healthConditions!;
            String? imagePath = userData['imagePath'] as String?;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              scrollDirection: Axis.vertical,
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(10)),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(children: [
                        ClipOval(
                          clipBehavior: Clip.hardEdge,
                          child: _imageFile != null
                              ? Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imagePath!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: ClipOval(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: Theme.of(context).colorScheme.primary,
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  maxLines: 1,
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Height /m",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  maxLines: 1,
                  controller: heightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Weight /kg",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  maxLines: 1,
                  controller: weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Allergies",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  maxLines: 5,
                  controller: allergiesController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Health Conditions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  maxLines: 5,
                  controller: healthConditionsController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
                  child: ElevatedButton(
                    onPressed: () async {
                      String bmi = (double.parse(weightController.text) /
                              (double.parse(heightController.text) *
                                  double.parse(heightController.text)))
                          .toStringAsFixed(2);
                      try {
                        await uploadImageToFirebase(_imageFile!);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(_email)
                            .update({
                          'imagePath': _url,
                          'username': nameController.text,
                          'height': heightController.text,
                          'weight': weightController.text,
                          'bmi': bmi,
                          'allergies': allergiesController.text,
                          'healthConditions': healthConditionsController.text,
                        });
                        final userData = await getUserData(_email);
                        await deleteUserDataFromSharedPrefs(_email);
                        await storeUserDataInSharedPrefs(_email, userData);
                        pushReplacementRoute(profileRoute);
                      } catch (e) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(_email)
                            .update({
                          'imagePath': imagePath,
                          'username': nameController.text,
                          'height': heightController.text,
                          'weight': weightController.text,
                          'bmi': bmi,
                          'allergies': allergiesController.text,
                          'healthConditions': healthConditionsController.text,
                        });
                        pushReplacementRoute(profileRoute);
                      }
                    },
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Save Changes",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            );
          } else {
            return const SnackBar(content: Text("No data"));
          }
        },
      ),
    );
  }
}
