class Mobil {
  final String nama;
  final double massa;
  final double cd;
  final double a;
  final double battery;

  Mobil(
    this.nama,
    this.massa,
    this.cd,
    this.a,
    this.battery,
  );
}

class SkenarioData {
  final String nama;
  final List<double> time;
  final List<double> speed;

  SkenarioData(
    this.nama,
    this.time,
    this.speed,
  );
}

class HasilPerhitungan {
  final double baterai;
  final double eTotal;
  final double jarakTotal;
  final double eKonsumsi;
  final double nE;
  final double jarakTempuh;

  final List<double> timeList;
  final List<double> speedList;

  final List<double> col1;
  final List<double> col2;
  final List<double> col3;

  HasilPerhitungan(
    this.baterai,
    this.eTotal,
    this.jarakTotal,
    this.eKonsumsi,
    this.nE,
    this.jarakTempuh,
    this.timeList,
    this.speedList,
    this.col1,
    this.col2,
    this.col3,
  );
}

final List<Mobil> daftarMobil = [
  Mobil("Tesla Model 3", 1844.0, 0.219, 2.22, 82.0),
  Mobil("Hyundai Ioniq 5N", 2214.0, 0.28, 2.55, 82.0),
  Mobil("BYD Seal", 2185.0, 0.219, 2.73, 82.5),
  Mobil("KIA EV6 GT", 2175.0, 0.30, 2.33, 80.0),
  Mobil("BMW i4 xDrive40", 2050.0, 0.25, 2.33, 80.7),
];

final List<SkenarioData> daftarSkenario = [
  SkenarioData(
    "Urban",
    List.generate(31, (i) => i.toDouble() * 10.0),
    [
      0.0,
      0.0,
      2.54,
      13.58,
      24.04,
      10.3,
      0.31,
      9.09,
      15.96,
      9.93,
      17.85,
      5.83,
      9.45,
      30.34,
      38.21,
      26.34,
      12.18,
      11.51,
      29.26,
      34.57,
      29.08,
      25.89,
      0.0,
      5.55,
      5.78,
      10.41,
      33.75,
      28.9,
      16.77,
      0.93,
      7.39,
    ],
  ),

  SkenarioData(
    "Highway",
    List.generate(31, (i) => i.toDouble() * 10.0),
    [
      0.0,
      16.01,
      46.86,
      56.29,
      57.47,
      60.0,
      68.04,
      73.47,
      75.74,
      75.49,
      76.09,
      79.0,
      78.92,
      76.83,
      72.16,
      66.08,
      72.87,
      76.52,
      72.87,
      68.8,
      70.92,
      69.75,
      66.61,
      72.29,
      75.94,
      76.33,
      77.94,
      77.65,
      72.84,
      61.53,
      49.0,
    ],
  ),
];
//=====================================================
// 1. REKAP DATA
//=====================================================

HasilPerhitungan simulasiRekap(
    Mobil mobil,
    SkenarioData skenario,
    double crr,
    double efisiensi,
    ) {

  double energiTotal = 0.0;
  double jarakTotal = 0.0;

  const double g = 9.81;
  const double rho = 1.225;

  for (int k = 1; k < skenario.speed.length; k++) {

    const double dt = 10.0;

    final double v = skenario.speed[k] / 3.6;
    final double vPrev = skenario.speed[k - 1] / 3.6;

    final double a = (v - vPrev) / dt;

    final double ft =
        (crr * mobil.massa * g) +
            (0.5 * rho * mobil.cd * mobil.a * v * v) +
            (mobil.massa * a);

    // Sama seperti Android Studio
    final double power = (ft * v) / efisiensi;

    // Hanya menghitung konsumsi ketika power positif
    if (power > 0) {
      energiTotal += (power * dt) / 3600.0;
    }

    jarakTotal += (v * dt) / 1000.0;
  }

  final double whkm =
  (jarakTotal == 0.0) ? 0.0 : energiTotal / jarakTotal;

  final double kmkwh =
  (whkm == 0.0) ? 0.0 : 1000.0 / whkm;

  return HasilPerhitungan(
    mobil.battery,
    energiTotal,
    jarakTotal,
    whkm,
    kmkwh,
    mobil.battery * kmkwh,
    skenario.time,
    skenario.speed,
    [],
    [],
    [],
  );
}
//=====================================================
// 2. AKSELERASI & GAYA AKSELERASI
//=====================================================

