// Flutter DevTools demo uygulaması. Her DevTools sekmesi için bir ekran var.
// Çalıştır: flutter run -d windows   (performans ölçümü için: --profile)
// Not: CPU Profiler ve Network sekmeleri web'de çalışmaz, Windows kullan.
import 'package:flutter/material.dart';

import 'demo_sayfalari.dart';
import 'sepet_sayfasi.dart';

void main() {
  runApp(const SunumApp());
}

class SunumApp extends StatelessWidget {
  const SunumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF0A1F44)),
      home: const AnaMenu(),
    );
  }
}

class AnaMenu extends StatelessWidget {
  const AnaMenu({super.key});

  static final _sayfalar = <(String, String, Widget Function())>[
    ('Sepet', 'Inspector, Debugger, Debug console', () => const SepetSayfasi()),
    ('Performance', 'Jank / frame chart', () => const PerformansSayfasi()),
    ('CPU Profiler', 'Ağır hesap, UserTag', () => const CpuSayfasi()),
    ('Memory', 'Sızıntı, diff snapshot', () => const BellekSayfasi()),
    ('Network', 'HTTP isteği', () => const AgSayfasi()),
    ('Logging', 'log() seviyeleri', () => const LogSayfasi()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DevTools Demo')),
      body: ListView(
        children: [
          for (final (baslik, alt, ac) in _sayfalar)
            ListTile(
              title: Text(baslik),
              subtitle: Text(alt),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ac())),
            ),
        ],
      ),
    );
  }
}
