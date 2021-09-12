
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// ...snapshot.data![index]["Names"].toList().map((e) => e == null ? Container(): Text(e["name"])),


class Constants{

  //Fonts
  static const String splashArabicFont  = "splasharabicfont";
  static const String splashFontEn      = "splashfont";
  static const String ubuntuBoldFont    = "ubuntuBold";
  static const String ubuntuMediumFont  = "ubuntuMedium";
  static const String ubuntuRegularFont = "ubuntuRegular";

  //Lists
  static const List<String> months = ["jan","Feb","Mar","Apl","May","Jun","Jul","Aug","Sep","Oct","Nov","Des"];

  //Functions
  static void showDialogs (BuildContext context,{required String title , required String content , required double  elevation }){
    showDialog(
        context: context,
        builder: (_)
        => AlertDialog(
          title: Center(child: Text(title , style: TextStyle(color: Colors.purple,fontSize: 22),),),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(content , style: TextStyle(color: Colors.purple,fontSize: 19),),
              Container(
                child: CircularProgressIndicator(backgroundColor: Colors.orange,),
              )
            ],
          ),
          elevation: elevation,
        ),
      barrierDismissible: false,
      barrierColor: Colors.black45,
    );
  }
  static double screenHeightSize (BuildContext context , double  less , double more ){
    return MediaQuery.of(context).size.height < 600.0 ? less  :  more  ;
  }
  static double screenWidthSize(BuildContext context , double  s , double m , double l){

    double width = MediaQuery.of(context).size.width ;

    if(width <= 411)
      return s ;
    else if(width > 411 && width <= 540)
      return m ;
    else
      return l ;
  }
  static String showTextEn({required String info}){
    return info.trim().toString().toLowerCase().replaceRange(0, 1, info.toString().substring(0,1).toUpperCase());
  }
  static Text arabicFont({required String text,required  double size,required  Color color,required  String lang}){
        return Text(text , style: TextStyle(color: color,fontSize: size,fontWeight: FontWeight.w500 ,fontFamily:lang.contains("ar") ?splashArabicFont : null),);
  }
  static Color getTexTColor(Color color){

    return useWhiteForeground(color)? Colors.white : Colors.black ;
  }
  static String customerPromotion (String promotion){

    if(promotion.contains(Constants.SuperAdmin))
      return "Super admin";
    else if(promotion.contains(Constants.Admin))
      return "Admin";
    else
      return "Customer";
  }


  //Promotions
  static const String SuperAdmin = "1000-SM";
  static const String Admin      = "2000-M";
  static const String Customer   = "3000-U";


  // Info User firebase
  static const String IDUSER          = "id";
  static const String NAME            = "name";
  static const String EMAIL           = "email";
  static const String PHONE           = "phone";
  static const String ADDRESS         = "address";
  static const String IMAGEUSER       = "image";
  static const String REGISTRATIONS   = "registrations";
  static const String PROMOTION       = "promotion";
  static const String JOINEDAT        = "joinedAt";
  static const dynamic CREATEDATUSER  = "createdAt";


  //Info Category

  static const String IDCATEGORY              = "id";
  static const String NAMECATEGORY            = "title";
  static const String DESCRIPTIONCATEGORY     = "description";
  static const String IMAGECATEGORY           = "image";

  //Info BRANDS

  static const String IDBRANDS               = "id";
  static const String NAMEBRANDS             = "title";
  static const String DESCRIPTIONBRANDS      = "description";
  static const String IMAGEBRANDS            = "image";

  // Info Product

  static const String  PRODUCTID                        = "productId";
  static const String  PRODUCTADMINID                   = "adminId";
  static const String  PRODUCTTITLE                     = "title";
  static const String  PRODUCTDESCRIPTION               = "description";
  static const String  PRODUCTCOVERIMAGE                = "coverImageProduct";
  static const String  PRODUCTOFFERIMAGE                = "offerImage";
  static const String  PRODUCTIMAGES                    = "imagesUrl";
  static const String  PRODUCTSIZES                     = "sizes";
  static const String  PRODUCTCOLORS                    = "colors";
  static const String  PRODUCTCOMMENTS                  = "comments";
  static const String  PRODUCTSELLINGPRICE              = "sellingPrice";
  static const String  PRODUCTPRICEBEFOREDISCOUNT       = "priceBeforeDiscount";
  static const String  PRODUCTDISCOUNTVALUE             = "discountValue";
  static const String  PRODUCTPRICEBEFOREDISCOUNTOFFER  = "priceBeforeDiscountOffer";
  static const String  PRODUCTSELLINGPRICEOFFER         = "sellingPriceOffer";
  static const String  PRODUCTDISCOUNTVALUOFFER         = "discountValueOffer";
  static const String  PRODUCTINVENTORY                 = "Inventory";
  static const String  PRODUCTCURRENCY                  = "currency";
  static const String  PRODUCTCATEGORYNAME              = "productCategoryName";
  static const String  PRODUCTBRANDS                    = "brands";
  static const String  PRODUCTSTARTDATE                 = "startDate";
  static const String  PRODUCTEXPIRYDATE                = "expiryDate";
  static const String  PRODUCTISACTIVATION              = "isActivation";
  static const String  PRODUCTISFAVORITE                = "isFavorite";
  static const String  PRODUCTISPOPULAR                 = "isPopular";
  static const String  PRODUCTISOFFER                   = "isOffer";
  static const String  PRODUCTCREATEAT                  = "createdAt";




}