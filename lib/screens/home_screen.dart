import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/screens/apppointment_screen.dart';
import 'package:health_watch/screens/chat_screen.dart';
import 'package:health_watch/screens/profile_screen.dart';
import 'package:health_watch/screens/search_screen.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:health_watch/utilities/stack_widget.dart';

final List<Widget> _screens = [
  const HomeScreen(),
  const SearchScreen(),
  const AppointmentScreen(),
  const ChatScreen(),
  const ProfileScreen(),
];

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            GestureDetector(
              child: stackWidget(
                "assets/home.jpeg",
                'Click here to talk to a licensed pharmacist',
              ),
              onTap: () {
                pushRoute(context, searchRoute);
              },
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              child: stackWidget(
                'assets/calendar.jpg',
                'Click here to check your appointments',
              ),
              onTap: () {
                pushRoute(context, appointmentRoute);
              },
            ),
            const SizedBox(
              height: 15,
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
              height: 10,
            ),
            GestureDetector(
              child: stackWidget(
                'assets/pharmacy.jpg',
                'Click here to find pharmacies near you',
              ),
              onTap: () {
                pushRoute(context, searchRoute);
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
