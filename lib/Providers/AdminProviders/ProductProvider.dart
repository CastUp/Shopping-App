
import 'dart:io';
import 'package:Shopping/Models/AdminModels/ProductModel.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Firebase/UploadingImageToFirebase.dart';
import 'package:Shopping/Services/Screens/ToastMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ProductProvider with ChangeNotifier ,ToastMessage,UploadingImageToFirebase{

  static CollectionReference _collectionReference(String child) => FirebaseFirestore.instance.collection(child);
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<void> set(BuildContext context,
  {required String title ,required String description , required String sellingPrice ,  required String priceBeforeDiscount,
   required String inventory ,required String currency,required String productCategoryName ,required String brand ,required String coverImage,
   required String sellingPriceOffer, required String priceBeforeDiscountOffer, required List<String> imagesPath, required String offerImage ,
   List<Map<String ,String>>? sizes,List<Map<String ,String>>? colors , List<Map<String ,String>>? comments, required String startDate ,
   required String expiryDate ,bool isActivation = true, bool isFavorite = false ,bool isPopular = false , bool isOffer = false}) async{

    Constants.showDialogs(context, title: "Create new product", content: "Waiting", elevation: 4);

    var uuid = Uuid();
    String productId = uuid.v4().length >= 28 ? uuid.v4().substring(0,27)  : uuid.v4();

    DateTime dateNow     = DateTime.now();
    String formattedDate = DateFormat.yMMMd().format(dateNow);

    double? sellingPrices        = double.tryParse(sellingPrice);
    double? pricesBeforeDiscount = double.tryParse(priceBeforeDiscount);
    double? discount             = sellingPrices == pricesBeforeDiscount ?  0.0 : 100- (sellingPrices!/pricesBeforeDiscount! * 100) ;
    String discountValue         = discount.round().toString();

    double? sellingPricesOffer         = sellingPriceOffer.contains("0.0")? 0.0 : double.tryParse(sellingPriceOffer);
    double? pricesBeforeDiscountOffer  = priceBeforeDiscountOffer.contains("0.0")? 0.0 : double.tryParse(priceBeforeDiscountOffer);
    double? discountOffer              = sellingPricesOffer == pricesBeforeDiscountOffer ?  0.0 : 100- (sellingPricesOffer!/pricesBeforeDiscountOffer! * 100) ;
    String discountValueOffer          = discountOffer.round().toString();

    try{

      List<Map<String , String>> imagesUrl = await uploadingImages(context, imagePath: imagesPath);
      String imageUrl                      = await uploadingImage(context, imagePath: coverImage);
      String offerImageUrl                 = await uploadingOfferImage(context, imagePath: offerImage);

      ProductModel productModel = ProductModel(
          productId               : productId,
          adminId                 : _firebaseAuth.currentUser!.uid,
          title                   : title.trim().toLowerCase(),
          description             : description.trim().toLowerCase(),
          coverImageProduct       : imageUrl,
          offerImage              : offerImageUrl,
          imagesUrl               : imagesUrl,
          sizes                   : sizes!,
          colors                  : colors!,
          comments                : comments!,
          sellingPrice            : sellingPrice.trim(),
          priceBeforeDiscount     : priceBeforeDiscount.trim(),
          discountValue           : discountValue,
          priceBeforeDiscountOffer: priceBeforeDiscountOffer,
          sellingPriceOffer       : sellingPriceOffer,
          discountValueOffer      : discountValueOffer,
          inventory               : inventory.trim(),
          productCategoryName     : productCategoryName,
          currency                : currency,
          brands                  : brand,
          startDate               : startDate,
          expiryDate              : expiryDate,
          isActivation            : isActivation,
          isFavorite              : isFavorite,
          isPopular               : isPopular,
          isOffer                 : isOffer,
          createAt                : formattedDate);

     await  _collectionReference("Products").doc(productId).set(productModel.toJson())
         .then((value) => this.toastMessage(context, message: "Successfully added"));

    }catch(e){

      if(e.toString().contains("'package:firebase_storage/src/reference.dart': Failed assertion: line 126 pos 12: 'file.absolute.existsSync()': is not true.")){
        this.toastMessage(context, message: "Please add Image");
      }else{
        this.toastMessage(context, message: e.toString());
        print(e.toString());
      }
    }
    Navigator.pop(context);
  }



  Future<void> edit(BuildContext context, String productId,
      {required String title ,required String description , required String sellingPrice ,  required String priceBeforeDiscount,
      required String inventory ,required String currency,required String productCategoryName ,required String brand ,required String coverImage,
      required List images, required String offerImage ,required List sizes,required List colors ,required String sellingPriceOffer,
      required String priceBeforeDiscountOffer, required List comments, required String startDate ,required String expiryDate,
      required bool isActivation,required bool isFavorite , required bool isPopular,required bool isOffer, required String createDate})async {

    Constants.showDialogs(context, title: "Product Edit", content: "Waiting", elevation: 4);

    double? sellingPrices        = double.tryParse(sellingPrice);
    double? pricesBeforeDiscount = double.tryParse(priceBeforeDiscount);
    double? discount             = sellingPrices == pricesBeforeDiscount ?  0.0 : 100- (sellingPrices!/pricesBeforeDiscount! * 100) ;
    String discountValue         = discount.round().toString();

    double? sellingPricesOffer         = sellingPriceOffer.contains("0.0")? 0.0 : double.tryParse(sellingPriceOffer);
    double? pricesBeforeDiscountOffer  = priceBeforeDiscountOffer.contains("0.0")? 0.0 : double.tryParse(priceBeforeDiscountOffer);
    double? discountOffer              = sellingPricesOffer == pricesBeforeDiscountOffer ?  0.0 : 100- (sellingPricesOffer!/pricesBeforeDiscountOffer! * 100) ;
    String discountValueOffer          = discountOffer.round().toString();

    try{

      ProductModel productModel = ProductModel(
          productId               : productId,
          adminId                 : _firebaseAuth.currentUser!.uid,
          title                   : title.trim().toLowerCase(),
          description             : description.trim().toLowerCase(),
          coverImageProduct       : coverImage,
          offerImage              : offerImage,
          imagesUrl               : images,
          sizes                   : sizes,
          colors                  : colors,
          comments                : comments,
          sellingPrice            : sellingPrice.trim(),
          priceBeforeDiscount     : priceBeforeDiscount.trim(),
          discountValue           : discountValue,
          priceBeforeDiscountOffer: priceBeforeDiscountOffer,
          sellingPriceOffer       : sellingPriceOffer,
          discountValueOffer      : discountValueOffer,
          inventory               : inventory.trim(),
          productCategoryName     : productCategoryName,
          currency                : currency,
          brands                  : brand,
          startDate               : startDate,
          expiryDate              : expiryDate,
          isActivation            : isActivation,
          isFavorite              : isFavorite,
          isPopular               : isPopular,
          isOffer                 : isOffer,
          createAt                : createDate);

         await _collectionReference("Products").doc(productId).update(productModel.toJson())
              .then((value) => this.toastMessage(context, message: "Edited successfully"));

    }catch(e){

      if(e.toString().contains("'package:firebase_storage/src/reference.dart': Failed assertion: line 126 pos 12: 'file.absolute.existsSync()': is not true.")){
        this.toastMessage(context, message: "Please add Image");
      }else{
        this.toastMessage(context, message: e.toString());
        print(e.toString());
      }
    }
    Navigator.pop(context);

  }


  Future<void> delete(BuildContext context , {required String idItem})async{

    Constants.showDialogs(context, title: "Delete", content: "Waiting", elevation: 2);

    try{
    await  _collectionReference("Products").doc(idItem).delete().then((value) => this.toastMessage(context, message: "Deleted"));

    }catch(e){
      this.toastMessage(context, message: e.toString());
    }
    Navigator.pop(context);
  }

  Future<void> deleteAll(BuildContext context , {required List idItem})async{

    Constants.showDialogs(context, title: "Delete", content: "Waiting", elevation: 2);

    try{

      idItem.forEach((product) async {
        await  _collectionReference("Products").doc(product.get(Constants.PRODUCTID)).delete();
      });

      this.toastMessage(context, message: "Deleted");

    }catch(e){
      this.toastMessage(context, message: e.toString());
    }
    Navigator.pop(context);
  }

  Stream<List<QueryDocumentSnapshot>> fetchListData(){

    final listProducts =  _collectionReference("Products").snapshots().map((products) => products.docs);

    return listProducts ;
  }

  Future<DocumentSnapshot<Object?>> fetchProduct({required String idProduct}) async{

    final product = await _collectionReference("Products").doc(idProduct).get();
    return product ;
  }

  Future<void> changeValueProduct(BuildContext context,{required String idProduct,required bool isActivation }) async{

   final userInfo =  await _collectionReference("Users").doc(_firebaseAuth.currentUser!.uid).get();

   if(userInfo.get(Constants.PROMOTION).toString().contains(Constants.SuperAdmin))
       return  await _collectionReference("Products").doc(idProduct).update({Constants.PRODUCTISACTIVATION: isActivation})
           .then((_) => this.toastMessage(context, message: isActivation? "Active":"Inactive"));
   else
     this.toastMessage(context, message: "You must be super admin");

  }

  Future<List<Map<String,String>>> uploadingImages(BuildContext context, {required List<String> imagePath}) async {

    List <Map<String , String>> imagesUrl =  [];

    var uuid = Uuid();

    imagePath.forEach((element) async {

      String imageRef = uuid.v4().substring(0,10);

      if(element.isEmpty){
        imagesUrl.add({"image": "https://firebasestorage.googleapis.com/v0/b/full-ecommerce-5f7a1.appspot.com/o/Nodelete%2F1253463288.png?alt=media&token=2e9f9188-0a7e-408a-93da-ade17cbb84d7"});
      }
      else{
        Reference storage =  FirebaseStorage.instance.ref().child("ProductsImages").child("${imageRef}.jpg") ;

        await storage.putFile(File(element));

        String imageUrl = await storage.getDownloadURL();

        imagesUrl.add({"image": imageUrl});
      }

    });

    return imagesUrl ;
  }

  Future<String> uploadingOfferImage(BuildContext context, {required String imagePath}) async{

    String imageUrl = "";

    if(imagePath.isNotEmpty){

      var uuid = Uuid();
      String imageRef = uuid.v4().substring(0,10);

      Reference storage =  FirebaseStorage.instance.ref().child("ProductsImages").child("${imageRef}.jpg") ;

      await storage.putFile(File(imagePath));

      imageUrl = await storage.getDownloadURL();
    }

    return imageUrl ;

  }

  @override
  Future<String> uploadingImage(BuildContext context, {required String imagePath}) async{

    var uuid = Uuid();
    String imageRef = uuid.v4().substring(0,10);

    Reference storage =  FirebaseStorage.instance.ref().child("ProductsImages").child("${imageRef}.jpg") ;

    await storage.putFile(File(imagePath));

    String imageUrl = await storage.getDownloadURL();

    return imageUrl ;

  }

  @override
  void toastMessage(BuildContext context, {required String message}) {
    FlutterToastr.show(message, context, backgroundRadius: 5, duration: 2,
        position: FlutterToastr.bottom,backgroundColor: Colors.black54,textStyle: TextStyle(color: Colors.white,));
  }


}