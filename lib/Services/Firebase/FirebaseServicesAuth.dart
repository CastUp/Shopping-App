import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';


class FirebaseServicesAuth {

  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance ;

  static CollectionReference _collectionReference (String collectionPath)=> FirebaseFirestore.instance.collection(collectionPath);

  static Future<String> getPromotionUser () async{

    var promotion = Constants.Customer ;

    if(_collectionReference("PromotionUser") != null){

      final snapshot = await _collectionReference("PromotionUser").get();

      snapshot.docs.forEach((element) {
        if(element.get(Constants.IDUSER).toString().contains(_firebaseAuth.currentUser!.uid))
          promotion = element.get(Constants.PROMOTION).toString();
        return ;
      });
    }

    return promotion ;

  }
  static Future<String> getPhoneUser () async{

    var phone = "";

    if(_collectionReference("PromotionUser") != null){

      final snapshot = await _collectionReference("PromotionUser").get();

      snapshot.docs.forEach((element) {
        if(element.get(Constants.IDUSER).toString().contains(_firebaseAuth.currentUser!.uid))
          phone = element.get(Constants.PHONE).toString();
        return ;
      });
    }

    return phone ;

  }
  static Future<String> getAddressUser () async{

    var address = "";

    if(_collectionReference("PromotionUser") != null){

      final snapshot = await _collectionReference("PromotionUser").get();

      snapshot.docs.forEach((element) {
        if(element.get(Constants.IDUSER).toString().contains(_firebaseAuth.currentUser!.uid))
          address = element.get(Constants.ADDRESS).toString();
        return ;
      });
    }

    return address ;

  }

  static Future<void> infoUserStorage(String promotionUser , String phone , String address) async{

    Map<String , dynamic> infoUser ={

      Constants.IDUSER : _firebaseAuth.currentUser!.uid,
      Constants.PROMOTION : promotionUser,
      Constants.PHONE : phone,
      Constants.ADDRESS : address
    } ;

    await _collectionReference("PromotionUser").doc(_firebaseAuth.currentUser!.uid)
        .set(infoUser);
  }

}