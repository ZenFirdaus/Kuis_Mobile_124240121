import 'package:flutter/material.dart';

// Import halaman Login
import 'pages/login_page.dart';


// Fungsi utama / titik awal aplikasi
void main() => runApp(const MyApp());


// Widget utama aplikasi
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // MaterialApp = konfigurasi utama aplikasi Flutter
    return MaterialApp(

      // Nama aplikasi
      title: 'Gacoan',

      // Menghilangkan tulisan DEBUG di pojok kanan atas
      debugShowCheckedModeBanner: false,

      // Mengatur tema aplikasi
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),

      // Halaman pertama yang dibuka
      home: const LoginPage(),
    );
  }
}