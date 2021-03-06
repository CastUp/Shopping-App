

class Language {

  final String name;

  final String flag;

  final String languageCode;

  Language({
   required this.name,
   required this.flag,
   required this.languageCode,
  });

  static List<Language> languageList(){

    return <Language>[
      Language(name: "Arabic", flag: "πΈπ¦",languageCode: "ar"),
      Language(name: "English", flag: "πΊπΈ",languageCode: "en"),
    ];
  }

}
