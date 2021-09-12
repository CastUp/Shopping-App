
import 'package:Shopping/Services/Firebase/UploadingImageToFirebase.dart';
import 'package:Shopping/Services/Screens/ToastMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


abstract class FormCategoryAndBrand implements ToastMessage , UploadingImageToFirebase{

  Future<void>  set (BuildContext context ,{required String title , required String desc , required String image});

  Future<void> edit(BuildContext context , String idItem,{required String newTitle ,required String oldTitle, required String desc , required String image });

  Future<void> deleted(BuildContext context ,{required String idItem ,required String title});

  Future<DocumentSnapshot> getItemField({required String idItem });

  Future<int> productsNumber ({required String title});

  Stream<List<QueryDocumentSnapshot>>fetchListData();

}