HasilPerhitungan simulasiAksel(
  Mobil mobil,
  SkenarioData skenario,
) {
  List<double> h1 = [];
  List<double> h2 = [];

  for (int i = 0; i < skenario.speed.length; i++) {
    final double v = skenario.speed[i] / 3.6;

    final double a = (i > 0)
        ? (v - (skenario.speed[i - 1] / 3.6)) / 10.0
        : 0.0;

    h1.add(a);
    h2.add(mobil.massa * a);
  }

  return HasilPerhitungan(
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    skenario.time,
    skenario.speed,
    h1,
    h2,
    [],
  );
}
//=====================================================
// 3. GAYA AERODINAMIK & GAYA GELINDING
//=====================================================

HasilPerhitungan simulasiAeroGelinding(
  Mobil mobil,
  SkenarioData skenario,
  double crr,
) {
  List<double> h1 = []; // Fd
  List<double> h2 = []; // Fr
  List<double> h3 = []; // Ft

  const double rho = 1.225;
  const double g = 9.81;

  for (int i = 0; i < skenario.speed.length; i++) {
    final double v = skenario.speed[i] / 3.6;

    final double a = (i > 0)
        ? (v - (skenario.speed[i - 1] / 3.6)) / 10.0
        : 0.0;

    final double fd =
        0.5 * rho * mobil.cd * mobil.a * v * v;

    final double fr =
        crr * mobil.massa * g;

    final double facc =
        mobil.massa * a;

    final double ft =
        fd + fr + facc;

    h1.add(fd);
    h2.add(fr);
    h3.add(ft);
  }

  return HasilPerhitungan(
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    skenario.time,
    skenario.speed,
    h1,
    h2,
    h3,
  );
}
//=====================================================
// 4. DAYA, KONSUMSI & JARAK TEMPUH
//=====================================================

HasilPerhitungan simulasiDayaKonsumsi(
  Mobil mobil,
  SkenarioData skenario,
  double crr,
  double efisiensi,
) {
  List<double> h1 = []; // Power (kW)
  List<double> h2 = []; // Jarak (km)
  List<double> h3 = []; // Energi (Wh)

  const double g = 9.81;
  const double rho = 1.225;

  double energiTotal = 0.0;
  double jarakTotal = 0.0;

  for (int k = 0; k < skenario.time.length; k++) {
    final double v = skenario.speed[k] / 3.6;

    double a;
    double dtLoop;

    if (k == 0) {
      a = 0.0;
      dtLoop = 0.0;
    } else {
      dtLoop = skenario.time[k] - skenario.time[k - 1];

      final double vLama = skenario.speed[k - 1] / 3.6;

      a = (v - vLama) / dtLoop;
    }

    final double fr = crr * mobil.massa * g;

    final double fd =
        0.5 * rho * mobil.cd * mobil.a * v * v;

    final double facc =
        mobil.massa * a;

    double powerMotor;
    double energi;

    if (a < 0) {
      powerMotor = 0.0;
      energi = 0.0;
    } else {
      powerMotor =
          (fr + fd + facc) * v / efisiensi;

      energi =
          (powerMotor * dtLoop) / 3600.0;
    }

    final double jarak =
        (v * dtLoop) / 1000.0;

    energiTotal += energi;
    jarakTotal += jarak;

    h1.add(powerMotor / 1000.0); // kW
    h2.add(jarak);               // km
    h3.add(energi);              // Wh
  }

  final double konsumsi =
      (jarakTotal == 0.0)
          ? 0.0
          : energiTotal / jarakTotal;

  final double efisiensiEnergi =
      (energiTotal == 0.0)
          ? 0.0
          : 1000.0 / konsumsi;

  final double range =
      mobil.battery * efisiensiEnergi;

  return HasilPerhitungan(
    mobil.battery,
    energiTotal,
    jarakTotal,
    konsumsi,
    efisiensiEnergi,
    range,
    skenario.time,
    skenario.speed,
    h1,
    h2,
    h3,
  );
}