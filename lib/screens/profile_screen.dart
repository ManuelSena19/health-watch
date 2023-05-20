import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:health_watch/utilities/profile_widget.dart';
import 'package:health_watch/constants/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _email = FirebaseAuth.instance.currentUser?.email ?? '';

  void pushRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  Widget buildName() => FutureBuilder<Map<String, dynamic>>(
        future: getUserData(_email),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            final String? name = userData['username'] as String?;
            return Column(
              children: [
                Text(
                  name!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5)),
                Text(_email),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Text("Check your network connection");
          }
        },
      );

  Widget buildBio() => FutureBuilder<Map<String, dynamic>>(
      future: getUserData(_email),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final userData = snapshot.data!;
          final String? day = userData['day'] as String?;
          final String? month = userData['month'] as String?;
          final String? year = userData['year'] as String?;
          final String? height = userData['height'] as String?;
          final String? weight = userData['weight'] as String?;
          final String? bmi = userData['bmi'] as String?;
          final String? bloodGroup = userData['bloodGroup'] as String?;
          final String? allergies = userData['allergies'] as String?;
          final String? healthConditions =
              userData['healthConditions'] as String?;
          final String? gender = userData['gender'] as String?;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Bio-data',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.all(5)),
                Text(
                  "Date of birth: $day/$month/$year",
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
                Text(
                  "Gender: $gender",
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
                Text(
                  "Height: $height m",
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
                Text(
                  "Weight: $weight kg",
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("BMI: ", style: TextStyle(fontSize: 20, height: 1.4),),
                    Text(
                      "$bmi",
                      style: TextStyle(
                          fontSize: 20,
                          height: 1.4,
                          color: double.parse(bmi!) >= 18.5 &&
                              double.parse(bmi) <= 24.9
                              ? Colors.green
                              : Colors.red),
                    ),
                  ],
                ),
                Text(
                  "Blood Type: $bloodGroup",
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
                Text(
                  "Allergies: $allergies",
                  maxLines: 5,
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
                Text(
                  "Health Conditions: $healthConditions",
                  maxLines: 5,
                  style: const TextStyle(fontSize: 20, height: 1.4),
                ),
              ],
            ),
          );
        } else {
          return const SnackBar(content: Text("No data"));
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      drawer: drawerWidget(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          const Padding(padding: EdgeInsets.all(10)),
          FutureBuilder(
              future: getUserData(_email),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return SnackBar(content: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  final String? imagePath = userData['imagePath'] as String?;
                  return ProfileWidget(
                    onClicked: () {},
                    imagePath: imagePath!,
                    isEdit: false,
                  );
                } else {
                  return const SnackBar(content: Text("No data"));
                }
              }),
          const SizedBox(height: 20,),
          buildName(),
          const SizedBox(height: 40,),
          buildBio(),
          const SizedBox(height: 60),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 100),
            child: ElevatedButton(
              onPressed: (){
                pushRoute(editProfileRoute);
              },
              child: Container(
                width: 150,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  "Edit Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
