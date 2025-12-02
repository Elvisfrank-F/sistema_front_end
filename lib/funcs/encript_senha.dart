import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncriptSenha {
//import 'dart:io';

// void main() {
//
//   String? entrada = stdin.readLineSync();
//
//   stdout.write(sha256Hash(entrada!));
//
// }

//função que criptografa a senha

  static String sha256Hash(String a) {
    final bytes = utf8.encode(a); //transformar o texto em bytes
    final hash = sha256.convert(bytes); //encriptografar com o sha256
    return hash.toString();
  }
}