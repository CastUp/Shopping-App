
import 'package:Shopping/Models/LanguagesModel.dart';
import 'package:Shopping/Parts/Admin/InnerScreen/Listproducts/CreateNewProduct.dart';
import 'package:Shopping/Parts/Admin/InnerScreen/Listproducts/EditProduct.dart';
import 'package:Shopping/Providers/AdminProviders/BrandsProvider.dart';
import 'package:Shopping/Providers/AdminProviders/CategoriesProvider.dart';
import 'package:Shopping/Providers/AdminProviders/ProductProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:Shopping/Services/Screens/AlertDialogs.dart';
import 'package:Shopping/Services/Screens/ToastMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:provider/provider.dart';

class ListProducts extends StatefulWidget {

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> with AlertDialogs ,ToastMessage{

  GlobalKey<FormState> _globalFormInv = GlobalKey();
  GlobalKey<FormState> _globalFormPr  = GlobalKey();

  List<String> activeProduct           = ["Active","Inactive"];
  List<QueryDocumentSnapshot> products = [];
  String lang                     = "en";
  String search                   = "";
  String nameSearch               = "title";
  int fromInventory               = 0 ;
  int toInventory                 = 0 ;
  double fromPrice                = 0.0 ;
  double toPrices                 = 0.0 ;
  bool   brand                    = false ;
  bool   category                 = false ;
  bool   activation               = false ;
  bool   inventory                = false ;
  bool   prices                   = false ;

  void searchInventory (List<QueryDocumentSnapshot> listProducts){

    if(_globalFormInv.currentState!.validate()){
      _globalFormInv.currentState!.save();
      if(fromInventory > toInventory)
         this.toastMessage(context, message: SetLocalization.of(context)!.getTranslateValue(Keys.listProductToastInventory)!);
      else{
        setState(() {
          nameSearch = "inventory";
          search     = "inventory";
        });
        _listProducts(listProducts);
        Navigator.pop(context);
      }
    }
  }

  void searchPrices (List<QueryDocumentSnapshot> listProducts){

    if(_globalFormPr.currentState!.validate()){
      _globalFormPr.currentState!.save();
      if(fromPrice > toPrices)
        this.toastMessage(context, message: SetLocalization.of(context)!.getTranslateValue(Keys.listProductToastPrice)!);
      else{
        setState(() {
          nameSearch = "prices";
          search     = "prices";
        });
        _listProducts(listProducts);
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    SaveLanguage.getLang().then((languageCode) => setState(()=> lang = languageCode));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size ;
    

    return Consumer<ProductProvider>(
      builder: (context , value , child)
      =>Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream:value.fetchListData(),
            builder: (context , AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot)
            => snapshot.hasData ? Container(
              height: size.height,
              width: size.width,
              padding: EdgeInsets.only(right: 5,left: 5,top: 20,bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Table(
                        defaultVerticalAlignment:
                        TableCellVerticalAlignment.top,
                        columnWidths: {
                          0:FlexColumnWidth(2),
                          1:FlexColumnWidth(5),
                          2:FlexColumnWidth(1),
                        },
                        children: <TableRow>[
                          TableRow(
                              children: <Widget>[
                                TextButton(
                                    child: Text(search.isEmpty ? SetLocalization.of(context)!.getTranslateValue(Keys.listProductCreate)! : SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthCancel)!,
                                      style: TextStyle(color: Colors.white ,fontSize: lang.contains("en")? 18 : 21 ,fontWeight:lang.contains("en")? FontWeight.bold : FontWeight.w400 ,
                                          fontFamily: lang.contains("ar")? Constants.splashArabicFont:null),),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: lang.contains("en")? 15 : 10)),
                                        elevation: MaterialStateProperty.all<double>(4),
                                        backgroundColor: MaterialStateProperty.all<Color>(search.isEmpty ? Colors.orange.shade700 : Colors.orange.shade800)
                                    ),
                                    onPressed: ()
                                    => search.isEmpty ? Navigator.of(context).push(MaterialPageRoute(builder: (_)=>CreateNewProduct())) : setState(()=> search = "")
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: TextField(
                                      maxLines: 1,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(color: Colors.black, fontSize: lang.contains("ar") ? 20:19 ,
                                        fontFamily: lang.contains("ar") ? Constants.splashArabicFont : null,),
                                      decoration: InputDecoration(
                                          hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTitle)!,
                                          hintStyle:
                                          TextStyle(color: Colors.grey, fontSize: lang.contains("en")? 18 : 21,fontFamily: lang.contains("ar")? Constants.splashArabicFont:null),
                                          border: InputBorder.none,
                                          suffixIcon: Icon(
                                            Icons.search_outlined,
                                            color: Colors.orange,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                              borderSide: BorderSide(width: 1 , color: Colors.orange)
                                          )
                                      ),
                                      onChanged: (val) => setState((){
                                        this.search     = val.trim();
                                        this.nameSearch = "title";
                                      })),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.list,color: Colors.white,),
                                    onPressed: ()=>  Scaffold.of(context).openDrawer(),
                                  ),
                                )
                              ]
                          ),
                        ],
                      )
                  ),

                  search.isNotEmpty ?
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 2 ,vertical: 4),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8 , vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blueGrey,width: 0.7)
                            ),
                            child: RichText(
                              text: TextSpan(
                                  children:[
                                    TextSpan(
                                      text: "$filter : ",
                                      style: TextStyle(color: Colors.black,fontSize: lang.contains("ar")? 18:16,
                                          fontWeight: lang.contains("ar")? FontWeight.w400 : FontWeight.w500 ,
                                        fontFamily: lang.contains("ar")? Constants.splashArabicFont : null
                                      ),
                                    ),
                                    TextSpan(
                                        text: search.length < 25 ? Constants.showTextEn(info:search) : Constants.showTextEn(info:search).substring(0,25)+"...",
                                        style:TextStyle(color: Colors.deepPurple, fontSize: lang.contains("ar") ? 18:16 ,
                                          fontFamily: lang.contains("ar") ? Constants.splashArabicFont : null,),
                                    )
                                  ]
                              ),
                            ),
                          ),
                          SizedBox(width: 5,),
                          _listProducts(snapshot.data!).length >= 1 ?
                          InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4 , vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.delete_forever,color: Colors.red,),
                                  Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductDeleteAll)!,style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600,fontSize: 17),)
                                ],
                              ),
                            ),
                            onTap: ()=> showDialog(
                                context: context,
                                builder: (context)=>showAlertDialog(context,
                                    function: ()=>value.deleteAll(context, idItem: products)
                                        .then((_){
                                      setState(() {
                                        search     = "";
                                        nameSearch = "title";
                                      });
                                      Navigator.pop(context);
                                    }),
                                    title: SetLocalization.of(context)!.getTranslateValue(Keys.listProductDeleteAll)!,
                                    dec: SetLocalization.of(context)!.getTranslateValue(Keys.listProductSure)!)
                            ),
                          ) : Container(),
                        ],
                      )
                  ):Container(),

                  Expanded(child: Container (
                    child: ListView.separated(
                      itemCount: snapshot.hasData ? _listProducts(snapshot.data!).length : 0 ,
                      separatorBuilder: (context , indexSep)=> SizedBox(height: 5,),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index)
                      => Material(
                        elevation: 1.5,
                        type: MaterialType.card,
                        shadowColor: Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          child:Stack(
                            children: <Widget>[
                              Container(
                                width: size.width,
                                height: lang.contains("en")? size.height*.26 : size.height*.29,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.grey.withOpacity(.01)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        tileMode: TileMode.mirror
                                    )
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft    : lang.contains("en")? Radius.circular(5) : Radius.circular(0),
                                        bottomLeft : lang.contains("en")? Radius.circular(5) : Radius.circular(0),
                                        topRight   : lang.contains("en")? Radius.circular(0) : Radius.circular(5),
                                        bottomRight: lang.contains("en")? Radius.circular(0) : Radius.circular(5),
                                      ),
                                      child: Image.network(_listProducts(snapshot.data!)[index].get(Constants.PRODUCTCOVERIMAGE),
                                        height: double.infinity,
                                        width: size.width*0.40 ,
                                        fit: BoxFit.fill,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:CrossAxisAlignment.start,
                                            children: <Widget>[
                                              FittedBox(
                                                child: RichText(
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "${SetLocalization.of(context)!.getTranslateValue(Keys.listProductTitle)!} : ",
                                                            style: TextStyle(color: Colors.black,fontWeight: lang.contains("ar")? FontWeight.w500 : FontWeight.bold ,fontSize: lang.contains("ar")? 18:14,
                                                                fontFamily: lang.contains("ar")? Constants.splashArabicFont:null)),
                                                        TextSpan(text: Constants.showTextEn(info: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTTITLE)),style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.w500,fontSize: 13)),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                child: RichText(
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "${SetLocalization.of(context)!.getTranslateValue(Keys.listProductBrand)!} : ",
                                                            style: TextStyle(color: Colors.black,fontWeight: lang.contains("ar")? FontWeight.w500 : FontWeight.bold ,fontSize: lang.contains("ar")? 18:14,
                                                                fontFamily: lang.contains("ar")? Constants.splashArabicFont:null)),
                                                        TextSpan(text: Constants.showTextEn(info: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTBRANDS)),style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.w500,fontSize: 13)),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                child: RichText(
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "${SetLocalization.of(context)!.getTranslateValue(Keys.listProductCategory)!} : ",
                                                            style: TextStyle(color: Colors.black,fontWeight: lang.contains("ar")? FontWeight.w500 : FontWeight.bold ,fontSize: lang.contains("ar")? 18:14,
                                                                fontFamily: lang.contains("ar")? Constants.splashArabicFont:null)),
                                                        TextSpan(text: Constants.showTextEn(info: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTCATEGORYNAME)),style: TextStyle(color: Colors.red.shade700,fontWeight: FontWeight.w500,fontSize: 13)),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                child: RichText(
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "${SetLocalization.of(context)!.getTranslateValue(Keys.listProductInventory)!} : ",
                                                            style: TextStyle(color: Colors.black,fontWeight: lang.contains("ar")? FontWeight.w500 : FontWeight.bold ,fontSize: lang.contains("ar")? 18:14,
                                                                fontFamily: lang.contains("ar")? Constants.splashArabicFont:null)),
                                                        TextSpan(text: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTINVENTORY),style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.w500,fontSize: 13)),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                              FittedBox(
                                                child: RichText(
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                      children: <TextSpan>[
                                                        TextSpan(text: "${SetLocalization.of(context)!.getTranslateValue(Keys.listProductPrice)!} : ",
                                                            style: TextStyle(color: Colors.black,fontWeight: lang.contains("ar")? FontWeight.w500 : FontWeight.bold ,fontSize: lang.contains("ar")? 18:14,
                                                                fontFamily: lang.contains("ar")? Constants.splashArabicFont:null)),
                                                        TextSpan(text: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTCURRENCY),style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.bold,fontSize: 13)),
                                                        TextSpan(text: " ${getPriceProduct(_listProducts(snapshot.data!), index)}",style: TextStyle(color: Colors.blue.shade900,fontWeight: FontWeight.w500,fontSize: 13)),
                                                      ]
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Material(
                                                        color: Colors.green.shade200,
                                                        elevation: 4,
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: InkWell(
                                                          splashColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                          child: CircleAvatar(
                                                            radius: 16,
                                                            backgroundColor: Colors.green.shade700,
                                                            child: Icon(Icons.edit,color: Colors.white,),
                                                          ),
                                                          radius: 16,
                                                          onTap: ()=> Navigator.push(context,
                                                              MaterialPageRoute(builder: (_)
                                                              =>EditProduct(idProduct: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTID)))),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20,),
                                                      Material(
                                                        color: Colors.red.shade200,
                                                        elevation: 4,
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: InkWell(
                                                          splashColor: Colors.transparent,
                                                          highlightColor: Colors.transparent,
                                                          child: CircleAvatar(
                                                            radius: 16,
                                                            backgroundColor: Colors.red.shade700,
                                                            child: Icon(Icons.delete_forever_outlined,color: Colors.white,),
                                                          ),
                                                          radius: 16,
                                                          onTap: ()=> showDialog(
                                                            context: context,
                                                            builder:(context)
                                                            => showAlertDialog(context,
                                                                function: ()=>value.delete(context, idItem: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTID)).
                                                                then((_) => Navigator.pop(context)),
                                                                title: SetLocalization.of(context)!.getTranslateValue(Keys.listProductDelete)!,
                                                                dec: SetLocalization.of(context)!.getTranslateValue(Keys.listProductSure)!),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Switch(
                                                    value: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTISACTIVATION),
                                                    onChanged: (val)=> value.changeValueProduct(context,
                                                      idProduct: _listProducts(snapshot.data!)[index].get(Constants.PRODUCTID),
                                                      isActivation: val,),
                                                    activeColor: Colors.deepOrange,
                                                    inactiveThumbColor: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: (){},
                          onLongPress: (){},
                        ),
                      ),
                    ),
                  ),),
                ],
              ),
            ) :
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  Text("Waiting",style: TextStyle(fontSize: 18,color: Colors.black26),),
                  SizedBox(width: 10,),
                  CircularProgressIndicator(color: Colors.black26,strokeWidth: 2,)
                ],
              ),
            )
        ),
        drawer: StreamBuilder(
          stream: value.fetchListData(),
          builder: (context , AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot)
          => AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            width: size.width*.60,
            height: size.height*.70,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight   : lang.contains("en")? Radius.circular(10) : Radius.circular(0),
                bottomRight: lang.contains("en")? Radius.circular(10) : Radius.circular(0),
                topLeft    : lang.contains("en")? Radius.circular(0)  : Radius.circular(10),
                bottomLeft : lang.contains("en")? Radius.circular(0)  : Radius.circular(10),
              ),
              child: Drawer(
                elevation: 4,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height*.08,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: lang.contains("en")? Radius.circular(10) : Radius.circular(0),
                              topLeft : lang.contains("en")? Radius.circular(0) : Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.orange,
                                  Colors.deepOrange
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                tileMode: TileMode.mirror
                            )
                        ),
                        child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductOption)!,
                          style: TextStyle(color: Colors.white,fontWeight:lang.contains("ar")? FontWeight.w400:FontWeight.w600,
                              fontSize: lang.contains("ar")? 24:18, fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
                        child: Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(5),
                              splashColor: Colors.black12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.bookmarks_rounded,color: Colors.blue,),
                                  Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductBrand)!,
                                    style: TextStyle(color: Colors.black87,fontWeight:lang.contains("ar")? FontWeight.w400:FontWeight.bold,
                                        fontSize: lang.contains("ar")? 19:15, fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),),
                                  Icon(brand ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up,color: brand ? Colors.red : Colors.black87,),
                                ],
                              ),
                              onTap: ()=> setState(()=> brand = !brand),
                            ),
                            Divider(color: Colors.blueGrey,thickness: 0.5,),
                            !brand ? Container():
                            Consumer<BrandsProvider>(
                              builder: (context , value , child)
                              => StreamBuilder(
                                  stream: value.fetchListData(),
                                  builder: (context ,AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot)
                                  => snapshot.hasData ? Container(
                                    child: Column(
                                      children: [
                                        ...snapshot.data!.map((brand) => InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          splashColor: Colors.orange.shade200,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.bookmark,color: Colors.deepPurple,size: 15,),
                                                SizedBox(width: 5,),
                                                Text(brand.get(Constants.NAMEBRANDS),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),)
                                              ],
                                            ),
                                          ),
                                          onTap: (){
                                            setState((){
                                              search     = brand.get(Constants.NAMEBRANDS);
                                              nameSearch = "brand";
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),),
                                      ],
                                    ),
                                  ) : Container()
                              ),
                            ),

                            SizedBox(height: 10,) ,//=================================Category==================

                            InkWell(
                              borderRadius: BorderRadius.circular(5),
                              splashColor: Colors.black12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.category_rounded,color: Colors.deepOrange.shade500,),
                                  Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductCategory)!,
                                    style: TextStyle(color: Colors.black87,fontWeight:lang.contains("ar")? FontWeight.w400:FontWeight.bold,
                                        fontSize: lang.contains("ar")? 19:15, fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),),
                                  Icon(category ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up,color: category ? Colors.red : Colors.black87,),
                                ],
                              ),
                              onTap: ()=> setState(()=> category = !category),
                            ),
                            Divider(color: Colors.blueGrey,thickness: 0.5,),
                            !category? Container():
                            Consumer<CategoriesProvider>(
                              builder: (context , value , child)
                              => StreamBuilder(
                                  stream: value.fetchListData(),
                                  builder: (context ,AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot)
                                  => snapshot.hasData ? Container(
                                    child: Column(
                                      children: [
                                        ...snapshot.data!.map((category) => InkWell(
                                          borderRadius: BorderRadius.circular(10),
                                          splashColor: Colors.orange.shade200,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Icon(Icons.bookmark,color: Colors.deepPurple,size: 15,),
                                                SizedBox(width: 5,),
                                                Text(category.get(Constants.NAMECATEGORY),style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),)
                                              ],
                                            ),
                                          ),
                                          onTap: (){
                                            setState((){
                                              search     = category.get(Constants.NAMECATEGORY);
                                              nameSearch = "category";
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),),

                                      ],
                                    ),
                                  ) : Container()
                              ),
                            ),

                            SizedBox(height: 10,) ,//=================================Activation==================

                            InkWell(
                              borderRadius: BorderRadius.circular(5),
                              splashColor: Colors.black12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.online_prediction,color: Colors.green,),
                                  Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductActivation)!,
                                    style: TextStyle(color: Colors.black87,fontWeight:lang.contains("ar")? FontWeight.w400:FontWeight.bold,
                                        fontSize: lang.contains("ar")? 19:15, fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),),
                                  Icon(activation ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up,color: activation ? Colors.red : Colors.black87,),
                                ],
                              ),
                              onTap: ()=> setState(()=> activation = !activation),
                            ),
                            Divider(color: Colors.blueGrey,thickness: 0.5,),
                            !activation ? Container():Column(
                              children: [
                                ...activeProduct.map((activationProduct) => InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  splashColor: Colors.orange.shade200,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.bookmark,color: Colors.deepPurple,size: 15,),
                                        SizedBox(width: 5,),
                                        Text(activationProduct,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),)
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                    setState((){
                                      search     = activationProduct;
                                      nameSearch = "activation";
                                    });
                                    Navigator.pop(context);
                                  },
                                ),),
                              ],
                            ),

                            SizedBox(height: 10,) ,//=================================Inventory==================

                            InkWell(
                              borderRadius: BorderRadius.circular(5),
                              splashColor: Colors.black12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.inventory,color: Colors.deepOrange.shade800,),
                                  Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductInventory)!,
                                    style: TextStyle(color: Colors.black87,fontWeight:lang.contains("ar")? FontWeight.w400:FontWeight.bold,
                                        fontSize: lang.contains("ar")? 19:15, fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),),
                                  Icon(inventory ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up,color: inventory? Colors.red : Colors.black87,),
                                ],
                              ),
                              onTap: ()=> setState(()=> inventory = !inventory),
                            ),
                            Divider(color: Colors.blueGrey,thickness: 0.5,),
                            !inventory ? Container():Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Form(
                                    key: _globalFormInv,
                                    child: Table(
                                      columnWidths: {
                                        0 : FlexColumnWidth(3),
                                        1 : FlexColumnWidth(1),
                                        2 : FlexColumnWidth(3)
                                      },
                                      children: <TableRow>[
                                        TableRow(
                                            children: <Widget>[
                                             lang.contains("en")? Padding(
                                                padding: EdgeInsets.only(left: 20),
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductFrom)!,
                                                    labelStyle: TextStyle(color: Colors.deepPurple),
                                                    border: InputBorder.none,
                                                    hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductFrom)!,
                                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                                  ),
                                                  validator: (val){
                                                    if(val!.trim().isEmpty)
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!;
                                                    if(!new RegExp(r"^([0-9]{1}|[0-9]{2}|[0-9]{3}|[0-9]{4}|[0-9]{5}|[0-9]{6}|[0-9]{7}|[0-9]{8}|[0-9]{9})$").hasMatch(val.trim()))
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductNumOnly)!;
                                                    else
                                                      return null;
                                                  },
                                                  onSaved: (val)=> setState(()=> this.fromInventory = int.parse(val!.trim())),
                                                ),
                                              ) : Padding(
                                               padding: EdgeInsets.only(right: 20),
                                               child: TextFormField(
                                                 maxLines: 1,
                                                 keyboardType: TextInputType.number,
                                                 textAlignVertical: TextAlignVertical.center,
                                                 style: TextStyle(color: Colors.black),
                                                 decoration: InputDecoration(
                                                   labelText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTo)!,
                                                   labelStyle: TextStyle(color: Colors.deepPurple),
                                                   border: InputBorder.none,
                                                   hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTo)!,
                                                   hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                                 ),
                                                 validator: (val){
                                                   if(val!.trim().isEmpty)
                                                     return SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!;
                                                   if(!new RegExp(r"^([0-9]{1}|[0-9]{2}|[0-9]{3}|[0-9]{4}|[0-9]{5}|[0-9]{6}|[0-9]{7}|[0-9]{8}|[0-9]{9})$").hasMatch(val.trim()))
                                                     return SetLocalization.of(context)!.getTranslateValue(Keys.listProductNumOnly)!;
                                                   else
                                                     return null;
                                                 },
                                                 onSaved: (val)=> setState(()=> this.fromInventory = int.parse(val!.trim())),
                                               ),
                                             ),
                                              Container(),
                                              lang.contains("en")? Padding(
                                                padding: EdgeInsets.only(right: 20),
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTo)!,
                                                    labelStyle: TextStyle(color: Colors.deepPurple),
                                                    border: InputBorder.none,
                                                    hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTo)!,
                                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                                  ),
                                                  validator: (val){
                                                    if(val!.trim().isEmpty)
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!;
                                                    if(!new RegExp(r"^([0-9]{1}|[0-9]{2}|[0-9]{3}|[0-9]{4}|[0-9]{5}|[0-9]{6}|[0-9]{7}|[0-9]{8}|[0-9]{9})$").hasMatch(val.trim()))
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductNumOnly)!;
                                                    else
                                                      return null;
                                                  },
                                                  onSaved: (val)=> setState(()=> this.toInventory = int.parse(val!.trim())),
                                                ),
                                              ) : Padding(
                                                padding: EdgeInsets.only(left: 20),
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductFrom)!,
                                                    labelStyle: TextStyle(color: Colors.deepPurple),
                                                    border: InputBorder.none,
                                                    hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductFrom)!,
                                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                                  ),
                                                  validator: (val){
                                                    if(val!.trim().isEmpty)
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!;
                                                    if(!new RegExp(r"^([0-9]{1}|[0-9]{2}|[0-9]{3}|[0-9]{4}|[0-9]{5}|[0-9]{6}|[0-9]{7}|[0-9]{8}|[0-9]{9})$").hasMatch(val.trim()))
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductNumOnly)!;
                                                    else
                                                      return null;
                                                  },
                                                  onSaved: (val)=> setState(()=> this.toInventory = int.parse(val!.trim())),
                                                ),
                                              ),
                                            ]
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                  child: TextButton(
                                    child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductSearch)!,style: TextStyle(color: Colors.white),),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 3,vertical: 2)),
                                        elevation: MaterialStateProperty.all<double>(0.5),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange.shade800)
                                    ),
                                    onPressed: ()=>searchInventory(snapshot.data!),
                                  ),
                                )
                              ],
                            ),

                            SizedBox(height: 10,) ,//=================================Price==================

                            InkWell(
                              borderRadius: BorderRadius.circular(5),
                              splashColor: Colors.black12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.monetization_on,color: Colors.green.shade600),
                                  Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductPrice)!,
                                    style: TextStyle(color: Colors.black87,fontWeight:lang.contains("ar")? FontWeight.w400:FontWeight.bold,
                                        fontSize: lang.contains("ar")? 19:15, fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),),
                                  Icon(prices ? Icons.keyboard_arrow_down_sharp : Icons.keyboard_arrow_up,color: prices? Colors.red : Colors.black87,),
                                ],
                              ),
                              onTap: ()=> setState(()=> prices = !prices),
                            ),
                            Divider(color: Colors.blueGrey,thickness: 0.5,),
                            !prices ? Container():Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Form(
                                    key: _globalFormPr,
                                    child: Table(
                                      columnWidths: {
                                        0 : FlexColumnWidth(3),
                                        1 : FlexColumnWidth(1),
                                        2 : FlexColumnWidth(3)
                                      },
                                      children: <TableRow>[
                                        TableRow(
                                            children: <Widget>[
                                              lang.contains("en")? Padding(
                                                padding: EdgeInsets.only(left: 20),
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductFrom)!,
                                                    labelStyle: TextStyle(color: Colors.deepPurple),
                                                    border: InputBorder.none,
                                                    hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductFrom)!,
                                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                                  ),
                                                  validator: (val){
                                                    if(val!.trim().isEmpty)
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!;
                                                    if(!new RegExp(r'(^\d*\.?\d*)$').hasMatch(val.trim()))
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductNumOnly)!;
                                                    else
                                                      return null;
                                                  },
                                                  onSaved: (val)=> setState(()=> this.fromPrice = double.parse(val!.trim())),
                                                ),
                                              ) : Padding(
                                                padding: EdgeInsets.only(right: 20),
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTo)!,
                                                    labelStyle: TextStyle(color: Colors.deepPurple),
                                                    border: InputBorder.none,
                                                    hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTo)!,
                                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                                  ),
                                                  validator: (val){
                                                    if(val!.trim().isEmpty)
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!;
                                                    if(!new RegExp(r'(^\d*\.?\d*)$').hasMatch(val.trim()))
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductNumOnly)!;
                                                    else
                                                      return null;
                                                  },
                                                  onSaved: (val)=> setState(()=> this.fromPrice = double.parse(val!.trim())),
                                                ),
                                              ),
                                              Container(),
                                              lang.contains("en")? Padding(
                                                padding: EdgeInsets.only(right: 20),
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTo)!,
                                                    labelStyle: TextStyle(color: Colors.deepPurple),
                                                    border: InputBorder.none,
                                                    hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductTo)!,
                                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                                  ),
                                                  validator: (val){
                                                    if(val!.trim().isEmpty)
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!;
                                                    if(!new RegExp(r'(^\d*\.?\d*)$').hasMatch(val.trim()))
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductNumOnly)!;
                                                    else
                                                      return null;
                                                  },
                                                  onSaved: (val)=> setState(()=> this.toPrices = double.parse(val!.trim())),
                                                ),
                                              ) : Padding(
                                                padding: EdgeInsets.only(left: 20),
                                                child: TextFormField(
                                                  maxLines: 1,
                                                  keyboardType: TextInputType.number,
                                                  textAlignVertical: TextAlignVertical.center,
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductFrom)!,
                                                    labelStyle: TextStyle(color: Colors.deepPurple),
                                                    border: InputBorder.none,
                                                    hintText: SetLocalization.of(context)!.getTranslateValue(Keys.listProductFrom)!,
                                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                                                  ),
                                                  validator: (val){
                                                    if(val!.trim().isEmpty)
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductEmpty)!;
                                                    if(!new RegExp(r'(^\d*\.?\d*)$').hasMatch(val.trim()))
                                                      return SetLocalization.of(context)!.getTranslateValue(Keys.listProductNumOnly)!;
                                                    else
                                                      return null;
                                                  },
                                                  onSaved: (val)=> setState(()=> this.toPrices = double.parse(val!.trim())),
                                                ),
                                              ),
                                            ]
                                        )
                                      ],
                                    )
                                ),
                                Container(
                                  child: TextButton(
                                    child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductSearch)!,style: TextStyle(color: Colors.white),),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 3,vertical: 2)),
                                        elevation: MaterialStateProperty.all<double>(0.5),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange.shade800)
                                    ),
                                    onPressed: ()=>searchPrices(snapshot.data!),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

  List<QueryDocumentSnapshot> _listProducts(List<QueryDocumentSnapshot> listProducts ){

    if(search.isEmpty){
       products = listProducts ;

    }else {
     products = listProducts.where((element){

          if(nameSearch.contains("brand"))
              return element.get(Constants.PRODUCTBRANDS).toString().contains(search.trim().toLowerCase());
          else if(nameSearch.contains("category"))
              return element.get(Constants.PRODUCTCATEGORYNAME).toString().contains(search.trim().toLowerCase());
          else if(nameSearch.contains("activation") && search.contains("Active"))
              return element.get(Constants.PRODUCTISACTIVATION) == true ;
          else if(nameSearch.contains("activation") && search.contains("Inactive"))
              return element.get(Constants.PRODUCTISACTIVATION) == false ;
          else if(nameSearch.contains("inventory"))
            return int.parse(element.get(Constants.PRODUCTINVENTORY)) >= fromInventory && int.parse(element.get(Constants.PRODUCTINVENTORY)) <= toInventory;
          else if(nameSearch.contains("prices"))
            return double.parse(element.get(Constants.PRODUCTSELLINGPRICE)) >= fromPrice && double.parse(element.get(Constants.PRODUCTSELLINGPRICE)) <= toPrices;
          else
              return element.get(Constants.PRODUCTTITLE).toString().contains(search.trim().toLowerCase());

       }).toList();
    }
    return products ;
  }

  @override
  Widget showAlertDialog(BuildContext context, {required function, required String title, required String dec}) {

      return AlertDialog(
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.delete_forever_outlined, color: Colors.red.shade500,),
            SizedBox(width: 5,),
            Text(title , style: TextStyle(color: Colors.black ,fontSize: 19 , fontWeight: FontWeight.bold),),
          ],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        contentTextStyle: TextStyle(fontSize: 18 , color: Colors.black),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(color: Colors.grey,thickness: 0.5,),
            SizedBox(height: 15,),
            Text(dec),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthCancel)! , style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                      elevation: MaterialStateProperty.all<double>(1.5),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20 ,vertical: 4))
                  ),
                  onPressed: ()=> Navigator.pop(context),
                ),
                TextButton(
                  child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductDelete)! , style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade600),
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.white,width: 1)),
                      elevation: MaterialStateProperty.all<double>(1.5),
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20 ,vertical: 4))
                  ),
                  onPressed: function,
                ),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),

      );
  }

  String getPriceProduct(List<QueryDocumentSnapshot> listProducts , int index){

    DateTime time         = DateTime.now();
    DateTime? startDate   = listProducts[index].get(Constants.PRODUCTISOFFER) ?
                            DateTime.parse(listProducts[index].get(Constants.PRODUCTSTARTDATE)) : null;
    DateTime? expiryDate  = listProducts[index].get(Constants.PRODUCTISOFFER) ?
                            DateTime.parse(listProducts[index].get(Constants.PRODUCTEXPIRYDATE)) : null;

    if(startDate != null && expiryDate != null){

      if(time.isAfter(startDate) && time.isBefore(expiryDate))
        return listProducts[index].get(Constants.PRODUCTSELLINGPRICEOFFER);
      else
        return listProducts[index].get(Constants.PRODUCTSELLINGPRICE);

    }else
      return listProducts[index].get(Constants.PRODUCTSELLINGPRICE);
  }

  String get filter {

    switch(nameSearch){

      case "brand":
        return SetLocalization.of(context)!.getTranslateValue(Keys.listProductBrand)!;

      case "category":
        return SetLocalization.of(context)!.getTranslateValue(Keys.listProductCategory)!;

      case "activation":
        return SetLocalization.of(context)!.getTranslateValue(Keys.listProductActivation)!;

      case "inventory":
        return SetLocalization.of(context)!.getTranslateValue(Keys.listProductInventory)!;

      case "prices":
        return SetLocalization.of(context)!.getTranslateValue(Keys.listProductPrice)!;

      default :
        return SetLocalization.of(context)!.getTranslateValue(Keys.listProductSearch)!;
    }

  }


  @override
  void toastMessage(BuildContext context, {required String message}) {
    FlutterToastr.show(message, context, backgroundRadius: 5, duration: 2,
        position: FlutterToastr.bottom,backgroundColor: Colors.black54,textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500));
  }


}



