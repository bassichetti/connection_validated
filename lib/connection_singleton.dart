import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity/connectivity.dart';

class ConnectionSingleton {
  //Criando o singleton para chamada interna
  static final ConnectionSingleton _singleton = ConnectionSingleton._internal();
  ConnectionSingleton._internal() {
    initialize();
  }

  //usando o retorno so singleton
  static ConnectionSingleton getInstance() => _singleton;

  //Status da conecção
  bool hasConnection = false;

  //Faz a alteração de controller da conecção
  StreamController connectionChangeController = StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Stream de conecção e verificaçãdõ
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  factory ConnectionSingleton() {
    return _singleton;
  }

  Stream get connectionChange => connectionChangeController.stream;

  //Limpa a memoria StreamController
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //Testa se a uma conecção
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //O status da conexão e alterado e envia uma atualização para todos os listener
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
