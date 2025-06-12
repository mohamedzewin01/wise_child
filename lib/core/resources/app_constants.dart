


import 'package:flutter/material.dart';
import '../../features/Children/presentation/pages/Children_page.dart';

class AppConstants {
  static const int listGenerate = 6;
  static const String version = 'v1.1.10';
  static const String collection = 'OrdersInfo';
  static const viewOptions = [
    ChildrenPage(),

    ChildrenPage(),
    Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    ),


  ];
}

