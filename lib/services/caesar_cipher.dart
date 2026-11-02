
class CaesarCipher {
  static void validate(String text, int key) {
    if (text.trim().isEmpty) {
      throw const FormatException('Please enter a message.');
    }

    if (key < 1 || key > 25) {
      throw const FormatException(
        'Enter a whole-number key from 1 to 25.',
      );
    }
  }

  // Encrypts English letters while preserving other characters.
  static String encrypt(String text, int key) {
    validate(text, key);

    final result = StringBuffer();

    for (final code in text.runes) {
      if (code >= 65 && code <= 90) {
        // Uppercase A-Z
        result.writeCharCode(65 + (code - 65 + key) % 26);
      } else if (code >= 97 && code <= 122) {
        // Lowercase a-z
        result.writeCharCode(97 + (code - 97 + key) % 26);
      } else {
        // Preserve spaces, numbers, punctuation, and other characters.
        result.writeCharCode(code);
      }
    }

    return result.toString();
  }

  // Decrypts by reversing the encryption shift.
  static String decrypt(String text, int key) {
    validate(text, key);

    final result = StringBuffer();

    for (final code in text.runes) {
      if (code >= 65 && code <= 90) {
        // Reverse uppercase A-Z
        result.writeCharCode(65 + (code - 65 - key + 26) % 26);
      } else if (code >= 97 && code <= 122) {
        // Reverse lowercase a-z
        result.writeCharCode(97 + (code - 97 - key + 26) % 26);
      } else {
        result.writeCharCode(code);
      }
    }

    return result.toString();
  }
}



