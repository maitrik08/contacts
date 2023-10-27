import 'package:flutter/material.dart';

class ISOProvider extends ChangeNotifier {
  int currentIndex = 0;
  void changeIndex(int value) {
    currentIndex = value;
    notifyListeners();
  }
}