import 'dart:async';

import 'package:flutter/services.dart';

class KeyEnclave {
  static const MethodChannel _channel = const MethodChannel('key_enclave');

  /// Generate Keypair (EC 256 bit)
  /// In ios store private key in Secure Enclave
  /// In Android in KeyStore
  /// return public key x509 format
  Future<String> generateKeyPair(String tag) async {
   String pubicKey =
        await _channel.invokeMethod('generateKeyPair', {"TAG": tag});
    if(!pubicKey.startsWith("MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE")) {
      pubicKey = pubicKey.replaceRange(0,36,"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE");
    }
    String publicKeyStr = "-----BEGIN PUBLIC KEY-----\r\n" +
        pubicKey.replaceAll("\n", "") +
        "\r\n-----END PUBLIC KEY-----";
    return publicKeyStr;
  }

  Future<bool> deletePrivateKeyIfExist(String tag) async {
      return await _channel.invokeMethod('deleteKey', {"TAG": tag});
  }

  Future<String> signMessage(String tag, String message) async {
    final String signed = await _channel.invokeMethod("sign", {
      "TAG": tag,
      "MESSAGE": message,
    });

    return signed;
  }
}
