import 'package:flutter/material.dart';

class Account extends StatelessWidget {

  static const String ACCOUNT = "/Account";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(child: Center(child: Text("Account"),),),
    );
  }
}
