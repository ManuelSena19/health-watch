import 'package:flutter/material.dart';
import 'package:health_watch/utilities/appointment_card.dart';
import 'package:health_watch/utilities/drawer_widget.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        title: const Text('Appointments'),
      ),
      drawer: drawerWidget(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: const [
            AppointmentCard()
          ],
        ),
      ),
    );
  }
}
