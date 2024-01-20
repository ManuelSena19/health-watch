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
  final ValueNotifier<Map<DateTime, List<String>>> _events = ValueNotifier({});
  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<dynamic> _getAppointmentsForDay(){
    List<String> appointments = _events.value[_selectedDay] ?? [];
    return appointments;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusDay){
    if(!isSameDay(_selectedDay, selectedDay)){
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusDay;
      });
    }
  }

  Future<void> loadEvents() async {
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    await appointmentProvider.getUserAppointments(email);
    _appointments = appointmentProvider.appointments;
    Map<DateTime, List<String>> events = {};
    for (var appointment in _appointments) {
      DateTime date = appointment.date;
      events[date] ??= [];
      events[date] = ['Dr. ${appointment.pharmacist}'];
    }
    _events.value = events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget('Calendar', Colors.transparent),
      drawer: drawerWidget(context),
      body: FutureBuilder(
        future: loadEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          } else if (snapshot.hasError) {
            showErrorDialog(context, '${snapshot.error}');
          }

          return ListView(
            children: [
              ValueListenableBuilder(
                valueListenable: _events,
                builder: (context, _, __) {
                  return TableCalendar(
                    focusedDay: _focusedDay,
                    onDaySelected: _onDaySelected,
                    firstDay: DateTime.now(),
                    lastDay: DateTime.utc(2030),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: (day) => _getAppointmentsForDay(),
                  );
                },
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
