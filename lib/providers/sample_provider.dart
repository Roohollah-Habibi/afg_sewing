

import 'package:flutter/material.dart';

class SampleProvider extends ChangeNotifier{
  bool _showFullScreen = false;
  int _selectedIndex = 0;

  bool get getFullScreen => _showFullScreen;
  int get getSelectedOrderIndex => _selectedIndex;

  void setFullScreen({required bool show,int selectedIndex = 0}){
    _showFullScreen = show;
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

}