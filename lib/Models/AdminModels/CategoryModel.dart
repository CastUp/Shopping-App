import 'package:Shopping/Services/Constants.dart';

class CategoryModel {

  final String id;
  final String name;
  final String description;
  final String image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic>? jsonMap) {

      return CategoryModel(
        id         : jsonMap![Constants.IDCATEGORY],
        name       : jsonMap[Constants.NAMECATEGORY],
        description: jsonMap[Constants.DESCRIPTIONCATEGORY],
        image      : jsonMap[Constants.IMAGECATEGORY],
      );
  }

  Map<String , dynamic> get toJson => {

    Constants.IDCATEGORY          : this.id,
    Constants.NAMECATEGORY        : this.name,
    Constants.DESCRIPTIONCATEGORY : this.description,
    Constants.IMAGECATEGORY       : this.image

  };
}
