import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<Stations> fetchAllStations() async {
  final response = await http
      .get(Uri.parse('https://api.gios.gov.pl/pjp-api/rest/station/findAll'));

  if (response.statusCode == 200) {
    return Stations.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed GET API');
  }
}

class Stations {
  List<Station> stations;

  Stations({required this.stations});

  static Stations fromJson(List<Map<String, dynamic>> json) {
    return Stations(stations: json.map((i) => Station.fromJson(i)).toList());
  }
}

class Station {
  int id;
  String name;
  double gegrLat;
  double gegrLon;

  Station(
      {required this.id,
      required this.name,
      required this.gegrLat,
      required this.gegrLon});

  static Station fromJson(Map<String, dynamic> json) {
    return Station(
        id: json['id'],
        name: json['stationName'],
        gegrLat: double.parse(json['gegrLat']),
        gegrLon: double.parse(json['gegrLon']));
  }
}

class GiosStation {
  late int stationId;

  GiosStation(String? stationName, String? geoLatitude, String? geoLongitude) {
    int stationId = 0;
    if (stationName != null) {
      stationId = findStationByName(stationName);
    } else if (geoLatitude != null && geoLongitude != null) {
      stationId = findStationByGeo(geoLatitude, geoLongitude);
    } else {
      throw Exception(
          "Either station name or geoLatitude and geoLongitude have to be provided");
    }

    if (stationId == -1) {
      throw Exception("Station Not Found");
    }

    this.stationId = stationId;
  }

  int findStationByName(String stationName) {
    return 0; //TODO: implement
  }

  int findStationByGeo(String geoLatitude, String geoLongitude) {
    return 0; //TODO: implement
  }
}

class AirQualityIndex {}

class SensorData {
  final int indexLevelId;
  final String indexLevelName;

  final String? pollutionPM25;
  final String? pollutionSO2;
  final String? pollutionNO2;
  final String? pollutionCO;
  final String? pollutionC6H6;
  final String? pollutionO3;

  const SensorData({
    required this.indexLevelId,
    required this.indexLevelName,
    this.pollutionPM25,
    this.pollutionSO2,
    this.pollutionNO2,
    this.pollutionCO,
    this.pollutionC6H6,
    this.pollutionO3,
  });

  factory SensorData.fetch() {
    http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    return SensorData(
      indexLevelId: 0,
      indexLevelName: '0',
    );
  }
}
