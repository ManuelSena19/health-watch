import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/models/appointment_model.dart';
import 'package:health_watch/providers/appointment_provider.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final email = FirebaseAuth.instance.currentUser!.email.toString();
  List<AppointmentModel> _appointments = [];
  Map<DateTime, List<String>> _events = {};

  @override
  Widget build(BuildContext context) {
    final appointmentProvider =
    Provider.of<AppointmentProvider>(context, listen: false);
    return Scaffold(
      appBar: appbarWidget('Calendar', Colors.transparent),
      drawer: drawerWidget(context),
      body: FutureBuilder(
        future: appointmentProvider.getUserAppointments(email),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showErrorDialog(context, '${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          _appointments = appointmentProvider.appointments;
          print(_appointments);
          _events = {};
          for (var appointment in _appointments) {
            DateTime date = appointment.date;
            _events[date] ??= [];
            _events[date] = ['Dr. ${appointment.pharmacist}'];
          }
          print(_events);
          return ListView(
            children: [
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030),
                eventLoader: (date) => _events[date] ?? [],
              )
            ],
          );
        },
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