import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/models/appointment_model.dart';
import 'package:health_watch/models/pharmacist_model.dart';
import 'package:health_watch/providers/appointment_provider.dart';
import 'package:health_watch/providers/pharmacist_provider.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';
import 'package:provider/provider.dart';
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

  Future<void> loadData() async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacistProvider =
        Provider.of<PharmacistProvider>(context, listen: false);
    List<PharmacistModel> t5Pharmacists = pharmacistProvider.t5Pharmacists;
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    List<AppointmentModel> appointments = appointmentProvider.appointments;
    List<AppointmentModel> todayAppointments = [];
    for (AppointmentModel appointmentModel in appointments) {
      if (appointmentModel.date
          .isAtSameMomentAs(DateTime(now.year, now.month, now.day, 0, 0, 0))) {
        todayAppointments.add(appointmentModel);
      } else {
        continue;
      }
    }
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
            FutureBuilder(
              future: appointmentProvider.getUserAppointments(patient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                } else if (snapshot.hasError) {
                  showErrorDialog(context, '${snapshot.error}');
                }
                return todayAppointments.isNotEmpty
                    ? Column(
                        children: todayAppointments.map((appointment) {
                          return AppointmentCard(
                            appointment: appointment,
                          );
                        }).toList(),
                      )
                    : const Center(
                        child: Text(
                          "You don't have any appointments today",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const SeeMore();
                      }),
                    );
                  },
                  child: const Text(
                    'See More...',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: pharmacistProvider.getT5Pharmacists(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const SizedBox();
                }
                else if(snapshot.hasError){
                  showErrorDialog(context, '${snapshot.error}');
                }
                return Column(
                  children: List.generate(5, (index) {
                    final pharmacist = t5Pharmacists[index];
                    return DoctorCard(
                      pharmacist: pharmacist,
                    );
                  }),
                );
              },
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
    final pharmacistProvider =
        Provider.of<PharmacistProvider>(context, listen: false);
    List<PharmacistModel> pharmacists = pharmacistProvider.pharmacists;
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
      body: FutureBuilder(
        future: pharmacistProvider.getPharmacists(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const SizedBox();
          }
          else if(snapshot.hasError){
            showErrorDialog(context, '${snapshot.error}');
          }
          return ListView(
            children: List.generate(pharmacists.length, (index) {
              final pharmacist = pharmacists[index];
              return DoctorCard(
                pharmacist: pharmacist,
              );
            }),
          );
        },
      ),
    );
  }
}
