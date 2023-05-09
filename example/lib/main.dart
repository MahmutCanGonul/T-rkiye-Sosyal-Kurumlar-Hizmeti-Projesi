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
  Colors.teal,
  Colors.black54,
  Colors.brown
];


var currentCities = [
  'Istanbul', 'Ankara', 'İzmir', 'Bursa',
  'Antalya', 'Konya', 'Adana', 'Şanlıurfa', 'Gaziantep', 'Kocaeli', 'Diyarbakır', 'Trabzon', 'Aydın',
  'Erzurum',
  'Eskişehir',
];


var targetData = { //İle göre belirlenmiş olan huzur evleri ilçe adreslerini ve konumları map şeklinde tutulmaktadır
  "Istanbul":[
    {"address":"19 Mayıs Mahallesi Sultan Sokak No:29 Kadıköy/ İstanbul",
      "name":"19 Mayıs Sosyal Yaşam Evi & Alzheimer Merkezi",
      "type":"Belediye",
      "target_audience":"65 yaş üzeri",
      "criteria":[ "Kadıköyde ikamet etmek, 65 yaş ve üzeri olmak",
        "1. ve 2. evre alzheimer tanısı almış ve tıbbi belgeye sahip olmak* (*Alzheimer merkezi için)",
       ],
      "telephone_number":" (0216) 356 11 14",
      "duration":"Hafta içi her gün 08.00 - 17.00",
      "latitude":40.97720201770398,
      "longitude":29.08521207639153},

    {"address":"Nisbetiye mah. Aytar cad. başlık sokak no:1 Beşiktaş-İstanbul",
      "name":"65+ Yaşam ofisi ",
      "type":"Belediye",
      "target_audience":"65 yaş ve üstü yaşlılar",
      "criteria":["Beşiktaş'ta ikamet ediyor olmak, 65 yaş ve üzeri olmak, alzhimer tanısı almamış olmak"],
      "telephone_number":"0212 319 4242 (3196)",
      "duration":"devamlı",
      "latitude":41.07505817134914,
      "longitude":29.020393535137902},

    {"address":"Nisbetiye mah. Ilgın Sokak 3 Beşiktaş,İstanbul",
      "name":"Ulus Yaşam Evi ",
      "type":"Belediye",
      "target_audience":"65 yaş ve üstü yaşlılar",
      "criteria":["Beşiktaş'ta ikamet ediyor olmak, 65 yaş ve üzeri olmak, alzhimer tanısı varsa refakatçısının olması"],
      "telephone_number":"0212 319 4242",
      "duration":"devamlı",
      "latitude":41.071330327674794,
      "longitude":29.023256653390035},

    {"address":"Etiler mahallesi, Ahular sokak, No:19 Beşiktaş",
      "name":"Etiler Yaşam Evi",
      "type":"Belediye",
      "target_audience":"65 yaş ve üstü yaşlılar",
      "criteria":["Beşiktaş'ta ikamet ediyor olmak, 65 yaş ve üzeri olmak, alzhimer tanısı varsa refakatçısının olması"],
      "telephone_number":"0212 319 4242",
      "duration":"devamlı",
      "latitude":41.0826110875536,
      "longitude":29.036534101839813},

    {"address":"Levent Mah. Ebulula Mardin Cad. Gazeteciler Sitesi B7 Blok No:63/9001 Beşiktaş/İSTANBUL",
      "name":"Esenlik Merkezi",
      "type":"Belediye",
      "target_audience":"75 yaş ve üstü yaşlılar",
      "criteria":["Beşiktaş'ta ikamet ediyor olmak, 75 yaş ve üzeri olmak, yalnız yaşamak ve/veya özbakımını karşılayamayacak durumda olmak "],
      "telephone_number":"(0212) 280 55 35",
      "duration":"devamlı",
      "latitude":41.08269519644975,
      "longitude":29.021217457659812},

    {"address":"Nisbetiye mah. Aytar cad. başlık sokak no:1 Beşiktaş-İstanbul",
      "name":"Beşiktaş Belediyesi (evde kişisel bakım ve muayene hizmet)",
      "type":"Belediye",
      "target_audience":"65 yaş üstü veya engelliler",
      "criteria":["Beşiktaş'ta ikamet ediyor olmak, 65 yaş üzeri veya engelli olmak, kronik rahatsızlığından dolayı bakıma muhtaç olmak"],
      "telephone_number":"444 44 55",
      "duration":"devamlı",
      "latitude":41.07505817134914,
      "longitude":29.020393535137902},

    {"address":"Sahrayıcedid mah. Güzide sok. No:7/1 Kadıköy-istanbul",
      "name":"Sahrayıcedit Sosyal Yaşam Evi",
      "type":"Belediye",
      "target_audience":"65 yaş üzeri",
      "criteria":[ "Kadıköyde ikamet etmek, 65 yaş ve üzeri olmak",],
      "telephone_number":" (0216) 363 43 81",
      "duration":"Hafta içi her gün 08.00 - 17.00",
      "latitude":40.98450046504063,
      "longitude":29.08960849784522},

    {"address":"Tepegöz Sokak, Nural Köşkü No:43 Göztepe, Kadıköy/İstanbul",
      "name":"Göztepe Sosyal Hizmet ve Alzheimer Merkezi",
      "type":"Belediye",
      "target_audience":"65 yaş üzeri",
      "criteria":[ "Kadıköyde ikamet etmek, 65 yaş ve üzeri olmak",
        "1. ve 2. evre alzheimer tanısı almış ve tıbbi belgeye sahip olmak* (*Alzheimer merkezi için)",
      ],
      "telephone_number":"(0216) 350 75 79",
      "duration":"Hafta içi her gün 08.00 - 17.00",
      "latitude":40.977605745696664,
      "longitude":29.06012952159111},

    {"address":"Merdivenköy, Şair Arşi Cd. No 56, 34732 Kadıköy/İstanbul",
      "name":"Göztepe Semiha Şakir Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Aile ve Sosyal Politikalar Bakanlığına bağlı huzurevi",
      "target_audience":"60 yaş üzeri",
      "criteria":[ "Kadıköyde ikamet etmek, 65 yaş ve üzeri olmak",
        "1. ve 2. evre alzheimer tanısı almış ve tıbbi belgeye sahip olmak* (*Alzheimer merkezi için)",
      ],
      "telephone_number":"(0216) 358 29 42",
      "duration":"Hafta içi her gün 08.00 - 17.00",
      "latitude":40.98852952861417,
      "longitude":29.074071824421335},

    {"address":"Caferağa Mah. General Asım Gündüz Cad. No: 39 Kadıköy/İstanbul",
      "name":"Kadıköy Sosyal Yardımlaşma ve Dayanışma Vakfı",
      "type":"Kadıköy Kaymakamlığı'na bağlı vakıf",
      "target_audience":"65 yaş üzeri, engeli var ise 65 yaş altı olabilir",
      "criteria":[
        "Yaşlı aylığı; 65 yaşını doldurmuş olan, nafaka bağlanmamış veya nafaka bağlanması mümkün olmayan, kamu veya özel kurum ve kuruluşlarda iaşe ve ibateleri dâhil olmak üzere sürekli bakımı yapılmayan veya yaptırılmayan, 2828 sayılı Sosyal Hizmetler Kanunu hükümlerine göre harçlık almayan, yurt içi-yurt dışı ayrımı yapılmaksızın sosyal güvenlik kurumlarından bir gelir veya aylık hakkından yararlanmayan, isteğe bağlı prim ödemeyen, uzun vadeli sigorta kollarına tabi olacak şekilde çalışmayan, aynı hanede ikamet edip etmediklerine bakılmaksızın kendisi ve eşi dikkate alınmak suretiyle kişi başına düşen ortalama aylık geliri, asgari ücretin aylık net tutarının 1/3’ünden (01.07.2022'den sonrası için 1833,45 TL) az olan Türk vatandaşlarına bağlanır. Yaşlılık aylığından faydalanan kişi yetkili sağlık kuruluşundan %70 ve üzeri bir engel oranına sahip rapor aldığı takdirde engelli aylığından da faydalanabilir. %70 oranının altında ise sadece yaşlı aylığı bağlanabilir. 65 yaşından önce %40-69 arası engelli aylığı bağlananların aylığının ödenmesine devam olunur. Fiilen Kadıköy ilçe sınırları içinde yaşayan ve ikametgahı Kadıköy'de olanlar başvuru yapabilir"
      ],
      "telephone_number":"(0216) 346 43 96 - (0216) 418 04 36 - (0216) 418 57 58",
      "duration":"Hafta içi her gün 08.30 - 17.00",
      "latitude":40.9867387626291,
      "longitude":29.02923465635994},

    {"address":"Koşuyolu Mah. Mahmut Yesari Cad. No:84 KADIKÖY",
      "name":"KADIKÖY BELEDİYESİ GÖRME ENGELLİLER SESLİ KÜTÜPHANESİ",
      "type":"Belediye",
      "target_audience":"Engelli bireyler",
      "criteria":[
        "Yaşlı aylığı; 65 yaşını doldurmuş olan, nafaka bağlanmamış veya nafaka bağlanması mümkün olmayan, kamu veya özel kurum ve kuruluşlarda iaşe ve ibateleri dâhil olmak üzere sürekli bakımı yapılmayan veya yaptırılmayan, 2828 sayılı Sosyal Hizmetler Kanunu hükümlerine göre harçlık almayan, yurt içi-yurt dışı ayrımı yapılmaksızın sosyal güvenlik kurumlarından bir gelir veya aylık hakkından yararlanmayan, isteğe bağlı prim ödemeyen, uzun vadeli sigorta kollarına tabi olacak şekilde çalışmayan, aynı hanede ikamet edip etmediklerine bakılmaksızın kendisi ve eşi dikkate alınmak suretiyle kişi başına düşen ortalama aylık geliri, asgari ücretin aylık net tutarının 1/3’ünden (01.07.2022'den sonrası için 1833,45 TL) az olan Türk vatandaşlarına bağlanır. Yaşlılık aylığından faydalanan kişi yetkili sağlık kuruluşundan %70 ve üzeri bir engel oranına sahip rapor aldığı takdirde engelli aylığından da faydalanabilir. %70 oranının altında ise sadece yaşlı aylığı bağlanabilir. 65 yaşından önce %40-69 arası engelli aylığı bağlananların aylığının ödenmesine devam olunur. Fiilen Kadıköy ilçe sınırları içinde yaşayan ve ikametgahı Kadıköy'de olanlar başvuru yapabilir"
      ],
      "telephone_number":"0216 337 21 21 (123-124)",
      "duration":"Online Hizmet",
      "latitude":41.00768282702324,
      "longitude":29.03481620826857},

    {"address":"Eğitim Mahallesi, Poyraz Sokak, Cem İş Merkezi, D:No:22/10, Kat 3, 34722 Kadıköy/İstanbul",
      "name":"Kanser Savaşçıları Derneği",
      "type":"STK",
      "target_audience":"Kanser hastaları, depremzede kanser hastaları",
      "criteria":[
         "Onko-van servisi sadece kamu hastanelerinde tedavi alan ve İstanbul Anadolu yakasında tedavi alan bireylere hizmet veriyor."
      ],
      "telephone_number":"0216 337 21 21 (123-124)",
      "duration":"Tedavi tarihlerine göre transferleri planlanıyor.",
      "latitude":40.9918029607687,
      "longitude":29.041926364401164},

  ],
  "Bursa":[
    {"address":"19 MAYIS MH. EGEMENLİK CD. NO:5 NİLÜFER/BURSA",
      "name":"Hasan Öztimur Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Aile ve Sosyal Politikalar Bakanlığı",
      "target_audience":"Yaşlı-Alzhemier",
      "criteria":["60 yaşı doldurmuş olmak",
        "Kendi öz bakımını gerçekleştirebilir olmak",
        "Akıl ve ruh sağlığı yerinde olmak",
        "Herhangi bir bulaşıcı hastalığa sahip olmamak"],
      "telephone_number":"0224 362 4778",
      "duration":"00.00 - 24.00",
      "latitude":40.22547694872019,
      "longitude":28.886497726022547}
  ],
};

