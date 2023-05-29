import 'package:flutter/material.dart';
import 'package:health_watch/constants/push_routes.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:lottie/lottie.dart';

class AppointmentBooked extends StatelessWidget {
  const AppointmentBooked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Lottie.asset("assets/9917-success.json", height: 250),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Successfully Booked Appointment',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  fixedSize: MaterialStateProperty.all(
                      const Size(double.infinity, 30)),
                ),
                onPressed: () {
                  pushReplacementRoute(context, homescreenRoute);
                },
                child: const Text('Back to Home'),
              ),
            ),
            const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
