// ========================================================================== //

import 'package:flutter/foundation.dart';

/// 📑 Recebe um Map e, se determinada chave existe nesse map e o valor de sua
/// variável não é nulo, chama a função [onData] para manipular esse valor. Caso
/// algum problema ocorra, um catch é usado para evitar que o programa seja
/// interrompido
void dataParse(Map data, String key, void Function() onData) {
  if (data.containsKey(key)) {
    if ((data[key] != null) && (data.runtimeType != Null)) {
      try {
        onData();
      } catch (e, s) {
        if (kDebugMode) {
          print("Falha ao obter variável '$key'");
          print(e);
          print(s);
        }
      }
    }
  }
}

// ------------------------------------------------------------------------ //

/// 📑 Recebe um Map e, se determinada chave existe nesse map e o valor de sua
/// variável não é nulo, chama a função [get] para manipular esse valor. Caso
/// algum problema ocorra, um catch é usado para evitar que o programa seja
/// interrompido
void getValue(
  Map<String, dynamic> data,
  String key,
  void Function(dynamic) get,
) {
  try {
    if (data.containsKey(key)) {
      if ((data[key] != null) && (data[key].runtimeType != Null)) {
        get(data[key]);
      }
    }
  } catch (e) {
    throw "Falha ao obter variável '$key'";
  }
}
// ========================================================================== //