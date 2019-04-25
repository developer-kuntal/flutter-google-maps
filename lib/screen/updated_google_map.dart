import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {

  List<Marker> allMarkers = [];
  GoogleMapController _controller;
  // Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(22.5726, 88.3639),
        ),
    );
    allMarkers.add(
        Marker(
          markerId: MarkerId('myCurrentLocation'),
          draggable: true,
          onTap: () {
            print('Marker Tapped');
          },
          position: LatLng(23.8988867, 87.8078373),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: Stack(
        children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: LatLng(23.8988867, 87.8078373), zoom: 12.0),
            markers: Set.from(allMarkers),
            onMapCreated: mapCreated,
            compassEnabled: true,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: movetoKolkata,
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.green
              ),
              child: Icon(Icons.forward, color: Colors.white),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: movetoMyhome,
            child: Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.red
              ),
              child: Icon(Icons.backspace, color: Colors.white),
            ),
          ),
        )
        ]
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoKolkata() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(22.5726, 88.3639), zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  movetoMyhome() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(23.8988867, 87.8078373), zoom: 12.0),
    ));
  }
}
