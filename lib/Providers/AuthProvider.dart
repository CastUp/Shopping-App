
import 'dart:io';
import 'package:Shopping/Parts/Admin/BottomBarAdmin.dart';
import 'package:Shopping/Parts/Splash/SplashScreen.dart';
import 'package:Shopping/Parts/User/BottomBarUser.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Models/AuthModel.dart';
import 'package:Shopping/Parts/Auth/SignIn.dart';
import 'package:Shopping/Services/Firebase/FirebaseServicesAuth.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:Shopping/Services/Screens/ToastMessage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class AuthProvider with ChangeNotifier , ToastMessage {


  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static CollectionReference _collectionReference(String collectionPath) => FirebaseFirestore.instance.collection(collectionPath);


  Future<void> signUpWithEmailAndPassword(BuildContext context, {required String name, required String email, required String password}) async {

    DateTime dateNow     = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(dateNow);


    Constants.showDialogs(context, title: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthRegistration)!,
        content: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthWaiting)!, elevation: 5);

    try {
      UserCredential newUser = await _firebaseAuth.createUserWithEmailAndPassword(
              email: email.trim().toLowerCase(), password: password.trim());

      if (newUser.user!.uid != null) {
        await newUser.user!.sendEmailVerification();

        AuthModel _authModel = new AuthModel(
            id: newUser.user!.uid,
            name: name.trim().toLowerCase(),
            email: email.trim().toLowerCase(),
            phone: "",
            address: "",
            imageUrl: "",
            promotion: Constants.Customer,
            registrations: "Email",
            joinedAt: formattedDate,
            createdAt: Timestamp.now());

        await _collectionReference("Users").doc(_firebaseAuth.currentUser!.uid).set(_authModel.toJson)
            .then((_)=>  Navigator.pop(context));
        AwesomeDialog(
            context: context,
            title: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthEmailVerification)!,
            desc: "${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthPleaseCheck)!}\n\n $email\n\n ${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthAndSignIn)!}",
            aligment: Alignment.center,
            dialogType: DialogType.INFO,
            animType: AnimType.LEFTSLIDE,
            dialogBackgroundColor: Colors.white,
            padding: EdgeInsets.all(10),
            headerAnimationLoop: true,
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            btnCancel: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.orange.shade300, Colors.orange.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          tileMode: TileMode.mirror,
                          stops: [0.1, 0.9]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.splashSingIn)!, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
                    ),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacementNamed(SignIn.SIGNIN);
                  },
                ),
              ],
            ))..show();
      }

    }  catch (e) {
      Navigator.pop(context);

      if(e.toString().contains("[firebase_auth/email-already-in-use] The email address is already in use by another account.")){
        this.toastMessage(context, message: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthToastAlreadyEmail)!);
      }else if(e.toString().contains("[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.")){
        this.toastMessage(context, message: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthToastNoInternet)!);
      }else{
        this.toastMessage(context, message: e.toString());
      }
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, {required String email, required String password}) async {

    Constants.showDialogs(context, title: SetLocalization.of(context)!.getTranslateValue(Keys.splashSingIn)!,
        content: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthWaiting)!, elevation: 5);

    try{

      UserCredential users = await _firebaseAuth.signInWithEmailAndPassword(email: email.trim().toLowerCase(), password: password.trim());

      if(users.user!.emailVerified){

        final Promotion  = await  await _collectionReference("Users").doc(_firebaseAuth.currentUser!.uid).get();
        String promotion = Promotion.get(Constants.PROMOTION);
        final Name       = await _collectionReference("Users").doc(_firebaseAuth.currentUser!.uid).get();
        String nameUser  = Name.get(Constants.NAME);

        Navigator.pop(context);
        promotion.contains(Constants.Customer) ? Navigator.pushReplacementNamed(context, BottomBarUser.BOTTOMBARUSER)
            : Navigator.pushReplacementNamed(context, BottomBarAdmin.BOTTOMBARADMIN);
        nameUser = nameUser.toLowerCase().replaceRange(0, 1, nameUser.substring(0, 1).toUpperCase());
        this.toastMessage(context, message: "${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthWelcomeBack)!} $nameUser");

      }else{

        await users.user!.sendEmailVerification().then((value) => Navigator.pop(context));
        AwesomeDialog(
            context: context,
            title: SetLocalization.of(context)!.getTranslateValue(Keys.splashSingIn)!,
            desc: "${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthEmailFirst)!}\n\n $email\n\n ${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthAndSignIn)!}",
            aligment: Alignment.center,
            dialogType: DialogType.ERROR,
            animType: AnimType.LEFTSLIDE,
            dialogBackgroundColor: Colors.white,
            padding: EdgeInsets.all(10),
            headerAnimationLoop: true,
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            btnCancel: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.redAccent, Colors.red.shade800],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          tileMode: TileMode.mirror,
                          stops: [0.1, 0.9]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthCancel)!, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
                    ),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () =>  Navigator.pop(context),
                ),
              ],
            ))..show();
      }

    }catch(e){
      Navigator.pop(context);
      this.toastMessage(context, message: e.toString());
    }


  }

  Future<void> signInWithGoogle(BuildContext context) async {

    Constants.showDialogs(context, title: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthRegistration)!,
        content: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthWaiting)!, elevation: 5);

    String promotionUser = Constants.Customer;
    String phone = "";
    String address = "";

    DateTime dateNow     = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(dateNow);

    try {
      final googleSignIn = GoogleSignIn();
      final googleAccount = googleSignIn.signIn();

      if (googleAccount != null) {
        final googleAuth = await googleAccount;
        final googleCurrentAuth = await googleAuth!.authentication;

        if (googleCurrentAuth.idToken != null &&
            googleCurrentAuth.accessToken != null) {
          final _authResult = await _firebaseAuth.signInWithCredential(
              GoogleAuthProvider.credential(
                  idToken: googleCurrentAuth.idToken,
                  accessToken: googleCurrentAuth.accessToken));

          promotionUser = await FirebaseServicesAuth.getPromotionUser();
          phone = await FirebaseServicesAuth.getPhoneUser();
          address = await FirebaseServicesAuth.getAddressUser();

          if (_authResult.user!.uid != null)
            await FirebaseServicesAuth.infoUserStorage(promotionUser, phone, address);

          AuthModel _authModel = new AuthModel(
            id: _authResult.user!.uid,
            name: _authResult.user!.displayName!.trim().toLowerCase(),
            email: _authResult.user!.email!.trim().toLowerCase(),
            phone: phone,
            address: address,
            imageUrl: _authResult.user!.photoURL!,
            joinedAt: formattedDate,
            registrations: "Google",
            promotion: promotionUser,
            createdAt: Timestamp.now(),
          );

          await _collectionReference("Users").doc(_firebaseAuth.currentUser!.uid).set(_authModel.toJson)
              .then((value) {

                Navigator.pop(context);
                promotionUser.contains(Constants.Customer) ? Navigator.pushReplacementNamed(context, BottomBarUser.BOTTOMBARUSER)
                    : Navigator.pushReplacementNamed(context, BottomBarAdmin.BOTTOMBARADMIN);

            String nameUser = _authResult.user!.displayName!.toLowerCase().replaceRange(0, 1, _authResult.user!.displayName!.substring(0, 1).toUpperCase());
            this.toastMessage(context, message: "${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthWelcomeBack)!} ${nameUser}");

          });
        }
      }
    } catch (e) {
      this.toastMessage(context, message: e.toString());
      Navigator.pop(context);
    }
  }

  Future<void> forgetPassword(BuildContext context ,{required String email}) async{

    try{

      await _firebaseAuth.sendPasswordResetEmail(email: email.trim().toLowerCase());

      AwesomeDialog(
          context: context,
          title: SetLocalization.of(context)!.getTranslateValue(Keys.splashSingIn)!,
          desc: "${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthCheckedEmail)!}\n\n $email\n\n ${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthAndSignIn)!}",
          aligment: Alignment.center,
          dialogType: DialogType.SUCCES,
          animType: AnimType.LEFTSLIDE,
          dialogBackgroundColor: Colors.white,
          padding: EdgeInsets.all(10),
          headerAnimationLoop: true,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          btnCancel: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue.shade800, Colors.blue.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.mirror,
                        stops: [0.1, 0.9]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.splashSingIn)!, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
                  ),
                ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, SignIn.SIGNIN);
                },
              ),
            ],
          ))..show();

    }catch(e){

      if(e.toString().contains("[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.")){

        this.toastMessage(context, message: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthNoFoundEmail)!);

      }else{

        this.toastMessage(context, message: e.toString());
      }
    }
  }

  Future<bool> uploadingImageUser(BuildContext context ,{required String image}) async{

    try{

     Reference _imageStorage = FirebaseStorage.instance.ref().child("ProfileImagesUsers").child("${_firebaseAuth.currentUser!.uid}.jpg");

     await _imageStorage.putFile(File(image));

     String profileImage = await _imageStorage.getDownloadURL();

     await _collectionReference("Users").doc(_firebaseAuth.currentUser!.uid).update({Constants.IMAGEUSER : profileImage});

     return true ;

    }catch(e){

      this.toastMessage(context, message: e.toString());
      return false ;
    }
  }

  Future<bool> changePromotion (BuildContext context , {required String idUser , required String promotion})async{

    Constants.showDialogs(context, title: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthValidity)!,
        content: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthWaiting)!, elevation: 3);

    try{

      final adminInfo = await _collectionReference("Users").doc(_firebaseAuth.currentUser!.uid).get();

      if(adminInfo.get(Constants.PROMOTION).toString().contains(Constants.SuperAdmin)){

        final userInfo = await _collectionReference("Users").doc(idUser).get();

        if(userInfo.get(Constants.REGISTRATIONS).toString().contains("Email")){

          await _collectionReference("Users").doc(idUser).update({Constants.PROMOTION : promotion})
              .then((value) => toastMessage(context, message: "${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthUpgraded)!} ${Constants.customerPromotion(promotion)}"));

        }else{

          await _collectionReference("Users").doc(idUser).update({Constants.PROMOTION : promotion})
              .then((value) async => await _collectionReference("PromotionUser").doc(idUser)
              .update({Constants.PROMOTION : promotion}).then((_) =>
              toastMessage(context, message: "${SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthUpgraded)!} ${Constants.customerPromotion(promotion)}")));
        }

        Navigator.pop(context);
        return true ;

      }else{

        toastMessage(context, message: SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthSuperAdmin)!);
        Navigator.pop(context);
        return false ;
      }

    }catch(e){

      toastMessage(context, message: e.toString());
      Navigator.pop(context);
      return false ;
    }


  }

  Stream<List<QueryDocumentSnapshot>> getUsers (){

    final users = _collectionReference("Users").snapshots().map((event) => event.docs);

    return users ;
  }

  Stream<DocumentSnapshot> getUserStream({required String idUser}) => _collectionReference("Users").doc(idUser).snapshots();

  Future<DocumentSnapshot> getUserFuture({required String idUser}) => _collectionReference("Users").doc(idUser).get();

  Future<void> logOut(BuildContext context) async{

   await _firebaseAuth.signOut().then((value) => Navigator.pushReplacementNamed(context, SplashScreen.splashScreen));
  }

  @override
  void toastMessage(BuildContext context, {required String message}) {
    FlutterToastr.show(message, context, backgroundRadius: 5, duration: 3,
        position: FlutterToastr.bottom,backgroundColor: Colors.black54,textStyle: TextStyle(color: Colors.white,));
  }
}
