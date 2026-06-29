import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CipherPage extends StatefulWidget {
  const CipherPage({super.key});

  @override
  State<CipherPage> createState() => _CipherPageState();
}

class _CipherPageState extends State<CipherPage> {
  final int _shiftKey = 3;
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  final String _arabicAlphabet = 'أبتثجحخدذرزسشصضطظعغفقكلمنهوي';
  final int _arabicAlphabetLength = 28;

  String _encrypt(String text) {
    final buffer = StringBuffer();
    for (final char in text.split('')) {
      final codeUnit = char.codeUnitAt(0);

      if (codeUnit >= 65 && codeUnit <= 90) {
        // Uppercase English letters
        buffer.writeCharCode((codeUnit - 65 + _shiftKey) % 26 + 65);
      } else if (codeUnit >= 97 && codeUnit <= 122) {
        // Lowercase English letters
        buffer.writeCharCode((codeUnit - 97 + _shiftKey) % 26 + 97);
      } else if (codeUnit >= 48 && codeUnit <= 57) {
        // Numbers 0-9
        buffer.writeCharCode((codeUnit - 48 + _shiftKey) % 10 + 48);
      } else if (_arabicAlphabet.contains(char)) {
        // Arabic letters
        final originalIndex = _arabicAlphabet.indexOf(char);
        final newIndex = (originalIndex + _shiftKey) % _arabicAlphabetLength;
        buffer.write(_arabicAlphabet[newIndex]);
      } else {
        buffer.write(char); // Other characters (spaces, symbols)
      }
    }
    return buffer.toString();
  }

  String _decrypt(String text) {
    final buffer = StringBuffer();
    for (final char in text.split('')) {
      final codeUnit = char.codeUnitAt(0);

      if (codeUnit >= 65 && codeUnit <= 90) {
        // Uppercase English letters
        buffer.writeCharCode((codeUnit - 65 - _shiftKey + 26) % 26 + 65);
      } else if (codeUnit >= 97 && codeUnit <= 122) {
        // Lowercase English letters
        buffer.writeCharCode((codeUnit - 97 - _shiftKey + 26) % 26 + 97);
      } else if (codeUnit >= 48 && codeUnit <= 57) {
        // Numbers 0-9
        buffer.writeCharCode((codeUnit - 48 - _shiftKey + 10) % 10 + 48);
      } else if (_arabicAlphabet.contains(char)) {
        // Arabic letters
        final originalIndex = _arabicAlphabet.indexOf(char);
        final newIndex = (originalIndex - _shiftKey + _arabicAlphabetLength) % _arabicAlphabetLength;
        buffer.write(_arabicAlphabet[newIndex]);
      } else {
        buffer.write(char); // Other characters (spaces, symbols)
      }
    }
    return buffer.toString();
  }

  void _copyToClipboard() {
    if (_outputController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _outputController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Secret message copied!', textAlign: TextAlign.center),
          backgroundColor: Colors.pink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
    }
  }

  void _clearFields() {
    _inputController.clear();
    _outputController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Memories cleared.', textAlign: TextAlign.center),
        backgroundColor: Colors.pink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background color
      appBar: AppBar(
        title: const Text(
          "Secret Messages ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pinkAccent),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _clearFields,
            icon: const Icon(Icons.favorite_border, color: Colors.pinkAccent),
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A001A), Color(0xFF000A1A)], // Dark, romantic gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              // Input Text Field
              _buildTextField(
                controller: _inputController,
                hintText: 'Whisper your secret here...',
                maxLines: 10,
                icon: Icons.edit,
                onTap: () {
                  _inputController.selection = TextSelection(baseOffset: 0, extentOffset: _inputController.text.length);
                },
              ),
              const SizedBox(height: 25),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: _buildActionButton(
                      label: 'Encrypt',
                      onPressed: () {
                        final encryptedText = _encrypt(_inputController.text);
                        _outputController.text = encryptedText;
                      },
                      color: Colors.pink[800]!, // Dark pink button color
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildActionButton(
                      label: 'Decrypt',
                      onPressed: () {
                        final decryptedText = _decrypt(_inputController.text);
                        _outputController.text = decryptedText;
                      },
                      color: Colors.pink[800]!.withOpacity(0.8), // Slightly lighter dark pink
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // Output Text Field
              _buildTextField(
                controller: _outputController,
                hintText: 'Your secret awaits...',
                readOnly: true,
                maxLines: 10,
                icon: Icons.lock_outline,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _copyToClipboard,
        label: const Text('Copy Note', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.favorite_sharp, color: Colors.white),
        backgroundColor: Colors.pink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
    bool readOnly = false,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 8,
      color: const Color(0xFF212121), // Dark card background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextField(
          onTap: onTap,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          controller: controller,
          readOnly: readOnly,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 16, color: Colors.white), // White text
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)), // Faded hint text
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Colors.pinkAccent), // Bright pink icons
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required String label, required VoidCallback onPressed, required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
