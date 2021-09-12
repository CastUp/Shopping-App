import 'package:flutter/material.dart';

class Languages with ChangeNotifier{

  bool _changeLang = false ;

  bool get changeLang => _changeLang ;

  set changeLang(bool lang){
    _changeLang = lang ;
    notifyListeners();
  }


}