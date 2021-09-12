
import 'package:Shopping/Services/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthModel {

  final String id ;
  final String name ;
  final String email ;
  final String phone ;
  final String address;
  final String imageUrl ;
  final String registrations;
  final String promotion ;
  final String joinedAt ;
  final Timestamp createdAt ;

  AuthModel(
      {required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.address,
        required this.imageUrl,
        required this.registrations,
        required this.promotion,
        required this.joinedAt,
        required this.createdAt});


  factory AuthModel.fromJson(Map<String , dynamic>? newUser){

      return AuthModel(
        id           : Constants.IDUSER,
        name         : Constants.NAME,
        email        : Constants.EMAIL,
        phone        : Constants.PHONE,
        address      : Constants.ADDRESS,
        imageUrl     : Constants.IMAGEUSER,
        registrations: Constants.REGISTRATIONS,
        promotion    : Constants.PROMOTION,
        joinedAt     : Constants.JOINEDAT,
        createdAt    : Constants.CREATEDATUSER,
      );
  }

  Map<String,dynamic> get toJson => {

    Constants.IDUSER            : this.id,
    Constants.NAME          : this.name,
    Constants.EMAIL         : this.email,
    Constants.PHONE         : this.phone,
    Constants.ADDRESS       : this.address,
    Constants.IMAGEUSER     : this.imageUrl,
    Constants.REGISTRATIONS : this.registrations,
    Constants.PROMOTION     : this.promotion,
    Constants.JOINEDAT      : this.joinedAt,
    Constants.CREATEDATUSER : this.createdAt,
  };


}