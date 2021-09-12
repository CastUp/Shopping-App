import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Parts/Admin/InnerScreen/Drawer.dart';
import 'package:Shopping/Parts/Admin/Screens/Customers.dart';
import 'package:Shopping/Parts/Admin/Screens/DashBoard.dart';
import 'package:Shopping/Parts/Admin/Screens/Orders.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'Screens/Products.dart';

class BottomBarAdmin extends StatefulWidget {

  static const String BOTTOMBARADMIN = "/BottomBarAdmin";
  @override
  _BottomBarAdminState createState() => _BottomBarAdminState();
}

class _BottomBarAdminState extends State<BottomBarAdmin> {

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  int _indexPage = 0;
  String ? lang ;
  late List<Map<String , Widget>> _pages ;
  late List<Map<String , dynamic>> _item ;

  double xOffset = 0 ;
  double yOffset = 0 ;
  double scaleFactor = 1 ;
  bool isDrawerOpen = false ;




  @override
  void initState() {

    _pages = [
      {"page" : DashBoard() },
      {"page" : Products()  },
      {"page" : Customers() },
      {"page" : Orders()    },
    ];

    SaveLanguage.getLang().then((languageCode) => setState(()=> lang = languageCode ));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    _item = [
      {"part" : SetLocalization.of(context)!.getTranslateValue(Keys.main_admin_dash)     , "icon": Icons.home                             },
      {"part" : SetLocalization.of(context)!.getTranslateValue(Keys.main_admin_products) , "icon": Icons.production_quantity_limits_sharp },
      {"part" : SetLocalization.of(context)!.getTranslateValue(Keys.main_admin_customers), "icon": Icons.supervisor_account_sharp         },
      {"part" : SetLocalization.of(context)!.getTranslateValue(Keys.main_admin_orders)   , "icon": Icons.speaker_notes                    },
    ];

    return Stack(
      children: <Widget>[
        DrawerScreenAdmin(),
        AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor),
          duration: Duration(milliseconds: 360),
          curve: Curves.linear,
          child: Scaffold(
            appBar:_indexPage == 1 ?  null  :  _appBar(namePage:_item[_indexPage]["part"]),
            body: _pages[_indexPage]["page"],
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              backgroundColor: Colors.white,
              color: Colors.orange.shade500,
              buttonBackgroundColor: Colors.orange.shade700,
              animationDuration: Duration(milliseconds: 400),
              animationCurve: Curves.easeInOutCirc,
              index: _indexPage,
              items: <Widget>[..._item.map((item)=> itemsNavigation(item: item))],
              onTap: (index) {
                setState(() => _indexPage = index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Column itemsNavigation({required Map<String,dynamic> item}){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(item["icon"], size: Constants.screenHeightSize(context,24, 27) ,color: Colors.red.shade800,),
        Text(item["part"],style: TextStyle(color: Colors.white,fontSize: Constants.screenHeightSize(context,8.5, 11),fontWeight: FontWeight.w500),)
      ],
    );
  }

  AppBar _appBar({required String namePage}){

    return AppBar(
      backgroundColor: Colors.orange.shade700,
      elevation: 2,
      title: Text(namePage,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20,),),
      centerTitle: true,
      leading: this.isDrawerOpen ? IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,size: 22,),
          onPressed: ()=> setState((){
            this.xOffset      = 0 ;
            this.yOffset      = 0 ;
            this.scaleFactor  = 1 ;
            this.isDrawerOpen = false ;
          })

      ) : IconButton(
          icon: Icon(Icons.menu,color: Colors.white,size: 22,),
          onPressed: ()=> setState((){
            this.xOffset      = lang!.contains("ar") ? -50 :220 ;
            this.yOffset      = 150 ;
            this.scaleFactor  = 0.6;
            this.isDrawerOpen = true ;
          })

      ),
    );
  }
}
