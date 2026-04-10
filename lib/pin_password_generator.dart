import 'dart:math';

import 'package:ironkey/passaword_generator.dart';
class PinPasswordGenerator implements PasswordGenerator{
  @override
  String generate(int length) {
    
     const numbers = "0123456789";
      final random = Random();

      return List.generate(
        length, 
        (_) => numbers[random.nextInt(numbers.length)],
        ).join();
  }
      
}