import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/models/appointment_model.dart';
import 'package:health_watch/models/pharmacist_model.dart';
import 'package:health_watch/models/user_model.dart';
import 'package:health_watch/providers/appointment_provider.dart';
import 'package:health_watch/providers/pharmacist_provider.dart';
import 'package:health_watch/providers/user_provider.dart';
import 'package:health_watch/screens/apppointment_screen.dart';
import 'package:health_watch/screens/loading_screen.dart';
// import 'package:health_watch/screens/chat_screen.dart';
import 'package:health_watch/screens/profile_screen.dart';
import 'package:health_watch/screens/search_screen.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:health_watch/utilities/stack_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utilities/doctor_card.dart';
import '../utilities/show_error_dialog.dart';

final List<Widget> _screens = [
  const HomeScreen(),
  const SearchScreen(),
  const AppointmentScreen(),
  // const ChatScreen(),
  const ProfileScreen(),
];

class MainNavigationScreen extends StatefulWidget {
  MainNavigationScreen({Key? key, this.index}) : super(key: key);

  int? index;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[widget.index ?? _currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.index ?? _currentIndex,
        onTap: (index) {
          setState(() {
            widget.index = null;
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
          // BottomNavigationBarItem(
          //   icon: Icon(CupertinoIcons.chat_bubble_text),
          //   label: 'Chats',
          // ),
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
  late AppointmentProvider appointmentProvider;
  late UserProvider userProvider;
  late PharmacistProvider pharmacistProvider;
  final String _email = FirebaseAuth.instance.currentUser!.email.toString();
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  void initState() {
    super.initState();
    appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    pharmacistProvider =
        Provider.of<PharmacistProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  String introText() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour >= 12 && hour < 18) {
      return 'Good Afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stacks = [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: GestureDetector(
          child: stackWidget(
            "assets/home.jpeg",
            'Talk to a licensed pharmacist',
          ),
          onTap: () {
            pushRoute(context, searchRoute);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: GestureDetector(
          child: stackWidget(
            'assets/calendar.jpg',
            'Check your appointments',
          ),
          onTap: () {
            pushRoute(context, appointmentRoute);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: GestureDetector(
          child: stackWidget(
            'assets/pharmacy.jpg',
            'Find pharmacies near you',
          ),
          onTap: () {
            pushRoute(context, searchRoute);
          },
        ),
      ),
    ];
    return Scaffold(
      drawer: drawerWidget(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            FutureBuilder(
              future: userProvider.getUserData(_email),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  showErrorDialog(context, 'Error: ${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox();
                } else {
                  final UserModel user = userProvider.user;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: ClipOval(
                        child: Image.network(
                          user.imagePath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      introText(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.blueGrey,
                      ),
                    ),
                    subtitle: Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                    trailing: const IconButton(
                      icon: Icon(
                        Icons.notifications_none,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: null,
                    ),
                  );
                }
                return const SizedBox(
                  height: 5,
                );
              },
            ),
            FutureBuilder(
              future: appointmentProvider.getUserAppointments(_email),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  showErrorDialog(context, '${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox();
                }
                List<AppointmentModel> appointments =
                    appointmentProvider.appointments;
                List<AppointmentModel> filteredAppointments =
                    appointmentProvider.filterAppointments(
                        appointments, 'upcoming');
                return Text(
                  'You have ${filteredAppointments.length} upcoming ${filteredAppointments.length == 1 ? 'appointment' : 'appointments'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 300,
              child: PageView.builder(
                padEnds: true,
                pageSnapping: false,
                itemCount: stacks.length,
                controller: controller,
                itemBuilder: (context, index) {
                  return stacks[index];
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: const ExpandingDotsEffect(
                  dotColor: Colors.grey,
                  spacing: 20,
                  activeDotColor: Colors.lightBlue,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Pharmacists",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
            FutureBuilder(
              future: pharmacistProvider.getT5Pharmacists(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  showErrorDialog(context, '${snapshot.error}');
                }
                List<PharmacistModel> t5Pharmacists =
                    pharmacistProvider.t5Pharmacists;
                return SizedBox(
                  height: 300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(5, (index) {
                      final pharmacist = t5Pharmacists[index];
                      return DoctorCardSmall(
                        pharmacist: pharmacist,
                      );
                    }),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
