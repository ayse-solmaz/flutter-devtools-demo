import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'hesap.dart';

/// Performance view: animasyon sürerken build'i bilerek yavaşlatır (jank).
class PerformansSayfasi extends StatefulWidget {
  const PerformansSayfasi({super.key});

  @override
  State<PerformansSayfasi> createState() => _PerformansSayfasiState();
}

class _PerformansSayfasiState extends State<PerformansSayfasi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _kontrol = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();
  bool _yavas = false;

  @override
  void dispose() {
    _kontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance (jank)')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Yavaş build (takılma üret)'),
            subtitle: const Text('Profile modda çalıştır: flutter run --profile'),
            value: _yavas,
            onChanged: (v) => setState(() => _yavas = v),
          ),
          AnimatedBuilder(
            animation: _kontrol,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: LinearProgressIndicator(value: _kontrol.value),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: _kontrol,
              builder: (context, _) => ListView.builder(
                itemCount: 50,
                itemBuilder: (context, i) {
                  if (_yavas) {
                    final sw = Stopwatch()..start();
                    while (sw.elapsedMilliseconds < 4) {} // yapay yük
                  }
                  return ListTile(title: Text('Satır $i'));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CPU Profiler: UI thread'i meşgul eden ağır hesap.
class CpuSayfasi extends StatefulWidget {
  const CpuSayfasi({super.key});

  @override
  State<CpuSayfasi> createState() => _CpuSayfasiState();
}

class _CpuSayfasiState extends State<CpuSayfasi> {
  static final _etiket = UserTag('fibonacci');
  String _sonuc = 'Henüz çalıştırılmadı';

  void _hesapla() {
    final onceki = _etiket.makeCurrent();
    final sw = Stopwatch()..start();
    final r = fib(36);
    sw.stop();
    onceki.makeCurrent();
    setState(() => _sonuc = 'fib(36) = $r  (${sw.elapsedMilliseconds} ms)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CPU Profiler')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('DevTools > CPU Profiler > Record, sonra butona bas, Stop.'),
            const SizedBox(height: 16),
            FilledButton(onPressed: _hesapla, child: const Text('Ağır hesabı çalıştır')),
            const SizedBox(height: 16),
            Text(_sonuc, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

/// Memory view: statik listede biriken nesneler (bilinçli sızıntı).
class BellekSayfasi extends StatefulWidget {
  const BellekSayfasi({super.key});

  @override
  State<BellekSayfasi> createState() => _BellekSayfasiState();
}

class _BellekSayfasiState extends State<BellekSayfasi> {
  static final List<List<int>> _sizinti = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory (sızıntı)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Snapshot al, butona birkaç kez bas, tekrar snapshot al, diff\'e bak.'),
            const SizedBox(height: 16),
            Text('Biriken blok: ${_sizinti.length} (~${_sizinti.length * 2} MB)',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(
                  onPressed: () => setState(
                      () => _sizinti.add(List<int>.filled(250000, 0))),
                  child: const Text('Sızıntı ekle (+2 MB)'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => setState(_sizinti.clear),
                  child: const Text('Temizle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Network view: dart:io HttpClient ile gerçek bir istek (web'de çalışmaz).
class AgSayfasi extends StatefulWidget {
  const AgSayfasi({super.key});

  @override
  State<AgSayfasi> createState() => _AgSayfasiState();
}

class _AgSayfasiState extends State<AgSayfasi> {
  String _durum = 'Henüz istek atılmadı';

  Future<void> _istekAt() async {
    setState(() => _durum = 'İstek gönderiliyor...');
    try {
      final istemci = HttpClient();
      final istek = await istemci
          .getUrl(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));
      final yanit = await istek.close();
      final govde = await yanit.transform(const SystemEncoding().decoder).join();
      istemci.close();
      setState(() => _durum = 'HTTP ${yanit.statusCode}\n$govde');
    } catch (e) {
      setState(() => _durum = 'Hata: $e\n(Network view web\'de çalışmaz; Windows kullan)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Network')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton(onPressed: _istekAt, child: const Text('GET isteği at')),
            const SizedBox(height: 16),
            Text(_durum),
          ],
        ),
      ),
    );
  }
}

/// Logging view: farklı seviyelerde log üretir.
class LogSayfasi extends StatelessWidget {
  const LogSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Logging')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton(
              onPressed: () => log('Bilgi mesajı', name: 'DEMO'),
              child: const Text('log() bilgi'),
            ),
            FilledButton(
              onPressed: () => log('Uyarı mesajı', name: 'DEMO', level: 900),
              child: const Text('log() uyarı'),
            ),
            FilledButton(
              onPressed: () => log('Hata mesajı',
                  name: 'DEMO', level: 1000, error: Exception('örnek hata')),
              child: const Text('log() hata'),
            ),
            OutlinedButton(
              onPressed: () => debugPrint('debugPrint çıktısı'),
              child: const Text('debugPrint'),
            ),
          ],
        ),
      ),
    );
  }
}
