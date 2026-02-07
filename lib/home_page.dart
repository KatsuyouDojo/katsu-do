import 'package:flutter/material.dart';
import 'models/verb.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final List<Verb> verbs;

  const HomePage({required this.verbs, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Verb? selectedVerb;
  String selectedForm = '辞書形'; // default jishokei
  bool isNegative = false; // 🔁 SWITCH positivo / negativo
  int visitCount = 0;

  // Lista dei forms con kanji e nome inglese
  late final List<Map<String, String>> formsList;

  @override
  void initState() {
    super.initState();

    formsList = [
      {'kanji': '辞書形', 'labelEng': 'Base'},
      {'kanji': 'ます形', 'labelEng': 'Polite'},
      {'kanji': 'て形', 'labelEng': 'TE-form'},
      {'kanji': 'た形', 'labelEng': 'TA-form'},
      {'kanji': '可能形', 'labelEng': 'Potential'},
      {'kanji': '意向形', 'labelEng': 'Volitional'},
      {'kanji': 'ば形', 'labelEng': 'Conditional BA'},
      {'kanji': 'たら形', 'labelEng': 'Conditional TARA'},
      {'kanji': '受身形', 'labelEng': 'Passive'},
      {'kanji': '使役形', 'labelEng': 'Causative'},
      {'kanji': '命令形', 'labelEng': 'Command'},
      {'kanji': 'たい形', 'labelEng': 'TAI'},
      {'kanji': '〜てがって', 'labelEng': 'TAGATTE'},
    ];

    _loadVisitCount();
  }

  Future<void> _loadVisitCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      visitCount = prefs.getInt('visitCount') ?? 0;
    });
  }

  Future<void> _incrementVisitCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      visitCount++;
    });
    await prefs.setInt('visitCount', visitCount);
  }

  // ----------------- LOGICA POSITIVO / NEGATIVO -----------------
  Map<String, String> getSelectedForm(Verb verb) {
    final positiveMap = {
      '辞書形': verb.baseForm,
      'ます形': verb.politeForm,
      'て形': verb.teForm,
      'た形': verb.taForm,
      '可能形': verb.potentialForm,
      '意向形': verb.volitionalForm,
      'ば形': verb.conditionalBaForm,
      'たら形': verb.conditionalTaraForm,
      '受身形': verb.passiveForm,
      '使役形': verb.causativeForm,
      '命令形': verb.commandForm,
      'たい形': verb.taiForm,
      '〜てがって': verb.tagatteForm,
    };

    final negativeMap = {
      '辞書形': verb.negativeForm,
      'ます形': verb.politeNegativeForm,
      'て形': verb.teNegativeForm,
      'た形': verb.taNegativeForm,
      '可能形': verb.potentialNegativeForm,
      '意向形': verb.volitionalNegativeForm,
      'ば形': verb.conditionalBaNegativeForm,
      'たら形': verb.conditionalTaraNegativeForm,
      '受身形': verb.passiveNegativeForm,
      '使役形': verb.causativeNegativeForm,
      '命令形': verb.commandNegativeForm,
      'たい形': verb.taiNegativeForm,
      '〜てがって': verb.tagatteNegativeForm,
    };

    final map = isNegative ? negativeMap : positiveMap;
    return map[selectedForm]!();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final searchBarWidth = screenWidth > 700 ? 600.0 : screenWidth * 0.8;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '活用道場-Katsuyō dōjō',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Noto Sans CJK',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // SFONDO
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/kanji_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // LOGO principale
          Positioned(
            top: 40,
            child: SizedBox(
              height: 800,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 800,
                  ),
                ),
              ),
            ),
          ),

          // SCHEDA VERBO
          if (selectedVerb != null)
            Positioned(
              top: 330,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // DROPDOWN
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedForm,
                              items: formsList
                                  .map(
                                    (f) => DropdownMenuItem(
                                      value: f['kanji'],
                                      child: Text('${f['kanji']} (${f['labelEng']})'),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedForm = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // SWITCH POSITIVO / NEGATIVO
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Negative'),
                          const SizedBox(width: 8),
                          Switch(
                            value: isNegative,
                            onChanged: (v) {
                              setState(() {
                                isNegative = v;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // MOSTRA FORMA SELEZIONATA
                      Builder(builder: (context) {
                        final form = getSelectedForm(selectedVerb!);
                        final kanji = form['kanji']!;
                        final hira = form['hiragana']!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              kanji.isNotEmpty ? kanji : hira,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Noto Sans CJK',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$hira - ${selectedVerb!.meaning}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Noto Sans CJK',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

          // SEARCH BAR
          Positioned(
            top: 620,
            child: Container(
              width: searchBarWidth,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Autocomplete<Verb>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Verb>.empty();
                  }
                  return widget.verbs.where((verb) {
                    final q = textEditingValue.text.toLowerCase();
                    return verb.kanji.toLowerCase().contains(q) ||
                        verb.hiragana.toLowerCase().contains(q) ||
                        verb.romaji.toLowerCase().contains(q) ||
                        verb.meaning.toLowerCase().contains(q);
                  });
                },
                displayStringForOption: (Verb v) => v.kanji.isNotEmpty
                    ? '${v.kanji} ${v.hiragana} (${v.romaji})'
                    : '${v.hiragana} (${v.romaji})',
                onSelected: (verb) {
                  setState(() {
                    selectedVerb = verb;
                    selectedForm = '辞書形';
                    isNegative = false;
                  });
                  _incrementVisitCount();
                },
                fieldViewBuilder:
                    (context, textEditingController, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: (value) => onFieldSubmitted(),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: '動詞を検索 / Search verbs',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Noto Sans CJK',
                    ),
                  );
                },
              ),
            ),
          ),

          // CONTATORE
          Positioned(
            bottom: 20,
            right: 20,
            child: Text(
              '検索された動詞\nSearched verbs: $visitCount',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Noto Sans CJK',
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
