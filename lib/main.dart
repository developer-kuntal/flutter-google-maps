import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var myKey = "AIzaSyD5LPQDM1bpAs6hxHa4CH1R7w3rzQ6FTKE";

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
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  
  Geolocator geolocator = new Geolocator();
  // Geolocator _geolocator = new Geolocator()..forceAndroidLocationManager = true;
  Geolocator _geolocator = new Geolocator();

  Future<GeolocationStatus>_getPermission() async {
    final GeolocationStatus result = await _geolocator.checkGeolocationPermissionStatus();
    return result;
  }

  Future<Position>_getLocation() {
    return _getPermission().then((result) async{
      Position coords = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best
      );
      return coords;
    });
  }

  Future<Position>_buildMap() async{
    return _getLocation().then((response) {
      return response;
    });
  }

  // @override
  void initState() {
    super.initState();
    setState(() {
        mapToggle = true; 
    });
  }

  @override
  Future<Position> _myStream() async{
    var position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
          future: _buildMap(),//_myStream(),
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
                      // onCameraMove: ,
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

          
        );
  }

}