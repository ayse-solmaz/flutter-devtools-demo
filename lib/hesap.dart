/// Fiyata yüzde indirim uygular. Örnek: 400 TL, %20 indirim -> 320 TL.
double indirimliFiyat(double fiyat, double yuzde) {
  return fiyat - (fiyat * yuzde / 100);
}

/// Fiyat listesinin toplamını verir.
double toplam(List<double> fiyatlar) {
  double sonuc = 0;
  for (final fiyat in fiyatlar) {
    sonuc += fiyat;
  }
  return sonuc;
}

/// CPU Profiler demosu için bilerek yavaş yazılmış özyinelemeli fonksiyon.
int fib(int n) => n < 2 ? n : fib(n - 1) + fib(n - 2);
