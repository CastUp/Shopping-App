
import 'dart:io';
import 'package:Shopping/Providers/AdminProviders/BrandsProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateBrands extends StatefulWidget {

  @override
  _CreateBrandsState createState() => _CreateBrandsState();
}

class _CreateBrandsState extends State<CreateBrands> {

  GlobalKey<FormState> _createKeyForm = GlobalKey();


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
           toolbarTitle: 'Brand Image',
           toolbarColor: Colors.deepOrange,
           toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original
          lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(title: 'Brand Image',),);
    if(croppedFile != null)
      setState(()=> brandImage = croppedFile.path);

  }
  }

  void createBrand() async{
    if (_createKeyForm.currentState!.validate()) {
      _createKeyForm.currentState!.save();

      await Provider.of<BrandsProvider>(context, listen: false).set(
          context,
          title: brandName.text,
          desc: brandDescription.text,
          image: brandImage).then((_) => Navigator.pop(context));
    }
  }


  @override
  void initState() {
    SaveLanguage.getLang().then((languageCode) => setState(()=>lang = languageCode));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade800,
        title:  Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductCreate)!,
          style: TextStyle(color: Colors.white, fontSize: 19,),),
        centerTitle: true,
      ),
      body: Consumer<BrandsProvider>(
        builder: (context, value, child)
        => Container(
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Form(
              key: _createKeyForm,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
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
                    validator: (val) => val!.trim().isEmpty
                        ? SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!
                        : val.length < 2
                            ? SetLocalization.of(context)!.getTranslateValue(Keys.brandToastNumber2)!
                            : null,
                    onSaved: (val) =>
                        setState(() => this.brandName.text = val!),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
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
                          borderSide:
                              BorderSide(color: Colors.deepOrange, width: 1)),
                    ),
                    validator: (val) => val!.trim().isEmpty
                        ? SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!
                        : val.length < 8
                            ? SetLocalization.of(context)!.getTranslateValue(Keys.brandToastNumber8)!
                            : null,
                    onSaved: (val) =>
                        setState(() => this.brandDescription.text = val!),
                  ),
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
                        Icon(
                          Icons.upload_rounded,
                          color: Colors.purple,
                        )
                      ],
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => dialogOptionImage()),
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
                    child: this.brandImage == ""
                        ? Center(
                            child: Text(
                              SetLocalization.of(context)!.getTranslateValue(Keys.brandImage)!,
                            style:
                                TextStyle(color: Colors.black54, fontSize: lang.contains("ar")? 17:15,
                                  fontFamily: lang.contains("ar")? Constants.splashArabicFont : null
                                ),
                          ))
                        : ClipRRect(
                            child: Image.file(
                              File(this.brandImage),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(5),
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
                            SetLocalization.of(context)!.getTranslateValue(Keys.listProductCreate)!,
                        style: TextStyle(color: Colors.white, fontSize: lang.contains("ar")? 22:19,
                          fontFamily: lang.contains("ar")? Constants.splashArabicFont : null
                        ),
                      )),
                    ),
                    onTap: () => createBrand(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
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
    brandDescription.dispose();
    brandName.dispose();
    super.dispose();
  }

}
