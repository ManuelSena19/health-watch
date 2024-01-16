import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/models/user_model.dart';
import 'package:health_watch/providers/user_provider.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:health_watch/utilities/profile_widget.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String _email = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
  }

  void pushRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  Widget buildName(UserModel user) {
    final String name = user.username;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 40,
              child: VerticalDivider(
                color: Colors.black12,
                thickness: 2,
              ),
            ),
            IconButton(
              onPressed: () {
                pushRoute(editProfileRoute);
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.lightBlueAccent,
                size: 30,
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.all(5)),
        Text(_email),
      ],
    );
  }

  Widget buildBio(UserModel user) {
    final String day = user.day;
    final String month = user.month;
    final String year = user.year;
    final String height = user.height;
    final String weight = user.weight;
    final String bmi = user.bmi;
    final String bloodGroup = user.bloodGroup;
    final String allergies = user.allergies;
    final String healthConditions = user.healthConditions;
    final String gender = user.gender;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  ProfileCard(
                    label: 'Height',
                    value: "$height m",
                  ),
                  const SizedBox(width: 10),
                  ProfileCard(
                    label: 'Weight',
                    value: "$weight kg",
                  ),
                  const SizedBox(width: 10),
                  ProfileCard(
                    label: 'BMI',
                    value: bmi,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.calendar,
                      size: 30,
                    ),
                    iconColor: Colors.lightBlueAccent,
                    title: const Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text('$day-$month-$year'),
                    tileColor: Colors.white,
                  ),
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.person_2,
                      size: 30,
                    ),
                    iconColor: Colors.lightBlueAccent,
                    title: const Text(
                      'Gender',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(gender),
                    tileColor: Colors.white,
                  ),
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.drop,
                      size: 30,
                    ),
                    iconColor: Colors.lightBlueAccent,
                    title: const Text(
                      'Blood Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(bloodGroup),
                    tileColor: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  Icons.coronavirus_outlined,
                  size: 30,
                ),
                iconColor: Colors.lightBlueAccent,
                title: const Text(
                  'Allergies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  allergies,
                  softWrap: true,
                ),
                tileColor: Colors.white,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.info,
                  size: 30,
                ),
                iconColor: Colors.lightBlueAccent,
                title: const Text(
                  'Health Conditions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  healthConditions,
                  softWrap: true,
                ),
                tileColor: Colors.white,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        appBar: appbarWidget('Profile'),
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
            final String imagePath = user.imagePath;
            return ListView(
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.lightBlue, Colors.white],
                        ),
                      ),
                    ),
                    Center(
                      child: ProfileWidget(
                        onClicked: () {},
                        imagePath: imagePath,
                        isEdit: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                buildName(user),
                const SizedBox(
                  height: 10,
                ),
                buildBio(user),
              ],
            );
          },
        ));
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
