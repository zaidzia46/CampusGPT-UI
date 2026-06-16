import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

Future<bool> checkInternetConnection() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  bool hasInternet =
      connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi);

  if (!hasInternet) {
    Fluttertoast.showToast(
      msg: "No Internet",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Color(0xFF06B6D4),
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: "#06B6D4",
    );
  }

  return hasInternet;
}
