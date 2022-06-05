import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:full_text_search/full_text_search.dart';

const String stationsUrl =
    'https://api.gios.gov.pl/pjp-api/rest/station/findAll';
const String dataUrl =
    'https://api.gios.gov.pl/pjp-api/rest/data/getData/'; //{sensorId}
const String sensorsUrl =
    'https://api.gios.gov.pl/pjp-api/rest/station/sensors/'; //{stationId}
const String airQualityIndexDataUrl =
    'https://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/'; //{stationId}

class Stations {
  List<Station> stations;

  Stations({required this.stations});

  static Future<Stations> fetchAllStations() async {
    return await http
        .get(Uri.parse(stationsUrl))
        .then((value) => fromJson(jsonDecode(value.body)));
  }

  static Stations fromJson(List<dynamic> json) {
    return Stations(stations: json.map((i) => Station.fromJson(i)).toList());
  }

  Future<List<Station>> searchStations(String stationName) async {
    return await FullTextSearch(
            term: stationName, items: stations, tokenize: tokenize)
        .findResults();
  }

  static List<dynamic> tokenize(Station s) {
    return s.name.split(' ');
  }

  @override
  String toString() {
    return stations.toString();
  }

  List<Station> getStationList() {
    return stations;
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

  @override
  String toString() {
    return name;
  }
}

// // ignore: constant_identifier_names
// enum PollutionName { STATION, PM10, PM25, NO2, SO2, CO, C6H6, O3 }

class SensorData {
  IndexLevel? pollutionST; // station level

  IndexLevel? pollutionPM10;
  IndexLevel? pollutionPM25;
  IndexLevel? pollutionSO2;
  IndexLevel? pollutionNO2;
  IndexLevel? pollutionCO;
  IndexLevel? pollutionC6H6;
  IndexLevel? pollutionO3;

  SensorData({
    this.pollutionST,
    this.pollutionPM10,
    this.pollutionPM25,
    this.pollutionSO2,
    this.pollutionNO2,
    this.pollutionCO,
    this.pollutionC6H6,
    this.pollutionO3,
  });

  static SensorData fromJson(Map<String, dynamic> json) {
    return SensorData(
      pollutionST: json['stIndexLevel'] != null
          ? IndexLevel.fromJson(json['stIndexLevel'])
          : null,
      pollutionPM10: json['pm10IndexLevel'] != null
          ? IndexLevel.fromJson(json['pm10IndexLevel'])
          : null,
      pollutionPM25: json['pm25IndexLevel'] != null
          ? IndexLevel.fromJson(json['pm25IndexLevel'])
          : null,
      pollutionSO2: json['so2IndexLevel'] != null
          ? IndexLevel.fromJson(json['so2IndexLevel'])
          : null,
      pollutionNO2: json['no2IndexLevel'] != null
          ? IndexLevel.fromJson(json['no2IndexLevel'])
          : null,
      pollutionCO: json['coIndexLevel'] != null
          ? IndexLevel.fromJson(json['coIndexLevel'])
          : null,
      pollutionC6H6: json['c6h6IndexLevel'] != null
          ? IndexLevel.fromJson(json['c6h6IndexLevel'])
          : null,
      pollutionO3: json['o3IndexLevel'] != null
          ? IndexLevel.fromJson(json['o3IndexLevel'])
          : null,
    );
  }

  static Future<SensorData> fetchSensorData(int stationId) async {
    return await http
        .get(Uri.parse('$airQualityIndexDataUrl$stationId'))
        .then((value) => fromJson(jsonDecode(value.body)));
  }
}

class IndexLevel {
  int id;
  String indexLevelName;

  IndexLevel({
    required this.id,
    required this.indexLevelName,
  });

  static IndexLevel fromJson(Map<String, dynamic> json) {
    return IndexLevel(id: json['id'], indexLevelName: json['indexLevelName']);
  }
}
