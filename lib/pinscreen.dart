import 'package:flutter/material.dart';
import 'package:h_k_app/cipherpage.dart';
import 'package:url_launcher/url_launcher.dart';

// New PinScreen class
class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final TextEditingController _pinController = TextEditingController();
  static const String _correctPin = 'f@rouk';

  void _checkPin() {
    if (_pinController.text == _correctPin) {
      // PIN is correct, navigate to the main app
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CipherPage()));
    } else {
      launchUrl(Uri.parse('https://www.google.com/search?q=nature+pictures&tbm=isch'), mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5)], // Light gray gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Enter PIN',
                  style: TextStyle(fontFamily: 'Pacifico', fontSize: 28, color: Color(0xFFC2185B), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '****', hintStyle: TextStyle(letterSpacing: 10)),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _checkPin,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    backgroundColor: const Color(0xFFC2185B),
                    foregroundColor: Colors.white,
                    elevation: 5,
                  ),
                  child: const Text('Unlock', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// In your main function, change the home to the new PinScreen
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secret Love Cipher',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: const Color(0xFFC2185B),
        fontFamily: 'Pacifico',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Color(0xFFC2185B), centerTitle: true),
      ),
      home: const PinScreen(), // Set PinScreen as the initial screen
    );
  }
}
