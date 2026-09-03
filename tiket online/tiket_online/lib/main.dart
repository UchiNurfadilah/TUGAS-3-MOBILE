import 'dart:async';

import 'package:flutter/material.dart';

// ============================================================
// ABSTRACT CLASS
// ============================================================

abstract class Tiket {
  String nama;
  double harga;
  String lokasi;
  String tanggal;

  Tiket({
    required this.nama,
    required this.harga,
    required this.lokasi,
    required this.tanggal,
  });

  String deskripsi();
}

// ============================================================
// SUBCLASS TIKET EKONOMI
// ============================================================

class TiketEkonomi extends Tiket {
  TiketEkonomi({
    required super.nama,
    required super.harga,
    required super.lokasi,
    required super.tanggal,
  });

  @override
  String deskripsi() {
    return 'Tiket ekonomi dengan harga terjangkau dan nyaman.';
  }
}

// ============================================================
// SUBCLASS TIKET VIP
// ============================================================

class TiketVIP extends Tiket {
  TiketVIP({
    required super.nama,
    required super.harga,
    required super.lokasi,
    required super.tanggal,
  });

  @override
  String deskripsi() {
    return 'Tiket VIP dengan fasilitas premium.';
  }
}

// ============================================================
// MIXIN DISKON
// ============================================================

mixin BisaDiskon {
  double hitungHargaDiskon(double persen, double harga) {
    if (persen < 0 || persen > 100) {
      throw Exception('Persentase diskon tidak valid.');
    }

    return harga - (harga * persen / 100);
  }
}

// ============================================================
// TIKET PROMO
// ============================================================

class TiketPromo extends TiketEkonomi with BisaDiskon {
  TiketPromo({
    required super.nama,
    required super.harga,
    required super.lokasi,
    required super.tanggal,
  });

  @override
  String deskripsi() {
    return 'Tiket ekonomi dengan promo diskon 20%.';
  }
}

// ============================================================
// CUSTOM EXCEPTION
// ============================================================

class TiketHabisException implements Exception {
  final String pesan;

  TiketHabisException(this.pesan);

  @override
  String toString() {
    return pesan;
  }
}

class TiketTidakDitemukanException implements Exception {
  final String pesan;

  TiketTidakDitemukanException(this.pesan);

  @override
  String toString() {
    return pesan;
  }
}

// ============================================================
// SERVICE
// ============================================================

class TiketService {
  // Mengambil daftar tiket secara asynchronous
  Future<List<Tiket>> ambilDaftarTiket() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      TiketPromo(
        nama: 'Festival Summer Vibes',
        harga: 150000,
        lokasi: 'Pantai Sulamadaha, Ternate',
        tanggal: '10 Juni 2026 | 15.00 WIT',
      ),
      TiketEkonomi(
        nama: 'Pesta Rakyat',
        harga: 150000,
        lokasi: 'Panggung Salero, Ternate',
        tanggal: '25 September 2026 | 19.00 WIT',
      ),
      TiketVIP(
        nama: 'Konser Vendeta Rap - VIP',
        harga: 500000,
        lokasi: 'Waterboom, Ternate',
        tanggal: '20 Oktober 2026 | 19.00 WIT',
      ),
    ];
  }

  // Memproses pemesanan secara asynchronous
  Future<String> pesanTiket({
    required Tiket tiket,
    required int jumlah,
    required String nama,
    required String email,
    required String whatsapp,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (tiket.nama.isEmpty) {
      throw TiketTidakDitemukanException('Tiket tidak ditemukan.');
    }

    if (jumlah <= 0) {
      throw Exception('Jumlah tiket tidak valid.');
    }

    if (jumlah > 5) {
      throw TiketHabisException(
        'Stok tiket tidak mencukupi. Maksimal 5 tiket.',
      );
    }

    return 'Pemesanan berhasil untuk $nama.';
  }
}

// ============================================================
// MAIN
// ============================================================

void main() {
  runApp(const AplikasiTiket());
}

// ============================================================
// APLIKASI
// ============================================================

class AplikasiTiket extends StatelessWidget {
  const AplikasiTiket({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tiket Online',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HalamanTiket(),
    );
  }
}

