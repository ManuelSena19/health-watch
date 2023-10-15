import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:table_calendar/table_calendar.dart';
import '../constants/user_data.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final email = FirebaseAuth.instance.currentUser!.email.toString();
  List _appointments = [];
  List _appointmentDates = [];

  Future<List<Map<String, dynamic>>?> getAppointmentsData(String name) async {
    List<DocumentSnapshot> appointmentSnapshots = await getAppointments(name);

    List<Map<String, dynamic>> appointmentsData =
        appointmentSnapshots.map((snapshot) {
      return snapshot.data() as Map<String, dynamic>;
    }).toList();
    return appointmentsData;
  }

  Future<void> setAppointments() async {
    List? appointments = await getAppointmentsData(email);
    setState(() {
      _appointments = appointments ?? [];
    });
    List dates = [];
    Timestamp timestamp = Timestamp(0, 0);
    if (_appointments.isNotEmpty) {
      for (final appointment in _appointments) {
        timestamp = appointment['date'];
        dates.add(timestamp.toDate());
      }
      setState(() {
        _appointmentDates = dates;
      });
    } else {
      const AlertDialog(
        title: Text('An error has occurred'),
        content: Text('No dates'),
      );
    }
  }

  @override
  void initState() {
    setAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget('Calendar'),
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
                selectedDayPredicate: (day) => _appointmentDates.contains(day),
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
