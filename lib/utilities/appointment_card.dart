import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard(
      {Key? key,
      required this.date,
      required this.patient,
      required this.pharmacist,
      required this.pharmacy,
      required this.time})
      : super(key: key);

  final Timestamp date;
  final String patient;
  final String pharmacist;
  final String pharmacy;
  final String time;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  bool isUpcoming = true;
  bool isCompleted = false;
  bool isCanceled = false;
  Future<void> updateStatus(String newStatus) async {
    try {
      final appointmentRef =
          FirebaseFirestore.instance.collection('appointments');

      QuerySnapshot querySnapshot = await appointmentRef
          .where('patient', isEqualTo: widget.patient)
          .where('pharmacy', isEqualTo: widget.pharmacy)
          .where('pharmacist', isEqualTo: widget.pharmacist)
          .where('date', isEqualTo: widget.date)
          .where('time', isEqualTo: widget.time)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final appointmentDoc = querySnapshot.docs.first;
        await appointmentDoc.reference.update({'status': newStatus});
      }
    } catch (error) {
      showError('$error');
    }
  }

  void showError(String text) {
    showErrorDialog(context, text);
  }

  @override
  Widget build(BuildContext context) {
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
                            widget.pharmacist,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.pharmacy,
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
                    date: widget.date,
                    time: widget.time,
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
                                          updateStatus('upcoming');
                                          setState(
                                            () {
                                              isUpcoming = true;
                                              isCanceled = false;
                                            },
                                          );
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
                                  updateStatus('canceled');
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
                                          updateStatus('upcoming');
                                          setState(
                                            () {
                                              isUpcoming = true;
                                              isCompleted = false;
                                            },
                                          );
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
                                  updateStatus('completed');
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
  const ScheduleCard({Key? key, required this.date, required this.time})
      : super(key: key);

  final Timestamp date;
  final String time;

  @override
  Widget build(BuildContext context) {
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
            '${date.toDate().day}/${date.toDate().month}/${date.toDate().year}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Expanded(child: Container()),
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
            '${time}0',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ))
        ],
      ),
    );
  }
}
