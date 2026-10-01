import 'package:flutter/material.dart';
import '/data.dart';        // Data username dan password
import 'main_page.dart';   // Halaman utama setelah login

// Halaman Login
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Controller untuk mengambil input username dan password
  final _userC = TextEditingController();
  final _passC = TextEditingController();

  // Menampilkan pesan menggunakan SnackBar
  void _pesan(String teks) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(teks)),
      );
  }

  // Proses login
  void _login() {

    // Mengambil input dari TextField
    final username = _userC.text.trim();
    final password = _passC.text;

    // Validasi jika input kosong
    if (username.isEmpty || password.isEmpty) {
      _pesan('Username dan password tidak boleh kosong');
      return;
    }

    // Mengecek username dan password
    if (username != account.username ||
        password != account.password) {
      _pesan('Username atau password salah');
      return;
    }

    // Jika login berhasil → pindah ke MainPage
    // pushReplacement membuat halaman Login tidak bisa
    // kembali dengan tombol Back
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainPage(username: username),
      ),
    );
  }

  // Membersihkan controller ketika halaman dihancurkan
  @override
  void dispose() {
    _userC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [

              // Logo Gacoan dari URL
              Image.network(
                'https://play-lh.googleusercontent.com/bB_cyOTbQfFmV4IaeqTIFJVc1Wm4UdQwQai8GjthG4uaXrTHNZTKsMtg9_9058GeZGLgoJzIasYYdFkSvdyQ',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 8),

              // Teks sambutan
              const Text(
                'Selamat Datang di Uniqlo',
              ),

              const SizedBox(height: 24),

              // Input username
              TextField(
                controller: _userC,
                decoration: InputDecoration(
                  hintText: 'username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Input password
              TextField(
                controller: _passC,

                // Menyembunyikan password
                obscureText: true,

                decoration: InputDecoration(
                  hintText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tombol login
              FilledButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}