import 'package:flutter/material.dart';
import '../data.dart';          // Data/model Menu
import '../favorites.dart';    // Sistem favorit
import 'detail_page.dart';     // Halaman detail menu

// Halaman utama untuk menampilkan daftar menu
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Menyimpan kondisi pencarian, kategori, sorting, dan favorit
  String _cari = '';
  String _kategori = 'Semua';
  String _urut = 'Default';
  bool _favOnly = false;

  // Membuat daftar kategori dari data menu
  final _kategoriList = [
    'Semua',
    ...catalog.map((m) => m.type).toSet()
  ];

  // Pilihan pengurutan menu
  final _urutList = [
    'Default',
    'Termurah',
    'Termahal',
    'Nama A-Z'
  ];

  // Mengubah harga "Rp.12000" menjadi angka 12000
  int _harga(Product m) =>
      int.parse(m.price.replaceAll(RegExp(r'[^0-9]'), ''));

  // Filter dan sorting data Product
  List<Product> _filter(Set<int> fav) {

    final hasil = catalog
        .where((m) =>
            // Filter berdasarkan pencarian
            m.productName.toLowerCase().contains(_cari.toLowerCase()) &&

            // Filter berdasarkan kategori
            (_kategori == 'Semua' || m.type == _kategori) &&

            // Filter hanya menu favorit jika diaktifkan
            (!_favOnly || fav.contains(m.id)))
        .toList();

    // Mengurutkan hasil
    hasil.sort((a, b) {
      final c = switch (_urut) {
        'Termurah' => _harga(a).compareTo(_harga(b)),
        'Termahal' => _harga(b).compareTo(_harga(a)),
        'Nama A-Z' => a.productName.compareTo(b.productName),
        _ => 0,
      };

      return c != 0 ? c : a.id.compareTo(b.id);
    });

    return hasil;
  }

  // Membuka halaman detail menu
  void _bukaDetail(Product m) {
    Navigator.push(
      context,
      PageRouteBuilder(

        // Durasi animasi 350 milidetik
        transitionDuration: const Duration(milliseconds: 350),

        // Halaman yang dituju
        pageBuilder: (_, __, ___) => DetailPage(catalog: m),

        // Animasi fade saat berpindah halaman
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(
              opacity: anim,
              child: child,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // =========================
        // SEARCH + SORTING
        // =========================
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 4, 8),
          child: Row(
            children: [

              // Kolom pencarian
              Expanded(
                child: TextField(
                  // Setiap teks berubah, update _cari
                  onChanged: (v) => setState(() => _cari = v),

                  decoration: InputDecoration(
                    hintText: 'Cari menu...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              // Tombol sorting
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
                tooltip: 'Urutkan',

                // Menampilkan sorting yang sedang dipilih
                initialValue: _urut,

                // Mengubah sorting
                onSelected: (v) =>
                    setState(() => _urut = v),

                // Menampilkan pilihan sorting
                itemBuilder: (_) => _urutList
                    .map(
                      (e) => PopupMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),

        // =========================
        // FILTER FAVORIT + KATEGORI
        // =========================
        SizedBox(
          height: 44,

          // Kategori bisa digeser ke samping
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),

            children: [

              // Filter khusus menu favorit
              FilterChip(
                avatar: const Icon(
                  Icons.favorite,
                  size: 16,
                  color: Colors.red,
                ),
                label: const Text('Favorit'),

                // Apakah filter favorit aktif?
                selected: _favOnly,

                // Mengaktifkan/nonaktifkan filter
                onSelected: (v) =>
                    setState(() => _favOnly = v),
              ),

              // Membuat ChoiceChip untuk setiap kategori
              for (final k in _kategoriList)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(k),

                    // Menandai kategori yang sedang dipilih
                    selected: _kategori == k,

                    // Mengubah kategori
                    onSelected: (_) =>
                        setState(() => _kategori = k),
                  ),
                ),
            ],
          ),
        ),

        // =========================
        // DAFTAR MENU
        // =========================
        Expanded(
          child: ValueListenableBuilder<Set<int>>(

            // Mendengarkan perubahan data favorit
            valueListenable: favorites,

            builder: (_, fav, __) {

              // Ambil menu yang sudah difilter
              final hasil = _filter(fav);

              // Jika tidak ada menu
              if (hasil.isEmpty) {
                return const Center(
                  child: Text('Menu tidak ditemukan'),
                );
              }

              // Menampilkan daftar menu
              return ListView.builder(
                itemCount: hasil.length,

                itemBuilder: (context, i) {
                  final m = hasil[i];

                  // Animasi menu ketika muncul
                  return TweenAnimationBuilder<double>(
                    key: ValueKey(m.id),
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 300),

                    builder: (_, v, child) => Opacity(
                      opacity: v,

                      child: Transform.translate(
                        offset: Offset(
                          0,
                          20 * (1 - v),
                        ),
                        child: child,
                      ),
                    ),

                    child: ListTile(

                      // Gambar menu
                      leading: Hero(
                        tag: 'menu-${m.id}',

                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8),

                          child: Image.network(
                            m.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,

                            // Jika gambar gagal
                            errorBuilder: (_, __, ___) =>
                                const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                ),
                          ),
                        ),
                      ),

                      // Nama menu
                      title: Text(m.productName),

                      // Tipe + harga
                      subtitle: Text(
                        '${m.type} • ${m.price}',
                      ),
                      
                      // Tombol favorit + tanda masuk detail
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FavButton(id: m.id),
                          const Icon(Icons.chevron_right),
                        ],
                      ),

                      // Klik menu → buka detail
                      onTap: () => _bukaDetail(m),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}