const tempCoordinates =
  {'Istanbul':{'latitude':41.008240,'longitude':28.978359},
  'Ankara':{'latitude':39.933365,'longitude':32.859741},
  'İzmir':{'latitude':38.423733,'longitude':27.142826},
  'Bursa':{'latitude':40.188526,'longitude':29.060965},
  'Antalya':{'latitude':36.897917,'longitude':30.648065},
  'Konya':{'latitude':37.8698698,'longitude':32.480586},
  'Adana':{'latitude':36.9973327,'longitude':35.1479824},
  'Şanlıurfa':{'latitude':37.1671169,'longitude':38.755785},
  'Gaziantep':{'latitude':37.0587509,'longitude':37.3100969},
  'Kocaeli':{'latitude':40.7711087,'longitude':29.8994816},
  'Diyarbakır':{'latitude':37.9263347,'longitude':40.1844574},
  'Trabzon':{'latitude':40.994703,'longitude':39.7057651},
  'Aydın':{'latitude':37.8428353,'longitude':27.8276054},
  'Erzurum':{'latitude':39.9044064,'longitude':41.2601875},
  'Eskişehir':{'latitude':39.7734595,'longitude':30.4998641},};

var citiesLocationData = { // İllerin kordinatları burada tutulmaktadır
   'Istanbul':{'latitude':41.008240,'longitude':28.978359, 'markers':[]},
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
/*
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
 */
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
              selectedCity!=null ? InkWell(
                onTap: (){
                  var random = Random();
                  var mapData = citiesLocationData[selectedCity!.title];
                  if(mapData!=null){
                    var cityName = selectedCity!.title;
                    if(targetData.containsKey(cityName)){
                      var targetList = targetData[cityName] as List;
                      List<Marker> markers = [];
                      for(Map t in targetList){
                        var rand_index = random.nextInt(colors.length);
                        markers.add(new Marker(
                            point:latLng.LatLng(
                                t['latitude'],t['longitude']
                            ),
                            width:200,
                            height: 200,
                            builder:(context) => Row(
                              children: [
                               Stack(
                                 children: [
                                   Icon(Icons.location_on,color: colors[rand_index],size:50,),
                                   Text('${(t['name'] as String).toLowerCase()}',style: TextStyle(color: Colors.white,fontSize:7,
                                       backgroundColor: Colors.black),)
                                 ],
                               )
                              ],
                            )));
                      }
                      mapData.update("markers", (value) =>markers);
                      mapData.update("latitude", (value) =>tempCoordinates[cityName]!['latitude'] as double);
                      mapData.update("longitude", (value) =>tempCoordinates[cityName]!['longitude'] as double);

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
                child: Text('KURUMLARI HARİTADA GÖR',style: TextStyle(color: Colors.pinkAccent),),
              ):SizedBox.shrink(),
            ],
          ),
              selectedCity != null  &&
                  targetData.containsKey(selectedCity!.title)
                  ?
              Expanded(child: SizedBox(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:(targetData[selectedCity!.title] as List).length,
                    itemBuilder: (context,index){
                      return Row(
                        children: [
                          InkWell(
                            onTap: (){
                              var random = Random();
                              var mapData = citiesLocationData[selectedCity!.title];
                              if(mapData!=null){
                                var cityName = selectedCity!.title;
                                if(targetData.containsKey(cityName)){
                                  List<Marker> markers = [];
                                  var rand_index = random.nextInt(colors.length);
                                  markers.add(new Marker(
                                        point:latLng.LatLng(
                                            (targetData[selectedCity!.title] as List)[index]['latitude'],
                                            (targetData[selectedCity!.title] as List)[index]['longitude']
                                        ),
                                        width:200,
                                        height: 200,
                                        builder:(context) => Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Icon(Icons.location_on,color: colors[rand_index],size:50,),
                                                Text('${((targetData[selectedCity!.title] as List)[index]['name'] as String).toLowerCase()}',
                                                  style: TextStyle(color: Colors.white,fontSize:7,
                                                    backgroundColor: Colors.black),)
                                              ],
                                            )
                                          ],
                                        )));
                                  mapData.update("markers", (value) =>markers);
                                  mapData.update("latitude", (value) =>markers[0].point.latitude);
                                  mapData.update("longitude", (value) =>markers[0].point.longitude);

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
                            child: Row(
                              children: [
                                RichText(
                                  text:TextSpan(
                                    text: 'Kurum Adı:',
                                    style: TextStyle(fontSize: 12,color: Colors.yellow),
                                    children:[
                                      TextSpan(
                                        text: ' ${(targetData[selectedCity!.title] as List)[index]['name']}',
                                        style: TextStyle(fontSize: 10,color: Colors.white),
                                      ),
                                    ],
                                ),textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 10,),
                                RichText(
                                  text:TextSpan(
                                    text: 'Hedef Kitle:',
                                    style: TextStyle(fontSize: 12,color: Colors.yellow),
                                    children:[
                                      TextSpan(
                                        text: ' ${(targetData[selectedCity!.title] as List)[index]['target_audience']}',
                                        style: TextStyle(fontSize: 10,color: Colors.white),
                                      ),
                                    ],
                                  ),textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 10,),
                                RichText(
                                  text:TextSpan(
                                    text: 'Telefon NO:',
                                    style: TextStyle(fontSize: 12,color: Colors.yellow),
                                    children:[
                                      TextSpan(
                                        text: ' ${(targetData[selectedCity!.title] as List)[index]['telephone_number']}',
                                        style: TextStyle(fontSize: 10,color: Colors.white),

                                      ),
                                    ],
                                  ),textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 10,),
                                RichText(
                                  text:TextSpan(
                                    text: 'Açık Adres:',
                                    style: TextStyle(fontSize: 12,color: Colors.yellow),
                                    children:[
                                      TextSpan(
                                        text: ' ${(targetData[selectedCity!.title] as List)[index]['address']}',
                                        style: TextStyle(fontSize: 10,color: Colors.white),

                                      ),
                                    ],
                                  ),textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 10,),
                                RichText(
                                  text:TextSpan(
                                    text: 'Saatler:',
                                    style: TextStyle(fontSize: 12,color: Colors.yellow),
                                    children:[
                                      TextSpan(
                                        text: ' ${(targetData[selectedCity!.title] as List)[index]['duration']}',
                                        style: TextStyle(fontSize: 10,color: Colors.white),

                                      ),
                                    ],
                                  ),textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 10,),
                                IconButton(onPressed:()=> showCupertinoModalSheet(context: context,
                                    builder:(context) => RichText(text: TextSpan(
                                      text: 'Kriterler: ',
                                      style: TextStyle(color: Colors.pinkAccent,fontSize: 15),
                                      children: [
                                        TextSpan(
                                            text:'${(targetData[selectedCity!.title] as List)[index]['criteria']}',
                                            style: TextStyle(color: Colors.white)
                                        )],
                      ))), icon: Icon(Icons.info,size: 20,color: Colors.pinkAccent,))
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
