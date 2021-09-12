import 'package:Shopping/Providers/AuthProvider.dart';
import 'package:Shopping/Parts/Auth/ForgetPassword.dart';
import 'package:Shopping/Parts/Auth/SignUp.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SignIn extends StatefulWidget {

  static const String SIGNIN = "/signIn";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  GlobalKey<FormState> _globalForm = GlobalKey<FormState>();
  bool hidePassword = true ;

  String? email ;
  String? password ;
  String lang = "en";

  void SignInUser() {

    FocusScope.of(context).unfocus();

    if(_globalForm.currentState!.validate()){

      _globalForm.currentState!.save();

      Provider.of<AuthProvider>(context,listen: false).signInWithEmailAndPassword(context, email: email!, password: password!);
    }
  }

  @override
  void initState() {
    SaveLanguage.getLang().then((langCode) => setState(()=>lang = langCode));
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    Size  sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: <Widget>[
              Container(
                height: sizeScreen.height,
                width: double.infinity,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: WaveWidget(
                    config: CustomConfig(
                      gradients: [
                        [Colors.blue.shade700, Colors.blue.shade500],
                        [Colors.white,Colors.white]
                      ],
                      durations: [19440, 10800],
                      heightPercentages: [0.20, 0.28],
                      blur: MaskFilter.blur(BlurStyle.solid, 20),
                      gradientBegin: Alignment.bottomLeft,
                      gradientEnd: Alignment.topRight,
                    ),
                    waveAmplitude: 0,
                    size: Size(
                        double.infinity,
                        double.infinity
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: sizeScreen.height *.10),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _globalForm,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.splashSingIn)!,
                          style: TextStyle(fontSize: Constants.screenHeightSize(context,28, 35) , fontWeight:lang.contains("en")? FontWeight.bold : FontWeight.w400,color: Colors.indigo,
                              fontFamily: lang.contains("en")? Constants.ubuntuRegularFont: Constants.splashArabicFont),),
                      ),
                      SizedBox(height: Constants.screenHeightSize(context,sizeScreen.height*.06, sizeScreen.height*.10),),
                      TextFormField(
                        maxLines: 1,
                        style: TextStyle(color: Colors.black,fontSize: 19),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey.shade100,
                          hintText: SetLocalization.of(context)!.getTranslateValue(Keys.email)!,
                          hintStyle: TextStyle(color: Colors.black38,fontSize: 17),
                          labelText: SetLocalization.of(context)!.getTranslateValue(Keys.email)!,
                          labelStyle: TextStyle(color: Colors.indigo,fontSize: 15),
                          prefixIcon: Icon(Icons.email,color: Colors.indigo,),
                        ),
                        validator: (val){

                          if(val!.trim().isEmpty)
                            return SetLocalization.of(context)!.getTranslateValue(Keys.formToastEmailEmpty)!;
                          else if(!RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(val.trim()))
                            return SetLocalization.of(context)!.getTranslateValue(Keys.formToastEmailCorrectly)!;
                          else
                            return null ;
                        },
                        onSaved: (val)=> setState(()=> this.email = val),
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        obscureText: hidePassword,
                        maxLines: 1,
                        style: TextStyle(color: Colors.black,fontSize: 19),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey.shade100,
                          hintText: SetLocalization.of(context)!.getTranslateValue(Keys.passWord)!,
                          hintStyle: TextStyle(color: Colors.black38,fontSize: 17),
                          labelText: SetLocalization.of(context)!.getTranslateValue(Keys.passWord)!,
                          labelStyle: TextStyle(color: Colors.indigo,fontSize: 15),
                          prefixIcon: Icon(Icons.password,color: Colors.indigo,),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.remove_red_eye , color: hidePassword ? Colors.black38 : Colors.green,),
                            onPressed: ()=> setState(()=> hidePassword = !hidePassword),
                          ),
                        ),
                        validator: (val){

                          if(val!.trim().isEmpty)
                            return SetLocalization.of(context)!.getTranslateValue(Keys.formToastPassWordEmpty)!;
                          else if(val.trim().length < 8)
                            return SetLocalization.of(context)!.getTranslateValue(Keys.formToastPasswordNumber)!;
                          else
                            return null;
                        },
                        onSaved: (val)=> setState(()=> this.password = val),
                      ),
                      SizedBox(height: 30,),
                      Container(
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.forgetPassword)! ,
                              style: TextStyle(color: Colors.indigo,fontSize: 16,textBaseline: TextBaseline.alphabetic,fontFamily: Constants.ubuntuRegularFont),),
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: (){
                            Navigator.of(context).pushNamed(ForgetPassword.PASSWORD);
                          },
                        ),
                      ),
                      SizedBox(height: Constants.screenHeightSize(context,50, 100),),
                      Container(
                        margin: EdgeInsets.only(left:Constants.screenHeightSize(context,sizeScreen.width*.35, sizeScreen.width*.40) ),
                        child: TextButton(
                          onPressed: ()=> SignInUser(),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.how_to_reg , color: Colors.white,size: 24,),
                              SizedBox(width: 5,),
                              Text(SetLocalization.of(context)!.getTranslateValue(Keys.splashSingIn)!,style: TextStyle(color: Colors.white,
                                  fontSize: Constants.screenHeightSize(context,lang.contains("en")? 18 : 16,lang.contains("en")? 21:20),
                                  fontFamily:lang.contains("ar")? Constants.splashArabicFont: null,
                                  fontWeight: lang.contains("ar")? FontWeight.w400: null),)
                            ],
                          ),
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(5),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade700),
                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20,vertical: 15)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(width: 1 ,color: Colors.white),
                              ))
                          ),
                        ),
                      ),
                      SizedBox(height: Constants.screenHeightSize(context,30, 90),),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.splashCreate)! ,
                            style: TextStyle(color: Colors.indigo,fontSize:lang.contains("en")? 16 : 18,textBaseline: TextBaseline.alphabetic,
                                fontFamily: lang.contains("en")?Constants.ubuntuRegularFont:null),),
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: (){
                          Navigator.of(context).pushReplacementNamed(SignUp.SIGNUP);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

}
