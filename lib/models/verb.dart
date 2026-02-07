class Verb {
  final String kanji;
  final String hiragana;
  final String romaji;
  final String meaning;
  final String type;   // 'る-v.' o 'う-v.'
  final String ending; // ultima sillaba in hiragana

  Verb({
    required this.kanji,
    required this.hiragana,
    required this.romaji,
    required this.meaning,
    required this.type,
    required this.ending,
  });

  factory Verb.fromJson(Map<String, dynamic> json) {
    return Verb(
      kanji: json['kanji'] ?? '',
      hiragana: json['hiragana'],
      romaji: json['romaji'],
      meaning: json['meaning'],
      type: json['type'],
      ending: json['ending'],
    );
  }

  // ----------------- UTILITY -----------------
  String stem() {
    // radice del verbo per forme come TAI, TAGATTE
    return hiragana.substring(0, hiragana.length - 1);
  }

  String kanjiStem() {
    return kanji.isNotEmpty ? kanji.substring(0, kanji.length - 1) : '';
  }

  // Mappe per u-verbs
  static const Map<String, String> politeMap = {
    'う':'い','つ':'ち','る':'り','く':'き','ぐ':'ぎ','す':'し','む':'み','ぶ':'び','ぬ':'に'
  };
  static const Map<String, String> negativeMap = {
    'う':'わ','つ':'た','る':'ら','く':'か','ぐ':'が','す':'さ','む':'ま','ぶ':'ば','ぬ':'な'
  };
  static const Map<String, String> potentialMap = {
    'う':'え','つ':'て','る':'れ','く':'け','ぐ':'げ','す':'せ','む':'め','ぶ':'べ','ぬ':'ね'
  };
  static const Map<String, String> volitionalMap = {
    'う':'お','つ':'と','る':'ろ','く':'こ','ぐ':'ご','す':'そ','む':'も','ぶ':'ぼ','ぬ':'の'
  };
  static const Map<String, String> passiveMap = {
    'う':'われ','つ':'たれ','る':'られ','む':'まれ','ぶ':'ばれ','ぬ':'なれ','く':'かれ','ぐ':'がれ','す':'され'
  };
  static const Map<String, String> causativeMap = {
    'う':'わせ','つ':'たせ','る':'らせ','む':'ませ','ぶ':'ばせ','ぬ':'なせ','く':'かせ','ぐ':'がせ','す':'させ'
  };
  static const Map<String, String> commandMap = {
    'う':'え','つ':'て','る':'れ','む':'め','ぶ':'べ','ぬ':'ね','く':'け','ぐ':'げ','す':'せ'
  };

  // ----------------- FORME BASE -----------------
  Map<String, String> baseForm() => {'kanji': kanji, 'hiragana': hiragana};

Map<String, String> politeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'します', 'hiragana': 'します'};
  if (hiragana == 'くる') return {'kanji': '来ます', 'hiragana': 'きます'};

  // Se non c'è kanji, usa l'hiragana
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'ます';
    hiraForm += 'ます';
  } else if (type == 'う-v.') {
    String p = politeMap[ending] ?? '';
    kanjiForm += p + 'ます';
    hiraForm += p + 'ます';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> politeNegativeForm() {
  // Verbi irregolari
  if (hiragana == 'する') {
    return {'kanji': 'しません', 'hiragana': 'しません'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来ません', 'hiragana': 'きません'};
  }

  // Verbi regolari
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'ません';
    hiraForm += 'ません';
  } else if (type == 'う-v.') {
    String p = politeMap[ending] ?? '';
    kanjiForm += p + 'ません';
    hiraForm += p + 'ません';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> negativeForm() {
  // Irregular verbs
  if (hiragana == 'する') {
    return {'kanji': 'しない', 'hiragana': 'しない'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来ない', 'hiragana': 'こない'};
  }

  // Verbi regolari
  // Se non c'è kanji, usa l'hiragana
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'ない';
    hiraForm += 'ない';
  } else if (type == 'う-v.') {
    String n = negativeMap[ending] ?? '';
    kanjiForm += n + 'ない';
    hiraForm += n + 'ない';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

  Map<String, String> pastNegativeForm() {
    final negative = negativeForm();
    return {
      'kanji': negative['kanji']!.replaceAll('ない', 'なかった'),
      'hiragana': negative['hiragana']!.replaceAll('ない', 'なかった')
    };
  }

  // ----------------- TE e TA -----------------
Map<String, String> teForm() {
  // Irregular verbs
  if (hiragana == 'する') {
    return {'kanji': 'して', 'hiragana': 'して'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来て', 'hiragana': 'きて'};
  }

  // Regular verbs
  // Se non c'è kanji, usa lo stem in hiragana
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'て';
    hiraForm += 'て';
  } else if (type == 'う-v.') {
    switch (ending) {
      case 'う':
      case 'つ':
      case 'る':
        kanjiForm += 'って';
        hiraForm += 'って';
        break;
      case 'む':
      case 'ぶ':
      case 'ぬ':
        kanjiForm += 'んで';
        hiraForm += 'んで';
        break;
      case 'く':
        kanjiForm += 'いて';
        hiraForm += 'いて';
        break;
      case 'ぐ':
        kanjiForm += 'いで';
        hiraForm += 'いで';
        break;
      case 'す':
        kanjiForm += 'して';
        hiraForm += 'して';
        break;
    }
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}
Map<String, String> teNegativeForm() {
  // Prende la TE-form attuale
  final te = teForm();
  String kanji = te['kanji'] ?? '';
  String hira = te['hiragana'] ?? '';

  // Trasformazione: rimuove il て finale e aggiunge なくて
  if (hira.endsWith('て')) {
    hira = hira.substring(0, hira.length - 1) + 'なくて';
  }
  if (kanji.endsWith('て')) {
    kanji = kanji.substring(0, kanji.length - 1) + 'なくて';
  }

  return {'kanji': kanji, 'hiragana': hira};
}
Map<String, String> taNegativeForm() {
  final baseNeg = negativeForm(); 
  String kanji = baseNeg['kanji'] ?? '';
  String hira = baseNeg['hiragana'] ?? '';

  // Trasformiamo た in なかった
  if (hira.endsWith('ない')) {
    hira = hira.substring(0, hira.length - 2) + 'なかった';
  }
  if (kanji.endsWith('ない')) {
    kanji = kanji.substring(0, kanji.length - 2) + 'なかった';
  }

  return {'kanji': kanji, 'hiragana': hira};
}

Map<String, String> potentialNegativeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'できない', 'hiragana': 'できない'};
  if (hiragana == 'くる') return {'kanji': '来られない', 'hiragana': 'こられない'};

  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    // ichidan: replace られる → られない
    kanjiForm += 'られない';
    hiraForm += 'られない';
  } else if (type == 'う-v.') {
    // godan: usa la mappa potentialMap per trasformare l'ultima sillaba, poi aggiungi 'ない'
    String p = potentialMap[ending] ?? '';
    kanjiForm += p + 'ない';
    hiraForm += p + 'ない';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> volitionalNegativeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'しまい', 'hiragana': 'しまい'};
  if (hiragana == 'くる') return {'kanji': '来まい', 'hiragana': 'こまい'};

  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'まい';
    hiraForm += 'まい';
  } else if (type == 'う-v.') {
    String v = volitionalMap[ending] ?? '';
    kanjiForm += v + 'うまい';
    hiraForm += v + 'うまい';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> conditionalBaNegativeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'しなければ', 'hiragana': 'しなければ'};
  if (hiragana == 'くる') return {'kanji': '来なければ', 'hiragana': 'こなければ'};

  String kanjiForm = '';
  String hiraForm = '';

  if (type == 'る-v.') {
    // Ichidan verbs: togli 'る' + なければ
    String stemKanji = kanji.isNotEmpty ? kanjiStem() : '';
    String stemHira = stem();
    kanjiForm = stemKanji + 'なければ';
    hiraForm = stemHira + 'なければ';
  } else if (type == 'う-v.') {
    // Godan verbs: usa negativeMap[ending] + なければ
    String n = negativeMap[ending] ?? '';
    String stemKanji = kanji.isNotEmpty ? kanjiStem() : stem();
    kanjiForm = stemKanji + n + 'なければ';
    hiraForm = stem() + n + 'なければ';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> conditionalTaraNegativeForm() {
  final pastNeg = pastNegativeForm(); // es: しなかった
  String kanjiForm = pastNeg['kanji']!;
  String hiraForm = pastNeg['hiragana']!;

  kanjiForm += 'ら';
  hiraForm += 'ら';

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> passiveNegativeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'されない', 'hiragana': 'されない'};
  if (hiragana == 'くる') return {'kanji': '来られない', 'hiragana': 'こられない'};

  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'られない';
    hiraForm += 'られない';
  } else if (type == 'う-v.') {
    String p = passiveMap[ending] ?? '';
    kanjiForm += p + 'ない';
    hiraForm += p + 'ない';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> causativeNegativeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'させない', 'hiragana': 'させない'};
  if (hiragana == 'くる') return {'kanji': '来させない', 'hiragana': 'こさせない'};

  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'させない';
    hiraForm += 'させない';
  } else if (type == 'う-v.') {
    String c = causativeMap[ending] ?? '';
    kanjiForm += c + 'ない';
    hiraForm += c + 'ない';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> commandNegativeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'するな', 'hiragana': 'するな'};
  if (hiragana == 'くる') return {'kanji': '来るな', 'hiragana': 'こるな'};

  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'るな';
    hiraForm += 'るな';
  } else if (type == 'う-v.') {
    String c = commandMap[ending] ?? '';
    kanjiForm += c + 'な';
    hiraForm += c + 'な';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> taiNegativeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'したくない', 'hiragana': 'したくない'};
  if (hiragana == 'くる') return {'kanji': '来たくない', 'hiragana': 'きたくない'};

  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  kanjiForm += 'たくない';
  hiraForm += 'たくない';

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> tagatteNegativeForm() {
  // Irregular verbs
  if (hiragana == 'する') return {'kanji': 'したがっていない', 'hiragana': 'したがっていない'};
  if (hiragana == 'くる') return {'kanji': '来たがっていない', 'hiragana': 'きたがっていない'};

  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  kanjiForm += 'たがっていない';
  hiraForm += 'たがっていない';

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

  Map<String, String> taForm() {
    final te = teForm();
    return {
      'kanji': te['kanji']!.replaceAll('て', 'た').replaceAll('で', 'だ'),
      'hiragana': te['hiragana']!.replaceAll('て', 'た').replaceAll('で', 'だ')
    };
  }

  // ----------------- Altre forme -----------------
 Map<String, String> potentialForm() {
  // Irregular verbs
  if (hiragana == 'する') {
    return {'kanji': 'できる', 'hiragana': 'できる'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来られる', 'hiragana': 'こられる'};
  }

  // Regular verbs
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem(); // usa hiragana se non c'è kanji
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'られる';
    hiraForm += 'られる';
  } else if (type == 'う-v.') {
    String p = potentialMap[ending] ?? '';
    kanjiForm += p + 'る';
    hiraForm += p + 'る';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

 Map<String, String> volitionalForm() {
  // Verbi irregolari
  if (hiragana == 'する') {
    return {'kanji': 'しよう', 'hiragana': 'しよう'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来よう', 'hiragana': 'こよう'};
  }

  // Usa l'hiragana se non c'è kanji
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'よう';
    hiraForm += 'よう';
  } else if (type == 'う-v.') {
    String v = volitionalMap[ending] ?? '';
    kanjiForm += v + 'う';
    hiraForm += v + 'う';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> conditionalBaForm() {
  // Verbi irregolari
  if (hiragana == 'する') {
    return {'kanji': 'すれば', 'hiragana': 'すれば'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来れば', 'hiragana': 'くれば'};
  }

  // Usa l'hiragana se non c'è kanji
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'れば';
    hiraForm += 'れば';
  } else if (type == 'う-v.') {
    String p = potentialMap[ending] ?? '';
    kanjiForm += p + 'ば';
    hiraForm += p + 'ば';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

  Map<String, String> conditionalTaraForm() {
    final ta = taForm();
    return {
      'kanji': ta['kanji']! + 'ら',
      'hiragana': ta['hiragana']! + 'ら'
    };
  }

Map<String, String> passiveForm() {
  // Verbi irregolari
  if (hiragana == 'する') {
    return {'kanji': 'される', 'hiragana': 'される'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来られる', 'hiragana': 'こられる'};
  }

  // Usa hiragana se non c'è kanji
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'られる';
    hiraForm += 'られる';
  } else if (type == 'う-v.') {
    String p = passiveMap[ending] ?? '';
    kanjiForm += p + 'る';  // aggiunto 'る'
    hiraForm += p + 'る';
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}


Map<String, String> causativeForm() {
  // Verbi irregolari
  if (hiragana == 'する') {
    return {'kanji': 'させる', 'hiragana': 'させる'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来させる', 'hiragana': 'こさせる'};
  }

  // Usa hiragana se non c'è kanji
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'させる';
    hiraForm += 'させる';
  } else if (type == 'う-v.') {
    String c = causativeMap[ending] ?? '';
    kanjiForm += c + 'る';  // aggiungi "る" finale
    hiraForm += c + 'る';   // aggiungi "る" finale
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> commandForm() {
  // Verbi irregolari
  if (hiragana == 'する') {
    return {'kanji': 'しろ', 'hiragana': 'しろ'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来い', 'hiragana': 'こい'};
  }

  // Usa hiragana se non c'è kanji
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  if (type == 'る-v.') {
    kanjiForm += 'ろ';
    hiraForm += 'ろ';
  } else if (type == 'う-v.') {
    String c = commandMap[ending] ?? '';
    kanjiForm += c;
    hiraForm += c;
  }

  return {'kanji': kanjiForm, 'hiragana': hiraForm};
}

Map<String, String> taiForm() {
  // Verbi irregolari
  if (hiragana == 'する') {
    return {'kanji': 'したい', 'hiragana': 'したい'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来たい', 'hiragana': 'きたい'};
  }

  // Usa hiragana se non c'è kanji
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  kanjiForm += 'たい';
  hiraForm += 'たい';

  return {
    'kanji': kanjiForm,
    'hiragana': hiraForm,
  };
}

Map<String, String> tagatteForm() {
  // Verbi irregolari
  if (hiragana == 'する') {
    return {'kanji': 'したがって', 'hiragana': 'したがって'};
  }
  if (hiragana == 'くる') {
    return {'kanji': '来たがって', 'hiragana': 'きたがって'};
  }

  // Usa hiragana se non c'è kanji
  String kanjiForm = kanji.isNotEmpty ? kanjiStem() : stem();
  String hiraForm = stem();

  kanjiForm += 'たがって';
  hiraForm += 'たがって';

  return {
    'kanji': kanjiForm,
    'hiragana': hiraForm,
  };
}

Map<String, String> suruForm(String form) {
  switch (form) {
    case 'Base':
      return {'kanji': 'する', 'hiragana': 'する'};
    case 'Polite':
      return {'kanji': 'します', 'hiragana': 'します'};
    case 'Negative':
      return {'kanji': 'しない', 'hiragana': 'しない'};
    case 'Past Negative':
      return {'kanji': 'しなかった', 'hiragana': 'しなかった'};
    case 'TE-form':
      return {'kanji': 'して', 'hiragana': 'して'};
    case 'TA-form':
      return {'kanji': 'した', 'hiragana': 'した'};
    case 'Potential':
      return {'kanji': 'できる', 'hiragana': 'できる'};
    case 'Volitional':
      return {'kanji': 'しよう', 'hiragana': 'しよう'};
    case 'Conditional BA':
      return {'kanji': 'すれば', 'hiragana': 'すれば'};
    case 'Conditional TARA':
      return {'kanji': 'したら', 'hiragana': 'したら'};
    case 'Passive':
      return {'kanji': 'される', 'hiragana': 'される'};
    case 'Causative':
      return {'kanji': 'させる', 'hiragana': 'させる'};
    case 'Command':
      return {'kanji': 'しろ', 'hiragana': 'しろ'};
    case 'TAI':
      return {'kanji': 'したい', 'hiragana': 'したい'};
    case 'TAGATTE':
      return {'kanji': 'したがって', 'hiragana': 'したがって'};
    default:
      return {'kanji': 'する', 'hiragana': 'する'};
  }
}
Map<String, String> kuruForm(String form) {
  switch (form) {
    case 'Base':
      return {'kanji': '来る', 'hiragana': 'くる'};
    case 'Polite':
      return {'kanji': '来ます', 'hiragana': 'きます'};
    case 'Negative':
      return {'kanji': '来ない', 'hiragana': 'こない'};
    case 'Past Negative':
      return {'kanji': '来なかった', 'hiragana': 'こなかった'};
    case 'TE-form':
      return {'kanji': '来て', 'hiragana': 'きて'};
    case 'TA-form':
      return {'kanji': '来た', 'hiragana': 'きた'};
    case 'Potential':
      return {'kanji': '来られる', 'hiragana': 'こられる'};
    case 'Volitional':
      return {'kanji': '来よう', 'hiragana': 'こよう'};
    case 'Conditional BA':
      return {'kanji': '来れば', 'hiragana': 'くれば'};
    case 'Conditional TARA':
      return {'kanji': '来たら', 'hiragana': 'きたら'};
    case 'Passive':
      return {'kanji': '来られる', 'hiragana': 'こられる'};
    case 'Causative':
      return {'kanji': '来させる', 'hiragana': 'こさせる'};
    case 'Command':
      return {'kanji': '来い', 'hiragana': 'こい'};
    case 'TAI':
      return {'kanji': '来たい', 'hiragana': 'きたい'};
    case 'TAGATTE':
      return {'kanji': '来たがって', 'hiragana': 'きたがって'};
    default:
      return {'kanji': '来る', 'hiragana': 'くる'};
  }
}

}
