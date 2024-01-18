import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/providers/user_provider.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

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
  String _imagePath = '';
  Future<void> updateField(String field, String newValue) async {
    DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('users').doc(_email);
    await userRef.update({field: newValue});
  }

  void pushRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  void pop() {
    Navigator.popAndPushNamed(context, profileRoute);
  }

  void showError(String text) {
    showErrorDialog(context, text);
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
      _imagePath = _url;
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: drawerWidget(context),
      body: FutureBuilder(
        future: userProvider.getUserData(_email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            showErrorDialog(context, '${snapshot.error}');
          }
          UserModel user = userProvider.user;
          nameController.text = user.username;
          heightController.text = user.height;
          weightController.text = user.weight;
          allergiesController.text = user.allergies;
          healthConditionsController.text = user.healthConditions;
          _imagePath = user.imagePath;
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
                                _imagePath,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.lightBlue,
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
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    String bmi = (double.parse(weightController.text) /
                            (double.parse(heightController.text) *
                                double.parse(heightController.text)))
                        .toStringAsFixed(2);
                    try {
                      await uploadImageToFirebase(_imageFile!);
                      UserModel newUser = UserModel(
                        allergies: allergiesController.text,
                        bloodGroup: user.bloodGroup,
                        bmi: bmi,
                        day: user.day,
                        email: user.email,
                        gender: user.gender,
                        healthConditions: healthConditionsController.text,
                        height: heightController.text,
                        imagePath: _imagePath,
                        month: user.month,
                        username: nameController.text,
                        weight: weightController.text,
                        year: user.year,
                      );
                      userProvider.editUserData(_email, newUser);
                      pop();
                    }
                    catch (e) {
                      UserModel newUser = UserModel(
                        allergies: allergiesController.text,
                        bloodGroup: user.bloodGroup,
                        bmi: bmi,
                        day: user.day,
                        email: user.email,
                        gender: user.gender,
                        healthConditions: healthConditionsController.text,
                        height: heightController.text,
                        imagePath: _imagePath,
                        month: user.month,
                        username: nameController.text,
                        weight: weightController.text,
                        year: user.year,
                      );
                      userProvider.editUserData(_email, newUser);
                      pop();
                    }
                  },
                  child: Container(
                    width: 150,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
        },
      ),
    );
  }
}
