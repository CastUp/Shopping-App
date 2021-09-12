
import 'package:Shopping/Parts/Admin/InnerScreen/InnerBrands/CreateBrands.dart';
import 'package:Shopping/Parts/Admin/InnerScreen/InnerBrands/EditBrands.dart';
import 'package:Shopping/Providers/AdminProviders/BrandsProvider.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:Shopping/Services/Screens/AlertDialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Brands extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Brands> with AlertDialogs {

  String search = "all";
  String lang   = "en";

  @override
  void initState() {
    SaveLanguage.getLang().then((languageCode) => lang = languageCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<BrandsProvider>(
      builder: (context, value, child)
      => StreamBuilder(
        stream: value.fetchListData(),
        builder: (context, AsyncSnapshot snapshot)
        => Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1)
                    },
                    children: <TableRow>[
                      TableRow(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                             right: lang.contains("ar") ? 0 : 8,
                             left: lang.contains("ar") ? 8 : 0
                          ),
                          child: TextField(
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color: Colors.black, fontSize: lang.contains("ar") ? 20:18 ,
                              fontFamily: lang.contains("ar") ? Constants.splashArabicFont : null,),
                            decoration: InputDecoration(
                                hintText: SetLocalization.of(context)!.getTranslateValue(Keys.brandTitle)!,
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 16,fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),
                                contentPadding: EdgeInsets.all(5),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.search_outlined,
                                  color: Colors.orange,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.orange, width: 1),
                                ),
                                ),
                            onChanged: (val) => setState(() => this.search = val),
                        ),
                        ),
                        TextButton(
                          child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.listProductCreate)!,
                            style: TextStyle(color: Colors.white,
                                fontSize: Constants.screenHeightSize(context, lang.contains("ar")? 14: 12,lang.contains("ar")? 21: 15),
                                fontWeight: lang.contains("ar")? FontWeight.w400 : null,
                                fontFamily: lang.contains("ar")? Constants.splashArabicFont : null),),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(4),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.orange.shade700),
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: lang.contains("ar")? 10: 15)),
                          ),
                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_)=> CreateBrands())),
                        )
                      ])
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * .04,
                ),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: Colors.orange.shade500,
                  child: Table(
                    children: [
                      TableRow(children: [
                        Text(
                          SetLocalization.of(context)!.getTranslateValue(Keys.brandTableTitle)!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: lang.contains("ar")? 21:18,
                              fontFamily: lang.contains("ar")? Constants.splashArabicFont : null,
                              fontWeight:lang.contains("ar")? FontWeight.w400 : FontWeight.bold),
                        ),
                        Text(
                          SetLocalization.of(context)!.getTranslateValue(Keys.brandTableDescription)!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: lang.contains("ar")? 21:18,
                              fontFamily: lang.contains("ar")? Constants.splashArabicFont : null,
                              fontWeight:lang.contains("ar")? FontWeight.w400 : FontWeight.bold),
                        ),
                        Container(),
                      ])
                    ],
                  ),
                ),
                snapshot.hasData ? Expanded(
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Table(
                          defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                          //IntrinsicColumnWidth(), // FixedColumnWidth(100),
                          border: TableBorder(
                              horizontalInside: BorderSide(color: Colors.black, width: 0.5)),
                          children: <TableRow>[
                            ...fetchBrandsData(snapshot.data!, searchBrand: this.search)
                                .map((objectBrand) => TableRow(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 5, bottom: 5),
                                          child: Text(
                                            Constants.showTextEn(
                                                info: objectBrand
                                                    .get(Constants
                                                    .NAMEBRANDS)),
                                            style: TextStyle(
                                                color: Colors
                                                    .black,
                                                fontSize: Constants
                                                    .screenHeightSize(
                                                    context,
                                                    16,
                                                    19),
                                                fontWeight:
                                                FontWeight
                                                    .w600),
                                          )),
                                      Padding(
                                        padding:
                                        EdgeInsets.only(
                                            top: 5,
                                            bottom: 5),
                                        child: InkWell(
                                          splashColor: Colors
                                              .grey.shade100,
                                          highlightColor:
                                          Colors
                                              .transparent,
                                          borderRadius:
                                          BorderRadius
                                              .circular(
                                              5),
                                          radius: 50,
                                          child: Text(
                                            objectBrand.get(Constants.DESCRIPTIONBRANDS).toString().length > 60 ?
                                            Constants.showTextEn(info: objectBrand.get(Constants.DESCRIPTIONBRANDS)).substring(0, 59) + "..."
                                                : Constants.showTextEn(info: objectBrand.get(Constants.DESCRIPTIONBRANDS)),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Constants.screenHeightSize(context, 16, 19),),
                                          ),
                                          onTap: () =>
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    FutureBuilder(
                                                      future: value.productsNumber(
                                                          title:
                                                          objectBrand
                                                              .get(Constants.NAMEBRANDS)),
                                                      builder: (context,
                                                          snapshot) =>
                                                          AlertDialog(
                                                            titleTextStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                19,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                            title: Center(
                                                                child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.brandInfo)!)),
                                                            actions: [
                                                              Divider(
                                                                color: Colors
                                                                    .black54,
                                                                thickness:
                                                                1,
                                                              ),
                                                              ConstrainedBox(
                                                                constraints:
                                                                BoxConstraints(),
                                                                child:
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      width:
                                                                      100,
                                                                      height:
                                                                      100,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(15),
                                                                          border: Border.all(color: Colors.black, width: 1),
                                                                          image: DecorationImage(image: NetworkImage(objectBrand.get(Constants.IMAGEBRANDS)), fit: BoxFit.fill)),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                      5,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                      Padding(
                                                                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 10),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            SizedBox(
                                                                              height: 6,
                                                                            ),
                                                                            RichText(
                                                                                text: TextSpan(children: <TextSpan>[
                                                                                  TextSpan(text: "${SetLocalization.of(context)!.getTranslateValue(Keys.brandNum)!}: ", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
                                                                                  TextSpan(text: "${snapshot.hasData ? snapshot.data! : 0}", style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400)),
                                                                                ])),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            RichText(
                                                                                text: TextSpan(children: <TextSpan>[
                                                                                  TextSpan(text: "${SetLocalization.of(context)!.getTranslateValue(Keys.brand)!}: ", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
                                                                                  TextSpan(text: Constants.showTextEn(info: objectBrand.get(Constants.NAMEBRANDS)), style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400)),
                                                                                ])),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            RichText(
                                                                                text: TextSpan(children: <TextSpan>[
                                                                                  TextSpan(text: "${SetLocalization.of(context)!.getTranslateValue(Keys.brandTableDescription)!}: ", style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600)),
                                                                                  TextSpan(text: Constants.showTextEn(info: objectBrand.get(Constants.DESCRIPTIONBRANDS)), style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400)),
                                                                                ])),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
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
                                      Padding(
                                        padding:
                                        EdgeInsets.only(top: 5, bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                             icon: Icon(Icons.edit),
                                             onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> EditBrands(idItem: objectBrand.get(Constants.IDBRANDS))))),
                                            IconButton(
                                              icon: Icon(Icons.delete, color: Colors.red.shade500,),
                                              onPressed: () => showDialog(context: context,
                                                builder: (context)
                                                => showAlertDialog(context,
                                                function: () => value.deleted(context, idItem: objectBrand.get(Constants.IDBRANDS),
                                                title: objectBrand.get(Constants.NAMEBRANDS)),
                                                title: SetLocalization.of(context)!.getTranslateValue(Keys.listProductDelete)!,
                                                dec: SetLocalization.of(context)!.getTranslateValue(Keys.listProductSure)!),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])),
                          ],
                        ),
                      )
                    ],
                  ),
                ) : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List fetchBrandsData(List<QueryDocumentSnapshot> listBrandsFirebase, {String? searchBrand}) {
    List brands = [];

    brands = searchBrand!.contains("all") ? listBrandsFirebase : listBrandsFirebase.where((element)
    => element.get(Constants.NAMEBRANDS).toString().toLowerCase().contains(searchBrand.trim().toLowerCase())).toList();

    return brands;
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
          Text(title, style: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),),
        ],
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(fontSize: 18, color: Colors.black),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Colors.grey, thickness: 0.5,),
          SizedBox(height: 15,),
          Text(dec),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                child: Text(SetLocalization.of(context)!.getTranslateValue(Keys.providerAuthCancel)!,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.white, width: 1)),
                    elevation: MaterialStateProperty.all<double>(1.5),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 4))),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(
                  SetLocalization.of(context)!.getTranslateValue(Keys.listProductDelete)!,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red.shade600),
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: Colors.white, width: 1)),
                    elevation: MaterialStateProperty.all<double>(1.5),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 4))),
                onPressed: function,
              ),
            ],
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
