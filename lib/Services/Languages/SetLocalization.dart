
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetLocalization {

  Locale? locale ;

  SetLocalization({this.locale});

  static SetLocalization? of(BuildContext context){

    return Localizations.of<SetLocalization>(context, SetLocalization);
  }

  static const LocalizationsDelegate<SetLocalization>? localizationsDelegate = _GetLocalizationDelegate();
  Map<String , String>? _localizedValues ;


  Future load() async{

    String jsonStringValues = await rootBundle.loadString('assets/translations/${locale!.languageCode}.json');

    Map<String , dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTranslateValue(String key){

    return _localizedValues![key];
  }



}

class _GetLocalizationDelegate extends LocalizationsDelegate<SetLocalization>{

  const _GetLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {

    return ['ar','en'].contains(locale.languageCode);
  }

  @override
  Future<SetLocalization> load(Locale locale) async{

    SetLocalization localization = new SetLocalization(locale: locale);
    await localization.load();
    return localization ;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<SetLocalization> old) {

    return false ;
  }


}