import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:health_watch/utilities/stack_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget('Health Watch'),
      drawer: drawerWidget(context),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            child: stackWidget(
              "assets/home.jpeg",
              'Click here to talk to a licensed pharmacist',
            ),
            onTap: () {
              pushRoute(context, appointmentRoute);
            },
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 10,
            thickness: 3,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            child: stackWidget(
              'assets/calendar.jpg',
              'Click here to check your appointments',
            ),
            onTap: () {
              pushRoute(context, calendarRoute);
            },
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            height: 10,
            thickness: 3,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            child: stackWidget(
              'assets/chat.jpeg',
              'Click here to check your chats',
            ),
            onTap: () {
              pushRoute(context, chatRoute);
            },
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
