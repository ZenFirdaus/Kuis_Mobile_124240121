import 'package:flutter/material.dart';
import 'home_page.dart';       // Halaman Home
import 'profile_page.dart';   // Halaman Profile

// Halaman utama setelah login
class MainPage extends StatefulWidget {

  // Menyimpan username dari halaman Login
  final String username;

  const MainPage({
    super.key,
    required this.username,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  // Menentukan halaman yang sedang aktif
  // 0 = Home, 1 = Profile
  int _index = 0;

  @override
  Widget build(BuildContext context) {

    // Daftar halaman yang bisa dipilih
    final pages = [
      const HomePage(),

      // Username dikirim ke ProfilePage
      ProfilePage(username: widget.username),
    ];

    return Scaffold(

      // AppBar menyesuaikan halaman yang aktif
      appBar: AppBar(
        title: Text(
          _index == 0 ? 'Home' : 'Profile',
        ),
      ),

      // Menampilkan halaman sesuai index
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),

        // Key digunakan agar Flutter mengenali
        // bahwa halaman telah berubah
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: pages[_index],
        ),
      ),

      // Navigasi di bagian bawah
      bottomNavigationBar: NavigationBar(

        // Menentukan tab yang sedang aktif
        selectedIndex: _index,

        // Dipanggil ketika user memilih tab
        onDestinationSelected: (i) =>
            setState(() => _index = i),

        // Daftar menu navigasi
        destinations: const [

          // Tab Home
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          // Tab Profile
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}