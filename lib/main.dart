import 'package:flutter/material.dart';
import 'logika_ev.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  String layar = "home";
  int tipeDetail = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: Builder(

          builder: (context) {

            switch (layar) {

              case "home":

                return HomeScreen(

                  onR: () {

                    setState(() {

                      layar = "rekap";

                    });

                  },

                  onD: () {

                    setState(() {

                      layar = "menu_detail";

                    });

                  },

                );

              case "menu_detail":

                return MenuDetailScreen(

                  onP: (p) {

                    setState(() {

                      tipeDetail = p;

                      layar = "detail_proses";

                    });

                  },

                  onB: () {

                    setState(() {

                      layar = "home";

                    });

                  },

                );

              case "detail_proses":

                return LayarKalkulator(

                  title: "DETAIL DATA",

                  isHalamanB: true,

                  tipeDetail: tipeDetail,

                  onBack: () {

                    setState(() {

                      layar = "menu_detail";

                    });

                  },

                );

              case "rekap":

                return LayarKalkulator(

                  title: "REKAP DATA",

                  isHalamanB: false,

                  tipeDetail: 0,

                  onBack: () {

                    setState(() {

                      layar = "home";

                    });

                  },

                );

              default:

                return Container();
            }
          },
        ),
      ),
    );
  }
}
class LayarKalkulator extends StatefulWidget {
  final String title;
  final bool isHalamanB;
  final int tipeDetail;
  final VoidCallback onBack;

  const LayarKalkulator({
    super.key,
    required this.title,
    required this.isHalamanB,
    required this.tipeDetail,
    required this.onBack,
  });

  @override
  State<LayarKalkulator> createState() => _LayarKalkulatorState();
}

class _LayarKalkulatorState extends State<LayarKalkulator> {

  String mobil = daftarMobil[0].nama;
  String skenario = "Urban";
  String ccr = "0.010";
  String efisiensi = "95%";

  HasilPerhitungan? hasilData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            //--------------------------------------------------
            // HEADER
            //--------------------------------------------------

            Row(

              children: [

                const Spacer(),

                TextButton.icon(

                  onPressed: widget.onBack,

                  icon: const Icon(Icons.arrow_back),

                  label: const Text("Kembali"),

                ),

              ],

            ),

            const SizedBox(height: 10),

            Text(

              widget.title,

              style: const TextStyle(

                fontSize: 26,

                fontWeight: FontWeight.bold,

              ),

            ),

            const SizedBox(height: 20),

            //--------------------------------------------------
            // CARD INPUT
            //--------------------------------------------------

            Card(

              elevation: 3,

              child: Padding(

                padding: const EdgeInsets.all(16),

                child: Column(

                  children: [

                    PilihDropdown(

                      label: "Pilih Mobil",

                      options: daftarMobil.map((e) => e.nama).toList(),

                      selected: mobil,

                      onSelected: (v) {

                        setState(() {

                          mobil = v;

                        });

                      },

                    ),

                    const SizedBox(height: 12),

                    PilihDropdown(

                      label: "Skenario",

                      options: const [

                        "Urban",

                        "Highway",

                      ],

                      selected: skenario,

                      onSelected: (v) {

                        setState(() {

                          skenario = v;

                        });

                      },

                    ),

                    const SizedBox(height: 12),

                    PilihDropdown(

                      label: "CCR",

                      options: const [

                        "0.010",

                        "0.015",

                      ],

                      selected: ccr,

                      onSelected: (v) {

                        setState(() {

                          ccr = v;

                        });

                      },

                    ),

                    const SizedBox(height: 12),

                    PilihDropdown(

                      label: "Efisiensi",

                      options: const [

                        "95%",

                        "85%",

                      ],

                      selected: efisiensi,

                      onSelected: (v) {

                        setState(() {

                          efisiensi = v;

                        });

                      },

                    ),

                    const SizedBox(height: 18),

                    SizedBox(

                      width: double.infinity,

                      height: 48,

                      child: ElevatedButton(

                        onPressed: () {

                          final m = daftarMobil.firstWhere(
                                  (e) => e.nama == mobil);

                          final s = daftarSkenario.firstWhere(
                                  (e) => e.nama == skenario);

                          final crrV =
                          double.parse(ccr);

                          final effV =
                              double.parse(
                                  efisiensi.replaceAll("%", "")) /
                                  100;

                          setState(() {

                            switch (widget.tipeDetail) {

                              case 1:

                                hasilData =
                                    simulasiAksel(
                                        m,
                                        s);

                                break;

                              case 2:

                                hasilData =
                                    simulasiAeroGelinding(
                                        m,
                                        s,
                                        crrV);

                                break;

                              case 3:

                                hasilData =
                                    simulasiDayaKonsumsi(
                                        m,
                                        s,
                                        crrV,
                                        effV);

                                break;

                              default:

                                hasilData =
                                    simulasiRekap(
                                        m,
                                        s,
                                        crrV,
                                        effV);

                            }

                          });

                        },

                        child: const Text(

                          "HITUNG HASIL",

                          style: TextStyle(

                            fontSize: 16,

                            fontWeight: FontWeight.bold,

                          ),

                        ),

                      ),

                    ),

                  ],

                ),

              ),

            ),
                        const SizedBox(height: 16),

            //--------------------------------------------------
            // HASIL
            //--------------------------------------------------

            if (hasilData != null)

