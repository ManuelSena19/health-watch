import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getNameFromFirestore(String email) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(email);
  final userSnapshot = await userRef.get();
  if (userSnapshot.exists) {
    final userData = userSnapshot.data() as Map<String, dynamic>;
    final name = userData['username'] as String?;
    return name;
  }
  return null;
}

Widget drawerWidget(BuildContext context) {
  void pushReplacementNamedRoute(String route) {
    pushReplacementRoute(context, route);
  }

  return Drawer(
    elevation: 0,
    child: FutureBuilder<String?>(
      future: getNameFromFirestore(
          FirebaseAuth.instance.currentUser!.email.toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LinearProgressIndicator());
        } else if (snapshot.hasData) {
          final name = snapshot.data!;
          final email = FirebaseAuth.instance.currentUser!.email.toString();
          return ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Image(
                        image: AssetImage("assets/icon.jpg"),
                        height: 75,
                        width: 75,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      'Hello, $name',
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '@$email',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                height: 10,
                thickness: 3,
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.home),
                title: const Text("Home"),
                iconColor: Colors.lightBlue,
                onTap: () {
                  pushRoute(context, homescreenRoute);
                },
              ),
              const Divider(
                height: 10,
                thickness: 3,
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text("Settings"),
                iconColor: Colors.lightBlue,
                onTap: (){
                  pushRoute(context, settingsRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Sign Out"),
                iconColor: Colors.lightBlue,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  pushReplacementNamedRoute(loginRoute);
                },
              ),
              const Divider(
                height: 10,
                thickness: 3,
              ),
            ],
          );
        } else {
          return const SnackBar(
            content: Text("Username Not Found!"),
            elevation: 0,
          );
        }
      },
    ),
  );
}
