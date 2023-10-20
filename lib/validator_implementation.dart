import 'dart:async';
import 'package:connection_validated/connection_singleton.dart';
import 'package:flutter/material.dart';

class ValidatorConnection extends StatefulWidget {
  @override
  ValidatorConnectionState createState() => ValidatorConnectionState();
}

class ValidatorConnectionState extends State<ValidatorConnection> {
  late StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  @override
  initState() {
    super.initState();

    ConnectionSingleton connectionStatus = ConnectionSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = hasConnection;
    });
  }

  @override
  Widget build(BuildContext ctxt) {
    return isOffline
        ? Text(
            "connected",
            style: TextStyle(color: Colors.green[700], fontSize: 20),
          )
        : Text(
            "Not Connected",
            style: TextStyle(color: Colors.red[700], fontSize: 20),
          );
  }
}
