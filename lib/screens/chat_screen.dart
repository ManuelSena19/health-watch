import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/utilities/drawer_widget.dart';

import '../utilities/appbar_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget('Chats'),
      drawer: drawerWidget(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index){
            return const TextCard(
              imagePath: 'assets/user.jpg',
              senderName: 'Name',
              text: 'This is a text',
              time: '0:00',
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        child: const Icon(
          CupertinoIcons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  const TextCard(
      {super.key,
      required this.imagePath,
      required this.senderName,
      required this.text,
      required this.time});

  final String imagePath;
  final String senderName;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
        ),
      ),
      title: Row(
        children: [
          Text(
            senderName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue,
            ),
          ),
          Expanded(child: Container()),
          Text(
            time,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
      subtitle: Text(text),
      tileColor: Colors.white,
    );
  }
}