              Expanded(

                child: widget.isHalamanB

                    //--------------------------------------------------
                    // HALAMAN DETAIL
                    //--------------------------------------------------
                    ? SingleChildScrollView(

                        scrollDirection: Axis.horizontal,

                        child: SingleChildScrollView(

                          child: DataTable(

                            border: TableBorder.all(),

                            columns: [

                              const DataColumn(
                                label: Text(
                                  "Time",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              const DataColumn(
                                label: Text(
                                  "Speed",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              if (widget.tipeDetail == 1) ...[
                                const DataColumn(
                                  label: Text(
                                    "a (m/s²)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    "Facc (N)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],

                              if (widget.tipeDetail == 2) ...[
                                const DataColumn(
                                  label: Text(
                                    "Fd (N)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    "Fr (N)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    "Ft (N)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],

                              if (widget.tipeDetail == 3) ...[
                                const DataColumn(
                                  label: Text(
                                    "Daya (kW)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    "Energi (Wh)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const DataColumn(
                                  label: Text(
                                    "Jarak (km)",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],

                            rows: List.generate(

                              hasilData!.timeList.length,

                              (i) {

                                List<DataCell> cells = [

                                  DataCell(Text(
                                      hasilData!.timeList[i]
                                          .toInt()
                                          .toString())),

                                  DataCell(Text(
                                      hasilData!.speedList[i]
                                          .toStringAsFixed(1))),
                                ];

                                if (widget.tipeDetail == 1) {

                                  cells.add(
                                    DataCell(Text(
                                        hasilData!.col1[i]
                                            .toStringAsFixed(2))),
                                  );

                                  cells.add(
                                    DataCell(Text(
                                        hasilData!.col2[i]
                                            .toStringAsFixed(2))),
                                  );
                                }

                                if (widget.tipeDetail == 2) {

                                  cells.add(
                                    DataCell(Text(
                                        hasilData!.col1[i]
                                            .toStringAsFixed(2))),
                                  );

                                  cells.add(
                                    DataCell(Text(
                                        hasilData!.col2[i]
                                            .toStringAsFixed(2))),
                                  );

                                  cells.add(
                                    DataCell(Text(
                                        hasilData!.col3[i]
                                            .toStringAsFixed(2))),
                                  );
                                }

                                if (widget.tipeDetail == 3) {

                                  cells.add(
                                    DataCell(Text(
                                        hasilData!.col1[i]
                                            .toStringAsFixed(2))),
                                  );

                                  cells.add(
                                    DataCell(Text(
                                        hasilData!.col3[i]
                                            .toStringAsFixed(2))),
                                  );

                                  cells.add(
                                    DataCell(Text(
                                        hasilData!.col2[i]
                                            .toStringAsFixed(3))),
                                  );
                                }

                                return DataRow(
                                  cells: cells,
                                );
                              },
                            ),
                          ),
                        ),
                      )
                                          //--------------------------------------------------
                    // HALAMAN REKAP
                    //--------------------------------------------------
                    : SingleChildScrollView(

                        child: Column(

                          children: [

                            BarisTabel(
                              "Kapasitas Baterai (kWh)",
                              hasilData!.baterai.toStringAsFixed(2),
                            ),

                            BarisTabel(
                              "Energi Total (Wh)",
                              hasilData!.eTotal.toStringAsFixed(2),
                            ),

                            BarisTabel(
                              "Jarak Tempuh Total (km)",
                              hasilData!.jarakTotal.toStringAsFixed(3),
                            ),

                            BarisTabel(
                              "Konsumsi Energi (Wh/km)",
                              hasilData!.eKonsumsi.toStringAsFixed(2),
                            ),

                            BarisTabel(
                              "Efisiensi Energi (km/kWh)",
                              hasilData!.nE.toStringAsFixed(2),
                            ),

                            BarisTabel(
                              "Estimasi Jarak Tempuh (km)",
                              hasilData!.jarakTempuh.toStringAsFixed(2),
                            ),

                          ],

                        ),

                      ),
              ),       

          ],

        ),

      ),

    );

  }

}
class HomeScreen extends StatelessWidget {

  final VoidCallback onR;
  final VoidCallback onD;

  const HomeScreen({
    super.key,
    required this.onR,
    required this.onD,
  });

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          const Text(
            "",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 50),

          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              onPressed: onR,
              child: const Text("MENU REKAP"),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              onPressed: onD,
              child: const Text("MENU DETAIL"),
            ),
          ),

        ],
      ),
    );
  }
}
class MenuDetailScreen extends StatelessWidget {

  final Function(int) onP;
  final VoidCallback onB;

  const MenuDetailScreen({
    super.key,
    required this.onP,
    required this.onB,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.all(20),

      child: Column(

        children: [

          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onB,
              icon: const Icon(Icons.arrow_back),
              label: const Text("Kembali"),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "DETAIL DATA",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ()=>onP(1),
              child: const Text("AKSELERASI & GAYA"),
            ),
          ),

          const SizedBox(height:15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ()=>onP(2),
              child: const Text("AERODINAMIK & GELINDING"),
            ),
          ),

          const SizedBox(height:15),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: ()=>onP(3),
              child: const Text("DAYA & KONSUMSI"),
            ),
          ),

        ],
      ),
    );
  }
}
class PilihDropdown extends StatelessWidget {

  final String label;
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const PilihDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(label),

        const SizedBox(height:5),
DropdownButtonFormField<String>(
  initialValue: selected,

          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),

          items: options.map((e){

            return DropdownMenuItem(

              value: e,

              child: Text(e),

            );

          }).toList(),

          onChanged: (v){

            if(v!=null){

              onSelected(v);

            }

          },

        ),

      ],

    );

  }

}
class BarisTabel extends StatelessWidget {

  final String kiri;
  final String kanan;

  const BarisTabel(
    this.kiri,
    this.kanan,{
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(

      padding: const EdgeInsets.symmetric(vertical:8),

      child: Row(

        children: [

          Expanded(
            child: Text(
              kiri,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(kanan),

        ],

      ),

    );

  }

}