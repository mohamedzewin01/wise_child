import 'package:flutter/material.dart';
import 'package:wise_child/features/Home/presentation/pages/Home_page.dart';
import 'package:wise_child/features/Settings/presentation/pages/Settings_page.dart';
import 'package:wise_child/features/Stories/presentation/pages/Stories_page.dart';
import '../../features/Children/presentation/pages/Children_page.dart';

class AppConstants {
  static const int listGenerate = 6;
  static const String version = 'v1.1.10';
  static const String collection = 'OrdersInfo';
  static const viewOptions = [
    HomePage(),
    ChildrenPage(),
    StoriesPage(),
    SettingsPage(),

  ];
}
