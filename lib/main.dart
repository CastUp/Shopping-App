
import 'dart:ui';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Parts/Admin/BottomBarAdmin.dart';
import 'package:Shopping/Parts/Admin/Screens/Customers.dart';
import 'package:Shopping/Parts/Admin/Screens/Orders.dart';
import 'package:Shopping/Parts/User/BottomBarUser.dart';
import 'package:Shopping/Parts/User/Screens/Account.dart';
import 'package:Shopping/Parts/User/Screens/Cart.dart';
import 'package:Shopping/Parts/User/Screens/Feeds.dart';
import 'package:Shopping/Parts/User/Screens/Search.dart';
import 'package:Shopping/Providers/AdminProviders/CategoriesProvider.dart';
import 'package:Shopping/Providers/lang.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Parts/Auth/ForgetPassword.dart';
import 'package:Shopping/Parts/Splash/OpenMainSplashScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Parts/Admin/Screens/Products.dart';
import 'Providers/AdminProviders/BrandsProvider.dart';
import 'Providers/AdminProviders/ProductProvider.dart';
import 'Providers/AuthProvider.dart';
import 'Parts/Admin/Screens/DashBoard.dart';
import 'Parts/Auth/SignIn.dart';
import 'Parts/Auth/SignUp.dart';
import 'Parts/Splash/SplashScreen.dart';
import 'Parts/User/Screens/HomeUser.dart';
import 'Services/Languages/SetLocalization.dart';
int x = 1 ;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark)
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp ,DeviceOrientation.portraitDown]).then((_)
  =>runApp( x == 0 ? DevicePreview(builder: (context)=>MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=> AuthProvider() ,),
    ChangeNotifierProvider(create: (_)=> CategoriesProvider(),),
    ChangeNotifierProvider(create: (_)=> ProductProvider()),
    ChangeNotifierProvider(create: (_)=> BrandsProvider()),
    ChangeNotifierProvider(create: (_)=> Languages()),

  ] , builder: (context, child)=> MyApp(),)) : MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=> AuthProvider(),),
    ChangeNotifierProvider(create: (_)=> CategoriesProvider(),),
    ChangeNotifierProvider(create: (_)=> ProductProvider()),
    ChangeNotifierProvider(create: (_)=> BrandsProvider()),
    ChangeNotifierProvider(create: (_)=> Languages()),

  ] , builder: (context, child)=> MyApp(),)));

}

class MyApp extends StatefulWidget {

  static void setLocale (BuildContext context , Locale locale ){

    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();

    state!.setLocale(locale);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference _reference = FirebaseFirestore.instance.collection("Users");

  Future<String> getPromotion()async{

    String promotion = Constants.Customer;
      if(_reference != null){
        final dataUser =  await _reference.doc(_firebaseAuth.currentUser!.uid).get();
        promotion = await dataUser.get(Constants.PROMOTION);
      }

    return promotion ;

  }

  Locale? _locale ;
  void setLocale(Locale locale)=> setState(()=> _locale = locale );


  @override
  void initState() {
    SaveLanguage.getLocal().then((locale) => setState(()=> _locale = locale));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Shopping App',
      builder: x == 0 ? DevicePreview.appBuilder : null,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
        Locale("ar","SA"),
        Locale("en","US"),
      ],
      localizationsDelegates: [
        SetLocalization.localizationsDelegate!,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale , supportLocale){
        for(var locale in supportLocale){
          if (locale.languageCode == deviceLocale!.languageCode && locale.countryCode == deviceLocale.countryCode)
            return deviceLocale;
          else
            return supportLocale.last ;
        }
      },
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      routes: {

        DashBoard.DASHBOARD                       : (_)=> DashBoard(),
        Products.PRODUCTS                         : (_)=> Products(),
        Customers.CUSTOMERS                       : (_)=> Customers(),
        Orders.ORDERS                             : (_)=> Orders(),
        Home.HOME                                 : (_)=> Home(),
        Cart.CART                                 : (_)=> Cart(),
        Feeds.FEEDS                               : (_)=> Feeds(),
        Search.SEARCH                             : (_)=> Search(),
        Account.ACCOUNT                           : (_)=> Account(),
        SignIn.SIGNIN                             : (_)=> SignIn(),
        SignUp.SIGNUP                             : (_)=> SignUp(),
        OpenMainSplashScreen.openMainSplashScreen : (_)=> OpenMainSplashScreen(),
        SplashScreen.splashScreen                 : (_)=> SplashScreen(),
        ForgetPassword.PASSWORD                   : (_)=> ForgetPassword(),
        BottomBarUser.BOTTOMBARUSER               : (_)=> BottomBarUser(),
        BottomBarAdmin.BOTTOMBARADMIN             : (_)=> BottomBarAdmin(),
      },
      home: StreamBuilder(
        stream: _firebaseAuth.userChanges(),
        builder: (context , snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: Colors.orange,),);

          }else if(snapshot.connectionState == ConnectionState.active){

            return snapshot.hasData ?
            FutureBuilder(
                future:  getPromotion(),
                builder: (context , promotion)
                => _firebaseAuth.currentUser!.emailVerified?
                promotion.connectionState == ConnectionState.waiting ? WaitingScreen()
                    : promotion.data == Constants.Customer ? BottomBarUser(): BottomBarAdmin()
                    : OpenMainSplashScreen()
            )
                : OpenMainSplashScreen();
          }
          return OpenMainSplashScreen();
        },
      ),
    );
  }
}

class WaitingScreen extends StatefulWidget {

  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade500,
              Colors.blue.shade600
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror
          )
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Loading  ",style: TextStyle(color: Colors.white,fontSize: 18),),
              SpinKitThreeBounce(
                color: Colors.white,
                size: 20,
                duration: Duration(seconds: 1),
              ),
            ],
          )
        ),
      )
    );
  }
}



