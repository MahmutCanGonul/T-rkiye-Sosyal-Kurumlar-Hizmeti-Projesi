

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
class MapScreen extends StatefulWidget {
  dynamic? mapData;
  String? cityName;
   MapScreen({ Key? key,required this.cityName,required this.mapData}) : super(key:key);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: '${widget.cityName} Haritası ',
            style: TextStyle(color: Colors.pink,fontSize: 25,fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: ' (Fare ile Haritayı yakınlaştırabilir ya da uzaklaştırabilirsiniz)',
              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: FlutterMap(
        options: MapOptions(
          center:latLng.LatLng(widget.mapData['latitude'], widget.mapData['longitude']),
          zoom: 13,
          maxZoom: 18.0
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          (widget.mapData['markers'] as List).length > 0 ?
          MarkerLayer(
            markers: widget.mapData['markers'],
          ):SizedBox.shrink(),
        ],
      ),
    );
  }
}