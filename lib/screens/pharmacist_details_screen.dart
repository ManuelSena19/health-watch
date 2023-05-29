import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:health_watch/utilities/appbar_widget.dart';
import 'package:health_watch/utilities/drawer_widget.dart';

class PharmacistDetailsScreen extends StatefulWidget {
  const PharmacistDetailsScreen({Key? key}) : super(key: key);

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
                const About(),
                const Details(),
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

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: const [
          CircleAvatar(
            radius: 65,
            backgroundImage: AssetImage('assets/user.jpg'),
            backgroundColor: Colors.white,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Dr Emmanuel Doke",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Pharm. D (KNUST)",
            style: TextStyle(color: Colors.grey, fontSize: 15),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Burma Camp Pharmacy",
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Details extends StatelessWidget {
  const Details({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(
            height: 15,
          ),
          Status(),
          SizedBox(
            height: 40,
          ),
          Text(
            'About',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum eget sapien pretium, aliquet nisl at, viverra lectus. Nulla nec tellus ac lacus pulvinar scelerisque sed ac odio. Sed ultrices ligula at quam fringilla eleifend. Suspendisse ut justo consequat, aliquet urna sed, ultrices mauris.",
            style: TextStyle(fontWeight: FontWeight.bold, height: 1.5),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

class Status extends StatelessWidget {
  const Status({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        InfoCard(label: 'Patients', value: '100'),
        SizedBox(
          width: 15,
        ),
        InfoCard(label: 'Experience', value: '10 years'),
        SizedBox(
          width: 15,
        ),
        InfoCard(label: 'Rating', value: '4.5'),
      ],
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
