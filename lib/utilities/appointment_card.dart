import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/models/appointment_model.dart';
import 'package:health_watch/providers/appointment_provider.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({Key? key, required this.appointment})
      : super(key: key);

  final AppointmentModel appointment;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool isUpcoming = true;
  bool isCompleted = false;
  bool isCanceled = false;

  void showError(String text) {
    showErrorDialog(context, text);
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.lightBlue, borderRadius: BorderRadius.circular(10)),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/user.jpg'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${widget.appointment.pharmacist}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.appointment.pharmacy,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ScheduleCard(
                    date: widget.appointment.date,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: isCanceled
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, elevation: 0),
                                child: const Text(
                                  'Canceled',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'The appointment has already been canceled',
                                      ),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          appointmentProvider.updateStatus(
                                              widget.appointment, 'upcoming');
                                          setState(
                                            () {
                                              isUpcoming = true;
                                              isCanceled = false;
                                            },
                                          );
                                          pushRoute(context, homescreenRoute);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, elevation: 0),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  appointmentProvider.updateStatus(
                                      widget.appointment, 'canceled');
                                  setState(() {
                                    isCanceled = true;
                                    isUpcoming = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'The appointment has been canceled',
                                      ),
                                    ),
                                  );
                                  pushRoute(context, homescreenRoute);
                                },
                              ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: isCompleted
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Completed',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'The appointment has already been completed',
                                      ),
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () {
                                          appointmentProvider.updateStatus(
                                              widget.appointment, 'upcoming');
                                          setState(
                                            () {
                                              isUpcoming = true;
                                              isCompleted = false;
                                            },
                                          );
                                          pushRoute(context, homescreenRoute);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Complete',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  appointmentProvider.updateStatus(
                                      widget.appointment, 'completed');
                                  setState(
                                    () {
                                      isCompleted = true;
                                      isUpcoming = false;
                                    },
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'The appointment has been completed',
                                      ),
                                    ),
                                  );
                                  pushRoute(context, homescreenRoute);
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.date})
      : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    DateFormat timeFormat = DateFormat('hh:mm a');
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            dateFormat.format(date),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Spacer(),
          const Icon(
            Icons.access_alarm_outlined,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              timeFormat.format(date),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
