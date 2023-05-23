import 'package:flutter/material.dart';

class DoctorCard extends StatefulWidget {
  const DoctorCard({Key? key}) : super(key: key);

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
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
                      const Text(
                        'Dr. Emmanuel Doke',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Burma Camp Pharmacy',
                        style: TextStyle(
                            fontSize: 15),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.star, color: Colors.yellow, size: 30,),
                          Spacer(flex: 1,),
                          Text('4.5'),
                          SizedBox(width: 10,),
                          Text('Reviews'),
                          Spacer(flex: 1,),
                          Text('(20)'),
                          Spacer(flex: 7,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: (){},
      ),
    );
  }
}
