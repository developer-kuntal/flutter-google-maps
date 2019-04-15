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

  var currentLocation = {
    "latitude": 22.5726,
    "longitude": 88.3639
  };
  StreamController<Position> streamController;
  List<Position> list = [];

  var clients = [];
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  
  Geolocator geolocator = new Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  // @override
  void initState() {
    super.initState();
    setState(() {
        mapToggle = true; 
    });
  }

  @override
  Future<Position> _myStream() async{
    var position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
          future: _myStream(),
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('Press button to start.');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Text('Awaiting result...');
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                if (snapshot.hasData) {
                  // return Text('Result: ${snapshot.data.latitude}, ${snapshot.data.longitude}');
                  return GoogleMap(
                      mapType: MapType.hybrid,
                      onMapCreated:  (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: new LatLng(snapshot.data.latitude,snapshot.data.longitude),
                        zoom: 10.0
                      ),
                  );
                }
            }
        },);

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
                    // Wrap with stream builder could be sloved your problem...
                    child: mapToggle ? futureBuilder : Center(child: 
                        Text('Loading...Please wait', style: TextStyle(
                          fontSize: 20.0
                        ),
                      ),
                    )
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