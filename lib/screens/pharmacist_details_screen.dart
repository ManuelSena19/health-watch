import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/constants/user_data.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';

class PharmacistDetailsScreen extends StatefulWidget {
  const PharmacistDetailsScreen({Key? key, required this.name})
      : super(key: key);

  final String name;

  @override
  State<PharmacistDetailsScreen> createState() =>
      _PharmacistDetailsScreenState();
}

class _PharmacistDetailsScreenState extends State<PharmacistDetailsScreen> {
  bool isFav = false;
  String _pharmacistName = '';
  String _pharmacy = '';

  @override
  Widget build(BuildContext context) {
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

    void push(String route){
      pushRoute(context, route);
    }

    Future<void> bookAppointment(DateTime? date, String patient,
        String pharmacist, String pharmacy, String status, String time) async {
      final CollectionReference appointments =
          FirebaseFirestore.instance.collection('appointments');
      try {
        await appointments.doc().set({
          'date': date,
          'patient': patient,
          'pharmacist': pharmacist,
          'pharmacy': pharmacy,
          'status': status,
          'time': time
        });
      } catch (error) {
        showError('$error');
      }
    }

    return Scaffold(
      appBar: appbarWidget("Pharmacist Details"),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SafeArea(
            child: Column(
              children: [
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                  future: getPharmacistInfo(widget.name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final pharmacistInfo = snapshot.data!;
                      final String certification =
                          pharmacistInfo['certification'] as String? ?? '';
                      final String pharmacy =
                          pharmacistInfo['pharmacy'] as String? ?? '';
                        _pharmacistName = widget.name;
                        _pharmacy = pharmacy;
                      final int id = pharmacistInfo['id'] as int? ?? 0;
                      return SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.lightBlue, Colors.white],
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundImage:
                                        AssetImage('assets/user.jpg'),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isFav = !isFav;
                                        });
                                      },
                                      icon: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.menu),
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Dr ${widget.name}",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Icon(
                                  Icons.verified,
                                  color: Colors.lightBlue,
                                  size: 25,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.numbers,
                                  color: Colors.lightBlue,
                                ),
                                Text(
                                  '$id',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              certification,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 15),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              pharmacy,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
                  future: getPharmacistInfo(widget.name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final pharmacistInfo = snapshot.data!;
                    final String about =
                        pharmacistInfo['about'] as String? ?? '';
                    return Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          FutureBuilder<
                              DocumentSnapshot<Map<String, dynamic>>?>(
                            future: getPharmacistInfo(widget.name),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              final pharmacistInfo = snapshot.data!;
                              final String patients =
                                  pharmacistInfo['patients'] as String? ?? '';
                              final String experience =
                                  pharmacistInfo['experience'] as String? ?? '';
                              final double rating =
                                  pharmacistInfo['rating'] as double? ?? 0.0;
                              return Row(
                                children: [
                                  InfoCard(label: 'Patients', value: patients),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InfoCard(
                                      label: 'Experience',
                                      value: '$experience years'),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InfoCard(label: 'Rating', value: '$rating'),
                                ],
                              );
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            'About',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            about,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, height: 1.5),
                            softWrap: true,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () async {
                      final date = await pickDate();
                      if (date == null) {
                        showError('Please enter a date');
                      }
                      else{
                        final time = await pickTime();
                        if (time == null) {
                          showError('Please enter a time');
                        }
                        else{
                          String selectedTime = '${time.hour}:${time.minute}';
                          String patient =
                          FirebaseAuth.instance.currentUser!.email.toString();
                          String pharmacist = _pharmacistName;
                          String pharmacy = _pharmacy;
                          String status = 'upcoming';
                          await bookAppointment(date, patient, pharmacist, pharmacy,
                              status, selectedTime);
                          push(successRoute);
                        }
                      }
                    },
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                    ),
                    child: const Text("Book appointment"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({Key? key, required this.label, required this.value})
      : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.lightBlue),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
