import 'dart:io';
import 'package:Shopping/Models/LanguagesModel.dart';
import 'package:Shopping/Parts/Admin/InnerScreen/Settings.dart';
import 'package:Shopping/Providers/AuthProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class DrawerScreenAdmin extends StatefulWidget {

  @override
  _DrawerScreenAdminState createState() => _DrawerScreenAdminState();
}

class _DrawerScreenAdminState extends State<DrawerScreenAdmin> {

  FirebaseAuth _auth = FirebaseAuth.instance ;

  Future<void> _pickImage(ImageSource source)async{

    final pickedImage = await ImagePicker.platform.pickImage(source: source);

    if(pickedImage != null){
      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: Platform.isAndroid
          ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
          ]
          : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Photo',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Photo',
          ));
      if(croppedFile != null){
        Constants.showDialogs(context, title: "Uploading Image", content: "Waiting...", elevation: 5);
        await Provider.of<AuthProvider>(context ,listen: false).uploadingImageUser(context, image: croppedFile.path);
      }
    }
    Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.orange.shade800,
      body: Container(
        padding: EdgeInsets.only(left: 20 , right: 20 , bottom: 20 , top: MediaQuery.of(context).size.height*.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: StreamBuilder(
                  stream: Provider.of<AuthProvider>(context).getUserStream(idUser: _auth.currentUser!.uid),
                  builder: (context , AsyncSnapshot<DocumentSnapshot> snapshot)
                  => !snapshot.hasData ? Container(child: Center(child: CircularProgressIndicator(color: Colors.orange,),),)
                      : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              height: Constants.screenHeightSize(context, 55, 70),
                              width: Constants.screenHeightSize(context, 55, 70),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:NetworkImage(snapshot.data!.get(Constants.IMAGEUSER) == "" ? "https://firebasestorage.googleapis.com/v0/b/full-ecommerce-5f7a1.appspot.com/o/ProfileImagesUsers%2Fuser_photo.png?alt=media&token=31abd2c8-ee3c-4541-8e28-8269bd9b7841"
                                          : snapshot.data!.get(Constants.IMAGEUSER)), //
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.fromBorderSide(BorderSide(color: Colors.black,width: 1))
                              ),
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()=> showDialog(
                                context: context,
                                builder: (context)
                                =>AlertDialog(
                                  elevation: 4,
                                  contentPadding: EdgeInsets.all(10),
                                  titleTextStyle: TextStyle(fontSize: Constants.screenHeightSize(context, 17, 20) ,color: Colors.black,fontWeight: FontWeight.w600),
                                  title: Text("Choose option"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Divider(thickness: 1,color: Colors.orange.shade700,),
                                        SizedBox(height: 10,),
                                        TextButton(
                                          child: Text("Camera",style: TextStyle(color: Colors.white,fontSize: 18),),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange.shade700),
                                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 70 , vertical: 5)),
                                            side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                                            elevation: MaterialStateProperty.all<double>(3),
                                          ),
                                          onPressed: ()=>_pickImage(ImageSource.camera),
                                        ),
                                        SizedBox(height: 2,),
                                        TextButton(
                                          child: Text("Gallery",style: TextStyle(color: Colors.white,fontSize: 18),),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange.shade700),
                                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 70 , vertical: 5)),
                                            side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                                            elevation: MaterialStateProperty.all<double>(3),
                                          ),
                                          onPressed:()=>_pickImage(ImageSource.gallery),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data!.get(Constants.NAME).toString().toLowerCase()
                                  .replaceRange(0, 1, snapshot.data!.get(Constants.NAME).toString().substring(0,1).toUpperCase()),
                                style: TextStyle(color: Colors.white,fontSize: Constants.screenHeightSize(context, 17, 20) ,fontFamily: Constants.ubuntuRegularFont),),
                              SizedBox(height: 5,),
                              Text(snapshot.data!.get(Constants.EMAIL).toString().length <= 23 ? Constants.showTextEn(info: snapshot.data!.get(Constants.EMAIL))
                                  : Constants.showTextEn(info: snapshot.data!.get(Constants.EMAIL)).substring(0,22)+"...",
                                style: TextStyle(color: Colors.black,fontSize: Constants.screenHeightSize(context, 15, 18) ,fontFamily: Constants.ubuntuRegularFont),)
                            ],
                          )
                        ],
                      ),
                       Container(
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*.08,left: 5),
                        height: MediaQuery.of(context).size.height*.60,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.language,color: Colors.white,),
                              title: Text(SetLocalization.of(context)!.getTranslateValue(Keys.drawerSettings)!,
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 17)),
                              subtitle:Text(SetLocalization.of(context)!.getTranslateValue(Keys.drawerSettings)!,
                                  style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontSize: 15)) ,
                              minLeadingWidth: 2,
                              horizontalTitleGap:4 ,
                              onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> SettingsDrawer())),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*.05,left: 20,right: 20),
        padding: EdgeInsets.all(5),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.logout,color: Colors.white,size: Constants.screenHeightSize(context, 21, 25),),
              SizedBox(width: 5,),
              Text(SetLocalization.of(context)!.getTranslateValue(Keys.drawerLogout)!,style: TextStyle(color: Colors.white,fontSize: Constants.screenHeightSize(context, 21, 25),fontFamily: Constants.ubuntuRegularFont),)
            ],
          ),
          onTap: ()=> Provider.of<AuthProvider>(context, listen: false).logOut(context),
        ),
      ),
    );
  }




}