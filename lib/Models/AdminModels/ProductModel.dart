import 'dart:core';
import 'package:Shopping/Services/Constants.dart';


class ProductModel {
  final String productId;
  final String adminId;
  final String title;
  final String description;
  final String coverImageProduct;
  final String offerImage ;
  final List imagesUrl;
  final List sizes;
  final List colors;
  final List comments;
  final String sellingPrice;
  final String priceBeforeDiscount;
  final String discountValue;
  final String priceBeforeDiscountOffer ;
  final String sellingPriceOffer;
  final String discountValueOffer;
  final String inventory;
  final String currency;
  final String productCategoryName;
  final String brands;
  final String startDate;
  final String expiryDate;
  final bool isActivation ;
  final bool isFavorite;
  final bool isPopular;
  final bool isOffer;
  final String createAt;


  ProductModel({
    required this.productId,
    required this.adminId,
    required this.title,
    required this.description,
    required this.coverImageProduct,
    required this.offerImage,
    required this.imagesUrl,
    required this.sizes,
    required this.colors,
    required this.comments,
    required this.sellingPrice,
    required this.priceBeforeDiscount,
    required this.discountValue,
    required this.sellingPriceOffer,
    required this.priceBeforeDiscountOffer,
    required this.discountValueOffer,
    required this.inventory,
    required this.currency,
    required this.productCategoryName,
    required this.brands,
    required this.startDate,
    required this.expiryDate,
    required this.isActivation,
    required this.isFavorite,
    required this.isPopular,
    required this.isOffer,
    required this.createAt,
  });

  factory ProductModel.fromJson({objectProduct}){

    return ProductModel(
      productId               : objectProduct[Constants.PRODUCTID],
      adminId                 : objectProduct[Constants.PRODUCTADMINID],
      title                   : objectProduct[Constants.PRODUCTTITLE],
      description             : objectProduct[Constants.PRODUCTDESCRIPTION],
      coverImageProduct       : objectProduct[Constants.PRODUCTCOVERIMAGE],
      offerImage              : objectProduct[Constants.PRODUCTOFFERIMAGE],
      imagesUrl               : objectProduct[Constants.PRODUCTIMAGES],
      sizes                   : objectProduct[Constants.PRODUCTSIZES],
      colors                  : objectProduct[Constants.PRODUCTCOLORS],
      comments                : objectProduct[Constants.PRODUCTCOMMENTS],
      sellingPrice            : objectProduct[Constants.PRODUCTSELLINGPRICE],
      priceBeforeDiscount     : objectProduct[Constants.PRODUCTPRICEBEFOREDISCOUNT],
      discountValue           : objectProduct[Constants.PRODUCTDISCOUNTVALUE],
      priceBeforeDiscountOffer: objectProduct[Constants.PRODUCTPRICEBEFOREDISCOUNTOFFER],
      sellingPriceOffer       : objectProduct[Constants.PRODUCTSELLINGPRICEOFFER],
      discountValueOffer      : objectProduct[Constants.PRODUCTDISCOUNTVALUOFFER] ,
      inventory               : objectProduct[Constants.PRODUCTINVENTORY],
      currency                : objectProduct[Constants.PRODUCTCURRENCY],
      productCategoryName     : objectProduct[Constants.PRODUCTCATEGORYNAME],
      brands                  : objectProduct[Constants.PRODUCTBRANDS],
      startDate               : objectProduct[Constants.PRODUCTSTARTDATE],
      expiryDate              : objectProduct[Constants.PRODUCTEXPIRYDATE],
      isFavorite              : objectProduct[Constants.PRODUCTISFAVORITE],
      isActivation            : objectProduct[Constants.PRODUCTISACTIVATION],
      isPopular               : objectProduct[Constants.PRODUCTISPOPULAR],
      isOffer                 : objectProduct[Constants.PRODUCTISOFFER],
      createAt                : objectProduct[Constants.PRODUCTCREATEAT],);
  }


  Map<String , dynamic> toJson ()=> {

   Constants.PRODUCTID                       : this.productId,
   Constants.PRODUCTADMINID                  : this.adminId,
   Constants.PRODUCTTITLE                    : this.title,
   Constants.PRODUCTDESCRIPTION              : this.description,
   Constants.PRODUCTCOVERIMAGE               : this.coverImageProduct,
   Constants.PRODUCTOFFERIMAGE               : this.offerImage,
   Constants.PRODUCTIMAGES                   : this.imagesUrl,
   Constants.PRODUCTSIZES                    : this.sizes,
   Constants.PRODUCTCOLORS                   : this.colors,
   Constants.PRODUCTCOMMENTS                 : this.comments,
   Constants.PRODUCTSELLINGPRICE             : this.sellingPrice,
   Constants.PRODUCTPRICEBEFOREDISCOUNT      : this.priceBeforeDiscount,
   Constants.PRODUCTDISCOUNTVALUE            : this.discountValue,
   Constants.PRODUCTPRICEBEFOREDISCOUNTOFFER : this.priceBeforeDiscountOffer,
   Constants.PRODUCTSELLINGPRICEOFFER        : this.sellingPriceOffer,
   Constants.PRODUCTDISCOUNTVALUOFFER        : this.discountValueOffer,
   Constants.PRODUCTINVENTORY                : this.inventory,
   Constants.PRODUCTCURRENCY                 : this.currency,
   Constants.PRODUCTCATEGORYNAME             : this.productCategoryName,
   Constants.PRODUCTBRANDS                   : this.brands,
   Constants.PRODUCTSTARTDATE                : this.startDate,
   Constants.PRODUCTEXPIRYDATE               : this.expiryDate,
   Constants.PRODUCTISACTIVATION             : this.isActivation,
   Constants.PRODUCTISFAVORITE               : this.isFavorite,
   Constants.PRODUCTISPOPULAR                : this.isPopular,
   Constants.PRODUCTISOFFER                  : this.isOffer,
   Constants.PRODUCTCREATEAT                 : this.createAt
  };

}
