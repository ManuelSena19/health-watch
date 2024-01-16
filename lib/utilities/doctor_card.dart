import 'package:flutter/material.dart';
import 'package:health_watch/models/pharmacist_model.dart';
import 'package:health_watch/screens/pharmacist_details_screen.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key, required this.pharmacist}) : super(key: key);

  final PharmacistModel pharmacist;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 200,
      child: GestureDetector(
        child: Card(
          elevation: 3,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: 180,
                child: Image.asset(
                  "assets/user.jpg",
                  fit: BoxFit.fill,
                ),
              ),
              Flexible(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${pharmacist.name}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        pharmacist.pharmacy,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 30,
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Text('${pharmacist.rating}'),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Reviews'),
                          const Spacer(
                            flex: 1,
                          ),
                          const Text('(20)'),
                          const Spacer(
                            flex: 7,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PharmacistDetailsScreen(
                  pharmacist: pharmacist,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
