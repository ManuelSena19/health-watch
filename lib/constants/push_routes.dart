import 'package:flutter/material.dart';

void pushRoute(BuildContext context, String route){
  Navigator.pushNamed(context, route);
}

void pushReplacementRoute(BuildContext context, String route){
  Navigator.pushReplacementNamed(context, route);
}