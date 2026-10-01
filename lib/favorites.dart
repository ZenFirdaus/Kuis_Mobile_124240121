import 'package:flutter/material.dart';

// Menyimpan ID menu yang menjadi favorit
// ValueNotifier digunakan agar perubahan favorit
// bisa langsung diketahui oleh widget yang menggunakannya
final ValueNotifier<Set<int>> favorites = ValueNotifier({});

// Fungsi untuk menambah / menghapus menu dari favorit
void toggleFavorite(int id) {

  // Membuat salinan data favorit
  final s = {...favorites.value};

  // Jika ID sudah ada → hapus
  // Jika belum ada → tambahkan
  s.contains(id)
      ? s.remove(id)
      : s.add(id);

  // Mengirim data baru agar widget diperbarui
  favorites.value = s;
}


// Tombol favorit yang digunakan di Home dan Detail
class FavButton extends StatelessWidget {

  // ID menu yang akan dijadikan favorit
  final int id;

  const FavButton({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {

    // Memantau perubahan data favorit
    return ValueListenableBuilder<Set<int>>(
      valueListenable: favorites,

      builder: (_, fav, __) {

        // Mengecek apakah menu sedang menjadi favorit
        final liked = fav.contains(id);

        return IconButton(

          // Ketika tombol diklik, ubah status favorit
          onPressed: () => toggleFavorite(id),

          icon: AnimatedSwitcher(

            // Durasi animasi
            duration: const Duration(milliseconds: 250),

            // Animasi membesar/mengecil
            transitionBuilder: (child, anim) =>
                ScaleTransition(
                  scale: anim,
                  child: child,
                ),

            // Icon berubah berdasarkan status favorit
            child: Icon(
              liked
                  ? Icons.favorite
                  : Icons.favorite_border,

              // Memberikan key berbeda agar animasi bekerja
              key: ValueKey(liked),

              // Jika favorit → warna merah
              color: liked ? Colors.red : null,
            ),
          ),
        );
      },
    );
  }
}