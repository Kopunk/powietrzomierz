import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:full_text_search/full_text_search.dart';

class Stations {
  List<Station> stations;

  Stations({required this.stations});

  static Future<Stations> fetchAllStations() async {
    return await http
        .get(Uri.parse('https://api.gios.gov.pl/pjp-api/rest/station/findAll'))
        .then((value) => fromJson(jsonDecode(value.body)));
  }

  static Stations fromJson(List<dynamic> json) {
    return Stations(stations: json.map((i) => Station.fromJson(i)).toList());
  }

  Future<List<String>> searchStations(String stationName) async {
    return await FullTextSearch(
            term: stationName, items: stations, tokenize: tokenize)
        .findResults()
        .then((value) => value.map((e) => e.name).toList());
  }

  static List<dynamic> tokenize(Station s) {
    return s.name.split(' ');
  }

  @override
  String toString() {
    return stations.toString();
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

  // #TODO: add fetch and pull data
}
