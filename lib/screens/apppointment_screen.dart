import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/models/appointment_model.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/appointment_card.dart';
import 'package:health_watch/utilities/drawer_widget.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

enum FilterStatus { upcoming, completed, canceled }

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final String _name = FirebaseAuth.instance.currentUser!.email.toString();
  List<String> filters = ['upcoming', 'completed', 'canceled'];
  int index = 0;
  FilterStatus status = FilterStatus.upcoming;
  String statusString = 'upcoming';
  List<AppointmentModel> filteredAppointments = [];
  late AppointmentProvider appointmentProvider;
  List<AppointmentModel> appointments = [];

  Future<DateTime?> pickDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.utc(2025),
    );
  }

  Future<TimeOfDay?> pickTime() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: TimeOfDay.now().hour,
        minute: TimeOfDay.now().minute,
      ),
    );
  }

  void showError(String error) {
    showErrorDialog(context, error);
  }

  void push(String route) {
    pushRoute(context, route);
  }

  @override
  void initState() {
    super.initState();
    appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    appointments = appointmentProvider.appointments;
    filteredAppointments =
        appointmentProvider.filterAppointments(appointments, statusString);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: appointmentProvider.getUserAppointments(_name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasError) {
          showErrorDialog(context, '${snapshot.error}');
        }
        return appointments.isNotEmpty
            ? Scaffold(
                appBar: appbarWidget('Appointments', Colors.transparent),
                drawer: drawerWidget(context),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Appointment Schedule',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SegmentedButton(
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment(
                                value: FilterStatus.upcoming,
                                label: Text('Upcoming')),
                            ButtonSegment(
                                value: FilterStatus.completed,
                                label: Text('Completed')),
                            ButtonSegment(
                                value: FilterStatus.canceled,
                                label: Text('Canceled')),
                          ],
                          selected: <FilterStatus>{status},
                          onSelectionChanged: (Set<FilterStatus> newSelection) {
                            setState(() {
                              status = newSelection.first;
                              if (status == FilterStatus.upcoming) {
                                statusString = 'upcoming';
                              } else if (status == FilterStatus.completed) {
                                statusString = 'completed';
                              } else if (status == FilterStatus.canceled) {
                                statusString = 'canceled';
                              }
                              try {
                                filteredAppointments =
                                    appointmentProvider.filterAppointments(
                                        appointments, statusString);
                              } catch (e) {
                                showErrorDialog(
                                    context, "You don't have any appointments");
                              }
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        filteredAppointments.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: appointments.length,
                                  itemBuilder: (context, index) {
                                    try {
                                      AppointmentModel schedule =
                                          filteredAppointments[index];
                                      bool isLastElement =
                                          filteredAppointments.length + 1 ==
                                              index;
                                      return Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        margin: !isLastElement
                                            ? const EdgeInsets.only(bottom: 20)
                                            : EdgeInsets.zero,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  const CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                      'assets/user.jpg',
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Dr. ${schedule.pharmacist}',
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        schedule.pharmacy,
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              ScheduleCard(
                                                date: schedule.date,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              schedule.status == 'upcoming'
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: OutlinedButton(
                                                            onPressed: () {
                                                              appointmentProvider
                                                                  .updateStatus(
                                                                      schedule,
                                                                      'canceled');
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                    'The appointment has been canceled',
                                                                  ),
                                                                ),
                                                              );
                                                              push(homescreenRoute);
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .lightBlueAccent,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: OutlinedButton(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .lightBlueAccent,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              final date =
                                                                  await pickDate();
                                                              if (date ==
                                                                  null) {
                                                                showError(
                                                                    'Please enter a date');
                                                              } else {
                                                                final time =
                                                                    await pickTime();
                                                                if (time ==
                                                                    null) {
                                                                  showError(
                                                                      'Please enter a time');
                                                                } else {
                                                                  DateTime dateTime = DateTime(
                                                                      date.year,
                                                                      date.month,
                                                                      date.day,
                                                                      time.hour,
                                                                      time.minute);
                                                                  appointmentProvider
                                                                      .rescheduleAppointment(
                                                                          schedule,
                                                                          dateTime);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                          'Your appointment has been scheduled for $date at $time'),
                                                                    ),
                                                                  );
                                                                  push(homescreenRoute);
                                                                }
                                                              }
                                                            },
                                                            child: const Text(
                                                              'Reschedule',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox(height: 5)
                                            ],
                                          ),
                                        ),
                                      );
                                    } on RangeError {
                                      return const SizedBox();
                                    } catch (e) {
                                      log('Error: $e');
                                      rethrow;
                                    }
                                  },
                                ),
                              )
                            : const SizedBox(
                                height: 5,
                                width: 5,
                              ),
                      ],
                    ),
                  ),
                ),
              )
            : Scaffold(
                appBar: appbarWidget('Appointments', Colors.transparent),
                body: Center(
                  child: SizedBox(
                    width: 500,
                    height: 200,
                    child: Column(
                      children: [
                        const Text(
                          "You don't have any appointments yet",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            pushRoute(context, searchRoute);
                          },
                          style: ElevatedButton.styleFrom(elevation: 0),
                          child: const Text('Find Pharmacists'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
