
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/caesar_cipher.dart';

class CipherScreen extends StatefulWidget {
  const CipherScreen({super.key});

  @override
  State<CipherScreen> createState() => _CipherScreenState();
}

class _CipherScreenState extends State<CipherScreen> {
  final TextEditingController _inputController =
      TextEditingController();

  final TextEditingController _outputController =
      TextEditingController();

  final TextEditingController _keyController =
      TextEditingController(text: '3');

  String? _errorMessage;
  String? _statusMessage;

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  // Handles encryption and decryption.
  void _processMessage({required bool encrypt}) {
  final message = _inputController.text;
  final key = int.tryParse(_keyController.text);

  if (message.trim().isEmpty) {
    setState(() {
      _errorMessage = 'Please enter a message in the Input Text box.';
      _statusMessage = null;
      _outputController.clear();
    });
    return;
  }

  if (key == null || key < 1 || key > 25) {
    setState(() {
      _errorMessage = 'Enter a valid shift key from 1 to 25.';
      _statusMessage = null;
      _outputController.clear();
    });
    return;
  }

  try {
    final result = encrypt
        ? CaesarCipher.encrypt(message, key)
        : CaesarCipher.decrypt(message, key);

    setState(() {
      _outputController.text = result;
      _errorMessage = null;
      _statusMessage = encrypt
          ? 'Message encrypted successfully.'
          : 'Message decrypted successfully.';
    });
  } on FormatException catch (error) {
    setState(() {
      _errorMessage = error.message;
      _statusMessage = null;
      _outputController.clear();
    });
  }
}

  // Clears both text areas.
  void _clearFields() {
    setState(() {
      _inputController.clear();
      _outputController.clear();
      _errorMessage = null;
      _statusMessage = null;
    });
  }

  Widget _buildTextPanel({
    required String title,
    required String subtitle,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF141C30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF29344B),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xFF252E4B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFA5B4FC),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8995AC),
                      ),
                    ),
                  ],
                ),
              ),
              if (readOnly)
                const Icon(
                  Icons.lock_outline,
                  size: 17,
                  color: Color(0xFF8995AC),
                ),
            ],
          ),
          const SizedBox(height: 22),
          TextField(
            controller: controller,
            readOnly: readOnly,
            minLines: 8,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              color: Color(0xFFE2E8F0),
              fontSize: 15,
              height: 1.7,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF64748B),
              ),
              filled: true,
              fillColor: const Color(0xFF0E1628),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF27334A),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF818CF8),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyField() {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF141C30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF29344B),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SHIFT KEY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Color(0xFF9AA7BD),
            ),
          ),
          const SizedBox(height: 9),
          TextField(
            controller: _keyController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              hintText: '1–25',
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enter a number from 1 to 25',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF8995AC),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    if (_errorMessage == null && _statusMessage == null) {
      return const SizedBox.shrink();
    }

    final hasError = _errorMessage != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: hasError
            ? const Color(0xFF3A1E2A)
            : const Color(0xFF16352F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError
              ? const Color(0xFF854052)
              : const Color(0xFF286B57),
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasError ? Icons.error_outline : Icons.check_circle_outline,
            color: hasError
                ? const Color(0xFFFCA5A5)
                : const Color(0xFF86EFAC),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage ?? _statusMessage!,
              style: TextStyle(
                color: hasError
                    ? const Color(0xFFFCA5A5)
                    : const Color(0xFF86EFAC),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 28,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Application header.
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252E4B),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFFA5B4FC),
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CipherLab',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'CLASSIC CRYPTOGRAPHY TOOL',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: Color(0xFF8995AC),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF17283A),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFF315047),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Color(0xFF4ADE80),
                              size: 8,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'EDUCATIONAL TOOL',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1,
                                color: Color(0xFF86EFAC),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 42),

                  // Main heading.
                  const Text(
                    'Transform your message.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Explore encryption and decryption through the Caesar Cipher.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9AA7BD),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Key and action controls.
                  Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _buildKeyField(),

                      FilledButton.icon(
                        onPressed: () =>
                            _processMessage(encrypt: true),
                        icon: const Icon(Icons.lock_outline),
                        label: const Text('Encrypt'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      OutlinedButton.icon(
                        onPressed: () =>
                            _processMessage(encrypt: false),
                        icon: const Icon(Icons.lock_open_outlined),
                        label: const Text('Decrypt'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFC7D2FE),
                          side: const BorderSide(
                            color: Color(0xFF59658A),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      TextButton.icon(
                        onPressed: _clearFields,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF9AA7BD),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  _buildFeedback(),

                  const SizedBox(height: 20),

                  // Responsive input and output panels.
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final inputPanel = _buildTextPanel(
                        title: 'Input Text',
                        subtitle: 'Enter the message you want to transform',
                        icon: Icons.edit_note,
                        controller: _inputController,
                        hint: 'Type your message here...',
                      );

                      final outputPanel = _buildTextPanel(
                        title: 'Output Text',
                        subtitle: 'Your transformed message appears here',
                        icon: Icons.output,
                        controller: _outputController,
                        hint: 'Your result will appear here...',
                        readOnly: true,
                      );

                      if (constraints.maxWidth >= 720) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: inputPanel),
                            const SizedBox(width: 18),
                            Expanded(child: outputPanel),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          inputPanel,
                          const SizedBox(height: 18),
                          outputPanel,
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 35),

                  // Footer.
                  const Divider(
                    color: Color(0xFF29344B),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'CIPHERLAB  •  CAESAR CIPHER  •  EDUCATIONAL DEMONSTRATION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
