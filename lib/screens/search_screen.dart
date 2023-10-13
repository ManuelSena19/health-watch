import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  Widget build(BuildContext context) {
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
            const AppointmentCard(),
            const SizedBox(
              height: 40,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context){
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
            const SizedBox(
              height: 20,
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

class SeeMore extends StatelessWidget {
  const SeeMore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Icon(Icons.local_pharmacy_outlined, color: Colors.lightBlue, size: 30,),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('pharmacists').snapshots(),
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

