import 'package:flutter/material.dart';
import '../data.dart';        // Model/data Product
import '../favorites.dart';  // Sistem favorit


// Halaman detail catalog
class DetailPage extends StatefulWidget {

  // Data catalog yang dipilih
  final Product catalog;

  const DetailPage({
    super.key,
    required this.catalog,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}



class _DetailPageState extends State<DetailPage> {

  // Daftar pilihan warna latar
  // Format: (nama, warna)
  final _warna = [
    ('S', Colors.pink.shade100),
    ('M', Colors.teal.shade100),
    ('L', Colors.blue.shade100),
    ('XL', Colors.green.shade100),
  ];

  // Menyimpan index warna yang sedang dipilih
  // 0 = Pink, 1 = Teal
  int _pilih = 0;

  get mainAxisAlignment => null;

  // get _counter => null;

  int _counter = 1;


  @override
  Widget build(BuildContext context) {

    // Mengambil data catalog dari StatefulWidget
    final catalog = widget.catalog;

    return Scaffold(

      // Bagian atas halaman
      appBar: AppBar(
        title: Text(catalog.productName),

        // Tombol favorit
        actions: [
          FavButton(id: catalog.id),
        ],
      ),

      // Isi halaman bisa di-scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // =========================
            // GAMBAR catalog
            // =========================
            AspectRatio(
              aspectRatio: 1,

              // Container dengan animasi perubahan warna
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(

                  // Warna mengikuti pilihan user
                  color: _warna[_pilih].$2,

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Hero(
                  // Tag harus sama dengan Hero di HomePage
                  tag: 'catalog-${catalog.id}',

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    // Menampilkan gambar dari URL
                    child: Image.network(
                      catalog.imageUrl,
                      fit: BoxFit.cover,

                      // Jika gambar gagal dimuat
                      errorBuilder: (_, __, ___) =>
                          const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 60,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),


            // =========================
            // INFORMASI catalog
            // =========================
            const SizedBox(height: 16),

            // Nama catalog
            Text(
              catalog.productName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Kategori
            Text(
              catalog.type,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            // Harga
            Text(
              catalog.price,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 16),
            
            // jumlah stok
            Text(
              'Like: ${catalog.likeCount}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ), 

            const SizedBox(height: 16),

            // jumlah stok
            Text(
              'Stok: ${catalog.stock}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                
              ),
            ),  

            const SizedBox(height: 16),
            
            // Jumlah produk
            const Text( 
              'Jumlah Produk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                // Tombol mengurangi jumlah
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_counter > 1) _counter--;
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),

                // Menampilkan jumlah
                Text(
                  '$_counter',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Tombol menambah jumlah
                IconButton(
                  onPressed: () {
                    setState(() {
                      _counter++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),

            // Judul deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Deskripsi catalog
            Text(catalog.details),

            // =========================
            // PILIHAN WARNA
            // =========================
            const SizedBox(height: 24),

            const Text(
              'Ukuran',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [

                // Membuat kartu untuk setiap warna
                for (int i = 0; i < _warna.length; i++)
                  Expanded(
                    child: GestureDetector(

                      // Ketika warna diklik
                      onTap: () =>
                          setState(() => _pilih = i),

                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 200),

                        height: 70,

                        margin: EdgeInsets.only(
                          left: i == 0 ? 0 : 12,
                        ),

                        decoration: BoxDecoration(

                          // Warna kartu
                          color: _warna[i].$2,

                          borderRadius:
                              BorderRadius.circular(16),

                          // Border muncul pada warna yang dipilih
                          border: Border.all(
                            color: _pilih == i
                                ? Colors.black87
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),

                        // Nama warna
                        child: Center(
                          child: Text(
                            _warna[i].$1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}