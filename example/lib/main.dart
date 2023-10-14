import 'dart:async';
import 'dart:math';
import 'package:example/map_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:city_picker_from_map/city_picker_from_map.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:url_launcher/url_launcher.dart';
var colors = [
  Colors.purple,
  Colors.blue,
  Colors.pinkAccent,
  Colors.green,
  Colors.amberAccent,
  Colors.orange,
  //Colors.pink,
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
      "target_audience":"65 yaş üzeri, \nengeli var ise 65 yaş altı olabilir",
      "criteria":[
        "Yaşlı aylığı; 65 yaşını doldurmuş olan, nafaka bağlanmamış veya nafaka bağlanması mümkün olmayan, kamu veya özel kurum ve kuruluşlarda iaşe ve ibateleri dâhil olmak üzere sürekli bakımı yapılmayan veya yaptırılmayan, 2828 sayılı Sosyal Hizmetler Kanunu hükümlerine göre harçlık almayan, yurt içi-yurt dışı ayrımı yapılmaksızın sosyal güvenlik kurumlarından bir gelir veya aylık hakkından yararlanmayan, isteğe bağlı prim ödemeyen, uzun vadeli sigorta kollarına tabi olacak şekilde çalışmayan, aynı hanede ikamet edip etmediklerine bakılmaksızın kendisi ve eşi dikkate alınmak suretiyle kişi başına düşen ortalama aylık geliri, asgari ücretin aylık net tutarının 1/3’ünden (01.07.2022'den sonrası için 1833,45 TL) az olan Türk vatandaşlarına bağlanır. Yaşlılık aylığından faydalanan kişi yetkili sağlık kuruluşundan %70 ve üzeri bir engel oranına sahip rapor aldığı takdirde engelli aylığından da faydalanabilir. %70 oranının altında ise sadece yaşlı aylığı bağlanabilir. 65 yaşından önce %40-69 arası engelli aylığı bağlananların aylığının ödenmesine devam olunur. Fiilen Kadıköy ilçe sınırları içinde yaşayan ve ikametgahı Kadıköy'de olanlar başvuru yapabilir"
      ],
      "telephone_number":"(0216) 346 43 96-\n(0216) 418 04 36-(0216) 418 57 58",
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

    {"address":"Eğitim Mahallesi, Poyraz Sokak, \nCem İş Merkezi, D:No:22/10, Kat 3, 34722 Kadıköy/İstanbul",
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

    {"address":"Rasimpaşa Mahallesi Karakolhane Caddesi \nNo:39 Kadıköy-İSTANBUL",
      "name":"Kadıköy Belediyesi Gönüllüleri-\nGönüllü Evi Seminerleri (Prof. Dr. Korkmaz Altuğ Sağlık Polikliniği)",
      "type":"Belediye",
      "target_audience":"Kronik hastalık, Hipertansiyon, Hiperlipidemi, \nAstım, Alzheimer Hastalığı,Romatizmal Hastalıklar, vb.",
      "criteria":[
        "Onko-van servisi sadece kamu hastanelerinde tedavi alan ve İstanbul Anadolu yakasında tedavi alan bireylere hizmet veriyor."
      ],
      "telephone_number":"0216 565 13 44-0216 565 25 94",
      "duration":"\nHafta içi 09.00 - 16.00",
      "latitude":40.995161,
      "longitude":29.029273},

    {"address":"Rasimpaşa Mah. İskele Sokak No: 2 - Kadıköy",
      "name":"‘Evde Kuaförlük' Hizmeti-\nKadıköy Sosyal Hizmet Merkezleri",
      "type":"Kadıköy Belediyesi Sosyal Destek Hizmetleri Müdürlüğü ",
      "target_audience":"65 yaş üzeri olmak ve fiziksel, psikolojik ya da \nyaşa bağlı nedenlerle günlük yaşam aktivitelerini gerçekleştirmekte zorluk yaşamak ve/veya engeli bulunmak,Kadıköy'de ikamet etmek",
      "criteria":[
        "Onko-van servisi sadece kamu hastanelerinde tedavi alan ve İstanbul Anadolu yakasında tedavi alan bireylere hizmet veriyor."
      ],
      "telephone_number":"0216 349 11 89\n-0216 418 21 75",
      "duration":"\nHafta içi 08.30 - 17.00",
      "latitude":40.99590730657526,
      "longitude":29.02501220364351},

    {"address":"Rasimpaşa Mah. İskele Sokak No:2-Kadıköy",
      "name":"Evde temizlik hizmeti-\nKadıköy Belediyesi Sosyal Hizmet Merkezleri",
      "type":"Kadıköy Belediyesi Sosyal Destek Hizmetleri Müdürlüğü ",
      "target_audience":"65 yaş üzeri olmak ve fiziksel, psikolojik ya da \nyaşa bağlı nedenlerle günlük yaşam aktivitelerini gerçekleştirmekte zorluk yaşamak ve/veya engeli bulunmak,Kadıköy'de ikamet etmek",
      "criteria":[
        "Onko-van servisi sadece kamu hastanelerinde tedavi alan ve İstanbul Anadolu yakasında tedavi alan bireylere hizmet veriyor."
      ],
      "telephone_number":"0216 349 11 89\n - 0216 418 21 75",
      "duration":"\nHafta içi 08.30 - 17.00",
      "latitude":40.99590730657526,
      "longitude":29.02501220364351},


    {"address":"Rasimpaşa Mah. İskele Sokak No: 2 - Kadıköy,\n / 19 Mayıs, Sultan Sokağı No:28, 34736 Kadıköy/İstanbul",
      "name":"Psikolojik Danışmanlık Hizmeti - \nRasimpaşa Sosyal Hizmet Merkezi & 19 Mayıs Sosyal Hizmet Merkezi",
      "type":"Kadıköy Belediyesi Sosyal Destek Hizmetleri Müdürlüğü ",
      "target_audience":"Yetişkinler, çocuklar, çiftler (65 Yaş üzeri dahil)",
      "criteria":[
        "Kadıköyde ikamet etmek, hizmet alınan merkez; ikamet edilen mahalleye göre değişir."
      ],
      "telephone_number":"0216 349 11 89 - 0216 418 21 75",
      "duration":"Hafta içi her gün 08.30 - 17.00",
      "latitude":40.99590730657526,
      "longitude":29.02501220364351},

    {"address":"Koşuyolu Mah. \nMahmut Yesari Cad. No:84 KADIKÖY",
      "name":"Koşuyolu Engelsiz Sosyal Hizmet Merkezi\n(Engelsiz Taksi)",
      "type":"Kadıköy Belediyesi Sosyal Destek Hizmetleri Müdürlüğü ",
      "target_audience":"Engelli bireyler öncelikli olmak üzere, tüm bireylere \n(çocuk, genç, kadın, erkek, engelli, yaşlı, mülteci, göçmen ve LGBTİ bireyler), Kadıköy de ikamet etmek",
      "criteria":[
        "Kadıköyde ikamet etmek, hizmet alınan merkez; ikamet edilen mahalleye göre değişir."
      ],
      "telephone_number":"0216 337 21 21-\n444 00 81",
      "duration":"Hafta içi her gün 08.30 - 17.00 \nEngelsiz taksi randevu sistemi ile",
      "latitude":41.00768282702324,
      "longitude":29.03481620826857},

    {"address":"Kayışdağı Cad. No:211 34755 Ataşehir/İSTANBUL",
      "name":"DARÜLACEZE MÜDÜRLÜĞÜ (Kayışdağı)",
      "type":"Belediye",
      "target_audience":"Çocuklar ile engelli ve yaşlı bireyler",
      "criteria":[
        "Darülaceze Başkanlığı Kabul Koşulları incelenmeli"
      ],
      "telephone_number":"0216 528 84 00",
      "duration":"Konaklama + Haftanın her günü 09:00–17:00 (Ziyaret saatleri)",
      "latitude":40.97805858536974,
      "longitude":29.148354474468096},

    {"address":"Küçükbakkalköy Mah. Vedat Günyol Cad. No: 4 Ataşehir / İstanbul",
      "name":"Türkan Saylan Tıp Merkezi",
      "type":"Belediye",
      "target_audience":"Sosyal Güvenlik Kurumu bünyesindeki(SSK, Bağ-Kur, Emekli Sandığı) \ntüm çalışan, emekli vatandaşlar ve 18 yaş altı çocuklar, Sosyal güvencesi bulunmayan vatandaşlar",
      "criteria":[
         "Sosyal güvencesi bulunmayan vatandaşlar da Türkan Saylan Tıp Merkezi’nden asgari bir ücret ödeyerek yararlanabilir. 18 yaş altı çocuklar tıp merkezinden hiçbir ücret ödemeden yararlanabiliyor."
      ],
      "telephone_number":"(0216) 577 71 40",
      "duration":"Hafta içi her gün 08:30–17:00",
      "latitude":40.980055993384234,
      "longitude":29.104084},

    {"address":"Ferhatpaşa Mahallesi Yeditepe Caddesi \n16.Sokak No:25 Ataşehir",
      "name":"Ataşehir Belediyesi Ferhatpaşa Sağlık Polikliniği",
      "type":"Belediye",
      "target_audience":"Ataşehir Belediyesi Ferhatpaşa Sağlık Polikliniği’nde sigortalı ya da \nsigortasız olduğuna bakılmaksızın tüm vatandaşlarımıza ücretsiz hizmet verilecektir.",
      "criteria":[
        " Not: Doğum"
      ],
      "telephone_number":"(0216) 570 50 00",
      "duration":"Hafta içi her gün 08:30–17:00,\n Cumartesi:08:30–12:30",
      "latitude":40.98771318901821,
      "longitude":29.169600743490086},

    {"address":"-",
      "name":"Ataşehir Belediyesi-EVDE SAĞLIK HİZMETLERİ-Tıbbi Danışmanlık Hizmeti",
      "type":"Belediye",
      "target_audience":"Sağlık sorunları yaşayan tüm Ataşehirlilere",
      "criteria":[
        " Not: Tıbbi Danışmanlık acil ya da acil olmayan, sağlınızla ilgili her türlü konuda sorularınızı deneyimli hekimlere yöneltebileceğiniz, koruyucu ve yönlendirici bir sağlık hizmetidir."
      ],
      "telephone_number":"444 45 70",
      "duration":"7 gün 24 saat",
      "latitude":null,
      "longitude":null},

    {"address":"-",
      "name":"Ataşehir Belediyesi - EVDE SAĞLIK HİZMETLERİ - Hasta Nakil Ambulans Hizmeti",
      "type":"Belediye",
      "target_audience":"Sağlık sorunları yaşayan tüm Ataşehirlilere",
      "criteria":[
        "Ataşehir’de ikamet etmek, engelli ve 65 yaş üstü yatalak olmak"
        " Not: Randevu için 1 gün öncesinden ulaşılmalı."
      ],
      "telephone_number":"444 60 39 ve ( 216) 570 50 00–(1825 dahili)",
      "duration":"Hafta içi her gün saat 08:30 - 17:00",
      "latitude":null,
      "longitude":null},

    {"address":"-",
      "name":"Ataşehir Belediyesi-EVDE SAĞLIK VE SOSYAL DESTEK HİZMETİ-Evde Muayene",
      "type":"Belediye",
      "target_audience":"Bedensel engelli ve 65 yaş üzeri bireyler",
      "criteria":[
          "Engelli ve/veya 65 yaş üzeri olmak, Ataşehir'de ikamet etmek"
          "Enjeksiyon uygulamaları"
      ],
      "telephone_number":"444 45 70",
      "duration":"Bu hizmete 7 gün 24 saat 444 45 70 numaralı çağrı merkezimizden \nulaşabiliyor ancak randevu oluşturmak gerekiyor.",
      "latitude":null,
      "longitude":null},

    {"address":"-",
      "name":"Ataşehir Belediyesi - EVDE SAĞLIK HİZMETLERİ - Evde Kişisel Bakım Hizmetleri",
      "type":"Belediye",
      "target_audience":"Bedensel engelli ve 65 yaş üzeri bireyler",
      "criteria":[
         "Bu hizmet evde yalnız yaşayan 65 yaş üstü, kronik rahatsızlığı olan, engelli ve kendi başına bu işlemleri yapamayacak durumda olan vatandaşlarımız için veriliyor."
        ],
      "telephone_number":"444 45 70",
      "duration":"Hafta içi her gün 09.00 - 17.00",
      "latitude":null,
      "longitude":null},

    {"address":"-",
      "name":"Ataşehir Belediyesi-SOSYAL ALARM SİSTEMİ HİZMETİ",
      "type":"Belediye",
      "target_audience":"Bedensel engelli ve 65 yaş üzeri bireyler",
      "criteria":[
        "Engelli ve 65 yaş üzeri Ataşehirliler",
" Not: Evlere kurduğumuz sosyal alarm sistemi ile sadece bir tuşa basarak, 7 gün 24 saat sağlık ve sosyal destek hizmetlerimizden ücretsiz olarak yararlanılabiliyor. Sabit telefon hattı üzerinden çalışan sosyal alarm sistemimiz ile;"
"-Tek tuşla çağrı merkezine bağlanarak, sesli görüşme yapabilir,"
"- Acil ve konuşamayacak durumda olsanız bile, sadece tek bir tuşa basarak yardım isteğini çağrı merkezimize ulaştırabilirsiniz."
    "Sosyal Alarm Sistemi, hastamız butona bastığı anda devreye giriyor. Hastanın adres ve konum bilgileri, anında merkezimize ulaşıyor. Yaşanan bu tür durumlarda hastamızı sözlü olarak sakinleştirmeye çalışıyor ve gerekli durumlarda harekete geçildiğine dair sözlü bilgilendirmede yaparak müdehalede bulunuyoruz."
      ],
      "telephone_number":"444 17 00/444 45 70",
      "duration":"7 gün 24 saat",
      "latitude":null,
      "longitude":null},

    {"address":"Cengiz Topel Cad. No: 11 Küçükbakkalköy–Ataşehir/İstanbul",
      "name":"DOÇ. DR. BAHRİYE ÜÇOK HASTA KONUK EVİ",
      "type":"Belediye",
      "target_audience":"Hasta Konukevi’nde özellikle Anadolu yakasındaki devlet hastanelerinde \nayakta tedavi gören hastalar misafir ediliyor.",
      "criteria":[
      "Bu hizmetten yararlanmak için hasta ve yakınlarının bir devlet hastanesinde tedavi olduklarına dair belge ya da sevk kağıdı ile başvuru yapmaları gerekiyor. Konuk Hastaların ayakta tedavi görmesi şartı aranıyor. Yatarak tedavisi olmadığı için riskli hastalar Hasta Konuk Evine kabul edilemiyor.",
      " Not: Konuk Evi’nde kalmak isteyen hastalar başvurularını Türkan Saylan Tıp Merkezi’ne ya da www.atasehir.bel.tr internet adresindeki iletişim numaralarından yapabiliyorlar."
      ],
      "telephone_number":"216 572 15 84",
      "duration":"Hasta Konuk Evi’ne başvurular \nsaat 17.00’a kadar alınıyor.",
      "latitude":40.97991128091252,
      "longitude":29.117651664660873},


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
      "longitude":28.886497726022547},

    {"address":"19 Mayıs Mh. 2. Ilgın Sk. No:29 Nilüfer/ BURSA",
      "name":"İnci ve Taner Altınmakas Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
        "Kendi gereksinimlerini karşılamasını engelleyici bir rahatsızlığı olmamak",
        "Akıl ve ruh sağlığı yerinde olmak",
        "Bulaşıcı hastalığı olmamak",
        "Uyuşturucu madde ya da alkol bağımlısı olmamak"
      ],
      "telephone_number":"0224 413 5073",
      "duration":"00.00 - 24.00",
      "latitude":40.22353531552986,
      "longitude":28.888511226136792},

    {"address":"Çamlıca Mah. Kavakdere Cad. Begüm Sok. No:18 Nilüfer/Bursa",
      "name":"İzzet Şadi Sayarel Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
        "Akıl ve ruh sağlığı yerinde olmak",
        "Bulaşıcı hastalığı olmamak",
        "Uyuşturucu madde ya da alkol bağımlısı olmamak",
        "Resmi evlilik birliği devam eden kişilerin eşlerinden dilekçe almak",
        "Toplu yaşam koşullarını etkileyecek düzeyde sabıka kaydı olmaması",
        "Toplu yaşam koşullarını etkilemeyecek düzeyde sabıka kaydı olması durumunda şartlı kabul dilekçesi alınır"
        ],
      "telephone_number":"0224 504 0203",
      "duration":"00.00 - 24.00",
      "latitude":40.193377806604,
      "longitude":28.97611435497109},

    {"address":"Özlüce Mahallesi Okul Caddesi No:13 Nilüfer/BURSA",
      "name":"Lions & Ercan Dikencik Alzheimer Hasta Konuk Evi",
      "type":"Belediye(ücretli Günlük150TL,Aylık4500TL)",
      "target_audience":"Yaşlı-Alzheimer",
      "criteria":[
        "Yaş sınırı yok",
        "Alzheimer tanısı almış olması",
        "Hastalığın başlangıç ve orta evresinde olması (Sağlık raporu)"
        ],
      "telephone_number":"(0224) 413 13 02",
      "duration":"00.00 - 24.00",
      "latitude":40.23950180725445,
      "longitude":28.9056164973019},

    {"address":"Değirmenlikızık Mah. Huzurevi Cad. 54/1-A Yıldırım, Bursa",
      "name":"BURSA BÜYÜKŞEHİR BELEDİYE BAŞKANLIĞI - HACI BULDUK ÇELİK",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
        "60 yaşı doldurmuş olmak",
        "Kendi öz bakımını gerçekleştirebilir  durumda olmak",
        "Akıl ve ruh sağlığı yerinde olmak",
        "Herhangi bir bulaşıcı hastalığa sahip olmamak"
      ],
      "telephone_number":"0224 716 31 00",
      "duration":"00.00 - 24.00",
      "latitude":40.17432674791703,
      "longitude":29.111791997299804},

    {"address":"Değirmenlikızık Mah. Huzurevi Cad. 54/1-A Yıldırım, Bursa",
      "name":"Fethiye Dörtçelik Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı-Engelli",
      "criteria":[
        "60 yaşın üzerindeki bakıma muhtaç veya sosyal güvencesi olmayan",
        "kimsesiz",
        "özürlü-engelli yaşlılar"
      ],
      "telephone_number":"0224 716 31 00",
      "duration":"00.00 - 24.00",
      "latitude":40.174277561432994,
      "longitude":29.111802726135167},

    {"address":"Yenigün, 16900 Yenişehir/Bursa",
      "name":"Bursa Yenişehir Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Belediye",
      "target_audience":"Yaşlı-Engelli",
      "criteria":[
        "60 yaşın üzerindeki bakıma muhtaç veya sosyal güvencesi olmayan",
        "madde bağımlılığı olmayan",
        "kimsesiz",
        "özürlü-engelli yaşlılar"
      ],
      "telephone_number":"0224 772 1116",
      "duration":"00.00 - 24.00",
      "latitude":40.27775380479703,
      "longitude":29.645170795657183},

    {"address":"Nalınlar, 16980 Orhaneli/Bursa",
      "name":"Dilruba evleri insanlık köyü",
      "type":"Derneğe bağlı özel(ücretli) kuruluş",
      "target_audience":"Yaşlı",
      "criteria":[
        "55 yaşın üzerindeki kadınlarda bakımevi hizmeti",
        "erkeklerde bakımevi ve huzurevi",
      ],
      "telephone_number":"0532 540 8038",
      "duration":"00.00 - 24.00",
      "latitude":40.02456166757298,
      "longitude":28.895299174843974},

    {"address":"Demirtaş Cumhuriyet, 16245, 16100 Osmangazi/Bursa",
      "name":"Bakım ve Rehabilitasyon  Merkezi (BAREM)",
      "type":"Belediye",
      "target_audience":"Alzeimer- yaşlı-zihinsel ve bedensel engelli-evsizler",
      "criteria":[
      ],
      "telephone_number":"Bilinmiyor",
      "duration":"Bilinmiyor",
      "latitude":40.197871712344934,
      "longitude":29.193582526135824},

    {"address":"Alipaşa, 1. Merve Sk. 2/2, 16040 Osmangazi/Bursa",
      "name":"Şukufe Hamdi Sami Gökçen Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
      ],
      "telephone_number":"(0224) 221 70 47",
      "duration":"Bilinmiyor",
      "latitude":40.17939043935218,
      "longitude":29.061602168464447},

    {"address":"Yeniceköy mahallesi Rauf Denktaş cd. no:39, 16400 İnegöl/Bursa",
      "name":"İnegöl Belediyesi Fatma Göztepe Huzurevi ve Aşevi",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
      ],
      "telephone_number":"(0224) 713 59 04",
      "duration":"Bilinmiyor",
      "latitude":40.0913634114339,
      "longitude":29.41866153962626},

    {"address":"Selçuk, 16860 İznik/Bursa",
      "name":"İznik Belediyesi Ülker Aktar Huzurevi ve Yaşlı Bakım Merkezi",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
        "60 yaşı doldurmuş olmak",
        "Kendi öz bakımını gerçekleştirebilir durumda olmak",
        "Akıl ve ruh sağlığı yerinde olmak",
        "Herhangi bir bulaşıcı hastalığa sahip olmamak"
      ],
      "telephone_number":"(0224) 757 72 14",
      "duration":"Bilinmiyor",
      "latitude":40.42148374653927,
      "longitude":29.714252691407605},

    {"address":"Cuma, Huzurevi Cad. No:54 D:1/a, 16740 Keles/Bursa",
      "name":"Bursa Büyükşehir Belediyesi Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
       ],
      "telephone_number":"(0224) 364 19 76",
      "duration":"Bilinmiyor",
      "latitude":39.91377535378206,
      "longitude": 29.22935852769715},
  ],
  "Trabzon":[
    {"address":"Soğuksu Mahallesi Huzur Cad. No:18/A Ortahisar/ Trabzon",
      "name":"Huzurevi, Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Yaşlı",
      "criteria":[
      ],
      "telephone_number":"+90 (462) 231 0529",
      "duration":"7 gün 24 saat ",
      "latitude":40.98960916857994,
      "longitude": 39.69627649636202},

    {"address":"Soğuksu Mah. Yarım Sakal Cad. Uygur Sok. No:2 Ortahisar/Trabzon",
      "name":"Trabzon Köşk Huzurevi Müdürlüğü",
      "type":"Huzurevi",
      "target_audience":"Yaşlı",
      "criteria":[
      ],
      "telephone_number":"+90 (462) 231 1390",
      "duration":"7 gün 24 saat ",
      "latitude":40.976950629243966,
      "longitude": 39.701214507217244},
  ],
  "Kocaeli":[
    {"address":"Yenişehir, 18, Ateş Böceği Sk., 41050 İzmit/ Kocaeli",
      "name":"Kocaeli Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
      ],
      "telephone_number":"2623253066",
      "duration":"24 saat",
      "latitude":40.78129663095729,
      "longitude": 29.97134169561978},
    {"address":"Turgut, Huzurevi Sk. No:5, 41200 İzmit/ Kocaeli",
      "name":"Kocaeli Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı",
      "criteria":[
      ],
      "telephone_number":"2623253066",
      "duration":"24 saat",
      "latitude":40.773943344448064,
      "longitude": 29.917482066783965},

    {"address":"Sanayi, Ömer Türkçakal Blv. D:34 41040, İzmit/ Kocaeli",
      "name":"Kocaeli Büyükşehir Engelli ve Yaşlı Hizmetleri Şube Müdürlüğü",
      "type":"Belediye",
      "target_audience":"Engelli ve Yaşlı",
      "criteria":[
      ],
      "telephone_number":"2623183809",
      "duration":"08.00-17.00",
      "latitude":40.74518499160377,
      "longitude": 29.944116941692776},

    {"address":"Ömerağa, Ömerağa Mahallesi, Abdurrahman Yüksel Cad. Belsa Plaza No:9 D:A-Blok,  41300 İzmit/ Kocaeli",
      "name":"İzmit Belediyesi",
      "type":"Belediye",
      "target_audience":"Herkes",
      "criteria":[
      ],
      "telephone_number":"2623180000",
      "duration":"08.00-17.00",
      "latitude":40.764760959633804,
      "longitude": 29.92992010356992},

    {"address":"Körfez Mah. Ankara Karayolu Cad. NO:129 Valilik Binası İzmit/ Kocaeli",
      "name":"Kocaeli İl Sivil Toplumla İlişkiler Müdürlüğü",
      "type":"Belediye",
      "target_audience":"Herkes",
      "criteria":[
      ],
      "telephone_number":"02623310357-kocaeli.dernekler@içişleri.gov.tr",
      "duration":"08.00-17.00",
      "latitude":40.76466386146974,
      "longitude": 29.945585866783436},

    {"address":"İzmit Yürüyüş yolu, Kuyumcular Çarşısı üstü Fevziye Camii karşısı. Belediye işhanı 2.kat no:75, 41500 İzmit/Kocaeli",
      "name":"Kocaeli Sağlık Çalışanları Derneği (Sağlıkça)",
      "type":"Dernek",
      "target_audience":"Sağlık",
      "criteria":[
      ],
      "telephone_number":"5550414111",
      "duration":"24 saat",
      "latitude":40.762195229207805,
      "longitude": 29.926609037947934},

  ],
  'İzmir':[
    {"address":"Aydoğdu Mahallesi 1263 Sokak No:1 D Evka -1 Buca İZMİR",
      "name":"Zübeyde Hanım Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlılar",
      "criteria":[
        "Kabul Şartları"
        "1- Huzurevi bölümüne kabul koşulları"

        "60 ve üzeri yaşta,"
        "Günlük yaşama faaliyetlerini (yeme, içme, tuvalet gibi) bağımsız yapabilecek nitelikte"
        "Yatalak ya da devamlı yatarak tıbbi tedavi ve bakıma ihtiyacı olmamak"
        "Beden fonksiyonlarında kendi ihtiyacını karşılamasına engel olacak sakatlığı ve bir hastalığı bulunmamak"
        "Ruh sağlığının yerinde olması"
        "Bulaşıcı ve sürekli tedaviyi gerektiren ağır hastalıklara sahip olmamak"
        "Uyuşturucu madde kullanmamak ve alkol bağımlısı olmamak"
        "Sosyal ve ekonomik yoksunluk içinde bulunduğu “Sosyal İnceleme Raporu” ile saptanmış olmak"

        "2- Bakım ve rehabilitasyon bölümüne kabul koşulları"

        "60 ve daha yukarı yaşlarda olmak"
        "Bedensel ve zihinsel gerilemeleri nedeniyle süreli ya da sürekli olarak ilgiye, desteğe, korunmaya ve rehabilitasyona gereksinimi olmak,"
        "Ruh sağlığı yerinde olmak,"
        "Uyuşturucu madde kullanmamak ve alkol bağımlısı olmamak"
        "Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu sosyal inceleme raporu ile saptanmış olmak."

        "Başvuru Evrakları"
        "Başvuru Dilekçesi"
        "Nüfus Cüzdan Aslı ve Fotokopisi"
        "SGK Gelir Dökümü"
        "4 Adet Fotoğraf"
        "Sağlık Kurulu Raporu (Huzurevine Yerleşme Aşamasında)"
      ],
      "telephone_number":"Tel :0232 293 97 07  Faks:0.232 293 96 10",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.40243906592842,
      "longitude": 27.15157283795505},


    {"address":"Kuvvetli, 35763 Ödemiş/İzmir",
      "name":"Mutahhar Şerif Başoğlu Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlılar",
      "criteria":[
        "* 60 yaşının üzerinde olmak   * bakıma muhtaç olmak"
      ],
      "telephone_number":"0232 544 36 33",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.232153103210685,
      "longitude": 27.963435349590473},

    {"address":"Atatürk, Şht. Er Ercüment Bozdoğan Cd. No:25, 35920 Selçuk/İzmir",
      "name":"Akıncılar Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlılar",
      "criteria":[
       "Yaşlı Kabulü İçin Gerekli Şartlar:"
"60 yaş ve üzeri yaşlarda olmak,"
    "Kendi gereksinimlerini karşılamasını engelleyici bir rahatsızlığı bulunmamak yeme, içme, banyo, "
"tuvalet ve bunun gibi günlük yaşam etkinliklerini bağımsız olarak yapabilecek durumda olmak,"
"Ruh sağlığı yerinde olmak,"
    "Bulaşıcı hastalığı olmamak,"
"Uyuşturucu madde ya da alkol bağımlısı olmamak,"
"Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu 'Sosyal İnceleme Raporu' ile saptanmış olmak."
"En az iki yıl Selçuk’ta ikamet etmiş olmak."
      ],
      "telephone_number":"0232 892 72 54 &&  E-posta: huzurevi@selcuk.bel.tr",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":37.944670501772954,
      "longitude": 27.366166910944003},

    {"address":"Nafiz Gürman Mah. 7160 Sok. No: 4 Bayraklı/İZMİR",
      "name":"Şehit Asteğmen Adem Dertsiz Yaşlı Bakım Ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
       "60 yaş üzerinde olmalı ve  tamamen bağımsız  bir şekilde özyeterliliğini yerine getirebilmeli"
      ],
      "telephone_number":"0232 3638083",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.478469654686165,
      "longitude": 27.138770493781298},

    {"address":"Aydoğdu mah. 1263 sk. no :5 Evka 1 Buca-İzmir",
      "name":"Nevvar Salih İşgören Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "60 yaş üzerinde olmalı ve  tamamen bağımsız  bir şekilde özyeterliliğini yerine getirebilmeli"
      ],
      "telephone_number":"0232 3747414",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.39792263923903,
      "longitude": 27.10137589562585},

    {"address":"Atatürk Mah. 174.sk No:3 Foça-İZMİR",
      "name":"Foça Reha Midilli Necla Ana Huzurevi Müdürlüğü",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "60 yaş üzerinde olmalı ve  tamamen bağımsız  bir şekilde özyeterliliğini yerine getirebilmeli"
      ],
      "telephone_number":"0232 8121241",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.65847288546897,
      "longitude": 26.753346266804378},

    {"address":"Atatürk Mah. 174.sk No:3 Foça-İZMİR",
      "name":"Foça Reha Midilli Necla Ana Huzurevi Müdürlüğü",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "60 yaş üzerinde olmalı ve  tamamen bağımsız  bir şekilde özyeterliliğini yerine getirebilmeli"
      ],
      "telephone_number":"0232 8121241",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.65847288546897,
      "longitude": 26.753346266804378},

    {"address":"Hasan Tahsin Cad. 219. Sok. No: 3 Basınsitesi-Karabağlar- İzmir",
      "name":"İzmir Huzurevi Yaşlı Bakım Ve Rehabilitasyon Merkezi Müdürlüğü",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "60 yaş üzerinde olmalı ve  tamamen bağımsız  bir şekilde özyeterliliğini yerine getirebilmeli"
      ],
      "telephone_number":"0232 2434460",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.396385165829216,
      "longitude": 27.101983147199213},

    {"address":"Huzur Mah. Öğretmenler Sk. No:7 Narlıdere-İzmir",
      "name":"Narlıdere Huzurevi Yaşlı Bakım Ve Rehabilitasyon Merkezi Müdürlüğü",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "60 yaş üzerinde olmalı ve  tamamen bağımsız  bir şekilde özyeterliliğini yerine getirebilmeli"
      ],
      "telephone_number":"0232 9712525",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.393972074950774,
      "longitude": 26.993905449047976},

    {"address":"Cumhuriyet Mah. 2026 Sk No:5 Torbalı/İzmir",
      "name":"Torbalı Huzurevi Yaşlı Bakım Ve Rehabilitasyon Merkezi Müdürlüğü",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "60 yaş üzerinde olmalı ve  tamamen bağımsız  bir şekilde özyeterliliğini yerine getirebilmeli"
      ],
      "telephone_number":"0232 8555222",
      "duration":"Hafta içi:08.30-17.00",
      "latitude":38.162693685049526,
      "longitude": 27.34847453794218},
  ],
  'Aydın':[
        {"address":"Yeni Mahalle. 850. Sokak. No:3/A. Didim – AYDIN",
      "name":"Aydın Büyükşehir Belediyesi Didim Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlılar",
      "criteria":[
        "60 yaş üstü sağlıklı bireyler. ",
        "Kurumun Sunduğu Psikososyal Hizmetler: Sosyal aktiviteler (piknik vs. ) psikoeğitimler, psikolog görüşmeleri",
      ],
      "telephone_number":"+902568110929",
      "duration":"7/24",
      "latitude":37.3720641,
      "longitude": 27.2730650},
  {"address":"Efeler Mah. Evliya Çelebi Cad. 30 Efeler, Aydın ",
      "name":"Aydın Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "Bakıma muhtaç veya sosyal güvencesi olmayan, kimsesiz, özürlü-engelli yaşlılar kuruma başvuruda bulunabilirler. \nEmekli Sandığı, SSK, Bağ-Kur emeklileri ise cüzi bir oda ücreti ödeyerek huzur evinde kalabiliyorlar.",
        "Kurumun Sunduğu Psikososyal Hizmetler: huzurevinde konaklama ve yemek hizmeti, sağlık kontrolleri, fiziksel bakım ve rehabilitasyon hizmeti, geziler, sosyal ve kültürel faaliyetler…",
      ],
      "telephone_number":"+902568110929",
      "duration":"7/24",
      "latitude":37.8420749,
      "longitude": 27.8267238},

      {"address":"Adnan Menderes Mahalllesi. 1028. Sokak. No: 28. Akbük, Didim – AYDIN",
      "name":"Aydın Akbük Huzurevi",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
 "Bakıma muhtaç veya sosyal güvencesi olmayan, kimsesiz, özürlü-engelli yaşlılar kuruma başvuruda bulunabilirler. Emekli Sandığı, SSK, Bağ-Kur emeklileri ise, kaldıkları yerin özelliklerine göre değişen tek veya çift kişilik oda ücreti ödeyerek huzur evinde kalabiliyorlar.",
      ],
      "telephone_number":"+90(256)8565055",
      "duration":"7/24",
      "latitude":37.4069776,
      "longitude": 27.4283594},

        {"address":"Yenicamii Mahallesi. İkinci Bahar Sokak. No:6. Söke – AYDIN",
      "name":"Aydın Söke Hilmi Fırat Huzurevi",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "Bakıma muhtaç veya sosyal güvencesi olmayan, kimsesiz, özürlü-engelli yaşlılar kuruma başvuruda bulunabilirler. Emekli Sandığı, SSK, Bağ-Kur emeklileri ise, kaldıkları yerin özelliklerine göre değişen tek veya çift kişilik oda ücreti ödeyerek huzur evinde kalabiliyorlar.",
        "Kurumun Sunduğu Psikososyal Hizmetler: Huzurevinde konaklama ve yemek hizmeti, sağlık kontrolleri, geziler,  sosyal ve kültürel faaliyetler…",
       ],
      "telephone_number":"+902565187352",
      "duration":"7/24",
      "latitude":37.7597143,
      "longitude": 27.4230290},

      {"address":"Girne Mah. 2185 Sok. 1 Aydın Merkez, Aydın ",
      "name":"AYDIN AİLE VE SOSYAL POLİTİKALAR MÜDÜRLÜĞÜ - HUZUREVİ YAŞLI BAKIM VE REHABİLİTASYON MERKEZİ",
      "type":"Huzurevi",
      "target_audience":"Yaşlılar",
      "criteria":[
        "Bakıma muhtaç veya sosyal güvencesi olmayan, kimsesiz, özürlü-engelli yaşlılar kuruma başvuruda bulunabilirler. Emekli Sandığı, SSK, Bağ-Kur emeklileri ise, kaldıkları yerin özelliklerine göre değişen tek veya çift kişilik oda ücreti ödeyerek huzur evinde kalabiliyorlar.",
        "Kurumun Sunduğu Psikososyal Hizmetler: Huzurevinde konaklama ve yemek hizmeti, sağlık kontrolleri, geziler,  sosyal ve kültürel faaliyetler…",
       ],
      "telephone_number":"+902562191873",
      "duration":"7/24",
      "latitude":37.8480477,
      "longitude": 27.8254352},
      
  ],
  'Konya':[
    {"address":"Köyceğiz Mahallesi. Köyceğiz Caddesi. Meram – KONYA",
      "name":"Konya Dr.İsmail Işık Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Belediye",
      "target_audience":"60 yaş üstü bireyler",
      "criteria":[
        "Bakıma muhtaç veya sosyal güvencesi olmayan, kimsesiz, özürlü-engelli yaşlılar kuruma başvuruda bulunabilirler. Emekli Sandığı, SSK, Bağ-Kur emeklileri ise cüzi bir oda ücreti ödeyerek huzurevinde kalabiliyorlar.",
        "Kurumun Sunduğu Psikososyal Hizmetler: huzurevinde konaklama ve yemek hizmeti, sağlık kontrolleri, fiziksel bakım ve rehabilitasyon hizmeti, geziler, sosyal ve kültürel faaliyetler…",
      ],
      "telephone_number":"(332) 325 04 25",
      "duration":"7/24",
      "latitude":37.8625536,
      "longitude": 32.4242067},

      {"address":"Sille,Piribeyli Sok. No:5 42132 Selçuklu",
      "name":"Sille Meliha Ercan Huzurevi",
      "type":"Belediye",
      "target_audience":"60 yaş üstü bireyler",
      "criteria":[
        "Devletin kabul gördüğü huzurevi kriterleri. Bulaşıcı hastalığı olmamalı ve psikozu olmamalı. ",
        "Kurumun Sunduğu Psikososyal Hizmetler: Psikososyal değerlendirme, birebir görüşme, psikiyatrik tanısı olan hastalara psikiyatri takibi gerekli ise ilaç ve terapi desteği. ",
      ],
      "telephone_number":"(332) 325 04 25",
      "duration":"7/24",
      "latitude":37.930979,
      "longitude": 32.4240836},
  ],
  'Erzurum':[

    {"address":"yeğen ağa iş merkezi 3.kat kazım karabekir paşa mah. Yakutiye erzurum ",
      "name":"ERZURUM BELEDİYESİ HAYIR ÇARŞISI",
      "type":"Belediye",
      "target_audience":"İHTİYAÇ SAHİBİ OLAN HERKESE",
      "criteria":[
          "TÜM İLÇELER İÇİN GEÇERLİ,",
       ],
      "telephone_number":"0442 215 09 09",
      "duration":"HAFTA İÇİ 8.00-17.00",
      "latitude":39.91030059058323,
      "longitude": 41.28098757496138},

       {"address":"erzurum belediyesi beyaz masa merkezi yönetim caddesi251000 ERZURUM",
      "name":"ERZURUM BELEDİYESİ ENGELLİ BİRİMİ",
      "type":"Belediye",
      "target_audience":"Emekli parası almayan yaşlı ,engelli bireyler,",
      "criteria":[
          "TÜM İLÇELER İÇİN GEÇERLİ,",
       ],
      "telephone_number":"0442 344 11 35/engelli.hizmetleri@erzurum.bel.tr",
      "duration":"HAFTA İÇİ 8.00-17.00",
      "latitude":39.90468193164019,
      "longitude": 41.261757388202334},

      {"address":"Rabiana Mahallesi Atatürk Lisesi Sok. No:1 Yakutiye Erzurum",
      "name":"ERZURUM SOSYAL HİZMETLER İL MÜDÜRLÜĞÜ",
      "type":"DARÜLACEZE DESTEĞİ İLE",
      "target_audience":"YAŞLI , ENGELLİ ",
      "criteria":[
          "YAKUTİYE SINIRLARI İÇERİSİNDE YAŞIYOR OLMAK",
       ],
      "telephone_number":"0442 234 15 41/0442 234 15 43/ erzurum@ailevecalisma.gov.tr",
      "duration":"HAFTA İÇİ 8.00-17.00",
      "latitude":39.89943183946708,
      "longitude": 41.27721683416921},

      {"address":"SELÇUKLU MAH. BELEDİYE ÖNÜ SOK. NO:1 AZİZİYE ERZURUM",
      "name":"AZİZİYE BELEDİYESİ",
      "type":"BELEDİYE",
      "target_audience":"İHTİYAÇ SAHİBİ VE YAŞLI OLMAK",
      "criteria":[
          "AZİZİYE SINIRLARI İÇERİSİNDE YAŞIYOR OLMAK",
       ],
      "telephone_number":"444 91 25/aziziye@erzurumaziziye.bel.tr",
      "duration":"HAFTA İÇİ 8.00-17.00",
      "latitude":39.94651737076235,
      "longitude": 41.10543494972458},
  ],
  'Eskişehir':[

     {"address":"Ankara Yolu 14.Km Odunpazarı / ESKİŞEHİR",
      "name":"Halis Toprak Huzurevi Yaşlı  Bakım ve Rehabilitasyon Merkezi",
      "type":"Aile ve Sosyal Hizmetler Bakanlığı",
      "target_audience":"",
      "criteria":[
          "(Huzurevi ve Yaşlı Bakım Rehabilitasyon Merkezleri Yönetmeliğine göre) \n1. 60 ve üzeri yaşlarda olmak \n2. Bedensel ve zihinsel gerilemeleri nedeniyle süreli ya da sürekli olarak özel ilgi, desteğe, korunmaya ve rehabilitasyona gereksinimi olmak \n3. Ruh sağlığı yerinde olmak \n4. Bulaşıcı hastalığı olmamak \n5. Uyuşturucu madde ya da alkol bağımlısı olmamak \n6. Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu sosyal inceleme raporu ile saptanmış olmak",
          "\nKurumun Sunduğu Psikososyoal Hizmetler: yok, durumu ağır yaşlılar olduğu için rehabilitasyon merkezlerinde pek olmuyor",
        ],
      "telephone_number":"0222 2282047",
      "duration":"Devamlı 0:00-24:00",
      "latitude":39.737773520581605,
      "longitude": 30.63317736931177},

      {"address":"Huzur Mh. Yıldızlar Sk. No: 44 Aile ve Sosyal Hizmetler Kampüsü Odunpazarı / ESKİŞEHİR",
      "name":"Hacı Süleyman Çakır Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Aile ve Sosyal Hizmetler Bakanlığı",
      "target_audience":"",
      "criteria":[
          "(Huzurevi ve Yaşlı Bakım Rehabilitasyon Merkezleri Yönetmeliğine göre) \n1. 60 ve üzeri yaşlarda olmak \n2. Bedensel ve zihinsel gerilemeleri nedeniyle süreli ya da sürekli olarak özel ilgi, desteğe, korunmaya ve rehabilitasyona gereksinimi olmak \n3. Ruh sağlığı yerinde olmak \n4. Bulaşıcı hastalığı olmamak \n5. Uyuşturucu madde ya da alkol bağımlısı olmamak \n6. Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu sosyal inceleme raporu ile saptanmış olmak",
          "\nNOT: telefonda bilgi vermek için il müdürlüğünden izin istiyorlar - kurum psikologu ile konuşuldu",
        ],
      "telephone_number":"0222 310 05 18",
      "duration":"Devamlı 0:00-24:00",
      "latitude":39.761031378467685,
      "longitude": 30.543252180058417},


      {"address":"Vadişehir Mah. Tekin Alp Cd. No:73 ",
      "name":"Lütfi Yüksel Yaşlı Bakım Merkezi",
      "type":"Belediye",
      "target_audience":"55 yaş ve üzeri, ruh sağlığı yerinde olup,  bulaşıcı hastalığı olmayan, yatağa bağımlı ya da fiziksel ve zihinsel gerilemeleri nedeniyle  özel ilgi, destek ve koruma gerektiren yaşlılar",
      "criteria":[
          "(Huzurevi ve Yaşlı Bakım Rehabilitasyon Merkezleri Yönetmeliğine göre) \n1. 55 ve üzeri yaşlarda olmak \n2. Bedensel ve zihinsel gerilemeleri nedeniyle süreli ya da sürekli olarak özel ilgi, desteğe, korunmaya ve rehabilitasyona gereksinimi olmak \n3. Ruh sağlığı yerinde olmak \n4. Bulaşıcı hastalığı olmamak \n5. Uyuşturucu madde ya da alkol bağımlısı olmamak \n6. Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu sosyal inceleme raporu ile saptanmış olmak",
          "\nNOT: telefonda bilgi vermek için il müdürlüğünden izin istiyorlar",
        ],
      "telephone_number":"0222 237 25 93",
      "duration":"Devamlı 0:00-24:00",
      "latitude":39.73728537840351,
      "longitude": 30.54850906671364},
    

    {"address":"Huzur Mh. Yıldızlar Sk. No: 44 Aile ve Sosyal Hizmetler Kampüsü Odunpazarı / ESKİŞEHİR",
      "name":"Maide Bolel Huzurevi",
      "type":"Aile ve Sosyal Hizmetler Bakanlığı",
      "target_audience":"60 yaş ve üzerindeki sosyal ve/veya ekonomik yönden yoksunluk içinde olup, korunmaya, bakıma ve yardıma muhtaç olan kişiler",
      "criteria":[
          "(Huzurevi ve Yaşlı Bakım Rehabilitasyon Merkezleri Yönetmeliğine göre) \n1. 60 ve üzeri yaşlarda olmak \n2. Bedensel ve zihinsel gerilemeleri nedeniyle süreli ya da sürekli olarak özel ilgi, desteğe, korunmaya ve rehabilitasyona gereksinimi olmak \n3. Ruh sağlığı yerinde olmak \n4. Bulaşıcı hastalığı olmamak \n5. Uyuşturucu madde ya da alkol bağımlısı olmamak \n6. Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu sosyal inceleme raporu ile saptanmış olmak",
          "\nNOT: telefonda bilgi vermek için il müdürlüğünden izin istiyorlar",
        ],
      "telephone_number":"0222 219 08 82",
      "duration":"Devamlı 0:00-24:00",
      "latitude":39.758750660628344,
      "longitude": 30.534368066714876},



       {"address":"Emek Mh. Bengül Sk.(Zümrüt Parkı içi) No: 1, 26080, Odunpazarı/Eskişehir",
      "name":"Koca Çınar Yaşam Merkezi",
      "type":"Odunpazarı Belediyesi Kadın ve Aile Hizmetleri Müdürlüğü",
      "target_audience":"60 Yaş ve üzeri ",
      "criteria":[
              "Psikososyal Hizmetler: Bireylerin fiziksel, ruhsal durumlarına bağlı olarak beceri ve el sanatları, resim, tiyatro, hafıza oyunları, kütüphane gibi kültürel faaliyetlerin yanı sıra psikolojik destek, sağlıklı yaşlanmaya yönelik aktivite-eğitim çalışmaları yapılıyor.",
              "NOT: telefonda bilgi vermek için müdürlüğü aramamızı istediler"
       ],
      "telephone_number":"0 222 213 3030 – 3066",
      "duration":"08:00 - 17.00",
      "latitude":39.74497271236882,
      "longitude": 30.570754526701688},



      {"address":"Kadir Akkaş (Üniversite Evleri) Halk Merkezi: Gültepe Mahallesi Üniversite Evleri Nusret Sokak No:B2",
      "name":"Koca Çınar Yaşam Merkezi - 2",
      "type":"Odunpazarı Belediyesi Kadın ve Aile Hizmetleri Müdürlüğü",
      "target_audience":"60 Yaş ve üzeri ",
      "criteria":[
              "Psikososyla Hizmetler: Çok amaçlı salon, faaliyet salonu, kuaför salonu, sağlık birimi, mescit, yemek salonu, mutfak, hobi bahçesi ve kütüphanenin bulunduğu Koca Çınar 2’de, kıdemli vatandaşların üretmeleri ve eğlenmeleri için de çeşitli aktiviteler düzenleniyor.",
       ],
      "telephone_number":"0 222 237 12 86",
      "duration":"08:00 - 17.00",
      "latitude":39.743405160648415,
      "longitude": 30.511455767180795},


      {"address":"Şirintepe Mh.,Orhan Kemal Sk. No:1, 26200 Tepebaşı/Eskişehir, Türkiye",
      "name":"Safiye Gönül Bayar Huzurevi",
      "type":"Aile ve Sosyal Hizmetler Bakanlığı ",
      "target_audience":"Genelde daha önce çalışma hayatı olmuş, kendi özbakımlarını vs. yapabilen nispeten sağlıklı kişiler",
      "criteria":[
      "1. 60 ve üzeri yaşlarda olmak \n2. Bedensel ve zihinsel gerilemeleri nedeniyle süreli ya da sürekli olarak özel ilgi, desteğe, korunmaya ve rehabilitasyona gereksinimi olmak \n3. Ruh sağlığı yerinde olmak \n4. Bulaşıcı hastalığı olmamak \n5. Uyuşturucu madde ya da alkol bağımlısı olmamak \n6. Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu sosyal inceleme raporu ile saptanmış olmak",
      "Sunulan Psikososyal Hizmetler: Kurumda bir sosyal çalışmacı ve bir psikolog bulunmakta. En az ayda bir kez olmak üzere hava şartlarına da bağlı olarak etkinlikler (piknik, gezi, vs.) Dışarıdan gelen gönüllü grupların yürüttüğü etkinlikler Özel günlerde etkinlikler (anneler/babalar günü, yaşlılar haftası vs.) Yeni gelen bir yaşlının ilk 1 ayı oryantasyontasyon süreci olarak değerlendirilip gerek görüldüğü şekilde takip ediliyor  Kişilerarası problemler ortaya çıktığında görüşmeler yapılıyor Bunların dışında rutin yok, gerek görüldükçe görüşme ve destek sağlanıyor."
      ],
      "telephone_number":"0222 325 04 91",
      "duration":"Devamlı 00:00-24:00",
      "latitude":39.80193583402099,
      "longitude": 30.487556084656042},
      


      {"address":"Namık Kemal, Hayat Cd. Ar., 10405 Tepebaşı/Eskişehir, Türkiye",
      "name":"Alzheimer Konukevi ve Yaşam Köyü",
      "type":"Belediye",
      "target_audience":"sadece Alzheimer hastaları",
      "criteria":[
      "1. 60 ve üzeri yaşlarda olmak \n2. Bedensel ve zihinsel gerilemeleri nedeniyle süreli ya da sürekli olarak özel ilgi, desteğe, korunmaya ve rehabilitasyona gereksinimi olmak \n3. Ruh sağlığı yerinde olmak \n4. Bulaşıcı hastalığı olmamak \n5. Uyuşturucu madde ya da alkol bağımlısı olmamak \n6. Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu sosyal inceleme raporu ile saptanmış olmak",
      "Sunulan Psikososyal Hizmetler:  Websitesinden: Gün içerisinde psikolog ve sosyal hizmet uzmanı bulunmaktadır. Psikoloğumuz ve hasta bakım elemanlarımız tarafından hastalarla birlikte zihinsel ve bedensel faaliyetlerini güçlendirecek, sağlık durumlarına uygun eğitici etkinlikler ve yürüyüşler yapılmakta, daha etkili ve keyifli zaman geçirmeleri sağlanmaktadır. Özel günlerde (bayramlar, yaşlılar haftası, yılbaşı vb.) hastalarımızın sosyal yaşama katılımlarını ve keyifli vakit geçirmelerini sağlamak amacıyla sağlık durumlarına uygun etkinlikler düzenlenmektedir."
      "NOT: 57 villanın dönüşüm kapsamında yenilenmesi ile oluşturulan Yaşam Köyü’nde, Alzheimer hastalarını misafir edecek konukevinden, çocuklara oyun alanı oluşturan kreşe, çeşitli etkinliklerin yapılacağı beceri ve sanat atölyesinden, fizyoterapi merkezine kadar toplumun tüm kesiminin sosyal hayata katılmasına yardımcı olacak tesis bulunuyor.  Bakım desteği gereken çocukların, yaşlıların, Alzheimer ya da engelli bireylerin hem konaklayabileceği hem tedavilerini sürdürebileceği hatta sosyalleşip, istihdam edilebilecekleri bir köy kurduk."
      ],
      "telephone_number":"0222 314 07 56",
      "duration":"Devamlı 00:00-24:00",
      "latitude":39.81273306618341,
      "longitude": 30.445189459695438},


      {"address":"Camikebir Mh. Eskişehir Cd. Mihalıççık/eskişehir",
      "name":"TÜRKİYE GÜÇSÜZLER VE KİMSESİZLERE YARDIM VAKFI SELAMİ VARDAR YAŞLILAR KÖŞKÜ",
      "type":"TÜRKİYE GÜÇSÜZLER VE KİMSESİZLERE YARDIM VAKFI ",
      "target_audience":"Ailesi tarafından çeşitli sebeplerle kabul edilmeyen ve bir kurumda kalması için başvuran tüm kişiler",
      "criteria":[
        "Yaş sınırı olmadığı belirtildi ama resmi olarak huzurevi statüsünde geçiyormuş ve devlet son zamanlarda buna göre kontrol etmeye başlamış, örneğin kendi gereksinimlerini (yeme-içme gibi) karşılayamayacak durumdaki kişileri alamıyorlarmış artık.  Emekli maaşı varsa buna göre (kendi ihtiyaçlarına imkan kalacak şekilde) ücret alınıyor, emekli maaşı yoksa ücretsiz kalınabiliyor.",
       "Sunulan Psikososyal Hizmetler:  Haftada 2 gün çeşitli etkinlikler yapılıyor İhtiyaç gözlemlendiğinde, örneğin yaşlı içine kapandığında, bire bir veya grup haline görüşme yapılıyor",
      ],
      "telephone_number":"0222 631 29 00",
      "duration":"Devamlı 00:00-24:00",
      "latitude":39.984563604814795,
      "longitude": 32.86457145369996},

  ],
  'Antalya':[
       
        {"address":"Kütükçü Mahallesi Şelale Caddesi No:201 07060 Kepez/Antalya",
      "name":"Kepez Belediyesi Şefkat ve Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı ",
      "criteria":[
            "65 Yaş üstü olmak"
         ],
      "telephone_number":"(0242) 326 12 12",
      "duration":"Hafta içi ve Cumartesi 9:00-17:00",
      "latitude":36.93524590520578,
      "longitude": 30.70260595187442},

      {"address":"Yeşilbayır, 07190 Döşemealtı/Antalya",
      "name":"Antalya Büyükşehir Belediyesi, Sosyal Hizmetler Daire Başkanlığı, Döşemealtı Halil Akyüz Huzurevi",
      "type":"Belediye",
      "target_audience":"Yaşlı, Bakıma muhtaç  ",
      "criteria":[
            "65 Yaş üstü olmak",
            "Psikososyal Hizmetler: Günaydın toplantıları ve arada bireysel konuşma mevcut, birlikte etkinlik yok."
         ],
      "telephone_number":"2424431769",
      "duration":"Hafta içi ve Cumartesi 9:00-17:00",
      "latitude":36.990344958151006,
      "longitude": 30.612317065369155},

      {"address":"Güzeloba, Eski, Lara Cd. No:505, 07100 Muratpaşa/Antalya",
      "name":"Antalya Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi Müdürlüğü",
      "type":"Müdürlük",
      "target_audience":"Yaşlı, Bakıma muhtaç  ",
      "criteria":[
            "65 Yaş üstü olmak",
            "Psikososyal Hizmetler: Günaydın toplantıları, vizit, birlikte sanat etkinlikleri, bireysel konuşma ve drama mevcut"
         ],
      "telephone_number":"02423491640",
      "duration":"Hafta içi ve Cumartesi 9:00-17:00",
      "latitude":36.87787344793172,
      "longitude": 30.71566000445443},

  ],
  'Gaziantep':[
     {"address":"Gerciğin Köyü 138009 Nolu Sk. No:38  Şahinbey, Gaziantep",
      "name":"GAZİANTEP HUZUREVİ VE YAŞLI BAKIM VE REHABİLİTASYON MERKEZİ",
      "type":"HUZUREVİ",
      "target_audience":"Yaşlı ",
      "criteria":[
        ],
      "telephone_number":"0342 448 15 41",
      "duration":"Pazartesi-Cuma/ 08.30- 17.00",
      "latitude":37.06505306978645,
      "longitude": 37.24368729120081},

      {"address":"MENDERES MAH. ŞEHİT MEHMET KAYA SK. NO:8 NİZİP/GAZİANTEP ",
      "name":"GAZİANTEP NİZİP HUZUREVİ",
      "type":"HUZUREVİ",
      "target_audience":"Yaşlı ",
      "criteria":[
         ],
      "telephone_number":"+90 (342) 517 31 27",
      "duration":"Hergün 7/24",
      "latitude":37.0093152868858,
      "longitude": 37.80043365208658},

      {"address":"Küçükkızılhisar Mah. 104031 Nolu Cad. 15 Beştepe, Şahinbey, Gaziantep",
      "name":"GAZİANTEP ÜNİVERSİTESİ - NEVİN ERUSLU PALYATİF BAKIM VE UMUT EVİ",
      "type":" HUZUREVİ ve Yaşlı bakım evleri",
      "target_audience":"Yaşlı ",
      "criteria":[
         ],
      "telephone_number":"0342 472 07 10",
      "duration":"Hergün 7/24",
      "latitude":36.99184141201574,
      "longitude": 37.31024951534144},
      
      {"address":"Osmangazi Mah. 56060 Nolu Cad. Şehitkamil, Gaziantep",
      "name":"GAZİANTEP HUZUREVİ YAŞLI BAKIM VE REHABİLİTASYON MERKEZİ",
      "type":" HUZUREVİ ve Yaşlı bakım evleri",
      "target_audience":"Yaşlı ",
      "criteria":[
          ],
      "telephone_number":"0342 360 01 81",
      "duration":"Hergün 7/24",
      "latitude":37.05570271270509,
      "longitude": 37.32057191090346},
    

    {"address":"Yeditepe, Yaşam Huzurevi, 85113 Nolu Sokak, 27470 Şahinbey/Gaziantep",
      "name":"Özel Yaşam Huzurevi ve Yaşlı Bakım Merkezi",
      "type":" HUZUREVİ ve Yaşlı bakım evleri",
      "target_audience":"Yaşlı ",
      "criteria":[
         ],
      "telephone_number":"0 552 1561220",
      "duration":"Hergün 7/24",
      "latitude":37.03310677302644,
      "longitude": 37.330084968194434},

    
    {"address":"Şehirgösteren Mah. 68028 Nolu Cad. 23 Dk:1 Şehitkamil, Gaziantep",
      "name":"ÖZEL MASAL KÖY BAKIM MERKEZİ",
      "type":" HUZUREVİ ve Yaşlı bakım evleri",
      "target_audience":"Yaşlı ",
      "criteria":[
         ],
      "telephone_number":" 0 539 9110295",
      "duration":"Hergün 7/24",
      "latitude":37.0959907,
      "longitude": 37.3301636},

    {"address":"Emek, 19021.Sok. 35/1, 27500 Şehitkamil/Gaziantep",
      "name":"ÖZEL GAZİANTEP BAKIM MERKEZİ",
      "type":" HUZUREVİ ve Yaşlı bakım evleri",
      "target_audience":"Yaşlı ",
      "criteria":[
         ],
      "telephone_number":"0 3423210880",
      "duration":"Hergün 7/24",
      "latitude":37.077675896635085,
      "longitude":  37.34637447141874},


      {"address":"Güllük Mah. 2042 Nolu Sok. No:5 27200 Gaziantep",
      "name":"ELİT BAKIM MERKEZİ",
      "type":" HUZUREVİ ve Yaşlı bakım evleri",
      "target_audience":"Yaşlı ",
      "criteria":[
         ],
      "telephone_number":"0535 466 90 09- 5323945676",
      "duration":"Hergün 7/24",
      "latitude":36.97217388654108,
      "longitude": 37.513648118020264},


      {"address":"Öğretmenevleri Mah. Safi Erselim Sk. 27010 Şahinbey/Gaziantep",
      "name":"CANEL ÖZEL BAKIM MERKEZİ",
      "type":" HUZUREVİ ve Yaşlı bakım evleri",
      "target_audience":"yaşlı ve 19 yaş ve üzerindeki kadın, erkek zihinsel engelli bireyler ",
      "criteria":[
         ],
      "telephone_number":"0 3423398808",
      "duration":"Hergün 7/24",
      "latitude":37.060374796621964,
      "longitude": 37.354279185219916},


      {"address":"Pancarlı, 58002. Sk. No:6, 27060 Şehitkamil/Gaziantep",
      "name":"ÖZEL NİSA BAKIM MERKEZİ",
      "type":" HUZUREVİ ve Yaşlı bakım evleri",
      "target_audience":"yaşlı ve 19 yaş ve üzerindeki kadın, erkek zihinsel engelli bireyler ",
      "criteria":[
         ],
      "telephone_number":"0532 175 23 52",
      "duration":"Hergün 7/24",
      "latitude":37.07229958899236,
      "longitude": 37.34076976004579},

  ],
  'Ankara':[
    
     {"address":"Ehlibeyt, Tekstilciler Cd. No:10, 06520 Çankaya/Ankara",
      "name":"Kızılay Ankara Şubesi",
      "type":"Kamu yararına çalışan kurum",
      "target_audience":"İhtiyaç sahibi tüm bireyler",
      "criteria":[
        'İhtiyaç sahibi olmak'
        'Psikososyal Hizmetler: Nakti ve Ayni Yardım (Sıcak Yemek, Düzenli Aylık, Giysi, Tekerlekli Sandalye, Barınma, Sağlık Yardımı)'
        ],
      "telephone_number":" (0312) 311 35 74",
      "duration":"Haftaiçi 9.00-17.00",
      "latitude":39.89548941113744,
      "longitude": 32.814957271164324},

      {"address":"Hanımeli Sokak No:1/A Sıhhiye",
      "name":"Çankaya Sosyal Dayanışma Ve Yardımlaşma Vakfı",
      "type":"Kamu kurumu",
      "target_audience":"65 yaş ve üstündeki yaşlı vatandaşlar,TC vatandaşı kadınlar",
      "criteria":[
        '"TC vatandaşı olmak 65 yaşını doldurmuş olmak Nafaka almıyor olmak. Herhangi bir sosyal güvenceye tabi olmamak(Emekli Sandığı, SSK ya da Bağkur sigorta kollarından birine bağlı olmamak) Herhangi bir düzenli gelire sahip olmamak En az asgari ücretle sigortalı bir işte çalışmıyor olmak Herhangi bir bireysel sağlık sigortası sahibi olmamak Üzerine kayıtlı gelir getirici değerli menkul ya da gayrimenkul sahibi olmamak Sosyal Hizmetler Kanunu kapsamında harçlık alıyor olmamak'
         'Son resmi nikâhlı eşi vefat etmiş, evli olmayan, kendisi ya da içinde bulunduğu hanedeki herhangi bir kişi kanunla kurulu sosyal güvenlik kuruluşlarına tabi olmayan, fakir ve muhtaç durumda olduğu Mütevelli Heyeti kararıyla tespit edilen kadınlar, 2022 sayılı kanuna göre engelli ve/veya 65 yaş aylığı alanların aynı zamanda dul aylığından da yararlanmalarında bir engel yoktur.'
         'Psikososyal Hizmetler: Yaşlı Aylığı/65 Yaş Aylığı',

        ],
      "telephone_number":"(0312) 418 33 24",
      "duration":"Haftaiçi 08:00-17:00",
      "latitude":39.92686475489532,
      "longitude": 32.85399527116432},

     {"address":"İstasyon Mahallesi Türk Kızılayı Caddesi No: 25 ",
      "name":"Etimesgut Sosyal Hizmet Merkezi",
      "type":"Kamu kurumu",
      "target_audience":"Kurum bakımına ihtiyaç duyan yaşlı bireyler",
      "criteria":[
          "\n1) 60 yaş ve üzeri yaşlarda olmak, \n2)Kendi gereksinimlerini karşılamasını engelleyici bir rahatsızlığı bulunmamak yeme, içme, banyo, tuvalet ve bunun gibi günlük yaşam etkinliklerini bağımsız olarak yapabilecek durumda olmak, \n3)Ruh sağlığı yerinde olmak, \n4)Bulaşıcı hastalığı olmamak, \n5)Uyuşturucu madde yada alkol bağımlısı olmamak, \n6)Sosyal ve/veya ekonomik yoksunluk içinde bulunduğu sosyal inceleme raporu ile saptanmış   olmak.",
         'Psikososyal Hizmetler: "Kurum Bakımı Huzurevi/Bakım ve Rehabilitasyon Merkezi"',

        ],
      "telephone_number":" (0312) 244 00 11",
      "duration":"Haftaiçi 9.00-17.00",
      "latitude":39.947482939100574,
      "longitude": 32.66999117116431},


      {"address":"Saray Osmangazi, Özal Bulvarı No:162, 06145 Pursaklar/Ankara",
      "name":"Saray Engelsiz Yaşam Bakım ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Kurum bakımına ihtiyaç duyan, zihinsel ve bedensel açıdan yetersiz bireyler",
      "criteria":[
         "Doğuştan veya sonradan herhangi bir nedenle bedensel, zihinsel, ruhsal, duyusal ve sosyal yeteneklerini çeşitli derecelerde kaybetmesi nedeniyle toplumsal yaşama uyum sağlama ve günlük gereksinimlerini karşılama güçlükleri olmak",
         'Psikososyal Hizmetler: Kurum Bakımı, Fizik Tedavi, Psiko-Sosyal Destek, Sosyal Etkinlikleri İçeren Rehabilitasyon Programları',

        ],
      "telephone_number":"(0312) 399 37 82",
      "duration":"08:00-17:00",
      "latitude":40.07000836731087,
      "longitude": 32.934533223286465},

      {"address":"İstiklal, Er Sk. No: 6, 06950 Şereflikoçhisar/Ankara",
      "name":"Şereflikoçhisar Bakım, Rehabilitasyon ve Aile Danışma Merkezi",
      "type":"Huzurevi",
      "target_audience":"Kurum bakımına ihtiyaç duyan, zihinsel ve bedensel açıdan yetersiz bireyler",
      "criteria":[
         "Doğuştan veya sonradan herhangi bir nedenle bedensel, zihinsel, ruhsal, duyusal ve sosyal yeteneklerini çeşitli derecelerde kaybetmesi nedeniyle toplumsal yaşama uyum sağlama ve günlük gereksinimlerini karşılama güçlükleri olmak",
         'Psikososyal Hizmetler: Kurum Bakımı, Fizik Tedavi, Psiko-Sosyal Destek, Sosyal Etkinlikleri İçeren Rehabilitasyon Programları',

        ],
      "telephone_number":"(0312) 687 94 64",
      "duration":" 08:00-17:00",
      "latitude":38.92764299330302,
      "longitude":  33.55726608465729},


      {"address":"Mutlukent, 1914. Sk. No:1, 06800 Çankaya/Ankara",
      "name":"Ümitköy Huzurevi Yaşlı Bakım Ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Kurum bakımına ihtiyaç duyan yaşlı bireyler",
      "criteria":[
         "60 yaşı doldurmuş olmak Kendi öz bakımını gerçekleştirebilir durumda olmak Akıl ve ruh sağlığı yerinde olmak, Herhangi bir bulaşıcı hastalığa sahip olmamak."
         'Psikososyal Hizmetler:  Konaklama ve Yemek Hizmeti, Sağlık Kontrolleri, Yaşlı Bakımı ve Rehabilitasyon Hizmetleri, Fizik Tedavi, Tiyatro Atölyesi, Kuaför, El Sanatları Atölyesi, Halk Oyunları, Geziler,  Sosyal ve Kültürel Faaliyetler.',

        ],
      "telephone_number":"(0312) 235 45 27",
      "duration":"08.00-17.00",
      "latitude":39.88912146531034,
      "longitude": 32.706792023286475},


      {"address":"Seyranbağları, Bağlar Cd. No:161, 06670 Çankaya/Ankara",
      "name":"Seyranbağları Huzurevi Yaşlı Bakım Ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Kurum bakımına ihtiyaç duyan yaşlı bireyler",
      "criteria":[
         "60 yaşı doldurmuş olmak Kendi öz bakımını gerçekleştirebilir durumda olmak Akıl ve ruh sağlığı yerinde olmak, Herhangi bir bulaşıcı hastalığa sahip olmamak."
         'Psikososyal Hizmetler:   Konaklama ve Yemek Hizmeti, Sağlık Kontrolleri, Yaşlı Bakımı ve Rehabilitasyon Hizmetleri, Fizik Tedavi, Tiyatro Atölyesi, Kuaför, El Sanatları Atölyesi, Halk Oyunları, Geziler,  Sosyal ve Kültürel Faaliyetler',

        ],
      "telephone_number":"(0312) 447 31 32",
      "duration":"08.00-17.00",
      "latitude":39.90654830421919,
      "longitude": 32.87150856931459},

      {"address":"Yavuz Selim, P.T.T. Cd No:1, 06760 Çubuk/Ankara",
      "name":"Çubuk Abidin Yılmaz Huzurevi Yaşlı Bakım Ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Kurum bakımına ihtiyaç duyan yaşlı bireyler",
      "criteria":[
         "60 yaşı doldurmuş olmak Kendi öz bakımını gerçekleştirebilir durumda olmak Akıl ve ruh sağlığı yerinde olmak, Herhangi bir bulaşıcı hastalığa sahip olmamak."
         'Psikososyal Hizmetler: Konaklama ve Yemek Hizmeti, Sağlık Kontrolleri, Yaşlı Bakımı ve Rehabilitasyon Hizmetleri, Fizik Tedavi, Tiyatro Atölyesi, Kuaför, El Sanatları Atölyesi, Halk Oyunları, Geziler,  Sosyal ve Kültürel Faaliyetler',

        ],
      "telephone_number":"(0312) 838 16 28",
      "duration":"08.00-17.00",
      "latitude":40.24467952097536,
      "longitude": 33.030811630685406},


      {"address":"Gicik, 06365 Altındağ/Ankara",
      "name":"Gicik Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi ",
      "type":"Huzurevi",
      "target_audience":"Kurum bakımına ihtiyaç duyan yaşlı bireyler",
      "criteria":[
         "60 yaşı doldurmuş olmak Kendi öz bakımını gerçekleştirebilir durumda olmak Akıl ve ruh sağlığı yerinde olmak, Herhangi bir bulaşıcı hastalığa sahip olmamak."
         'Psikososyal Hizmetler: Konaklama ve Yemek Hizmeti, Sağlık Kontrolleri, Yaşlı Bakımı ve Rehabilitasyon Hizmetleri, Fizik Tedavi, Tiyatro Atölyesi, Kuaför, El Sanatları Atölyesi, Halk Oyunları, Geziler,  Sosyal ve Kültürel Faaliyetler',

        ],
      "telephone_number":"(0312) 399 70 74",
      "duration":"08.00-17.00",
      "latitude":40.01098465337784,
      "longitude": 32.96741924602811},


      {"address":"İsmetpaşa, 2. Cd., 06890 Kızılcahamam/Ankara",
      "name":"Kızılcahamam Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Kurum bakımına ihtiyaç duyan yaşlı bireyler",
      "criteria":[
         "60 yaşı doldurmuş olmak Kendi öz bakımını gerçekleştirebilir durumda olmak Akıl ve ruh sağlığı yerinde olmak, Herhangi bir bulaşıcı hastalığa sahip olmamak."
         'Psikososyal Hizmetler: Konaklama ve Yemek Hizmeti, Sağlık Kontrolleri, Yaşlı Bakımı ve Rehabilitasyon Hizmetleri, Fizik Tedavi, Tiyatro Atölyesi, Kuaför, El Sanatları Atölyesi, Halk Oyunları, Geziler,  Sosyal ve Kültürel Faaliyetler',

        ],
      "telephone_number":"(0312) 736 30 20 - (0312) 753 16 20",
      "duration":"08:00-17:00 ve yatılı kuruluş olması nedeni ile hizmet 24 saat devam etmektedir.",
      "latitude":40.47532080935096,
      "longitude": 32.65951425397189},


      {"address":"Ehlibeyt, Cevizlidere Cd. No:4, 06520 Çankaya/Ankara",
      "name":"75. Yıl Huzurevi Yaşlı Bakım ve Rehabilitasyon Merkezi",
      "type":"Huzurevi",
      "target_audience":"Kurum bakımına ihtiyaç duyan yaşlı bireyler",
      "criteria":[
         "60 yaşı doldurmuş olmak Kendi öz bakımını gerçekleştirebilir durumda olmak Akıl ve ruh sağlığı yerinde olmak, Herhangi bir bulaşıcı hastalığa sahip olmamak."
         'Psikososyal Hizmetler: Konaklama ve Yemek Hizmeti, Sağlık Kontrolleri, Yaşlı Bakımı ve Rehabilitasyon Hizmetleri, Fizik Tedavi, Tiyatro Atölyesi, Kuaför, El Sanatları Atölyesi, Halk Oyunları, Geziler,  Sosyal ve Kültürel Faaliyetler.',

        ],
      "telephone_number":"(0312) 289 50 00",
      "duration":"Haftaiçi 08:30-17:00",
      "latitude":39.894384926539566,
      "longitude": 32.81957250739893},

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
  List<Widget> targetAddressList = [];
  Color selected_color = Colors.teal;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('images/harita65Logo.jpg'),
              radius: 65,
            ),
            SizedBox(width: 10,),
            Text('Seçilen Şehir: ${selectedCity?.title ?? '(Lütfen işaretli olan illeri seçiniz)'}'),
          ],
        ),
        //Text('Seçilen Şehir: ${selectedCity?.title ?? '(Lütfen işaretli olan illeri seçiniz)'}'),
        actions: [
          IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _mapKey.currentState?.clearSelect();
                provinces.clear();
                setState(() {
                  selectedCity = null;
                });
              })
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap:()async{
                  await launchUrl(Uri.parse('https://siviltoplumdestek.org/'));
                },
                child: CircleAvatar(
                  //backgroundColor: Colors.purpleAccent,
                  backgroundImage:AssetImage('images/stdv.jpeg'),
                  radius: 30,
                ),
              ),
              SizedBox(width: 10,),
              InkWell(
                onTap: ()async{
                  //launch url
                  await launchUrl(Uri.parse('https://www.agesa.com.tr/'));
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/agesa.jpeg'),
                  radius: 30,
                ),
              ),
            ],
          ),
          Text("Bu proje, AgeSA Hayat ve Emeklilik tarafından, Sivil Toplum için Destek Vakfı koordinasyonuyla hayata geçirilen Her Yaşta Fonu'nun desteğiyle yürütülmektedir.",
            style: TextStyle(color: Colors.black,
                ),
            textAlign: TextAlign.center,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: ()async{
                  await launchUrl(Uri.parse('https://www.birizdernegi.org/'));
                },
                child: CircleAvatar(
                  //backgroundColor: Colors.teal,
                  backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1146773186580832257/I9XwL7fH_400x400.jpg'),
                  radius: 30,
                ),
              ),
            ],
          ),
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
                  var random = Random();
                  selectedCity=null;
                  if(currentCities.contains(city!.title)){
                    setState(() {
                      selected_color = colors[random.nextInt(colors.length)];
                      selectedCity = city;
                    });
                  }
                  else{
                    selected_color=Colors.white;
                    provinces.clear();
                  }
                  setState(() {

                  });
                },
                actAsToggle: true,
                dotColor: Colors.pink,
                selectedColor: selected_color,
                strokeColor: Colors.black,
              ),
            ),
          ),

          Row(
            children: [
              selectedCity!=null && targetData.containsKey(selectedCity!.title) ? InkWell(
                onTap: (){
                  var random = Random();
                  var mapData = citiesLocationData[selectedCity!.title];
                  if(mapData!=null){
                    var cityName = selectedCity!.title;
                    if(targetData.containsKey(cityName)){
                      var targetList = targetData[cityName] as List;
                      List<Marker> markers = [];
                      for(Map t in targetList){
                        var name = "";
                        var split_name = (t['name'] as String).split(' ');
                        var count =0;
                        for(var n in split_name){
                          if(count%2==0)
                             name+="\n";
                          name+="${n} ";
                          count++;
                        }
                        var rand_index = random.nextInt(colors.length);
                        if(t['latitude'] != null  && t['longitude']!=null)
                          markers.add(new Marker(
                            point:latLng.LatLng(
                                t['latitude'],t['longitude']
                            ),
                            width:200,
                            height: 200,
                            builder:(context) =>
                               Stack(
                                 children: [
                                   Positioned(child: Row(
                                     children: [
                                       Icon(Icons.location_on,color: colors[rand_index],size:50,),
                                       RichText(text: TextSpan(
                                         text: '${name.toUpperCase()}',
                                         style: TextStyle(color: Colors.white,
                                             fontSize:10,
                                             fontWeight: FontWeight.bold,
                                             backgroundColor: Colors.black),
                                       )),
                                       /*
                                       Text('${name.toUpperCase()}',
                                       style: TextStyle(color: Colors.white,
                                           fontSize:8,
                                           fontWeight: FontWeight.bold,
                                           backgroundColor: Colors.black),)
                                        */
                                     ],
                                   )),
                                 ],
                               )

                             ));
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
                child: Text('TÜM KURUMLARI HARİTADA GÖR',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold),),
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
                                  var name = "";
                                  var split_name = ((targetData[selectedCity!.title] as List)[index]['name'] as String).split(' ');
                                  var count =0;
                                  for(var n in split_name){
                                    if(count%2==0)
                                      name+="\n";
                                    name+="${n} ";
                                    count++;
                                  }
                                  var rand_index = random.nextInt(colors.length);
                                  if((targetData[selectedCity!.title] as List)[index]['latitude'] != null &&
                                      (targetData[selectedCity!.title] as List)[index]['longitude'] != null)
                                    markers.add(new Marker(
                                        point:latLng.LatLng(
                                            (targetData[selectedCity!.title] as List)[index]['latitude'],
                                            (targetData[selectedCity!.title] as List)[index]['longitude']
                                        ),
                                        width:200,
                                        height: 200,
                                        builder:(context) =>
                                            Stack(
                                              children: [
                                                Positioned(child: Row(
                                                  children: [
                                                    Icon(Icons.location_on,color: colors[rand_index],size:50,),
                                                    Text('${(name.toUpperCase())}',
                                                      style: TextStyle(color: Colors.white,
                                                          fontSize:10,
                                                          fontWeight: FontWeight.bold,
                                                          backgroundColor: Colors.black),)
                                                  ],
                                                )),
                                              ],
                                            )
                                          ));
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
                            child: Expanded(
                              child: Row(
                                children: [
                                  RichText(
                                    text:TextSpan(
                                      text: '${index+1}.Kurum Adı:',
                                      style: TextStyle(fontSize: 12,color: Colors.teal,fontWeight: FontWeight.bold),
                                      children:[
                                        TextSpan(
                                          text: ' ${(targetData[selectedCity!.title] as List)[index]['name']}'.toUpperCase(),
                                          style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 5,),
                                  RichText(
                                    text:TextSpan(
                                      text: 'Hedef Kitle:',
                                      style: TextStyle(fontSize: 12,color: Colors.teal,fontWeight: FontWeight.bold),
                                      children:[
                                        TextSpan(
                                          text: ' ${(targetData[selectedCity!.title] as List)[index]['target_audience']}'.toUpperCase(),
                                          style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 5,),
                                  RichText(
                                    text:TextSpan(
                                      text: 'Telefon:',
                                      style: TextStyle(fontSize: 12,color: Colors.teal,fontWeight: FontWeight.bold),
                                      children:[
                                        TextSpan(
                                          text: ' ${(targetData[selectedCity!.title] as List)[index]['telephone_number']}'.toUpperCase().replaceAll(' ',''),
                                          style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),

                                        ),
                                      ],
                                    ),textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 5,),
                                  RichText(
                                    text:TextSpan(
                                      text: 'Açık Adres:',
                                      style: TextStyle(fontSize: 12,color: Colors.teal,fontWeight: FontWeight.bold),
                                      children:[
                                        TextSpan(
                                          text: ' ${((targetData[selectedCity!.title] as List)[index]['address'] as String).toUpperCase()}',
                                          style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),

                                        ),
                                      ],
                                    ),textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 5,),
                                  RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text:TextSpan(
                                      text: 'Saatler:',
                                      style: TextStyle(fontSize: 12,color: Colors.teal,fontWeight: FontWeight.bold),
                                      children:[
                                        TextSpan(
                                          text: ' ${(targetData[selectedCity!.title] as List)[index]['duration']}'.toUpperCase(),
                                          style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),

                                        ),
                                      ],
                                    ),textAlign: TextAlign.center,
                                  ),
                                  SizedBox(width: 5,),
                                  ((targetData[selectedCity!.title] as List)[index]['criteria'] as List).isNotEmpty ?
                                  IconButton(onPressed:()=> showModalBottomSheet(context: context,
                                      builder:(context) => RichText(text: TextSpan(
                                        text: 'Kriterler: ',
                                        style: TextStyle(color: Colors.pink,fontSize: 20,fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                              text:'${(targetData[selectedCity!.title] as List)[index]['criteria']}',
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)
                                          ),
                                          ],
                                      ))), icon: Icon(Icons.info,size: 20,color: Colors.pink,)):SizedBox.shrink(),
                                ],
                              ),
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
