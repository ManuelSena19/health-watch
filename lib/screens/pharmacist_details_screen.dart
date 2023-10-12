import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/constants/user_data.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/drawer_widget.dart';

class PharmacistDetailsScreen extends StatefulWidget {
  const PharmacistDetailsScreen({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  State<PharmacistDetailsScreen> createState() =>
      _PharmacistDetailsScreenState();
}

class _PharmacistDetailsScreenState extends State<PharmacistDetailsScreen> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget("Pharmacist Details"),
      drawer: drawerWidget(context),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 350,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isFav = !isFav;
                  });
                },
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.red,
                  size: 30,
                ),
              ),
            ],
          ),
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
                    }
                    else if(snapshot.hasError){
                      return Text('Error: ${snapshot.error}');
                    }
                    else{
                      final pharmacistInfo = snapshot.data!;
                      final String certification =
                          pharmacistInfo['certification'] as String? ?? '';
                      final String pharmacy =
                          pharmacistInfo['pharmacy'] as String? ?? '';
                      final int id = pharmacistInfo['id'] as int? ?? 0;
                      return SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 65,
                              backgroundImage: AssetImage('assets/user.jpg'),
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Dr ${widget.name}",
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
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
                    }
                    else if(snapshot.hasError){
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
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: CircularProgressIndicator(),
                                );
                              }
                              else if(snapshot.hasError){
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
                    onPressed: () {
                      pushRoute(context, calendarRoute);
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
