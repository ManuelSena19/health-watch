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
      appBar: appbarWidget('Chat'),
      drawer: drawerWidget(context),
      body: const Placeholder(),
    );
  }
}
