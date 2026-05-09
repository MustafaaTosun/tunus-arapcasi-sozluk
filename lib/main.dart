import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (_) => PhrasesCubit()..init(),
      child: const TunisApp(),
    ),
  );
}

class TunisApp extends StatelessWidget {
  const TunisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunus Günlük İfadeler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1F7A8C),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts _tts = FlutterTts();
  String _voiceLang = 'ar-TN';
  double _rate = 0.45;
  double _pitch = 1.0;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      await _tts.setLanguage(_voiceLang);
      final langs = await _tts.getLanguages;
      if (langs is List && !langs.contains(_voiceLang)) {
        await _tts.setLanguage('ar'); // fallback
      }
      await _tts.setSpeechRate(_rate);
      await _tts.setPitch(_pitch);
    } catch (_) {}
  }

  Future<void> _speak(String text) async {
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tunus Günlük İfadeler'),
        actions: [
          IconButton(
            tooltip: 'Ayarlar',
            icon: const Icon(Icons.settings),
            onPressed: () => showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (_) => _SettingsSheet(
                currentRate: _rate,
                currentPitch: _pitch,
                onChanged: (r, p) async {
                  setState(() {
                    _rate = r;
                    _pitch = p;
                  });
                  await _tts.setSpeechRate(_rate);
                  await _tts.setPitch(_pitch);
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<PhrasesCubit, PhrasesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Hata: ${state.error}'));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Ara (TR, Latin ya da Arapça yaz)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: context.read<PhrasesCubit>().setQuery,
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: state.categories.length,
                  itemBuilder: (_, i) {
                    final c = state.categories[i];
                    final sel = c == state.catFilter;
                    return ChoiceChip(
                      label: Text(c),
                      selected: sel,
                      onSelected: (_) =>
                          context.read<PhrasesCubit>().setCategory(c),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: state.filtered.isEmpty
                    ? const Center(child: Text('Sonuç bulunamadı'))
                    : ListView.builder(
                        itemCount: state.filtered.length,
                        itemBuilder: (_, i) {
                          final p = state.filtered[i];
                          final key = '${p.cat}|${p.ar}';
                          final fav = state.favs.contains(key);
                          return _PhraseTile(
                            phrase: p,
                            isFav: fav,
                            onSpeak: () => _speak(p.ar),
                            onFav: () =>
                                context.read<PhrasesCubit>().toggleFav(p),
                            onOpen: () => _showDetails(context, p),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<PhrasesCubit, PhrasesState>(
        builder: (context, state) {
          final favCount = state.favs.length;
          return FloatingActionButton.extended(
            onPressed: () => _openFavs(context),
            icon: const Icon(Icons.bookmark),
            label: Text('Favoriler ($favCount)'),
          );
        },
      ),
    );
  }

  void _openFavs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavsPage()),
    );
  }

  void _showDetails(BuildContext context, Phrase p) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(p.latin, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  p.ar,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  FilledButton.icon(
                    onPressed: () => _speak(p.ar),
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Dinle'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Kapat'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PhraseTile extends StatelessWidget {
  final Phrase phrase;
  final bool isFav;
  final VoidCallback onSpeak;
  final VoidCallback onFav;
  final VoidCallback onOpen;

  const _PhraseTile({
    required this.phrase,
    required this.isFav,
    required this.onSpeak,
    required this.onFav,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onOpen,
        title: Text(
          phrase.tr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(phrase.latin),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(phrase.ar),
            ),
          ],
        ),
        leading: CircleAvatar(child: Text(phrase.cat.characters.first)),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              tooltip: 'Dinle',
              icon: const Icon(Icons.volume_up),
              onPressed: onSpeak,
            ),
            IconButton(
              tooltip: isFav ? 'Favoriden çıkar' : 'Favoriye ekle',
              icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_border),
              onPressed: onFav,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatefulWidget {
  final double currentRate;
  final double currentPitch;
  final void Function(double rate, double pitch) onChanged;

  const _SettingsSheet({
    required this.currentRate,
    required this.currentPitch,
    required this.onChanged,
  });

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late double _rate = widget.currentRate;
  late double _pitch = widget.currentPitch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Ses Ayarları',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Hız'),
              Expanded(
                child: Slider(
                  value: _rate,
                  min: 0.2,
                  max: 0.9,
                  onChanged: (v) => setState(() => _rate = v),
                ),
              ),
              Text(_rate.toStringAsFixed(2)),
            ],
          ),
          Row(
            children: [
              const Text('Perde'),
              Expanded(
                child: Slider(
                  value: _pitch,
                  min: 0.7,
                  max: 1.3,
                  onChanged: (v) => setState(() => _pitch = v),
                ),
              ),
              Text(_pitch.toStringAsFixed(2)),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              widget.onChanged(_rate, _pitch);
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

class FavsPage extends StatelessWidget {
  const FavsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoriler')),
      body: BlocBuilder<PhrasesCubit, PhrasesState>(
        builder: (context, state) {
          final favs = state.favs;
          final items =
              state.filtered; // mevcut filtre etkili; istersen state.all kullan
          final favItems = items
              .where((p) => favs.contains('${p.cat}|${p.ar}'))
              .toList();

          if (favItems.isEmpty) {
            return const Center(child: Text('Henüz favori yok'));
          }

          return ListView.builder(
            itemCount: favItems.length,
            itemBuilder: (_, i) {
              final p = favItems[i];
              return ListTile(
                title: Text(p.tr),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.latin),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(p.ar),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PhrasesCubit extends Cubit<PhrasesState> {
  PhrasesCubit() : super(const PhrasesState());

  Future<void> init() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      // JSON yükle
      final jsonStr = await rootBundle.loadString('assets/data/phrases.json');
      final List list = json.decode(jsonStr);
      final all = list.map((e) => Phrase.fromJson(e)).toList();

      // Favoriler
      final sp = await SharedPreferences.getInstance();
      final favs = sp.getStringList('favs')?.toSet() ?? <String>{};

      emit(state.copyWith(all: all, favs: favs, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> toggleFav(Phrase p) async {
    final key = '${p.cat}|${p.ar}';
    final next = Set<String>.from(state.favs);
    if (next.contains(key)) {
      next.remove(key);
    } else {
      next.add(key);
    }
    emit(state.copyWith(favs: next));
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList('favs', next.toList());
  }

  void setQuery(String q) => emit(state.copyWith(query: q));
  void setCategory(String c) => emit(state.copyWith(catFilter: c));
}

class Phrase {
  final String cat;
  final String ar; // Tunus Darijası
  final String latin; // okunuş
  final String tr; // Türkçe

  const Phrase({
    required this.cat,
    required this.ar,
    required this.latin,
    required this.tr,
  });

  factory Phrase.fromJson(Map<String, dynamic> j) => Phrase(
    cat: j['cat'] as String,
    ar: j['ar'] as String,
    latin: j['latin'] as String,
    tr: j['tr'] as String,
  );
}

class PhrasesState extends Equatable {
  final List<Phrase> all;
  final Set<String> favs; // key: cat|ar
  final String query;
  final String catFilter; // 'Tümü' veya kategori adı
  final bool loading;
  final String? error;

  const PhrasesState({
    this.all = const [],
    this.favs = const {},
    this.query = '',
    this.catFilter = 'Tümü',
    this.loading = false,
    this.error,
  });

  List<Phrase> get filtered {
    final list = catFilter == 'Tümü'
        ? all
        : all.where((e) => e.cat == catFilter).toList();

    if (query.isEmpty) return list;

    final q = query.toLowerCase();
    return list
        .where(
          (e) =>
              e.tr.toLowerCase().contains(q) ||
              e.latin.toLowerCase().contains(q) ||
              e.ar.contains(query),
        )
        .toList();
  }

  List<String> get categories => [
    'Tümü',
    ...{for (final p in all) p.cat},
  ];

  PhrasesState copyWith({
    List<Phrase>? all,
    Set<String>? favs,
    String? query,
    String? catFilter,
    bool? loading,
    String? error,
  }) {
    return PhrasesState(
      all: all ?? this.all,
      favs: favs ?? this.favs,
      query: query ?? this.query,
      catFilter: catFilter ?? this.catFilter,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [all, favs, query, catFilter, loading, error];
}
