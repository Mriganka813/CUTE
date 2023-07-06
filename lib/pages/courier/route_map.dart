import 'dart:async';

import 'package:cute/constant/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class RouteMap extends StatefulWidget {
  final sourceLat,
      sourceLang,
      destinationLat,
      destinationLang,
      driverLat,
      driverLang;
  final IO.Socket? socket;
  RouteMap(
      {Key? key,
      required this.sourceLat,
      required this.sourceLang,
      required this.destinationLat,
      required this.destinationLang,
      this.driverLat,
      this.driverLang,
      this.socket})
      : super(key: key);
  @override
  _RouteMapState createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  double cameraZoom = 13;
  double cameraTilt = 30;
  double cameraBearing = 10;
  LatLng? sourceLocatioon;
  LatLng? destLocatioon;
  LatLng? driverLocatioon;

  Completer<GoogleMapController> _controller = Completer();
  // this set will hold my markers
  Set<Marker> _markers = {};
  // this will hold the generated polylines
  Set<Polyline> _polylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  // this is the key object - the PolylinePoints
  // which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = googleMapKey;
  // for my custom icons
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? driverIcon;

  @override
  void initState() {
    super.initState();
    sourceLocatioon = LatLng(widget.sourceLat, widget.sourceLang);
    destLocatioon = LatLng(widget.destinationLat, widget.destinationLang);
    driverLocatioon = widget.driverLat == null
        ? LatLng(0, 0)
        : LatLng(widget.driverLat, widget.driverLang);
    setSourceAndDestinationIcons();
    if (widget.socket != null) socketListener();
  }

  void socketListener() {
    widget.socket!.on('driverLocation', (data) {
      print('driverLocation');
      updateDriverLocation(data['lat'], data['long']);
    });
  }

  void updateDriverLocation(double lat, double lang) {
    setState(() {
      driverLocatioon = LatLng(lat, lang);
      _markers.removeWhere(
          (element) => element.markerId.value == 'driverlocationPin');
      _markers.add(Marker(
          markerId: MarkerId('driverlocationPin'),
          position: driverLocatioon!,
          icon: driverIcon!));
    });
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/start2.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/end2.png');
    driverIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/driver2.png');
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation = CameraPosition(
        zoom: cameraZoom,
        bearing: cameraBearing,
        tilt: cameraTilt,
        target: sourceLocatioon!);
    return GoogleMap(
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        polylines: _polylines,
        mapType: MapType.terrain,
        indoorViewEnabled: true,
        trafficEnabled: true,
        initialCameraPosition: initialLocation,
        onMapCreated: onMapCreated);
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(Utils.mapStyles);
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: sourceLocatioon!,
          icon: sourceIcon!));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: destLocatioon!,
          icon: destinationIcon!));
      // driver location pin
      if (widget.driverLat != null) {
        _markers.add(Marker(
            markerId: MarkerId('driverlocationPin'),
            position: driverLocatioon!,
            icon: driverIcon!));
      }
    });
  }

  setPolylines() async {
    PolylineResult? result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(sourceLocatioon!.latitude, sourceLocatioon!.longitude),
      PointLatLng(destLocatioon!.latitude, destLocatioon!.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          width: 5,
          color: Colors.black,
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      _polylines.add(polyline);
    });
  }
}

class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}
