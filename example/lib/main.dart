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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap:()async{
                  await launchUrl(Uri.parse('https://siviltoplumdestek.org/'));
                },
                child: CircleAvatar(
                  //backgroundColor: Colors.purpleAccent,
                  backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1479052515786301440/H6JrNSS3_400x400.png'),
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
                  backgroundImage: NetworkImage('https://mir-s3-cdn-cf.behance.net/projects/404/d30af0155719783.Y3JvcCwxMjMxLDk2MywzNTMsMTg.png'),
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
                dotColor: Colors.pink,
                selectedColor: Colors.teal,
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
                        for(int i=0; i<(t['name'] as String).length;i++){
                           if(i%30==0)
                             name+="\n";
                           name += (t['name'] as String)[i];
                        }
                        var rand_index = random.nextInt(colors.length);
                        if(t['latitude'] != null  && t['longitude']!=null)
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
                                   Positioned(child: Row(
                                     children: [
                                       Icon(Icons.location_on,color: colors[rand_index],size:50,),
                                       Text('${name.toUpperCase()}',style: TextStyle(color: Colors.white,
                                           fontSize:8,
                                           fontWeight: FontWeight.bold,
                                           backgroundColor: Colors.black),)
                                     ],
                                   )),
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
                                  for(int i=0; i<((targetData[selectedCity!.title] as List)[index]['name'] as String).length;i++){
                                    if(i%30==0)
                                      name+="\n";
                                    name += ((targetData[selectedCity!.title] as List)[index]['name'] as String)[i];
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
                                        builder:(context) => Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Positioned(child: Row(
                                                  children: [
                                                    Icon(Icons.location_on,color: colors[rand_index],size:50,),
                                                    Text('${(name.toUpperCase())}',
                                                      style: TextStyle(color: Colors.white,
                                                          fontSize:8,
                                                          fontWeight: FontWeight.bold,
                                                          backgroundColor: Colors.black),)
                                                  ],
                                                )),
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
                                          text: ' ${(targetData[selectedCity!.title] as List)[index]['telephone_number']}'.toUpperCase(),
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
                                          )],
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
