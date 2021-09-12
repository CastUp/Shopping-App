import 'dart:io';
import 'package:Shopping/Providers/AdminProviders/BrandsProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditBrands extends StatefulWidget {

  final String idItem;

  EditBrands({required this.idItem});


  @override
  _EditBrandsState createState() => _EditBrandsState();
}

class _EditBrandsState extends State<EditBrands> {

  GlobalKey<FormState> _editKeyForm      = GlobalKey();

  TextEditingController brandName        = TextEditingController();
  TextEditingController brandDescription = TextEditingController();
  String brandImage                      = "";
  String lang                            = "en";

  Future<void> _imagePiker(ImageSource source) async {
    final image = await ImagePicker.platform.pickImage(source: source);

    if (image != null) {
      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: Platform.isAndroid
          ? [
          CropAspectRatioPreset.square,
          ]
              : [
          CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
      toolbarTitle: 'Brand image',
      toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original
          lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(title: 'Brand image',),);
    if(croppedFile != null){
          Constants.showDialogs(context, title: "Uploading", content: "Waiting", elevation: 2);
          String imageStorage = await Provider.of<BrandsProvider>(context,listen: false).uploadingImage(context, imagePath: croppedFile.path);
         setState(()=> brandImage = imageStorage);
        }
     }
    Navigator.pop(context);
  }

  void editBrand(BuildContext context) async {

    final filed = await Provider.of<BrandsProvider>(context,listen: false).getItemField(idItem: widget.idItem);

    if (_editKeyForm.currentState!.validate()) {
      _editKeyForm.currentState!.save();

      await Provider.of<BrandsProvider>(context, listen: false).edit(context,
          widget.idItem,
          oldTitle: filed.get(Constants.NAMEBRANDS),
          newTitle: this.brandName.text,
          desc: this.brandDescription.text,
          image: this.brandImage).then((_) => Navigator.pop(context));
    }
  }


  void getInfoItem()async{

   await Provider.of<BrandsProvider>(context,listen: false).getItemField(idItem: widget.idItem)
       .then((DocumentSnapshot filed) {
     brandName.text        = filed.get(Constants.NAMEBRANDS);
     brandDescription.text = filed.get(Constants.DESCRIPTIONBRANDS);
     brandImage            = filed.get(Constants.IMAGEBRANDS);
   });
   setState(() {});
  }


  @override
  void initState() {
    getInfoItem();
    SaveLanguage.getLang().then((languageCode) => lang = languageCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title:  Text(SetLocalization.of(context)!.getTranslateValue(Keys.categoryEdit)!, style: TextStyle(color: Colors.white, fontSize: 19),),
        centerTitle: true,
      ),
      body: Consumer<BrandsProvider>(
        builder: (context, value, child)
        =>SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Form(
                key: _editKeyForm,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          controller: this.brandName,
                          maxLength: 25,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: SetLocalization.of(context)!.getTranslateValue(Keys.brandTitle)!,
                            labelStyle: TextStyle(color: Colors.black54, fontSize:lang.contains("ar")? 16: 13,
                                fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),
                            contentPadding: EdgeInsets.all(10),
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(color: Colors.deepOrange, width: 1)),
                          ),
                          validator: (val) =>
                          val!.trim().isEmpty ? SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!
                              : val.length < 2 ? SetLocalization.of(context)!.getTranslateValue(Keys.brandToastNumber2)! : null,
                          onSaved: (val) => setState(() => this.brandName.text = val!)),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          controller: this.brandDescription,
                          maxLength: 120,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          keyboardType: TextInputType.text,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                              labelText: SetLocalization.of(context)!.getTranslateValue(Keys.brandTableDescription)!,
                              labelStyle: TextStyle(color: Colors.black54, fontSize: lang.contains("ar")? 16:13,
                                  fontFamily: lang.contains("ar")? Constants.splashArabicFont : null
                              ),
                            contentPadding: EdgeInsets.all(10),
                            alignLabelWithHint: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.deepOrange, width: 1)),
                          ),
                          validator: (val) =>
                          val!.trim().isEmpty ? SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!
                              : val.length < 8 ? SetLocalization.of(context)!.getTranslateValue(Keys.brandToastNumber8)! : null,
                          onSaved: (val) => setState(() => this.brandDescription.text = val!)),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        child: Row(
                          children: [
                            Text(
                              SetLocalization.of(context)!.getTranslateValue(Keys.brandImage)!,
                              style: TextStyle(color: Colors.black, fontSize:lang.contains("ar")? 22: 19,
                                  fontFamily: lang.contains("ar")? Constants.splashArabicFont : null
                              ),
                            ),
                            Icon(Icons.upload_rounded, color: Colors.purple,)
                          ],
                        ),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => showDialog(context: context, builder: (context) => dialogOptionImage()),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:brandImage.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.grey,)): ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(brandImage,fit: BoxFit.fill,)
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        splashColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.orange, Colors.deepOrange],
                              tileMode: TileMode.mirror,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                                SetLocalization.of(context)!.getTranslateValue(Keys.brandEdit)!,
                                style: TextStyle(color: Colors.white, fontSize: lang.contains("ar")? 22:19,
                                    fontFamily: lang.contains("ar")? Constants.splashArabicFont : null
                                ),
                              )),
                        ),
                        onTap: () => editBrand(context),),
                    ],
                  ),
                )
            )
        ),
      ),
    );
  }

  Widget dialogOptionImage() {
    return AlertDialog(
      elevation: 4,
      contentPadding: EdgeInsets.all(10),
      titleTextStyle: TextStyle(
          fontSize: Constants.screenHeightSize(context, 17, 20),
          color: Colors.black,
          fontWeight: FontWeight.w600),
      title: Center(child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.chooseOption)!,
        style: TextStyle(
            fontFamily: lang.contains("ar")? Constants.splashArabicFont : null,
            fontWeight: lang.contains("ar")? FontWeight.w400 : null,
            fontSize: lang.contains("ar")? 21 :19
        ),
      )),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Divider(
              thickness: 1,
              color: Colors.indigo,
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              child: Text(
                SetLocalization.of(context)!.getTranslateValue(Keys.camera)!,
                style: TextStyle(color: Colors.white, fontSize: lang.contains("ar")? 21:18,
                    fontFamily: lang.contains("ar")? Constants.splashArabicFont : null,
                    fontWeight: lang.contains("ar")? FontWeight.w400 : null
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.deepOrange),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: lang.contains("ar")? 75 :67, vertical: 5)),
                side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(color: Colors.white, width: 1)),
                elevation: MaterialStateProperty.all<double>(3),
              ),
              onPressed: () async => await _imagePiker(ImageSource.camera)
                  .then((value) => Navigator.pop(context)),
            ),
            SizedBox(
              height: 2,
            ),
            TextButton(
              child: Text(
                  SetLocalization.of(context)!.getTranslateValue(Keys.gallery)!,
                  style: TextStyle(color: Colors.white, fontSize: lang.contains("ar")? 21:18,
                      fontFamily: lang.contains("ar")? Constants.splashArabicFont : null,
                      fontWeight: lang.contains("ar")? FontWeight.w400 : null
                  )),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.deepOrange),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 70, vertical: 5)),
                side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(color: Colors.white, width: 1)),
                elevation: MaterialStateProperty.all<double>(3),
              ),
              onPressed: () async => await _imagePiker(ImageSource.gallery)
                  .then((value) => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    brandName.dispose();
    brandDescription.dispose();
    super.dispose();
  }
}
