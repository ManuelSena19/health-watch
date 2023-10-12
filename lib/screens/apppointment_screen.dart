import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/appointment_card.dart';
import 'package:health_watch/utilities/doctor_card.dart';
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
      appBar: appbarWidget('Appointments'),
      drawer: drawerWidget(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Today",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const AppointmentCard(),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Top Pharmacists",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 2000,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('pharmacists')
                    .orderBy('rating', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    final pharmacists = snapshot.data!.docs;
                    return Column(
                      children: List.generate(5, (index) {
                        final pharmacist = pharmacists[index];
                        return DoctorCard(
                          name: pharmacist['name'] ?? '',
                          pharmacy: pharmacist['pharmacy'] ?? '',
                          rating: pharmacist['rating'] ?? 0.0,
                        );
                      }),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
