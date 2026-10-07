import 'dart:developer';

import 'package:flutter/material.dart';

import 'hesap.dart';

/// Inspector, Debugger, Debug console ve Logging demosu.
class SepetSayfasi extends StatefulWidget {
  const SepetSayfasi({super.key});

  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}

class _SepetSayfasiState extends State<SepetSayfasi> {
  final Map<String, double> _urunler = {
    'Kitap': 250,
    'Kalem': 100,
    'Defter': 50,
  };

  late double _toplam = toplam(_urunler.values.toList());
  bool _tasmaGoster = false;
  bool _tasmaDuzelt = false;

  void _indirimUygula() {
    final onceki = _toplam;
    final yeni = indirimliFiyat(onceki, 20); // <- BREAKPOINT'i buraya koy
    log('İndirim uygulandı: $onceki -> $yeni', name: 'SEPET');
    setState(() {
      _toplam = yeni;
    });
  }

  void _sifirla() {
    log('Sepet sıfırlandı', name: 'SEPET');
    setState(() {
      _toplam = toplam(_urunler.values.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sepet (Inspector / Debugger)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final urun in _urunler.entries)
              ListTile(
                title: Text(urun.key),
                trailing: Text('${urun.value.toStringAsFixed(0)} TL'),
              ),
            const Divider(),
            Text(
              'Toplam: ${_toplam.toStringAsFixed(0)} TL',
              key: const Key('toplam'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(
                  key: const Key('indirim'),
                  onPressed: _indirimUygula,
                  child: const Text('%20 İndirim Uygula'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  key: const Key('sifirla'),
                  onPressed: _sifirla,
                  child: const Text('Sıfırla'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Taşma hatası göster (Inspector demosu)'),
              value: _tasmaGoster,
              onChanged: (v) => setState(() => _tasmaGoster = v),
            ),
            SwitchListTile(
              title: const Text('Düzelt (Expanded kullan)'),
              value: _tasmaDuzelt,
              onChanged: (v) => setState(() => _tasmaDuzelt = v),
            ),
            if (_tasmaGoster)
              // Düzeltme kapalıyken Row içinde uzun metin taşar (sarı-siyah bant).
              Row(
                children: [
                  if (_tasmaDuzelt)
                    Expanded(child: Text('Bu çok uzun bir metin ' * 6))
                  else
                    Text('Bu çok uzun bir metin ' * 6),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
