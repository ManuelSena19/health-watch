import 'package:flutter/material.dart';

Widget drawerWidget() {
  return Drawer(
    elevation: 0,
    child: ListView(
      children: const [
        SizedBox(
          height: 50,
        ),
        ListTile(
          leading: Icon(Icons.home_outlined),
          title: Text("Home"),
          iconColor: Colors.lightBlue,
        ),
        ListTile(
          leading: Icon(Icons.person_outlined),
          title: Text("Profile"),
          iconColor: Colors.lightBlue,
        ),
        ListTile(
          leading: Icon(Icons.chat_outlined),
          title: Text("Chats"),
          iconColor: Colors.lightBlue,
        ),
        ListTile(
          leading: Icon(Icons.calendar_month_outlined),
          title: Text("Calendar"),
          iconColor: Colors.lightBlue,
        ),
        ListTile(
          leading: Icon(Icons.today_outlined),
          title: Text("Appointments"),
          iconColor: Colors.lightBlue,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text("Settings"),
          iconColor: Colors.lightBlue,
        ),
        ListTile(
          leading: Icon(Icons.logout_outlined),
          title: Text("Sign Out"),
          iconColor: Colors.lightBlue,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
      ],
    ),
  );
}
