
import 'package:Shopping/Services/Constants.dart';

class BrandsModel{


  final String id;
  final String name;
  final String description;
  final String image;

  BrandsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory BrandsModel.fromJson(Map<String, dynamic>? jsonMap) {

    return BrandsModel(
      id         : jsonMap![Constants.IDBRANDS],
      name       : jsonMap[Constants.NAMEBRANDS ],
      description: jsonMap[Constants.DESCRIPTIONBRANDS],
      image      : jsonMap[Constants.IMAGEBRANDS],
    );
  }

  Map<String , dynamic> get toJson => {

    Constants.IDBRANDS           : this.id,
    Constants.NAMEBRANDS         : this.name,
    Constants.DESCRIPTIONBRANDS  : this.description,
    Constants.IMAGEBRANDS        : this.image

  };
}