import 'package:flutter/material.dart';

class Search extends StatelessWidget {

  static const String SEARCH = "/Search";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Center(child: Text("Search"),),),
    );
  }
}
