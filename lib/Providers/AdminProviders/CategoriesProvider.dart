import 'dart:io';
import 'package:Shopping/Models/AdminModels/CategoryModel.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Firebase/FormCategoryAndBrand.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:uuid/uuid.dart';

class CategoriesProvider with ChangeNotifier , FormCategoryAndBrand{

  static CollectionReference _collectionReference(String child) => FirebaseFirestore.instance.collection(child);


  @override
  Future<void> set(BuildContext context, {required String title, required String desc, required String image}) async {

    Constants.showDialogs(context, title: "Create category", content: "Waiting", elevation: 4);

    var uuid = Uuid();

    String categoryId = uuid.v4().length >= 28 ? uuid.v4().substring(0,27)  : uuid.v4();

    try{

      String imagesUrl = await uploadingImage(context, imagePath: image);

      await _collectionReference("Categories").doc(categoryId).set(new CategoryModel(
          id: categoryId,
          name: title.trim().toLowerCase(),
          description: desc.trim().toLowerCase(),
          image: imagesUrl
      ).toJson);

      this.toastMessage(context, message: "Successfully added");

    }catch(e){

      if(e.toString().contains("'package:firebase_storage/src/reference.dart': Failed assertion: line 126 pos 12: 'file.absolute.existsSync()': is not true.")){
        this.toastMessage(context, message: "Please add Image");
      }else{
        this.toastMessage(context, message: e.toString());
      }

    }
    Navigator.pop(context);
  }


  @override
  Future<void> edit(BuildContext context, String idItem, {required String newTitle, required String oldTitle, required String desc, required String image}) async{
    Constants.showDialogs(context, title: "Edit category", content: "Waiting", elevation: 4);

    try{

      List idProducts =[];

      final products =   await _collectionReference("Products").get();

      final listProducts = products.docs.where((product) => product.get(Constants.PRODUCTCATEGORYNAME) == oldTitle).toList();

      idProducts = listProducts.map((list) => list.get(Constants.PRODUCTID)).toList();

      await _collectionReference("Categories").doc(idItem).update(new CategoryModel(
          id: idItem,
          name: newTitle.trim().toLowerCase(),
          description: desc.trim().toLowerCase(),
          image: image).toJson);


      idProducts.forEach((id) async {
        await _collectionReference("Products").doc(id.toString()).update({Constants.PRODUCTCATEGORYNAME:newTitle.toString().trim().toLowerCase()});
      });

      this.toastMessage(context, message: "Edited successfully");

    }catch(e){
      this.toastMessage(context, message: e.toString());
    }
    Navigator.pop(context);
  }


  @override
  Future<void> deleted(BuildContext context, {required String idItem ,required String title}) async{

    Constants.showDialogs(context, title: "Delete ${title} Category", content: "Waiting", elevation: 4);

    int productsNum = 0 ;

    List<QueryDocumentSnapshot> products = await _collectionReference("Products").get().then((products) => products.docs);

    products.forEach((product) {

      if(product.get(Constants.PRODUCTCATEGORYNAME).toString().contains(title))
        productsNum++;
    });

    Navigator.pop(context);

    if(productsNum == 0) {
      try {
        await _collectionReference("Categories").doc(idItem).delete();
        this.toastMessage(context, message: "Deleted successfully");
      } catch (e) {
        this.toastMessage(context, message: e.toString());
      }
    }else{
      await Flushbar(
        title:"Can't delete\n ",
        titleColor: Colors.white,
        titleSize: 17,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(5) ,bottomLeft: Radius.circular(5)),
        backgroundGradient: LinearGradient(
          colors: [
            Colors.red,
            Colors.orange.shade500
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.mirror,
        ),
        message: "It is not possible to delete because there are $productsNum products that include this category. You can modify the title of the category",
        messageSize: 15,
        messageColor: Colors.white,
        flushbarPosition: FlushbarPosition.BOTTOM ,
        icon: Icon(Icons.error,color: Colors.white,),
      ).show(context);
    }

    Navigator.pop(context);

  }

  @override
  Future<int> productsNumber({required String title}) async {

    int productsNum = 0 ;

    List products = await _collectionReference("Products").get().then((product) => product.docs);

    products.forEach((product) {

      if(product.get(Constants.PRODUCTCATEGORYNAME).toString().contains(title))
        productsNum++;
    });

    return productsNum ;
  }

  @override
  Future<DocumentSnapshot<Object?>> getItemField({required String idItem}) async {

    final resultData = await  _collectionReference("Categories").doc(idItem).get();

    return resultData ;
  }

  @override
  Future<String> uploadingImage(BuildContext context, {required String imagePath}) async {

    var uuid = Uuid();
    String imageRef = uuid.v4().substring(0,10);

    Reference storage =  FirebaseStorage.instance.ref().child("CategoriesImages").child("${imageRef}.jpg") ;

    await storage.putFile(File(imagePath));

    String imageUrl = await storage.getDownloadURL();

    return imageUrl ;

  }

  @override
  Stream<List<QueryDocumentSnapshot>> fetchListData() {

    final listCategory =  _collectionReference("Categories").snapshots().map((event) => event.docs);

    return listCategory;
  }

  @override
  void toastMessage(BuildContext context, {required String message}) {

    FlutterToastr.show(message, context, backgroundRadius: 5, duration: 2,
        position: FlutterToastr.bottom,backgroundColor: Colors.black54,textStyle: TextStyle(color: Colors.white,));
  }



}
