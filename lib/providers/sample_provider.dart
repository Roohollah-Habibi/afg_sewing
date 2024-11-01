

import 'package:flutter/material.dart';

class SampleProvider extends ChangeNotifier{
  List<String> _images = [];
  bool _showFullScreen = false;
  int _selectedIndex = 0;

  bool get getFullScreen => _showFullScreen;
  int get getSelectedOrderIndex => _selectedIndex;
  List<String> get imgList => _images;

  void replaceNewImageList(List<String> newList){
    _images = newList;
  }

  void setFullScreen({required bool show,int selectedIndex = 0}){
    _showFullScreen = show;
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

}