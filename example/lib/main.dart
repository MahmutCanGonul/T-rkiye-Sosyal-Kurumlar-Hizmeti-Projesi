import 'dart:async';
import 'dart:math';
import 'package:cupertino_modal_sheet/cupertino_modal_sheet.dart';
import 'package:example/map_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:city_picker_from_map/city_picker_from_map.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart' as latLng;

var colors = [
  Colors.purple,
  Colors.blue,
  Colors.pinkAccent,
  Colors.green,
  Colors.amberAccent,
  Colors.orange,
  Colors.pink,
  Colors.tealAccent,
  Colors.black,
  Colors.red,
];


var currentCities = [
  'Istanbul', 'Ankara', 'İzmir', 'Bursa',
  'Antalya', 'Konya', 'Adana', 'Şanlıurfa', 'Gaziantep', 'Kocaeli', 'Diyarbakır', 'Trabzon', 'Aydın',
  'Erzurum',
  'Eskişehir',
];

var izmirData = {"status":"OK","data":[{"id":35,"name":"İzmir","area":11891,"population":4425789,"areaCode":[232],"isMetropolitan":true,"coordinates":{"latitude":38.41885,"longitude":27.12872},"maps":{"googleMaps":"https://goo.gl/maps/nukYGi69xLMX7SNR6","openStreetMap":"https://www.openstreetmap.org/relation/223167"},"region":{"en":"Aegean","tr":"Ege"},"districts":[{"id":1128,"name":"Aliağa","area":379,"population":103364},{"id":2006,"name":"Balçova","area":16,"population":80513},{"id":1178,"name":"Bayındır","area":548,"population":40049},{"id":2056,"name":"Bayraklı","area":30,"population":296839},{"id":1181,"name":"Bergama","area":1544,"population":104980},{"id":1776,"name":"Beydağ","area":172,"population":12197},{"id":1203,"name":"Bornova","area":220,"population":452867},{"id":1780,"name":"Buca","area":178,"population":517963},{"id":1251,"name":"Çeşme","area":285,"population":48167},{"id":2007,"name":"Çiğli","area":139,"population":209951},{"id":1280,"name":"Dikili","area":534,"population":46587},{"id":1334,"name":"Foça","area":251,"population":33611},{"id":2009,"name":"Gaziemir","area":70,"population":137856},{"id":2018,"name":"Güzelbahçe","area":77,"population":37572},{"id":2057,"name":"Karabağlar","area":89,"population":478788},{"id":1432,"name":"Karaburun","area":421,"population":11927},{"id":1448,"name":"Karşıyaka","area":51,"population":347023},{"id":1461,"name":"Kemalpaşa","area":681,"population":112049},{"id":1467,"name":"Kınık","area":479,"population":28513},{"id":1477,"name":"Kiraz","area":573,"population":43674},{"id":1819,"name":"Konak","area":24,"population":336545},{"id":1826,"name":"Menderes","area":777,"population":104147},{"id":1521,"name":"Menemen","area":573,"population":193229},{"id":2013,"name":"Narlıdere","area":50,"population":63438},{"id":1563,"name":"Ödemiş","area":1019,"population":132769},{"id":1611,"name":"Seferihisar","area":375,"population":52507},{"id":1612,"name":"Selçuk","area":317,"population":37689},{"id":1677,"name":"Tire","area":716,"population":86758},{"id":1682,"name":"Torbalı","area":577,"population":201476},{"id":1703,"name":"Urla","area":727,"population":72741}]}]};

var provienceLocationData = { //İle göre belirlenmiş olan huzur evleri ilçe adreslerini ve konumları map şeklinde tutulmaktadır
  "Istanbul":[
    {"address":"Galata Kulesi","latitude":41.0256186,"longitude":28.974113821},
    {"address":"Üsküdar Adres-1","latitude":41.026184,"longitude":29.0144958},
    {"address":"Üsküdar Adres-2","latitude":41.026184,"longitude":29.0144958},
    {"address":"Üsküdar Adres-3","latitude":41.026184,"longitude":29.0144958},
    {"address":"Adalar Adres-4","latitude":41.026184,"longitude":29.0144958},

  ],
};

