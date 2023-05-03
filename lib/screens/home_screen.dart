import 'package:flutter/material.dart';
import 'package:health_watch/utilities/drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: const Text("Health Watch"),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_outlined))
        ],
      ),
      drawer: drawerWidget(),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const SizedBox(height: 15,),
          Stack(
            children: [
              const Image(
                image: AssetImage('assets/home.jpeg'),
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  width: 600,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Click here to talk to a licensed pharmacist',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          const Divider(
            height: 10,
            thickness: 3,
          ),
          const SizedBox(height: 5,),
          Stack(
            children: [
              const Image(
                image: AssetImage('assets/calendar.jpg'),
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Container(
                  width: 600,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Click here to check your appointments',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
