import 'package:Shopping/Models/LanguagesModel.dart';
import 'package:Shopping/Parts/Admin/BottomBarAdmin.dart';
import 'package:Shopping/Services/Languages/Keys.dart';
import 'package:Shopping/Services/Languages/SaveLanguage.dart';
import 'package:Shopping/Services/Languages/SetLocalization.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';

class SettingsDrawer extends StatefulWidget {


  @override
  _SettingsDrawerState createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {

  String lang = "en";

  @override
  void initState() {
    SaveLanguage.getLang().then((languageCode) => lang = languageCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(SetLocalization.of(context)!.getTranslateValue(Keys.drawerSettings)!,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 21),),
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: ()=> Navigator.pushReplacementNamed(context, BottomBarAdmin.BOTTOMBARADMIN),
        ),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Material(
              elevation: 1,
              shadowColor: Colors.blueGrey,
              child: ListTile(
                title: Text(SetLocalization.of(context)!.getTranslateValue(Keys.drawerLanguage)! , style: TextStyle(color: Colors.black,fontSize: 19),),
                leading: Icon(Icons.language,color: Colors.blue,),
                subtitle: Text(SetLocalization.of(context)!.getTranslateValue(Keys.drawerNameLanguage)!,style: TextStyle(color: Colors.blueGrey,fontSize: 17),),
                minLeadingWidth: 3,
                onTap: ()=> showDialog(context: context, builder: (context)=> getDialog()),
              ),
            ),
          ],
        ),
      ),
    );
  }


  AlertDialog getDialog(){

    return AlertDialog(
      elevation: 4,
      backgroundColor: Colors.white.withOpacity(0.9),
      title: Center(child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.language,color: Colors.blueGrey,),SizedBox(width: 5),Text("Languages")],)
      ),
      titleTextStyle: TextStyle(color: Colors.black,fontSize: 18),
      contentTextStyle: TextStyle(color: Colors.black,fontSize: 17),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 1,color: Colors.blueGrey,),
          ...Language.languageList().map((e)
          => InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(e.flag ),
                  SizedBox(width: 5),
                  Text(e.name)
                ],
              ),
            ),
            onTap: ()async=> await _changeLanguage(e.languageCode).then((value) => Navigator.pop(context)),
          ),
          ),
        ],
      ),
    );

  }

  Future<void> _changeLanguage(String lang) async {
    Locale _tempLang =  await SaveLanguage.setLocal(lang);
    MyApp.setLocale(context, _tempLang);
  }
}

