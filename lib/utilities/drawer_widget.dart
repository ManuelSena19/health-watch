import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_watch/constants/routes.dart';

Widget drawerWidget(BuildContext context) {
  void pushReplacementRoute(String route){
    Navigator.pushReplacementNamed(context, route);
  }

  return Drawer(
    elevation: 0,
    child: ListView(
      children: [
        const SizedBox(
          height: 50,
        ),
        const ListTile(
          leading: Icon(Icons.home_outlined),
          title: Text("Home"),
          iconColor: Colors.lightBlue,
        ),
        const ListTile(
          leading: Icon(Icons.person_outlined),
          title: Text("Profile"),
          iconColor: Colors.lightBlue,
        ),
        const ListTile(
          leading: Icon(Icons.chat_outlined),
          title: Text("Chats"),
          iconColor: Colors.lightBlue,
        ),
        const ListTile(
          leading: Icon(Icons.calendar_month_outlined),
          title: Text("Calendar"),
          iconColor: Colors.lightBlue,
        ),
        const ListTile(
          leading: Icon(Icons.today_outlined),
          title: Text("Appointments"),
          iconColor: Colors.lightBlue,
        ),
        const Divider(
          height: 10,
          thickness: 3,
        ),
        const ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text("Settings"),
          iconColor: Colors.lightBlue,
        ),
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: const Text("Sign Out"),
          iconColor: Colors.lightBlue,
          onTap: () async{
            await FirebaseAuth.instance.signOut();
            pushReplacementRoute(loginRoute);
          },
        ),
        const Divider(
          height: 10,
          thickness: 3,
        ),
      ],
    ),
  );
}