// ============================================================
// HALAMAN UTAMA
// ============================================================

class HalamanTiket extends StatefulWidget {
  const HalamanTiket({super.key});

  @override
  State<HalamanTiket> createState() {
    return _HalamanTiketState();
  }
}

class _HalamanTiketState extends State<HalamanTiket> {
  final TiketService service = TiketService();

  String kategori = 'Semua';
  String pencarian = '';

  late Future<List<Tiket>> futureTiket;

  @override
  void initState() {
    super.initState();

    futureTiket = service.ambilDaftarTiket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiket Online',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            Text('Pesan tiket favoritmu', style: TextStyle(fontSize: 12)),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: Column(
        children: [
          // ======================================================
          // SEARCH
          // ======================================================

          Container(
            color: Colors.blue,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  pencarian = value.toLowerCase();
                });
              },

              decoration: InputDecoration(
                hintText: 'Cari event, konser, atau kegiatan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // KATEGORI
          // ======================================================
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _kategoriButton('Semua'),
                _kategoriButton('Ekonomi'),
                _kategoriButton('VIP'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ======================================================
          // FUTURE BUILDER
          // ======================================================
          Expanded(
            child: FutureBuilder<List<Tiket>>(
              future: futureTiket,

              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ERROR
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 50),
                        const SizedBox(height: 10),
                        const Text('Gagal mengambil data tiket.'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              futureTiket = service.ambilDaftarTiket();
                            });
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                // DATA KOSONG
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada tiket tersedia.'));
                }

                List<Tiket> daftar = snapshot.data!;

                // ==================================================
                // FILTER TIKET
                // ==================================================

                daftar = daftar.where((tiket) {
                  final bool sesuaiPencarian = tiket.nama
                      .toLowerCase()
                      .contains(pencarian);

                  bool sesuaiKategori = true;

                  if (kategori == 'VIP') {
                    sesuaiKategori = tiket is TiketVIP;
                  }

                  if (kategori == 'Ekonomi') {
                    sesuaiKategori = tiket is TiketEkonomi;
                  }

                  return sesuaiPencarian && sesuaiKategori;
                }).toList();

                // TIDAK DITEMUKAN
                if (daftar.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 55),
                        SizedBox(height: 10),
                        Text(
                          'Tiket tidak ditemukan.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ==================================================
                // LIST TIKET
                // ==================================================

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  itemCount: daftar.length,

                  itemBuilder: (context, index) {
                    return _kartuTiket(context, daftar[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUTTON KATEGORI
  // ============================================================

  Widget _kategoriButton(String nama) {
    final bool aktif = kategori == nama;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(nama),
        selected: aktif,

        onSelected: (_) {
          setState(() {
            kategori = nama;
          });
        },
      ),
    );
  }

  // ============================================================
  // KARTU TIKET
  // ============================================================

  Widget _kartuTiket(BuildContext context, Tiket tiket) {
    final bool promo = tiket is TiketPromo;

    final bool vip = tiket is TiketVIP;

    double hargaAkhir = tiket.harga;

    if (promo) {
      hargaAkhir = (tiket as TiketPromo).hitungHargaDiskon(20, tiket.harga);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // GAMBAR / HEADER TIKET
          // ======================================================

          Container(
            height: 145,
            width: double.infinity,

            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: vip
                    ? [Colors.deepPurple, Colors.purpleAccent]
                    : [Colors.blue, Colors.lightBlueAccent],
              ),

              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),

            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.confirmation_num,
                    size: 65,
                    color: Colors.white,
                  ),
                ),

                if (promo)
                  Positioned(
                    top: 12,
                    left: 12,

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Text(
                        'PROMO 20%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ======================================================
          // INFORMASI TIKET
          // ======================================================
          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // LABEL KATEGORI
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: vip ? Colors.deepPurple : Colors.blue,

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    vip ? 'VIP' : 'EKONOMI',

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // NAMA
                Text(
                  tiket.nama,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // DESKRIPSI
                Text(
                  tiket.deskripsi(),

                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),

                const SizedBox(height: 10),

                // LOKASI
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 17),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        tiket.lokasi,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // TANGGAL
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined, size: 17),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        tiket.tanggal,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // HARGA + BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        if (promo)
                          Text(
                            'Rp${tiket.harga.toStringAsFixed(0)}',

                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12,
                            ),
                          ),

                        Text(
                          'Rp${hargaAkhir.toStringAsFixed(0)}',

                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          'per tiket',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      onPressed: () {
                        _pilihTiket(context, tiket);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text('Pilih Tiket'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // COUNTDOWN
                const CountdownTiket(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORM PEMESANAN TIKET
  // ============================================================

  void _pilihTiket(BuildContext context, Tiket tiket) {
    int jumlah = 1;

    final BuildContext halamanContext = context;

    final formKey = GlobalKey<FormState>();

    final namaController = TextEditingController();

    final emailController = TextEditingController();

    final whatsappController = TextEditingController();

    final bool isPromo = tiket is TiketPromo;

    final bool isVip = tiket is TiketVIP;

    double hargaNormal = tiket.harga;

    double hargaSetelahDiskon = tiket.harga;

    if (isPromo) {
      hargaSetelahDiskon = (tiket as TiketPromo).hitungHargaDiskon(
        20,
        tiket.harga,
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),

      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final double totalDiskon =
                (hargaNormal - hargaSetelahDiskon) * jumlah;

            final double totalPembayaran = hargaSetelahDiskon * jumlah;

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),

                child: Form(
                  key: formKey,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // ==================================================
                      // JUDUL
                      // ==================================================

                      const Center(
                        child: Text(
                          'Pemesanan Tiket',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ==================================================
                      // INFORMASI TIKET
                      // ==================================================
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,

                          borderRadius: BorderRadius.circular(16),

                          border: Border.all(color: Colors.grey.shade300),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),

                                  decoration: BoxDecoration(
                                    color: isVip
                                        ? Colors.deepPurple
                                        : Colors.blue,

                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    isVip ? 'VIP' : 'EKONOMI',

                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                if (isPromo)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),

                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),

                                    child: const Text(
                                      'PROMO 20%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Text(
                              tiket.nama,

                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 17,
                                ),
                                const SizedBox(width: 5),
                                Expanded(child: Text(tiket.lokasi)),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 17,
                                ),
                                const SizedBox(width: 5),
                                Expanded(child: Text(tiket.tanggal)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // DATA PEMESAN
                      // ==================================================
                      const Text(
                        'Data Pemesan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // NAMA
                      TextFormField(
                        controller: namaController,

                        decoration: InputDecoration(
                          labelText: 'Nama Lengkap',

                          hintText: 'Masukkan nama lengkap',

                          prefixIcon: const Icon(Icons.person_outline),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama wajib diisi';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // EMAIL
                      TextFormField(
                        controller: emailController,

                        keyboardType: TextInputType.emailAddress,

                        decoration: InputDecoration(
                          labelText: 'Email',

                          hintText: 'Masukkan email',

                          prefixIcon: const Icon(Icons.email_outlined),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }

                          if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // WHATSAPP
                      TextFormField(
                        controller: whatsappController,

                        keyboardType: TextInputType.phone,

                        decoration: InputDecoration(
                          labelText: 'Nomor WhatsApp',

                          hintText: 'Masukkan nomor WhatsApp',

                          prefixIcon: const Icon(Icons.phone_outlined),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nomor WhatsApp wajib diisi';
                          }

                          final nomor = value.replaceAll(RegExp(r'[^0-9]'), '');

                          if (nomor.length < 10) {
                            return 'Nomor WhatsApp tidak valid';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // DETAIL PEMESANAN
                      // ==================================================
                      const Text(
                        'Detail Pemesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // KATEGORI
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text('Kategori Tiket'),

                            Row(
                              children: [
                                Text(
                                  isVip ? 'VIP' : 'Ekonomi',

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(width: 8),

                                const Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // JUMLAH
                      Container(
                        width: double.infinity,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text('Jumlah Tiket'),

                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (jumlah > 1) {
                                      setModalState(() {
                                        jumlah--;
                                      });
                                    }
                                  },

                                  icon: const Icon(Icons.remove_circle),
                                ),

                                SizedBox(
                                  width: 35,

                                  child: Center(
                                    child: Text(
                                      '$jumlah',

                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    if (jumlah < 10) {
                                      setModalState(() {
                                        jumlah++;
                                      });
                                    }
                                  },

                                  icon: const Icon(Icons.add_circle),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // RINGKASAN
                      // ==================================================
                      const Text(
                        'Ringkasan Pesanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text('Harga Tiket'),

                          Text('Rp${hargaNormal.toStringAsFixed(0)}'),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [const Text('Jumlah Tiket'), Text('$jumlah')],
                      ),

                      const SizedBox(height: 8),

                      if (isPromo)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            const Text('Diskon (20%)'),

                            Text(
                              '- Rp${totalDiskon.toStringAsFixed(0)}',

                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),

                      const SizedBox(height: 12),

                      const Divider(),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            'Total Pembayaran',

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            'Rp${totalPembayaran.toStringAsFixed(0)}',

                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // TOMBOL PEMBAYARAN
                      // ==================================================
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(bottomSheetContext);

                              _prosesPemesanan(
                                halamanContext,
                                tiket,
                                jumlah,
                                namaController.text.trim(),
                                emailController.text.trim(),
                                whatsappController.text.trim(),
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,

                            foregroundColor: Colors.white,

                            padding: const EdgeInsets.symmetric(vertical: 16),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          child: const Text(
                            'Lanjut ke Pembayaran',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // KEAMANAN
                      const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: Colors.grey,
                            ),

                            SizedBox(width: 5),

                            Text(
                              'Pembayaran aman dan terenkripsi',

                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // PROSES PEMESANAN
  // ============================================================

  Future<void> _prosesPemesanan(
    BuildContext context,
    Tiket tiket,
    int jumlah,
    String nama,
    String email,
    String whatsapp,
  ) async {
    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (dialogContext) {
        return const AlertDialog(
          content: Row(
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(),
              ),

              SizedBox(width: 20),

              Expanded(child: Text('Memproses pesanan...')),
            ],
          ),
        );
      },
    );

    try {
      final String hasil = await service.pesanTiket(
        tiket: tiket,
        jumlah: jumlah,
        nama: nama,
        email: email,
        whatsapp: whatsapp,
      );

      if (!context.mounted) {
        return;
      }

      // Tutup loading
      Navigator.pop(context);

      // Tampilkan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$hasil\n'
            'Email: $email',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    }
    // ==========================================================
    // TIKET HABIS
    // ==========================================================
    on TiketHabisException catch (e) {
      if (!context.mounted) {
        return;
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
    // ==========================================================
    // TIKET TIDAK DITEMUKAN
    // ==========================================================
    on TiketTidakDitemukanException catch (e) {
      if (!context.mounted) {
        return;
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.orange),
      );
    }
    // ==========================================================
    // ERROR LAIN
    // ==========================================================
    catch (e) {
      if (!context.mounted) {
        return;
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    // ==========================================================
    // FINALLY
    // ==========================================================
    finally {
      debugPrint('Proses pemesanan selesai.');
    }
  }
}

// ============================================================
// COUNTDOWN STREAM
// ============================================================

class CountdownTiket extends StatefulWidget {
  const CountdownTiket({super.key});

  @override
  State<CountdownTiket> createState() {
    return _CountdownTiketState();
  }
}

class _CountdownTiketState extends State<CountdownTiket> {
  late Stream<int> countdownStream;

  @override
  void initState() {
    super.initState();

    countdownStream = Stream.periodic(const Duration(seconds: 1), (detik) {
      return 3600 - detik - 1;
    }).take(3600);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: countdownStream,

      builder: (context, snapshot) {
        final int sisa = snapshot.data ?? 3600;

        final int jam = sisa ~/ 3600;

        final int menit = (sisa % 3600) ~/ 60;

        final int detik = sisa % 60;

        final String waktu =
            '${jam.toString().padLeft(2, '0')}:'
            '${menit.toString().padLeft(2, '0')}:'
            '${detik.toString().padLeft(2, '0')}';

        return Row(
          children: [
            const Icon(Icons.timer_outlined, size: 18, color: Colors.orange),

            const SizedBox(width: 6),

            Text(
              'Waktu tersisa: $waktu',

              style: const TextStyle(
                fontSize: 12,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
