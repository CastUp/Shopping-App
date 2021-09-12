import 'dart:io';
import 'package:Shopping/Providers/AdminProviders/BrandsProvider.dart';
import 'package:Shopping/Providers/AdminProviders/CategoriesProvider.dart';
import 'package:Shopping/Providers/AdminProviders/ProductProvider.dart';
import 'package:Shopping/Providers/AuthProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Screens/ToastMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {

  late String idProduct;

  EditProduct({ required this.idProduct});

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> with ToastMessage {

  FirebaseAuth _auth = FirebaseAuth.instance;
  String lang        = "en";
  GlobalKey<FormState> _globalFormKey = GlobalKey();

  List<String> _listSizes    = ["S","M","L","XL","XXL","XXXL"];
  List<String> _listCurrency = ["USD","EGP","EUR","GBP","CAD","JPY","RUP","CNH","TRY"];

  String coverImageProduct   = "";
  String offerImage          = "";

  TextEditingController productTitle             = TextEditingController(); //
  TextEditingController priceBeforeDiscount      = TextEditingController(); //
  TextEditingController sellingPrice             = TextEditingController(); //
  TextEditingController priceBeforeDiscountOffer = TextEditingController();
  TextEditingController sellingPriceOffer        = TextEditingController();
  TextEditingController inventory                = TextEditingController(); //
  TextEditingController description              = TextEditingController(); //
  String currency            = "";

  String category            = "";
  String brand               = "";

  bool _isActivation         = true ;
  bool _isFavorite           = false ;
  bool _isPopular            = false ;
  bool _isOffer              = false ;

  String createDate          = "" ;
  String startDate           = "" ;
  String expiryDate          = "" ;


  List imagesProductFirebase = [];
  List colorsProduct         = [{}];
  List sizesProduct          = [{}];
  List comments              = [];




  Future<void> _getCoverImageProduct(ImageSource source)async{

    final image = await ImagePicker.platform.getImage(source: source);

    if(image != null){

      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: Platform.isAndroid? [CropAspectRatioPreset.square, ]: [CropAspectRatioPreset.square,],
          androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cover Product',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original
          lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(title: 'Cover Product',),);
    if(croppedFile != null)
    Constants.showDialogs(context, title: "Uploading image", content: "Waiting", elevation: 4);
    String updateImage = await  Provider.of<ProductProvider>(context,listen: false).uploadingImage(context, imagePath: croppedFile!.path);
    if(updateImage.isNotEmpty){
    Navigator.pop(context);
    setState(() {
    coverImageProduct = updateImage;
    });
    }
    }

    Navigator.pop(context);
  }

  Future<void> _getOfferImageProduct(ImageSource source)async{

    final image = await ImagePicker.platform.getImage(source: source);

    if(image != null){

      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: Platform.isAndroid? [CropAspectRatioPreset.ratio7x5]: [CropAspectRatioPreset.ratio7x5],
          androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cover Product',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original
          lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(title: 'Cover Product',),);
       if(croppedFile != null)
          Constants.showDialogs(context, title: "Uploading image", content: "Waiting", elevation: 4);
          String updateImage = await  Provider.of<ProductProvider>(context,listen: false).uploadingOfferImage(context, imagePath: croppedFile!.path);
           if(updateImage.isNotEmpty){
              Navigator.pop(context);
             setState(() {
               offerImage = updateImage;
            });
      }
    }

    Navigator.pop(context);
  }

  Future<void> _getImagesProduct(ImageSource source) async{

    if(imagesProductFirebase.length < 12) {

      final image = await ImagePicker.platform.getImage(source: source);

      if (image != null) {
        File? croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
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
              toolbarTitle: 'Product Images',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(title: 'Product Images',),);
        if (croppedFile != null){
          Constants.showDialogs(context, title: "Uploading image", content: "Waiting", elevation: 4);
          String updateImage = await  Provider.of<ProductProvider>(context,listen: false).uploadingImage(context, imagePath: croppedFile.path);
          if(updateImage.isNotEmpty){
            Navigator.pop(context);
            setState(() {
              imagesProductFirebase.add({"image":updateImage});
            });
          }
        }

      }

    }else{
      this.toastMessage(context, message: "You have reached the limit");
    }
    Navigator.pop(context);

  }

  String get _currencySymbol  {

    if(currency.contains("USD") || currency.contains("CAD"))
      return "\$";
    else if(currency.contains("EGP"))
      return "LE";
    else if(currency.contains("EUR"))
      return "€";
    else if(currency.contains("GBP"))
      return "£";
    else if(currency.contains("JPY"))
      return "¥";
    else if(currency.contains("RUP"))
      return "₽";
    else if(currency.contains("CNH"))
      return "元";
    else if(currency.contains("TRY"))
      return "₺";
    else
      return "";
  }

  Future<void> _editProduct()async{

    if(_globalFormKey.currentState!.validate()){

      _globalFormKey.currentState!.save();

      if(double.tryParse(priceBeforeDiscount.text)! < double.tryParse(sellingPrice.text)!)
        this.toastMessage(context, message: "The price before regular price should be greater than the selling price");
      else if(_currencySymbol.isEmpty)
        this.toastMessage(context, message: "Please add a Currency");
      else if(coverImageProduct.isEmpty)
        this.toastMessage(context, message: "Please add a cover image of the product");
      else if(imagesProductFirebase.length == 1)
        this.toastMessage(context, message: "Please add at least one image of the product");
      else if(_isOffer && offerImage.isEmpty)
        this.toastMessage(context, message: "Please add a offer image of the product");
      else if(_isOffer && startDate.isEmpty)
        toastMessage(context, message: "Please add start date");
      else if(_isOffer && expiryDate.isEmpty)
        toastMessage(context, message: "Please add expiry date");
      else if(_isOffer && DateTime.parse(expiryDate).isBefore(DateTime.parse(startDate)))
        toastMessage(context, message: "The start date must be earlier than the expiry date");
      else if(_isOffer && double.tryParse(priceBeforeDiscountOffer.text)! < double.tryParse(sellingPriceOffer.text)!)
        this.toastMessage(context, message: "The price before regular price should be greater than the selling price");
      else if(brand.isEmpty)
        this.toastMessage(context, message: "Please add a brand");
      else if(category.isEmpty)
        this.toastMessage(context, message: "Please add a category");
      else
        await Provider.of<ProductProvider>(context,listen: false).edit(
          context,widget.idProduct,
          title                   : productTitle.text,
          description             : description.text,
          sellingPrice            : sellingPrice.text,
          priceBeforeDiscount     : priceBeforeDiscount.text,
          priceBeforeDiscountOffer: _isOffer ? priceBeforeDiscountOffer.text : "0.0",
          sellingPriceOffer       : _isOffer ? sellingPriceOffer.text  : "0.0" ,
          inventory               : inventory.text,
          productCategoryName     : category,
          offerImage              : offerImage,
          brand                   : brand,
          coverImage              : coverImageProduct,
          colors                  : colorsProduct ,
          sizes                   : sizesProduct  ,
          currency                : this._currencySymbol,
          comments                : comments,
          createDate              : createDate ,
          images                  : imagesProductFirebase  ,
          isActivation            : _isActivation,
          startDate               : startDate,
          expiryDate              : expiryDate,
          isFavorite              : _isFavorite,
          isPopular               : _isPopular,
          isOffer                 : _isOffer,
        ).then((value) => Navigator.pop(context));

    }

  }

  void  productInfo ()async{

    await Provider.of<ProductProvider>(context,listen: false).fetchProduct(idProduct: widget.idProduct)
        .then((DocumentSnapshot productInfo){

      this.coverImageProduct               = productInfo.get(Constants.PRODUCTCOVERIMAGE);
      this.offerImage                      = productInfo.get(Constants.PRODUCTOFFERIMAGE);
      this.productTitle.text               = productInfo.get(Constants.PRODUCTTITLE);
      this.priceBeforeDiscount.text        = productInfo.get(Constants.PRODUCTPRICEBEFOREDISCOUNT);
      this.sellingPrice.text               = productInfo.get(Constants.PRODUCTSELLINGPRICE);
      this.priceBeforeDiscountOffer.text   = productInfo.get(Constants.PRODUCTPRICEBEFOREDISCOUNTOFFER);
      this.sellingPriceOffer.text          = productInfo.get(Constants.PRODUCTSELLINGPRICEOFFER);
      this.inventory.text                  = productInfo.get(Constants.PRODUCTINVENTORY);
      this.description.text                = productInfo.get(Constants.PRODUCTDESCRIPTION);
      this.currency                        = _currency(productInfo.get(Constants.PRODUCTCURRENCY));
      this.category                        = productInfo.get(Constants.PRODUCTCATEGORYNAME);
      this.brand                           = productInfo.get(Constants.PRODUCTBRANDS);
      this.imagesProductFirebase           = productInfo.get(Constants.PRODUCTIMAGES);
      this.colorsProduct                   = productInfo.get(Constants.PRODUCTCOLORS);
      this.sizesProduct                    = productInfo.get(Constants.PRODUCTSIZES) ;
      this.comments                        = productInfo.get(Constants.PRODUCTCOMMENTS);
      this._isActivation                   = productInfo.get(Constants.PRODUCTISACTIVATION);
      this._isPopular                      = productInfo.get(Constants.PRODUCTISPOPULAR);
      this._isFavorite                     = productInfo.get(Constants.PRODUCTISFAVORITE);
      this._isOffer                        = productInfo.get(Constants.PRODUCTISOFFER);
      this.createDate                      = productInfo.get(Constants.PRODUCTCREATEAT);
      this.startDate                       = productInfo.get(Constants.PRODUCTSTARTDATE);
      this.expiryDate                      = productInfo.get(Constants.PRODUCTEXPIRYDATE);

    });
    setState(() {});
  }

  @override
  void initState() {
    SaveLanguage.getLang().then((languageCode) => setState(()=>lang = languageCode));
    productInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size ;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Container(
          child: Form(
            key: _globalFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        splashColor: Colors.grey,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: size.width,
                          height: size.height*.35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black12
                          ),
                          child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black.withOpacity(0.9),
                              child: this.coverImageProduct.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.orange,))
                                  :Image.network(coverImageProduct ,
                                fit: BoxFit.contain)
                          ),
                        ),
                        onTap: ()=> showDialog(context: context, builder: (_)
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
                                Divider(thickness: 1,color: Colors.indigo,),
                                SizedBox(height: 10,),
                                TextButton(
                                  child: Text("Camera",style: TextStyle(color: Colors.white,fontSize: 18),),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 70 , vertical: 5)),
                                    side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                                    elevation: MaterialStateProperty.all<double>(3),
                                  ),
                                  onPressed: ()=>_getCoverImageProduct(ImageSource.camera),
                                ),
                                SizedBox(height: 2,),
                                TextButton(
                                  child: Text("Gallery",style: TextStyle(color: Colors.white,fontSize: 18),),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 70 , vertical: 5)),
                                    side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                                    elevation: MaterialStateProperty.all<double>(3),
                                  ),
                                  onPressed:()=>_getCoverImageProduct(ImageSource.gallery),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left : lang.contains("ar")? null : 20,
                      right: lang.contains("ar")? 20 : null,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 25,),
                        onPressed: ()=> Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: this.productTitle,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black, fontSize: 19),
                      decoration: InputDecoration(
                        hintText: "Product title",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                        labelText: "Title",
                        labelStyle: TextStyle(color: Colors.orange.shade800, fontSize: 18,fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        suffixIcon: Container(child: Icon(Icons.title, color: Colors.black,) ,
                          decoration:BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                              color: Colors.orange
                          ),),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                        ),
                        fillColor: Colors.black12,
                        filled: true,
                      ),
                      enableSuggestions: true,
                      validator: (val){
                        if(val!.trim().isEmpty)
                          return "Don't leave it empty";
                        if(val.trim().length < 4)
                          return "No less than four letters";
                        else
                          return null ;
                      },
                      onSaved: (val)=> setState(()=> this.productTitle.text = val!.trim()) ,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: lang.contains("ar")? 0 : 10 , left: lang.contains("ar")? 10 : 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: TextFormField(
                                  controller: priceBeforeDiscount,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.black, fontSize: 19),
                                  decoration: InputDecoration(
                                    hintText: "Regular price",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                    labelText: "Regular price",
                                    labelStyle: TextStyle(color: Colors.orange.shade800, fontSize: 14,fontWeight: FontWeight.bold),
                                    border: InputBorder.none,
                                    suffixIcon: Container(child: Icon(Icons.price_change_sharp, color: Colors.black,) ,
                                      decoration:BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                          color: Colors.orange
                                      ),),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                                    ),
                                    fillColor: Colors.black12,
                                    filled: true,
                                  ),
                                  enableSuggestions: true,
                                  validator: (val){
                                    if(val!.trim().isEmpty)
                                      return "Don't leave it empty";
                                    else if(!new RegExp(r'(^\d*\.?\d*)$').hasMatch(val.trim()))
                                      return "Numbers only";
                                    else
                                      return null ;
                                  },
                                  onSaved: (val)=> setState(()=> this.priceBeforeDiscount.text = val!.trim()) ,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: lang.contains("ar")?  0 : 10 , right: lang.contains("ar")?  10 : 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: TextFormField(
                                  controller: sellingPrice,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.black, fontSize: 19),
                                  decoration: InputDecoration(
                                    hintText: "Sale price",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                    labelText: "Sale price",
                                    labelStyle: TextStyle(color: Colors.orange.shade800, fontSize: 14,fontWeight: FontWeight.bold),
                                    border: InputBorder.none,
                                    suffixIcon: Container(child: Icon(Icons.price_change_sharp, color: Colors.black,) ,
                                      decoration:BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                          color: Colors.orange
                                      ),),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                                    ),
                                    fillColor: Colors.black12,
                                    filled: true,
                                  ),
                                  enableSuggestions: true,
                                  validator: (val){
                                    if(val!.trim().isEmpty)
                                      return "Don't leave it empty";
                                    if(!new RegExp(r'(^\d*\.?\d*)$').hasMatch(val))
                                      return "Numbers only";
                                    else
                                      return null ;
                                  },
                                  onSaved: (val)=> setState(()=> this.sellingPrice.text = val!.trim()) ,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: lang.contains("ar")? 0 : 10 , left: lang.contains("ar")? 10 : 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: TextFormField(
                                  controller: inventory,
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: Colors.black, fontSize: 19),
                                  decoration: InputDecoration(
                                    hintText: "Inventory",
                                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                    labelText: "Inventory",
                                    labelStyle: TextStyle(color: Colors.orange.shade800, fontSize: 14,fontWeight: FontWeight.bold),
                                    border: InputBorder.none,
                                    suffixIcon: Container(child: Icon(Icons.storage, color: Colors.black,) ,
                                      decoration:BoxDecoration(
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                          color: Colors.orange
                                      ),),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                                    ),
                                    fillColor: Colors.black12,
                                    filled: true,
                                  ),
                                  enableSuggestions: true,
                                  validator: (val){
                                    if(val!.trim().isEmpty)
                                      return "Don't leave it empty";
                                    if(!new RegExp(r"^([0-9]{1}|[0-9]{2}|[0-9]{3}|[0-9]{4}|[0-9]{5}|[0-9]{6}|[0-9]{7}|[0-9]{8}|[0-9]{9})$").hasMatch(val.trim()))
                                      return "Numbers only";
                                    else
                                      return null ;
                                  },
                                  onSaved: (val)=> setState(()=> this.inventory.text = val!.trim()) ,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: lang.contains("ar")?  0 : 10 , right: lang.contains("ar")?  10 : 0),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.orange,width: 1),
                                  color: Colors.black12
                              ),
                              child: DropdownButton(
                                items: <DropdownMenuItem<String>>[
                                  ..._listCurrency.map((curr) => DropdownMenuItem(
                                      value: curr,
                                      child: Column(
                                        children: [
                                          Text(curr,style: TextStyle(fontSize: 14 , color: Colors.black),),
                                          Divider(color: Colors.grey,thickness: 0.5,)
                                        ],
                                      )
                                  )),
                                ].toList(),
                                elevation: 2,
                                underline: Container(),
                                isExpanded: true,
                                icon: Icon(Icons.monetization_on,color: Colors.orange.shade800,),
                                hint: Text(currency.isEmpty ? "Currency" : currency.toUpperCase() ,
                                  style: TextStyle(color: currency.isEmpty ? Colors.grey : Colors.black , fontSize: 14),),
                                onChanged: (val)=> setState(()=> this.currency = val.toString()),
                              ),
                            )
                          ]
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: description,
                      keyboardType: TextInputType.text,
                      maxLines: 10,
                      style: TextStyle(color: Colors.black, fontSize: 19),
                      decoration: InputDecoration(
                        hintText: "Description",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(width: 1 , color: Colors.orange)
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                        ),
                        fillColor: Colors.black12,
                        filled: true,
                      ),
                      enableSuggestions: true,
                      validator: (val){
                        if(val!.trim().isEmpty)
                          return "Don't leave it empty";
                        else
                          return null ;
                      },
                      onSaved: (val)=> setState(()=> this.description.text = val!.trim()) ,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                          children: <Widget>[
                            StreamBuilder(
                              stream: Provider.of<CategoriesProvider>(context).fetchListData(),
                              builder: (context ,AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot)
                              => snapshot.hasData ? Container(
                                margin: EdgeInsets.only(right: lang.contains("ar")? 0 : 10 , left: lang.contains("ar")? 10 : 0),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.orange,width: 1),
                                    color: Colors.black12
                                ),
                                child: DropdownButton(
                                  items: <DropdownMenuItem<String>>[
                                    ...snapshot.data!.map((objectCategory) => DropdownMenuItem(
                                        value: objectCategory.get(Constants.NAMECATEGORY),
                                        child: Text(Constants.showTextEn(info: objectCategory.get(Constants.NAMECATEGORY)))
                                    )),
                                  ].toList(),
                                  elevation: 2,
                                  underline: Container(),
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down_circle,color: Colors.orange.shade800,),
                                  hint: Text(this.category.isEmpty ? !snapshot.data!.isEmpty? "Category": "Create category" : Constants.showTextEn(info: this.category),
                                    style: TextStyle(fontSize: 15, color: this.category.isEmpty ? Colors.grey : Colors.black),),
                                  onChanged: (val)=> setState(()=> this.category = val.toString()),
                                ),
                              ) : Container(),
                            ),
                            StreamBuilder(
                              stream: Provider.of<BrandsProvider>(context).fetchListData(),
                              builder: (context ,AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot)
                              => snapshot.hasData ? Container(
                                margin: EdgeInsets.only(left: lang.contains("ar")?  0 : 10 , right: lang.contains("ar")?  10 : 0),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.orange,width: 1),
                                    color: Colors.black12
                                ),
                                child: DropdownButton(
                                  items: <DropdownMenuItem<String>>[
                                    ...snapshot.data!.map((objectBrand) => DropdownMenuItem(
                                      value: objectBrand.get(Constants.NAMEBRANDS),
                                      child: Text(Constants.showTextEn(info: objectBrand.get(Constants.NAMEBRANDS))),
                                    )),
                                  ].toList(),
                                  elevation: 2,
                                  underline: Container(),
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down_circle,color: Colors.orange.shade800,),
                                  hint: Text(this.brand.isEmpty ? !snapshot.data!.isEmpty ? "Brand" : "Create brand" : Constants.showTextEn(info: this.brand),
                                    style: TextStyle(fontSize: 15, color: this.brand.isEmpty ? Colors.grey : Colors.black),),
                                  onChanged: (val)=> setState(()=> this.brand = val.toString()),
                                ),
                              ) : Container(),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Product images:",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500),)
                ),
                Container(
                  height: _heights(size: size ) ,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 3/3.5
                      ),
                      itemCount: imagesProductFirebase.length ,
                      itemBuilder: (context,index)
                      => index == 0 ? Material(
                        elevation: 1.5,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1,color: Colors.grey),
                                color: Colors.black12
                            ),
                            child: Center(child: Icon(Icons.add,color: Colors.grey.shade600,),),
                          ),
                          onTap: ()=> showDialog(
                              context: context,
                              builder: (_)
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
                                      Divider(thickness: 1,color: Colors.indigo,),
                                      SizedBox(height: 10,),
                                      TextButton(
                                        child: Text("Camera",style: TextStyle(color: Colors.white,fontSize: 18),),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 70 , vertical: 5)),
                                          side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                                          elevation: MaterialStateProperty.all<double>(3),
                                        ),
                                        onPressed: ()=>_getImagesProduct(ImageSource.camera),
                                      ),
                                      SizedBox(height: 2,),
                                      TextButton(
                                        child: Text("Gallery",style: TextStyle(color: Colors.white,fontSize: 18),),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 70 , vertical: 5)),
                                          side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                                          elevation: MaterialStateProperty.all<double>(3),
                                        ),
                                        onPressed:()=>_getImagesProduct(ImageSource.gallery),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ),
                      ):Material(
                        elevation: 0.8,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            decoration:BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 0.5,color: Colors.black12),
                                image: DecorationImage(
                                  image: NetworkImage(imagesProductFirebase[index]["image"]) ,
                                  fit: BoxFit.fill,
                                )
                            ),
                          ),
                          onLongPress: ()=> setState(()=> imagesProductFirebase.removeAt(index)),
                        ),
                      )
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Product Colors:",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),)
                ),
                Container(
                  height: size.height*.18 ,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 3/2
                      ),
                      itemCount: colorsProduct.length,
                      itemBuilder: (context,index)
                      => index == 0 ? Material(
                        elevation: 1.5,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 1,color: Colors.grey),
                                  color: Colors.black12
                              ),
                              child: Center(child: Icon(Icons.format_color_fill,color: Colors.deepPurpleAccent,),),
                            ),
                            onTap: ()
                            => colorsProduct.length < 10 ? showDialog(context: context, builder: (context)=> AlertDialog(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.color_lens_rounded,color: Colors.deepPurple,),
                                  Text('Colors',style: TextStyle(color: Colors.black)),
                                ],
                              ),
                              content: SingleChildScrollView(
                                  child: MaterialPicker(
                                    pickerColor: Colors.blue,
                                    onColorChanged: (color){
                                      setState(() {
                                        colorsProduct.add({"color":color.value.toRadixString(16)});
                                      });
                                      Navigator.pop(context);
                                    },
                                  )
                              ),
                            ),):
                            this.toastMessage(context, message: "Maximum reached")
                        ),
                      ):Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 0.5,color: Colors.black87),
                                color: HexColor(colorsProduct[index]["color"].toString())
                            ),
                          ),
                          onLongPress: ()=> setState(()=> colorsProduct.removeAt(index)),
                        ),
                      )
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Product Sizes:",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),)
                ),
                Container(
                  height: size.height*.18 ,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: 3/2
                      ),
                      itemCount: sizesProduct.length,
                      itemBuilder: (context,index)
                      => index == 0 ? Material(
                        elevation: 1.5,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 1,color: Colors.grey),
                                  color: Colors.black12
                              ),
                              child: Icon(Icons.format_size,color: Colors.deepPurpleAccent,),
                            ),
                            onTap: ()
                            => sizesProduct.length < 7 ? showDialog(context: context, builder: (context)=> AlertDialog(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.format_size,color: Colors.deepPurple,),
                                  Text('Sizes',style: TextStyle(color: Colors.black)),
                                ],
                              ),
                              content: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (context,indexsize)=> Divider(color: Colors.grey,thickness: 1,),
                                itemCount: _listSizes.length,
                                itemBuilder: (context,index) => InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(child: Text(_listSizes[index], style: TextStyle(fontWeight: FontWeight.bold),),),
                                  ),
                                  onTap: (){
                                    Navigator.pop(context);
                                    setState(()=> sizesProduct.add({"size":_listSizes[index]}));
                                  },
                                ),
                              ),),): Container()
                        ),
                      ):Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1,color: Colors.black),
                                color: Colors.white
                            ),
                            child: Text(sizesProduct[index]["size"].toString(),
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                          ),
                          onLongPress: ()=> setState(()=> sizesProduct.removeAt(index)),
                        ),
                      )
                  ),
                ),
                SizedBox(height: 30,),
                FutureBuilder(
                  future: Provider.of<AuthProvider>(context).getUserFuture(idUser: _auth.currentUser!.uid),
                  builder: (context , AsyncSnapshot<DocumentSnapshot> promotion)
                  =>Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTileSwitch(
                      title: Text("Activation",style: TextStyle(fontSize: 18,color: _isActivation ? Colors.deepOrange: Colors.black54,fontWeight: FontWeight.bold),),
                      subtitle: Text("Activate and deactivate the product",style: TextStyle(fontSize: 15 , color: Colors.grey.shade600),),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      switchActiveColor: Colors.orange,
                      switchInactiveColor: Colors.grey,
                      value: _isActivation,
                      onChanged: (val)
                      => promotion.data!.get(Constants.PROMOTION).toString().contains(Constants.SuperAdmin)
                          ? setState(()=> _isActivation = val) : this.toastMessage(context, message: "You must be super admin"),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTileSwitch(
                    title: Text("Favorite",style: TextStyle(fontSize: 18,color: _isFavorite ? Colors.deepOrange: Colors.black54,fontWeight: FontWeight.bold),),
                    subtitle: Text("Include the product in the list of favorites",style: TextStyle(fontSize: 15 , color: Colors.grey.shade600),),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    switchActiveColor: Colors.orange,
                    switchInactiveColor: Colors.grey,
                    value: _isFavorite,
                    onChanged: (val)=> setState(()=> _isFavorite = val),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTileSwitch(
                    title: Text("Popular",style: TextStyle(fontSize: 18,color: _isPopular ? Colors.deepOrange: Colors.black54,fontWeight: FontWeight.bold),),
                    subtitle: Text("Include the product in the list of Popular",style: TextStyle(fontSize: 15 , color: Colors.grey.shade600),),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    switchActiveColor: Colors.orange,
                    switchInactiveColor: Colors.grey,
                    value: _isPopular,
                    onChanged: (val)=> setState(()=> _isPopular = val),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListTileSwitch(
                    title: Text("Offer",style: TextStyle(fontSize: 18,color: _isOffer ? Colors.deepOrange: Colors.black54,fontWeight: FontWeight.bold),),
                    subtitle: Text("Include the product in the list of Offer",style: TextStyle(fontSize: 15 , color: Colors.grey.shade600),),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    switchActiveColor: Colors.orange,
                    switchInactiveColor: Colors.grey,
                    value: _isOffer,
                    onChanged: (val){
                      setState(()=> _isOffer = val);
                      if(!_isOffer){
                        offerImage = "";
                        startDate  = "";
                        expiryDate = "";
                        priceBeforeDiscountOffer.text ="";
                        sellingPriceOffer.text = "";
                      }
                    },
                  ),
                ),
                SizedBox(height: 30,),
                _isOffer ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Offer period:",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),)
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: lang.contains("ar")? 0 : 10 , left: lang.contains("ar")? 10 : 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: TextField(
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: this.startDate.isEmpty ? "Start date" : DateFormat.yMMMEd().format(DateTime.parse(this.startDate)),
                                        hintStyle: TextStyle(color: this.startDate.isEmpty ? Colors.grey : Colors.red.shade500, fontSize: 15),
                                        border: InputBorder.none,
                                        suffixIcon: _getStartDate(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                                        ),
                                        fillColor: Colors.black12,
                                        filled: true,
                                      ),
                                      enableSuggestions: true,
                                      textAlignVertical: TextAlignVertical.center,
                                      readOnly: true,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: lang.contains("ar")?  0 : 10 , right: lang.contains("ar")?  10 : 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: TextField(
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        hintText: this.expiryDate.isEmpty ? "Expiry date" : DateFormat.yMMMEd().format(DateTime.parse(this.expiryDate)),
                                        hintStyle: TextStyle(color: this.expiryDate.isEmpty ? Colors.grey : Colors.red.shade500, fontSize: 15),
                                        border: InputBorder.none,
                                        suffixIcon: _getExpiryDate(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                                        ),
                                        fillColor: Colors.black12,
                                        filled: true,
                                      ),
                                      enableSuggestions: true,
                                      textAlignVertical: TextAlignVertical.center,
                                      readOnly: true,
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: <TableRow>[
                          TableRow(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: lang.contains("ar")? 0 : 10 , left: lang.contains("ar")? 10 : 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: TextFormField(
                                      controller: priceBeforeDiscountOffer,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.black, fontSize: 19),
                                      decoration: InputDecoration(
                                        hintText: "Regular price",
                                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                        labelText: "Regular price",
                                        labelStyle: TextStyle(color: Colors.orange.shade800, fontSize: 14,fontWeight: FontWeight.bold),
                                        border: InputBorder.none,
                                        suffixIcon: Container(child: Icon(Icons.price_change_sharp, color: Colors.black,) ,
                                          decoration:BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                              color: Colors.orange
                                          ),),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                                        ),
                                        fillColor: Colors.black12,
                                        filled: true,
                                      ),
                                      enableSuggestions: true,
                                      validator: (val){
                                        if(val!.trim().isEmpty)
                                          return "Don't leave it empty";
                                        else if(!new RegExp(r'(^\d*\.?\d*)$').hasMatch(val.trim()))
                                          return "Numbers only";
                                        else
                                          return null ;
                                      },
                                      onSaved: (val)=> setState(()=> this.priceBeforeDiscountOffer.text = val!.trim()) ,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: lang.contains("ar")?  0 : 10 , right: lang.contains("ar")?  10 : 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: TextFormField(
                                      controller: sellingPriceOffer,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.black, fontSize: 19),
                                      decoration: InputDecoration(
                                        hintText: "Sale price",
                                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                        labelText: "Sale price",
                                        labelStyle: TextStyle(color: Colors.orange.shade800, fontSize: 14,fontWeight: FontWeight.bold),
                                        border: InputBorder.none,
                                        suffixIcon: Container(child: Icon(Icons.price_change_sharp, color: Colors.black,) ,
                                          decoration:BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
                                              color: Colors.orange
                                          ),),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(width: 1 , color: Colors.red.shade700)
                                        ),
                                        fillColor: Colors.black12,
                                        filled: true,
                                      ),
                                      enableSuggestions: true,
                                      validator: (val){
                                        if(val!.trim().isEmpty)
                                          return "Don't leave it empty";
                                        if(!new RegExp(r'(^\d*\.?\d*)$').hasMatch(val))
                                          return "Numbers only";
                                        else
                                          return null ;
                                      },
                                      onSaved: (val)=> setState(()=> this.sellingPriceOffer.text = val!.trim()) ,
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text("Note : \nthese prices will only be valid during the offer",style: TextStyle(color: Colors.blueGrey,fontSize: 14)),
                    ),
                    SizedBox(height: 30,),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: size.width,
                        height: size.height*.30,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black12
                        ),
                        child: this.offerImage.isEmpty ? Center(child: Text("Offer image"),): Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child:offerImage.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.orange,)): Image.network(offerImage ,fit: BoxFit.fill,filterQuality: FilterQuality.high,),
                            )
                        ),
                      ),
                      onTap: ()=> showDialog(context: context, builder: (_)
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
                              Divider(thickness: 1,color: Colors.indigo,),
                              SizedBox(height: 10,),
                              TextButton(
                                child: Text("Camera",style: TextStyle(color: Colors.white,fontSize: 18),),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 70 , vertical: 5)),
                                  side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                                  elevation: MaterialStateProperty.all<double>(3),
                                ),
                                onPressed: ()=>_getOfferImageProduct(ImageSource.camera),
                              ),
                              SizedBox(height: 2,),
                              TextButton(
                                child: Text("Gallery",style: TextStyle(color: Colors.white,fontSize: 18),),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 70 , vertical: 5)),
                                  side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                                  elevation: MaterialStateProperty.all<double>(3),
                                ),
                                onPressed:()=>_getOfferImageProduct(ImageSource.gallery),
                              ),
                            ],
                          ),
                        ),
                      )),
                    )
                  ],
                ) : Container(),
                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 2,
        child: Container(
          width: size.width,
          height: size.height*0.09,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.orange,
                    Colors.deepOrange
                  ],
                  tileMode: TileMode.mirror,
                  end: Alignment.topLeft,
                  begin: Alignment.center
              )
          ),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(child: Text("Edit product",style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),)),
            ),
            onTap: ()=> _editProduct(),
          ),
        ),
      ),
    );
  }

  double _heights ({required Size size}){

    if(imagesProductFirebase.length == 1      || imagesProductFirebase.length < 4 )
      return size.height*.22 ;
    else if(imagesProductFirebase.length == 4 || imagesProductFirebase.length < 7)
      return size.height*.39;
    else if(imagesProductFirebase.length == 7 || imagesProductFirebase.length < 10)
      return size.height*.57;
    else if(imagesProductFirebase.length == 10 || imagesProductFirebase.length < 13)
      return size.height*.75;
    else
      return size.height*.22 ;
  }

  Widget _getStartDate(){

    return InkWell(
      borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
      splashColor: Colors.orange,
      highlightColor: Colors.transparent,
      child: Container(child: Icon(Icons.date_range, color: Colors.black,) ,
        decoration:BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
            color: Colors.orange
        ),),
      onTap: ()
      => showDatePicker(context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 360)))
          .then((date) => setState(()=>  date.toString().isEmpty ? "" : startDate = date!.toString())),
    );
  }

  Widget _getExpiryDate(){

    return InkWell(
      borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
      splashColor: Colors.orange,
      highlightColor: Colors.transparent,
      child: Container(child: Icon(Icons.date_range, color: Colors.black,) ,
        decoration:BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
            color: Colors.orange
        ),),
      onTap: ()
      => startDate.isNotEmpty ? showDatePicker(context: context,
          initialDate: DateTime.parse(startDate).add(Duration(days: 1)),
          firstDate: DateTime.parse(startDate).add(Duration(days: 1)),
          lastDate: DateTime.parse(startDate).add(Duration(days: 360)))
          .then((date) => setState(()=>  date.toString().isEmpty ? "" : expiryDate = date!.toString()))
          : toastMessage(context, message: "Create start date first"),
    );
  }

  String  _currency (String curr) {

    if(curr.contains("\$"))
      return "USD";
    else if(curr.contains("LE"))
      return "EGP";
    else if(curr.contains("€"))
      return "EUR";
    else if(curr.contains("£"))
      return "GBP";
    else if(curr.contains("¥"))
      return "JPY";
    else if(curr.contains("₽"))
      return "RUP";
    else if(curr.contains("元"))
      return "CNH";
    else if(curr.contains("₺"))
      return "TRY";
    else
      return "CAD";
  }


  @override
  void toastMessage(BuildContext context, {required String message}) {

    FlutterToastr.show(message, context, backgroundRadius: 5, duration: 3,
        position: FlutterToastr.bottom,backgroundColor: Colors.black54,textStyle: TextStyle(color: Colors.white,));
  }

  @override
  void dispose() {
    productTitle.dispose();
    priceBeforeDiscount.dispose();
    sellingPrice.dispose();
    priceBeforeDiscountOffer.dispose();
    sellingPriceOffer.dispose();
    inventory.dispose();
    description.dispose();
    super.dispose();
  }

}
