import 'package:Shopping/Parts/User/InnserScreen/Drawer.dart';
import 'package:Shopping/Parts/User/Screens/Account.dart';
import 'package:Shopping/Parts/User/Screens/Cart.dart';
import 'package:Shopping/Parts/User/Screens/Feeds.dart';
import 'package:Shopping/Parts/User/Screens/HomeUser.dart';
import 'package:Shopping/Parts/User/Screens/Search.dart';
import 'package:Shopping/Services/Constants.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomBarUser extends StatefulWidget {

  static const String BOTTOMBARUSER = "/BottomBarUser";

  @override
  _BottomBarUserState createState() => _BottomBarUserState();
}

class _BottomBarUserState extends State<BottomBarUser> {

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  int _indexPage = 0;
  String? lang ;
  late List<Map<String , Widget>> _pages ;
  late List<Map<String , dynamic>> _item ;

  double xOffset     = 0 ;
  double yOffset     = 0 ;
  double scaleFactor = 1 ;
  bool isDrawerOpen  = false ;



  @override
  void initState() {

    _pages = [
      {"page" : Home()    },
      {"page" : Feeds()   },
      {"page" : Search()  },
      {"page" : Cart()    },
      {"page" : Account() },
    ];

    SaveLanguage.getLang().then((langCode) => lang = langCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _item = [
      {"part" : "Home"    , "icon": Icons.home                 },
      {"part" : "Feeds"   , "icon": Icons.feed                 },
      {"part" : "Search"  , "icon": Icons.search_outlined      },
      {"part" : "Cart"    , "icon": Icons.shopping_cart        },
      {"part" : "Account" , "icon": Icons.account_circle       },
    ];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          DrawerScreenUser(),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor),
            duration: Duration(milliseconds: 360),
            curve: Curves.linear,
            child: Scaffold(
              appBar: _indexPage != 4 ? _appBar(namePage:_item[_indexPage]["part"]) : null,
              body: _pages[_indexPage]["page"],
              bottomNavigationBar: CurvedNavigationBar(
                key: _bottomNavigationKey,
                backgroundColor: Colors.white,
                color: Colors.blue,
                buttonBackgroundColor: Colors.blue.shade800,
                animationDuration: Duration(milliseconds: 400),
                animationCurve: Curves.easeInOutCirc,
                index: _indexPage,
                items: [..._item.map((item) => itemsNavigation(item: item))],
                onTap: (index) {
                  setState(() => _indexPage = index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Column itemsNavigation({required Map<String,dynamic> item}){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(item["icon"], size: Constants.screenHeightSize(context, 20, 25) ,color: Colors.white,),
        Text(item["part"],style: TextStyle(color: Colors.white ,fontSize: Constants.screenHeightSize(context, 12.2, 14)),)
      ],
    );
  }

  AppBar _appBar({required String namePage}){

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(namePage,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20,fontFamily: Constants.ubuntuRegularFont),),
      centerTitle: true,
      leading: this.isDrawerOpen ? IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,size: 22,),
          onPressed: ()=> setState((){
            this.xOffset      = 0 ;
            this.yOffset      = 0 ;
            this.scaleFactor  = 1;
            this.isDrawerOpen = false ;
          })

      ) : IconButton(
          icon: Icon(Icons.menu,color: Colors.black,size: 22,),
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
