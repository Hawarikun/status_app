import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:status_app/features/maps/persentation/view/picker_maps.dart';
import 'package:status_app/features/stories/domain/stories.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.data,
  });

  final Story data;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  LatLng location = const LatLng(0, 0);
  MapType selectedMapType = MapType.normal;
  geo.Placemark? placemark;

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  @override
  void initState() {
    super.initState();
    location = LatLng(widget.data.lat!, widget.data.lon!);

    final marker = Marker(
      markerId: const MarkerId("current"),
      position: location,
      onTap: () {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(location, 18),
        );
      },
    );
    markers.add(marker);
  }

  @override
  Widget build(BuildContext context) {
    print(location);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Maps",
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              markers: markers,
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: location,
              ),
              onMapCreated: (controller) async {
                final info = await geo.placemarkFromCoordinates(
                    location.latitude, location.longitude);
                final place = info[0];
                final street = place.street!;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                setState(() {
                  placemark = place;
                });
                defineMarker(location, street, address);
                final marker = Marker(
                  markerId: const MarkerId("source"),
                  position: location,
                );
                setState(() {
                  mapController = controller;
                  markers.add(marker);
                });
                setState(() {
                  mapController = controller;
                });
              },
              mapType: selectedMapType,
            ),
            // Positioned(
            //   bottom: 0,
            //   right: 16,
            //   child: Column(
            //     children: [],
            //   ),
            // ),
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    onPressed: null,
                    child: PopupMenuButton<MapType>(
                      onSelected: (MapType item) {
                        setState(() {
                          selectedMapType = item;
                        });
                      },
                      offset: const Offset(0, 54),
                      icon: const Icon(Icons.layers_outlined),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<MapType>>[
                        const PopupMenuItem<MapType>(
                          value: MapType.normal,
                          child: Text('Normal'),
                        ),
                        const PopupMenuItem<MapType>(
                          value: MapType.satellite,
                          child: Text('Satellite'),
                        ),
                        const PopupMenuItem<MapType>(
                          value: MapType.terrain,
                          child: Text('Terrain'),
                        ),
                        const PopupMenuItem<MapType>(
                          value: MapType.hybrid,
                          child: Text('Hybrid'),
                        ),
                      ],
                    ),
                  ),
                  FloatingActionButton.small(
                    heroTag: "zoom-in",
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomIn(),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton.small(
                    heroTag: "zoom-out",
                    onPressed: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: PlacemarkWidget(
                  placemark: placemark!,
                  location: location,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
