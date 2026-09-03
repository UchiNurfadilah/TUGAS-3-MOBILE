import 'dart:async';

// Custom Exception
class StokHabisException implements Exception {
  final String m;
  StokHabisException(this.m);
  @override
  String toString() => 'StokHabisException: $m';
}

class ProdukTidakAdaException implements Exception {
  final String m;
  ProdukTidakAdaException(this.m);
  @override
  String toString() => 'ProdukTidakAdaException: $m';
}

// Mixin
mixin BisaDiskon {
  void validasiDiskon(double p) =>
      (p < 0 || p > 100) ? throw ArgumentError('Diskon tidak valid') : null;
  double hitungHargaDiskon(double h, double p) {
    validasiDiskon(p);
    return h * (1 - p / 100);
  }
}

// Abstract Class & Subclasses
abstract class Produk {
  String id, nama;
  double harga;
  int stok;
  Produk(this.id, this.nama, this.harga, this.stok);
  void deskripsi();
}

class ProdukDigital extends Produk with BisaDiskon {
  double ukuranMB;
  String formatFile;
  ProdukDigital(
    super.id,
    super.nama,
    super.harga,
    super.stok,
    this.ukuranMB,
    this.formatFile,
  );
  @override
  void deskripsi() => print(
    '[Digital] $nama ($formatFile, ${ukuranMB}MB) - Rp$harga | Stok: $stok',
  );
}

class ProdukFisik extends Produk with BisaDiskon {
  double beratGram;
  String dimensi;
  ProdukFisik(
    super.id,
    super.nama,
    super.harga,
    super.stok,
    this.beratGram,
    this.dimensi,
  );
  @override
  void deskripsi() =>
      print('[Fisik] $nama ($dimensi, ${beratGram}g) - Rp$harga | Stok: $stok');
}

// Keranjang Class
class Keranjang {
  final List<Produk> items = [];
  void tambah(Produk p) {
    if (p.stok <= 0) throw StokHabisException('Stok ${p.nama} habis!');
    items.add(p);
    p.stok--;
    print('+ ${p.nama} masuk keranjang.');
  }

  void hapus(Produk p) {
    if (!items.contains(p))
      throw ProdukTidakAdaException('${p.nama} tidak di keranjang!');
    items.remove(p);
    p.stok++;
  }

  double totalHarga() => items.fold(0, (sum, p) => sum + p.harga);
}

// TokoService Class
class TokoService {
  final List<Produk> katalog = [];

  Future<Produk> cariProduk(String nama) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulasi async
    return katalog.firstWhere(
      (p) => p.nama.toLowerCase() == nama.toLowerCase(),
      orElse: () =>
          throw ProdukTidakAdaException('Produk "$nama" tidak ditemukan!'),
    );
  }

  Future<void> prosesCheckout(Keranjang k) async {
    print('\n[Async] Memproses Checkout...');
    await Future.delayed(Duration(seconds: 1));
    if (k.items.isEmpty) throw Exception('Keranjang kosong!');

    print('--- RINGKASAN BELANJA ---');
    k.items.forEach((p) => print('- ${p.nama}: Rp${p.harga}'));
    print('TOTAL CHECKOUT: Rp${k.totalHarga()}');
    k.items.clear();
  }
}

// Main Execution & Testing
void main() async {
  var toko = TokoService();
  var keranjang = Keranjang();

  var p1 = ProdukDigital('D01', 'E-Book Flutter', 50000, 2, 10, 'PDF');
  var p2 = ProdukFisik(
    'F01',
    'Mouse Wireless',
    150000,
    0,
    150,
    '10x5 cm',
  ); // Stok 0
  toko.katalog.addAll([p1, p2]);

  print('=== KATALOG TOKO ===');
  p1.deskripsi();
  p2.deskripsi();

  // Test Mixin
  print('\nDiskon 10% ${p1.nama}: Rp${p1.hitungHargaDiskon(p1.harga, 10)}');

  // Test Flow & Error Handling
  try {
    // 1. Tambah produk sukses
    var item1 = await toko.cariProduk('E-Book Flutter');
    keranjang.tambah(item1);

    // 2. Error: Stok Habis
    print('\n[Test] Menambah barang stok habis:');
    var item2 = await toko.cariProduk('Mouse Wireless');
    keranjang.tambah(item2);
  } on StokHabisException catch (e) {
    print(' Catch Exception: $e');
  } on ProdukTidakAdaException catch (e) {
    print(' Catch Exception: $e');
  }

  try {
    // 3. Error: Produk Tidak Ada
    print('\n[Test] Cari barang ngawur:');
    await toko.cariProduk('Kamera');
  } on ProdukTidakAdaException catch (e) {
    print(' Catch Exception: $e');
  }

  // 4. Proses Checkout Async
  await toko.prosesCheckout(keranjang);
}
