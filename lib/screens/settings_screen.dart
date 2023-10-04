import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/utilities/appbar_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget('Settings'),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(
              Icons.person_outline,
              color: Colors.lightBlue,
              size: 30,
            ),
            title: const Text(
              'Your account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'See information about your account and learn about account deactivation options',
            ),
            tileColor: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.lock_outline,
              color: Colors.lightBlue,
              size: 30,
            ),
            title: const Text(
              'Security and account access',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Manage your account's security and keep track of your account usage",
            ),
            tileColor: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_outlined,
              color: Colors.lightBlue,
              size: 30,
            ),
            title: const Text(
              'Privacy and safety',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Manage what information you see and share on Health Watch",
            ),
            tileColor: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.notifications_outlined,
              color: Colors.lightBlue,
              size: 30,
            ),
            title: const Text(
              'Notifications',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Select the kinds of notifications you get about your activities and recommendations",
            ),
            tileColor: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.display_settings_outlined,
              color: Colors.lightBlue,
              size: 30,
            ),
            title: const Text(
              'Accessibility and display',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Manage how content on Health Watch is displayed to you",
            ),
            tileColor: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.contact_phone_outlined,
              color: Colors.lightBlue,
              size: 30,
            ),
            title: const Text(
              'Contact us',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Contact the Health Watch team to make enquiries about the app or report bugs",
            ),
            tileColor: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.info_outline,
              color: Colors.lightBlue,
              size: 30,
            ),
            title: const Text(
              'About',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Get information about the Health Watch app and the team",
            ),
            tileColor: Colors.white,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(
              Icons.help_outline,
              color: Colors.lightBlue,
              size: 30,
            ),
            title: const Text(
              'Help and additional resources',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "Check out other helpful information to learn more about Health Watch and our other services",
            ),
            tileColor: Colors.white,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
