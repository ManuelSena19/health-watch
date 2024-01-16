import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/providers/appointment_provider.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final email = FirebaseAuth.instance.currentUser!.email.toString();
  List _appointments = [];
  List _appointmentDates = [];
  Map<DateTime, String> _events = {};

  @override
  Widget build(BuildContext context) {
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    appointmentProvider.getUserAppointments(email);
    _appointments = appointmentProvider.appointments;
    print(_appointments);
    print(_appointmentDates);
    return Scaffold(
      appBar: appbarWidget('Calendar', Colors.transparent),
      drawer: drawerWidget(context),
      body: ListView(
        children: [
          Builder(builder: (context) {
            if (_appointments.isEmpty) {
              return TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030),
              );
            } else {
              return TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030),
              );
            }
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushRoute(context, searchRoute);
        },
        elevation: 0,
        child: const Icon(Icons.add_business_outlined),
      ),
    );
  }
}
