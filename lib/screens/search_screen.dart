import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utilities/appbar_widget.dart';
import '../utilities/appointment_card.dart';
import '../utilities/doctor_card.dart';
import '../utilities/drawer_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DateTime now = DateTime.now();
  String patient = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    Timestamp today =
        Timestamp.fromDate(DateTime.utc(now.year, now.month, now.day));
    return Scaffold(
      appBar: appbarWidget('Search'),
      drawer: drawerWidget(context),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SearchAnchor(builder: (context, SearchController controller) {
              return SearchBar(
                controller: controller,
                hintText: 'Search for pharmacists and pharmacies near you',
                hintStyle: MaterialStateProperty.all(
                    const TextStyle(color: Colors.grey)),
                elevation: MaterialStateProperty.all(1),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 8)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            }, suggestionsBuilder: (context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'pharmacist ${index + 1}';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            }),
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
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('patient', isEqualTo: patient)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  final appointments = snapshot.data!.docs;
                  if (appointments.isNotEmpty) {
                    final todayAppointments = appointments.where((appointment) {
                      Timestamp firestoreTimestamp = appointment['date'];
                      return firestoreTimestamp.toDate().isAtSameMomentAs(
                            DateTime(now.year, now.month, now.day, 0, 0, 0),
                          );
                    }).toList();
                    if (todayAppointments.isNotEmpty) {
                      return Column(
                        children: todayAppointments.map((appointment) {
                          return AppointmentCard(
                            date: appointment['date'] ?? today,
                            patient: patient,
                            pharmacist: appointment['pharmacist'] ?? '',
                            pharmacy: appointment['pharmacy'] ?? '',
                            time: appointment['time'] ?? '',
                          );
                        }).toList(),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          "You don't have any appointments today",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  } else {
                    return const SizedBox(height: 1);
                  }
                } else {
                  return const SizedBox(height: 1);
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text(
                  "Top Pharmacists",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container()),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SeeMore();
                    }));
                  },
                  child: const Text(
                    'See More...',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 1000,
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
                    try {
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
                    } catch (e) {
                      return const SizedBox();
                    }
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

class SeeMore extends StatelessWidget {
  const SeeMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Icon(
          Icons.local_pharmacy_outlined,
          color: Colors.lightBlue,
          size: 30,
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('pharmacists').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            final pharmacists = snapshot.data!.docs;
            return ListView(
              children: List.generate(pharmacists.length, (index) {
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
    );
  }
}
