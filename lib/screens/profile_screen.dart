import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
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
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            final String? name = userData['username'] as String?;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name!,
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
          return Container();
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
                          value: "$bmi",
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
                          subtitle: Text('$gender'),
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
                          subtitle: Text('$bloodGroup'),
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
                      subtitle: Text('$allergies', softWrap: true,),
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
                      subtitle: Text('$healthConditions', softWrap: true,),
                      tileColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const SnackBar(content: Text("No data"));
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget('Profile'),
      drawer: drawerWidget(context),
      body: ListView(
        children: <Widget>[
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
                  return Stack(
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
                          imagePath: imagePath!,
                          isEdit: false,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SnackBar(content: Text("No data"));
                }
              }),
          const SizedBox(
            height: 5,
          ),
          buildName(),
          const SizedBox(
            height: 10,
          ),
          buildBio(),
        ],
      ),
    );
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
