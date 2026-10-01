import 'package:flutter/material.dart';
import '../data.dart';          // Data menu
import '../favorites.dart';    // Data menu favorit
import 'login_page.dart';      // Halaman login

// Halaman Profile
class ProfilePage extends StatelessWidget {

  // Username yang diterima dari MainPage
  final String username;

  const ProfilePage({
    super.key,
    required this.username,
  });

  // Fungsi untuk logout
  void _logout(BuildContext context) {

    // Kembali ke Login dan menghapus semua halaman sebelumnya
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),

      // false = semua route sebelumnya dihapus
      (route) => false,
    );
  }

  // Widget untuk menampilkan statistik
  Widget _stat(
    String label,
    String nilai,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),

          child: Column(
            children: [

              // Icon statistik
              Icon(icon),

              const SizedBox(height: 4),

              // Nilai statistik
              Text(
                nilai,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Nama statistik
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // Menghitung jumlah kategori unik
    final jumlahKategori =
        catalog.map((m) => m.type).toSet().length;

    return ListView(
      padding: const EdgeInsets.all(16),

      children: [

        const SizedBox(height: 8),

        // Foto/profile icon
        const Center(
          child: CircleAvatar(
            radius: 40,
            child: Icon(
              Icons.person,
              size: 40,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Label username
        const Center(
          child: Text(
            'Username',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),

        // Menampilkan username yang sedang login
        Center(
          child: Text(
            username,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Memantau perubahan data favorit
        ValueListenableBuilder<Set<int>>(
          valueListenable: favorites,

          builder: (_, fav, __) {

            // Mengambil menu yang masuk daftar favorit
            final daftar = catalog
                .where((m) => fav.contains(m.id))
                .toList();

            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // =========================
                // STATISTIK
                // =========================
                Row(
                  children: [

                    // Jumlah seluruh menu
                    _stat(
                      'Total Produk',
                      '${catalog.length}',
                      Icons.restaurant_menu,
                    ),

                    // Jumlah menu favorit
                    _stat(
                      'Favorit',
                      '${fav.length}',
                      Icons.favorite,
                    ),

                    // Jumlah kategori
                    _stat(
                      'Kategori',
                      '$jumlahKategori',
                      Icons.category,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Judul daftar favorit
                const Text(
                  'Produk Favorit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                // Jika belum ada favorit
                if (daftar.isEmpty)
                  const Text(
                    'Belum ada produk favorit',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )

                // Jika ada favorit
                else
                  for (final m in daftar)
                    ListTile(

                      // Menghilangkan padding bawaan
                      contentPadding: EdgeInsets.zero,

                      // Gambar menu
                      leading: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(8),

                        child: Image.network(
                          m.imageUrl,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,

                          // Jika gambar gagal dimuat
                          errorBuilder: (_, __, ___) =>
                              const Icon(
                                Icons.broken_image,
                                size: 40,
                              ),
                        ),
                      ),

                      // Nama menu
                      title: Text(m.productName),

                      // Harga menu
                      subtitle: Text(m.price),
                    ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // Tombol Logout
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
      ],
    );
  }
}