import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/constants/constants.dart';
import 'package:location/location.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  Uint8List? initialLocIcon;
  Uint8List? destinationIcon;
  Uint8List? currentLocIcon;

  static const LatLng initialLocation = LatLng(
      10.260595559853076, 123.83385144252178); //Wilcon Depot Talisay City Cebu
  static const LatLng destination = LatLng(10.266114367851582,
      123.8419560781981424); //Greenwich Tabunok Talisay Cebu
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then((currentLoc) {
      currentLocation = currentLoc;
    });
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ),
      );
      setState(() {});
    });
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(initialLocation.latitude, initialLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        setState(() {});
      }
    }
  }

  loadMarkers() async {
    currentLocIcon = await getBytesFromAssets('assets/person.jpg', 100);
    initialLocIcon = await getBytesFromAssets('assets/initial_pin.png', 80);
    destinationIcon =
        await getBytesFromAssets('assets/destination_pin.png', 80);
  }

  @override
  void initState() {
    loadMarkers();
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: currentLocation == null
            ? Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()),
              )
            : Container(
                color: Colors.white,
                child: Center(
                  child: GoogleMap(
                      zoomControlsEnabled: false,
                      polylines: {
                        Polyline(
                          polylineId: const PolylineId("route"),
                          points: polylineCoordinates,
                          color: polyLineColor,
                          width: 6,
                        ),
                      },
                      initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          zoom: 12.5),
                      onMapCreated: (mapController) {
                        _controller.complete(mapController);
                      },
                      markers: {
                        Marker(
                          icon: BitmapDescriptor.fromBytes(currentLocIcon!),
                          markerId: const MarkerId("currentLocation"),
                          position: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                        ),
                        Marker(
                          icon: BitmapDescriptor.fromBytes(initialLocIcon!),
                          markerId: const MarkerId("initialLoc"),
                          position: initialLocation,
                        ),
                        Marker(
                          icon: BitmapDescriptor.fromBytes(destinationIcon!),
                          markerId: const MarkerId("destination"),
                          position: destination,
                        ),
                      }),
                ),
              ),
      ),
    );
  }
}
