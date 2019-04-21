import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {

  bool mapToggle = false;
  GoogleMapController mapController;
  Completer<GoogleMapController> _controller = Completer();
  // Geolocator geolocator = new Geolocator();
  // Geolocator _geolocator = new Geolocator()..forceAndroidLocationManager = true;
  Geolocator _geolocator = new Geolocator();

  
  Future<GeolocationStatus>_getPermission() async {
    final GeolocationStatus result = await _geolocator.checkGeolocationPermissionStatus();
    return result;
  }

  Future<Position>_getLocation() {
    return _getPermission().then((result) async{
      Position coords = await _geolocator.getCurrentPosition(
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

  // @override
  // Future<Position> _myStream() async{
  //   var position = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  //   return position;
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = new TextEditingController();

    TextField textfield = new TextField(
      controller: textEditingController,
      decoration: InputDecoration(hintText: "Type in the text for the marker"),
    );

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

                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                  
                      initialCameraPosition: CameraPosition(
                        target: new LatLng(snapshot.data.latitude, snapshot.data.longitude),
                        zoom: 10.0
                      ),
                      
                      compassEnabled: true,
                      myLocationEnabled: true,

                      // markers: 

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
                  ),
                  RaisedButton(
                    child: const Text('Add a Marker'),
                    onPressed: () {
                      // mapController.addMarker(MarkerOptions {
                        
                      // });
                      // new Marker(position: new LatLng(40.71, -74.00), markerId: MarkerId("1"),);
                    },
                  )
                ],
              )
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: mapController == null ? null : () {
              // mapController.addMarker(
              //   MarkerOptions (

              //   )
              // );
            },
            label: Text('my current position!'),
            icon: Icon(Icons.location_on),
          ),
          
        );
    }
}