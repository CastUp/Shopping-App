import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Providers/AuthProvider.dart';
import 'package:Shopping/Parts/Auth/SignIn.dart';
import 'package:Shopping/Parts/Auth/SignUp.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static const String splashScreen = "/splashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;
  bool stateAnimationTitle = false ;
  bool stateAnimationRegistrations = false ;
  String lang = "en" ;

  @override
  void initState() {
    super.initState();

    SaveLanguage.getLang().then((languageCode) => lang = languageCode);

    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.0, end: 0.9).animate(CurvedAnimation(parent: _controller, curve: Curves.linear))
      ..addListener(() {
        setState(() {});
      })..addStatusListener((status) {if(status == AnimationStatus.completed) setState(() {
        this.stateAnimationTitle = true ;
      });});
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size ;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/splashtow.jpg"),
                      fit: BoxFit.fill)),
              child: AnimatedOpacity(
                opacity: _animation.value,
                duration: Duration(seconds: 1),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                          tileMode: TileMode.repeated,
                          stops: [0.1, 0.9])),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1300),
                    curve: Curves.linear,
                    onEnd: ()=> setState(()=> this.stateAnimationRegistrations = true) ,
                    margin: EdgeInsets.only(top: this.stateAnimationTitle ? Constants.screenHeightSize(context, size.height*.08 , size.height*.12) : 0.0),
                    child: Text("Welcome\nTo\nShopping App" ,
                        style: TextStyle(fontSize: Constants.screenHeightSize(context, 35 , 50) , color: Colors.white,fontFamily: Constants.splashFontEn,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: Constants.screenHeightSize(context, size.height*.13 , size.height*.16),),
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 1500),
                    curve: Curves.easeInSine,
                    opacity: this.stateAnimationRegistrations? 1.0 : 0.0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.10),
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("assets/images/google_icon.png",filterQuality: FilterQuality.high,width:35,height: 35,),
                            SizedBox(width: 12,),
                            Text("SignIn with Google" ,style: TextStyle(color: Colors.black,fontSize: Constants.screenHeightSize(context, 15, 18)),)
                          ],
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20 ,vertical:8)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>
                            (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30) ,
                              side: BorderSide(color: Colors.lightBlue.shade200,width: 0.5))),
                          elevation: MaterialStateProperty.all<double>(4),
                        ),
                        onPressed: ()async =>await Provider.of<AuthProvider>(context,listen: false).signInWithGoogle(context),
                      ),
                    )
                  ),
                  SizedBox(height: size.height*.03,),
                  AnimatedOpacity(
                      duration: Duration(milliseconds: 1500),
                      curve: Curves.easeInSine,
                      opacity: this.stateAnimationRegistrations? 1.0 : 0.0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.10),
                        child: TextButton(
                          child: Center(child: Constants.arabicFont(text: SetLocalization.of(context)!.getTranslateValue(Keys.splashSingIn)!,
                              size: Constants.screenHeightSize(context, lang.contains("en")? 17.0 : 18.5,lang.contains("en")? 22.0 : 23),color: Colors.white ,lang: lang)),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical:14.50)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>
                              (RoundedRectangleBorder(borderRadius: BorderRadius.circular(30) ,
                                side: BorderSide(color: Colors.white,width: 1.0))),
                            elevation: MaterialStateProperty.all<double>(4),
                          ),
                          onPressed: ()=> Navigator.pushReplacementNamed(context, SignIn.SIGNIN),
                        ),
                      )
                  ),
                  SizedBox(height: size.height*.07,),
                  AnimatedOpacity(
                      duration: Duration(milliseconds: 1500),
                      curve: Curves.easeInSine,
                      opacity: this.stateAnimationRegistrations? 1.0 : 0.0,
                      child: Container(
                        alignment: Alignment.center,
                        child: Constants.arabicFont(text: SetLocalization.of(context)!.getTranslateValue(Keys.splashDontAccount)!,
                            size: Constants.screenHeightSize(context, lang.contains("en")? 17.0 : 18.5,lang.contains("en")? 22.0 : 24),color: Colors.white.withOpacity(0.65) ,lang: lang)
                      )
                  ),
                  SizedBox(height: size.height*.04,),
                  AnimatedOpacity(
                      duration: Duration(milliseconds: 1500),
                      curve: Curves.easeInSine,
                      opacity: this.stateAnimationRegistrations? 1.0 : 0.0,
                      child: InkWell(
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: Constants.arabicFont(text: SetLocalization.of(context)!.getTranslateValue(Keys.splashCreate)!,
                                size: Constants.screenHeightSize(context, lang.contains("en")? 17.0 : 18.5,lang.contains("en")? 22.0 : 24),color: Colors.white.withOpacity(0.8) ,lang: lang)
                        ),
                        onTap: () => Navigator.pushReplacementNamed(context, SignUp.SIGNUP),
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
