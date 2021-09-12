import 'package:Shopping/Providers/AuthProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class ForgetPassword extends StatefulWidget {

  static const String PASSWORD = "/password";

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  GlobalKey<FormState> _globalForm = GlobalKey<FormState>();

  String? email ;
  String lang = "en";

  @override
  void initState() {
    SaveLanguage.getLang().then((langCode) => setState(()=>lang = langCode));
    super.initState();

  }

  void ForgetPasswordUser(){

    FocusScope.of(context).unfocus();

    if(_globalForm.currentState!.validate()){

      _globalForm.currentState!.save();
      Provider.of<AuthProvider>(context,listen: false).forgetPassword(context,email: email!);
    }

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
                        child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.forgetPassword)!,
                          style: TextStyle(fontSize: Constants.screenHeightSize(context, 28, 35) ,
                              fontWeight:lang.contains("ar")? FontWeight.w400 : FontWeight.bold,color: Colors.indigo,
                              fontFamily:lang.contains("ar")? Constants.splashArabicFont: Constants.ubuntuRegularFont),),
                      ),
                      SizedBox(height: sizeScreen.height*0.10,),
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
                      SizedBox(height: Constants.screenHeightSize(context,60, 100),),
                      Container(
                        margin: EdgeInsets.only(left: Constants.screenHeightSize(context,sizeScreen.width*.20, sizeScreen.width*.24)),
                        child: TextButton(
                          onPressed: ()=> ForgetPasswordUser(),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.password , color: Colors.white,size: 22,),
                              SizedBox(width: 8,),
                              Text(SetLocalization.of(context)!.getTranslateValue(Keys.resetPassword)!,
                                style: TextStyle(color: Colors.white,
                                    fontSize: Constants.screenHeightSize(context,lang.contains("en")? 17 : 17.50,lang.contains("en")? 21: 24),
                                    fontFamily:lang.contains("ar")? Constants.splashArabicFont: null , fontWeight: lang.contains("ar")? FontWeight.w400: null),)
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
