import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Parts/Auth/SignIn.dart';
import 'package:Shopping/Parts/Auth/SignUp.dart';
import 'package:Shopping/Parts/Splash/SplashScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OpenMainSplashScreen extends StatefulWidget {

  static const String openMainSplashScreen = "/openMainSplashScreen";

  @override
  _OpenMainSplashScreenState createState() => _OpenMainSplashScreenState();
}

class _OpenMainSplashScreenState extends State<OpenMainSplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation ;
  bool _stateAnimationContinuation = false ;

  List images = [
    "https://firebasestorage.googleapis.com/v0/b/full-ecommerce-5f7a1.appspot.com/o/splashImages%2Fjon-ly-Xn7GvimQrk8-unsplash.jpg?alt=media&token=2d34070f-baf6-4a3d-ab2a-ee86160a3d7b",
    "https://firebasestorage.googleapis.com/v0/b/full-ecommerce-5f7a1.appspot.com/o/splashImages%2Fashkan-forouzani-c6597HEP82E-unsplash.jpg?alt=media&token=e9b458ee-9cdf-468d-b143-8a070ba6583d",
    "https://firebasestorage.googleapis.com/v0/b/full-ecommerce-5f7a1.appspot.com/o/splashImages%2Fjoel-mott-c6-9Cqpl6LA-unsplash.jpg?alt=media&token=957e3ed5-5c41-4ecb-873b-42abb6cf5c7f",
    "https://firebasestorage.googleapis.com/v0/b/full-ecommerce-5f7a1.appspot.com/o/splashImages%2Fsam-WgKIF62qvbo-unsplash.jpg?alt=media&token=5394ea5c-ef6d-47d5-818e-87a6dcb52eb8"];


  @override
  void initState() {
    super.initState();
    images.shuffle();
    _controller = AnimationController(vsync: this ,duration: Duration(seconds: 15));
    _animation  = CurvedAnimation(parent: _controller , curve: Curves.linear)..addListener(() {setState(() {});})
                  ..addStatusListener((status) {
                    if(status == AnimationStatus.completed){
                      _controller.reset();
                      _controller.forward();
                    }else if(status == AnimationStatus.reverse){
                      setState(()=> _stateAnimationContinuation = !_stateAnimationContinuation);
                    }
                  });
    _controller.repeat(reverse: true);

  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size ;

    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: images[1],
            errorWidget: (context , url , error )=> Image.network("https://firebasestorage.googleapis.com/v0/b/full-ecommerce-5f7a1.appspot.com/o/splashImages%2Fjon-ly-Xn7GvimQrk8-unsplash.jpg?alt=media&token=2d34070f-baf6-4a3d-ab2a-ee86160a3d7b",
              fit: BoxFit.cover,),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset(_animation.value , 0.0),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .15 , left: 10 , right: 10),
                  child: Text("Welcome To Shopping App",
                    style: TextStyle(color: Colors.yellow.shade800,fontSize: Constants.screenHeightSize(context, 30 , 40) ,fontWeight: FontWeight.bold,fontFamily: Constants.splashFontEn),maxLines: 1,),
                ),
                SizedBox(height: Constants.screenHeightSize(context, 42 , 50),),
                Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(.5),
                    radius:Constants.screenHeightSize(context, 50 , 60),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset("assets/images/shoping_sale.png" ,filterQuality: FilterQuality.high,),
                    ),
                  ),
                ),
                SizedBox(height: Constants.screenHeightSize(context, size.height*.20 , size.height*.25),),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  height: size.height * .20,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(.35),
                        Colors.black12
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.mirror
                    )
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(.02),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedDefaultTextStyle(
                          duration: Duration(seconds: 10),
                          curve: Curves.linear,
                          style: TextStyle(color: _stateAnimationContinuation ? Colors.orange.shade800:Colors.white,
                            fontSize: Constants.screenHeightSize(context, 28.0 , 35.0),fontWeight: FontWeight.bold,fontFamily: Constants.ubuntuRegularFont),
                          child: Text("Continue"),
                        )
                      ),
                      onTap: ()=>Navigator.of(context).popAndPushNamed(SplashScreen.splashScreen),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

