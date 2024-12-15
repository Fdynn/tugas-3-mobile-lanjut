// ignore_for_file: file_names

import 'dart:math';

String generateId() {
    final random = Random();
    final randomString = StringBuffer();
    for (int i = 0; i < 5; i++) {
      final randomIndex = random.nextInt(62);
      if (randomIndex < 10) {
        randomString.write(randomIndex);
      } else if (randomIndex < 36) {
        randomString.write(String.fromCharCode(randomIndex + 55));
      } else {
        randomString.write(String.fromCharCode(randomIndex + 61));
      }
    }

    return randomString.toString();
  }