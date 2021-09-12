import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SaveLanguage{

 static Future<Locale> setLocal (String languageCode) async{

    SharedPreferences _pref = await SharedPreferences.getInstance();

    await _pref.setString("languages", languageCode);

    return _locale(languageCode);

  }

 static Locale _locale (String lang) {

    Locale _temp ;

    switch(lang){

      case 'en':
        _temp = Locale(lang, 'US');
        break;
      case 'ar':
        _temp = Locale(lang, 'SA');
        break ;
      default:
        _temp = Locale(lang, 'US');
        break ;
    }

    return _temp ;
  }

 static Future<Locale> getLocal () async{

    SharedPreferences _pref = await SharedPreferences.getInstance();

    String langCode = _pref.getString("languages") ?? 'en';

    return _locale(langCode);
  }

 static Future<String> getLang() async{

    SharedPreferences _pref = await SharedPreferences.getInstance();

    String langCode = _pref.getString("languages") ?? 'en';

    return langCode;
  }

}
