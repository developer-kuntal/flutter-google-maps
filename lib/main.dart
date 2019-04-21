import 'package:flutter/material.dart';
// import 'package:flutter_google_maps/screen/login.dart';
// import 'package:google_api_availability/google_api_availability.dart';
import 'package:flutter_google_maps/screen/google_map.dart';
// var myKey = "AIzaSyD5LPQDM1bpAs6hxHa4CH1R7w3rzQ6FTKE";

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new GoogleMaps(),
  ));
}