var citiesLocationData = { // İllerin kordinatları burada tutulmaktadır
   'Istanbul':{'latitude':41.008240,'longitude':28.978359,
     'markers':[
       /* MARKER EXAMPLES
       new Marker(
       point:latLng.LatLng(
           41.0255682,28.9653736
       ),
       width: 30,
       height: 30,
       builder:(context) => Icon(Icons.location_on,color: Colors.red,)),
       new Marker(
           point:latLng.LatLng(
               41.026184,29.0144958
           ),
           width: 30,
           height: 30,
           builder:(context) => Icon(Icons.location_on,color: Colors.red,))

        */
     ]},

  'Ankara':{'latitude':39.933365,'longitude':32.859741,'markers':[]},
   'İzmir':{'latitude':38.423733,'longitude':27.142826,'markers':[]},
   'Bursa':{'latitude':40.188526,'longitude':29.060965,'markers':[]},
   'Antalya':{'latitude':36.897917,'longitude':30.648065,'markers':[]},
   'Konya':{'latitude':37.8698698,'longitude':32.480586,'markers':[]},
   'Adana':{'latitude':36.9973327,'longitude':35.1479824,'markers':[]},
   'Şanlıurfa':{'latitude':37.1671169,'longitude':38.755785,'markers':[]},
  'Gaziantep':{'latitude':37.0587509,'longitude':37.3100969,'markers':[]},
  'Kocaeli':{'latitude':40.7711087,'longitude':29.8994816,'markers':[]},
  'Diyarbakır':{'latitude':37.9263347,'longitude':40.1844574,'markers':[]},
  'Trabzon':{'latitude':40.994703,'longitude':39.7057651,'markers':[]},
  'Aydın':{'latitude':37.8428353,'longitude':27.8276054,'markers':[]},
  'Erzurum':{'latitude':39.9044064,'longitude':41.2601875,'markers':[]},
  'Eskişehir':{'latitude':39.7734595,'longitude':30.4998641,'markers':[]},
};


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harita65+',
      home: HomeView(),
      theme: ThemeData.dark(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  City? selectedCity;
  final GlobalKey<CityPickerMapState> _mapKey = GlobalKey();
  final url = "https://turkiyeapi.cyclic.app/api/v1/provinces?name=";
  var provinces = [];
  var population=0;
  List<Widget> targetAddressList = [];
 @override
 void initState(){
   super.initState();

 }

 void getStates(String state)async{
   provinces.clear();
   population = 0;
   try{
     if(state == "Istanbul")
       state = "istanbul";
     else
       state = state.toLowerCase();
     var response = await http.get(Uri.parse(url+state));
     if(response.statusCode == 200){
       var json_data = jsonDecode(response.body);
       var data = json_data['data'] as List;
       if(data.isNotEmpty){
         population = data[0]['population'];
         var districts = data[0]['districts'] as List;
         for(var district in districts){
           provinces.add(district['name']);
         }
       }
     }
     else{
       var data = izmirData['data'] as List;
       population = data[0]['population'];
       var districts = data[0]['districts'] as List;
       for(var district in districts){
         provinces.add(district['name']);
       }
     }

   }catch(err){
         print(err.toString());
   }
   setState(() {

   });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seçilen Şehir: ${selectedCity?.title ?? '(Lütfen işaretli olan illeri seçiniz)'}'),
        actions: [
          IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _mapKey.currentState?.clearSelect();
                population=0;
                provinces.clear();
                setState(() {
                  selectedCity = null;
                });
              })
        ],
      ),
      body: Column(
        children: [
          Center(
            child: InteractiveViewer(
              scaleEnabled: true,
              panEnabled: true,
              constrained: true,
              child: CityPickerMap(
                key: _mapKey,
                width: double.infinity,
                height: double.infinity,
                map: Maps.TURKEY,
                onChanged: (city) {
                  selectedCity=null;
                  if(currentCities.contains(city!.title)){
                    getStates(city!.title);
                    setState(() {
                      selectedCity = city;
                    });
                  }
                  else{
                    population=0;
                    provinces.clear();
                  }
                  setState(() {

                  });
                },
                actAsToggle: true,
                dotColor: Colors.white,
                selectedColor: Colors.lightBlueAccent,
                strokeColor: Colors.white24,
              ),
            ),
          ),

          Row(
            children: [
             provinces.isNotEmpty ?
             Text('İLÇELER: ',textAlign: TextAlign.start,style: TextStyle(color: Colors.amberAccent),)
             :SizedBox.shrink(),
              SizedBox(width: 10,),
             population > 0 ?
             Text('  NÜFUS: ${population}',textAlign: TextAlign.start,style: TextStyle(color: Colors.amberAccent),):
                 SizedBox.shrink(),
              SizedBox(width: 10,),
              population > 0 || provinces.isNotEmpty ? InkWell(
                onTap: (){
                  var random = Random();
                  var mapData = citiesLocationData[selectedCity!.title];
                  if(mapData!=null){
                    var cityName = selectedCity!.title;
                    if(provienceLocationData.containsKey(cityName)){
                      var targetList = provienceLocationData[cityName] as List;
                      List<Marker> markers = [];
                      for(Map t in targetList){
                        var rand_index = random.nextInt(colors.length);
                        markers.add(new Marker(
                            point:latLng.LatLng(
                                t['latitude'],t['longitude']
                            ),
                            width: 30,
                            height: 30,
                            builder:(context) => Icon(Icons.location_on,color: colors[rand_index],)));
                      }
                      mapData.update("markers", (value) =>markers);
                    }
                    if(cityName == 'Istanbul')
                       cityName ="İstanbul";
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  MapScreen(
                          cityName: cityName,
                          mapData: mapData)),
                    );
                  }
                },
                child: Text('  KURUMLARI HARİTADA GÖR',style: TextStyle(color: Colors.pinkAccent),),
              ):SizedBox.shrink(),
              SizedBox(width: 100,),
            ],
          ),
              selectedCity != null  && provinces.length > 0
                  ?
              Expanded(child: SizedBox(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:provinces.length,
                    itemBuilder: (context,index){
                      return Row(
                        children: [
                          InkWell(
                            onTap: (){
                              targetAddressList.clear();
                              if(provienceLocationData.containsKey(selectedCity!.title)){
                                var data = provienceLocationData[selectedCity!.title] as List;
                                var count=0;
                                for(var d in data){
                                    var address = d['address'] as String;
                                    if(address.contains(provinces[index])){
                                         count++;
                                         if(count == 1)
                                           targetAddressList.add(RichText(
                                           text: TextSpan(
                                             text: '${provinces[index]} Yaşlı Bakım Adresleri',
                                             style: TextStyle(fontSize: 20,color: Colors.pink,
                                             fontWeight: FontWeight.bold),
                                           ),
                                           textAlign: TextAlign.center,
                                         ));
                                       targetAddressList.add(RichText(
                                        text: TextSpan(
                                          text: '${address}',
                                          style: TextStyle(fontSize: 15,color: Colors.amberAccent),
                                        ),
                                          textAlign: TextAlign.center,
                                        ));
                                        targetAddressList.add(SizedBox(height: 10,));
                                    }
                                }
                                setState(() {

                                });
                                if(targetAddressList.isNotEmpty)
                                  showCupertinoModalSheet(context: context, builder:(context)=>
                                      Container(
                                        child: ListView(
                                          children: targetAddressList,
                                        ),
                                      ));
                              }
                              print(provinces[index]);
                            },
                            child: Row(
                              children: [
                                Text('${provinces[index]}',textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                        ],
                      );
                    }),

              )):SizedBox.shrink(),
        ],
      ),
    );
  }
}


/*
FlutterMap(
        options: MapOptions(
          center:latLng.LatLng(40.8662807, 28.9186165),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point:  latLng.LatLng(40.872840, 29.091541),
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on,color: Colors.red,),
                ),
              ),
            ],
          ),
        ],
      ),
 */
