import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new GoogleMaps(),
  ));
}

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {

  bool mapToggle = false;
  var currentLocation;
  var clients = [];
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  // @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
       currentLocation = currloc;
       mapToggle = true; 
       populateClients();
      });
    });
  }

  populateClients() {
    clients = [];
    // Firestore.instance.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Google Maps Demo"),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                
                height: MediaQuery.of(context).size.height - 100.0,
                width: double.infinity,
                child: mapToggle ? GoogleMap(
                        mapType: MapType.hybrid,
                        onMapCreated:  (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation.latitude, currentLocation.logitude),
                          zoom: 10.0
                        ),
                      ) : Center(child: 
                      Text('Loading...Please wait', style: TextStyle(
                        fontSize: 20.0
                      ),),)
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}