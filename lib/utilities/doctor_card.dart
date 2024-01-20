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
      height: 230,
      child: GestureDetector(
        child: Card(
          elevation: 3,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: 200,
                height: 230,
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
                          const SizedBox(
                            width: 10,
                          ),
                          Text('${pharmacist.rating}'),
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

class DoctorCardSmall extends StatelessWidget {
  const DoctorCardSmall({super.key, required this.pharmacist});

  final PharmacistModel pharmacist;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 230,
      width: 220,
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: Image.asset(
                "assets/user.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Text(
              'Dr. ${pharmacist.name}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.local_hospital_outlined,
                  color: Colors.lightBlue,
                ),
                Text(
                  pharmacist.pharmacy,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
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
