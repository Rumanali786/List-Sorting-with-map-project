import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'model/list_model.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //give initial Position latitude and longitude
  LatLng _initialPosition = LatLng(30.3894007, 69.3532207);

  //using predefined function of location package
  Location _location = Location();

  GoogleMapController _controller;

  //function for getting current location of user and updating it in realtime
  void _onMapCreated(GoogleMapController _controller) {
    _controller = _controller;
    _location.getLocation().then((l) => {
    CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(l.latitude, l.longitude),
            zoom: 15,
          ),
    )
    });
  }

  //list for distances
  List<ListOfLocation> locations = [
    ListOfLocation(from: "A", to: "B", value: 12),
    ListOfLocation(from: "A", to: "C", value: 18),
    ListOfLocation(from: "A", to: "D", value: 8),
    ListOfLocation(from: "A", to: "E", value: 24),
    ListOfLocation(from: "Z", to: "X", value: 5),
    ListOfLocation(from: "Z", to: "Y", value: 15),
  ];

  String listOrder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0a81ab),
          centerTitle: true,
          title: Text(
            "ListView With Map",
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //row for select Ascending or Descending sorting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(listOrder == null ? "" : listOrder),
              PopupMenuButton(
                itemBuilder: (BuildContext bc) => [
                  PopupMenuItem(
                    child: Text("Ascending"),
                    value: "Ascending",
                  ),
                  PopupMenuItem(child: Text("Descending"), value: "Descending"),
                  PopupMenuItem(child: Text("Random"), value: "Random"),
                ],
                onSelected: (route) async {
                  if (route == 'Ascending') {
                    setState(() {
                      listOrder = "Ascending List";
                      locations.sort((a, b) => a.value.compareTo(b.value));
                    });
                  } else if (route == 'Descending') {
                    setState(() {
                      listOrder = "Descending List";
                      locations.sort((a, b) => b.value.compareTo(a.value));
                    });
                  } else {
                    setState(() {
                      listOrder = "Random List";
                      locations.shuffle();
                    });
                  }
                },
              ),
            ],
          ),

          //List View for given Data
          ListView.builder(
            shrinkWrap: true,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(locations[index].from),
                      Text(locations[index].to),
                      Text(locations[index].value.toString() + "Km"),
                    ],
                  ),
                ),
              );
            },
          ),

          //google maps
          Expanded(
            child: GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _initialPosition, zoom: 3),
              mapType: MapType.terrain,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

}
