// ignore_for_file: unused_element

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:powietrzomierz/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'api_manager.dart';
import 'air_quality_index_table.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Powietrzomierz',
      theme: ThemeData(
        // colorScheme: redColorScheme,
        colorScheme: redDarkColorScheme,
        // colorScheme: greenColorScheme,
        // colorScheme: greenDarkColorScheme,
      ),
      home: MyHomePage(title: 'Powietrzomierz', lastStationName: ""),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required lastStationName})
      : super(key: key);
  final String title;
  final String lastStationName = "";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeData theme = ThemeData(colorScheme: redDarkColorScheme);
  bool brightTheme = false;
  late Stations stations;
  int _lastStationId = 0;
  String lastStationName = "";
  SensorData _stationSensorData = SensorData();
  IndexLevel _stationIndex = IndexLevel(id: -1, indexLevelName: "¯\\_(ツ)_/¯");
  List<Station> _foundStations = [];
  String _mainIndicatorStatus = "";
  Color _buttonColor = primaryRed;

  @override
  void initState() {
    super.initState();
    Stations.fetchAllStations().then((value) {
      stations = value;
    }).whenComplete(() {
      _loadlastStation().whenComplete(() {
        Station currentStation = stations.getStationById(_lastStationId);
        lastStationName = currentStation.name;
        currentStation.getStationIndexLevel().then((value) {
          _stationIndex = value;
          if (_stationIndex.id < 1) {
            _buttonColor = buttonGreen;
          } else {
            _buttonColor = buttonRed;
          }
        });
        currentStation.getStationSensorData().then(((value) {
          _stationSensorData = value;
        }));
      });
    });

    _foundStations = [];
  }

  final Color barBackgroundColor = const Color(0xaac9c8c8);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  //Loading last_place value on start
  Future<void> _loadlastStation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastStationId =
          (prefs.getInt('last_place') ?? stations.getStationList()[0].id);
    });
  }

  //Saving last_place
  Future<void> _savelastStation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastStationId =
          (prefs.getInt('last_place') ?? stations.getStationList()[0].id);
      prefs.setInt('last_place', _lastStationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

        actions: [
          IconButton(
              onPressed: () {
                showdialog();
              },
              icon: Icon(Icons.help_outline))
        ],
      ),
      body: Container(
        width: double.infinity,
        // <-- Takes up total width of the device
        height: double.infinity,
        // <-- Takes up the total height of the device
        child: Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    // onSurface: _buttonColor,
                    fixedSize: const Size(240, 60),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70))),
                  ),
                  label: Marquee(
                      text: lastStationName == "" ? "Ładowanie" : lastStationName,
                      pauseAfterRound: Duration(seconds: 2),
                      blankSpace: 30,
                      velocity: 20),
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => Search(),
                      ),
                    );
                  },
                )),
            Container(
                margin: EdgeInsets.all(20.0),
                child: CircularPercentIndicator(
                  radius: 90.0,
                  lineWidth: 5.0,
                  percent: _stationIndex.id != -1
                      ? (5 - _stationIndex.id) / 5.0
                      : 0, //1 - _stationIndex.id / 50 +
                  // linearGradient:
                  //     LinearGradient(colors: [primaryRed, primaryGreen]),
                  // rotateLinearGradient: true,
                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                  center: Text(
                    _stationIndex.indexLevelName,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  addAutomaticKeepAlive: false,
                  progressColor: primaryGreen,

                )),
            Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              isPlaying ? randomData() : mainBarData(),
                              swapAnimationDuration: animDuration,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  showdialog() {
    //dialog z info o API
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return MaterialApp(
              theme: Theme.of(context),
              home: DefaultTabController(
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                      bottom: const TabBar(
                        tabs: [
                          Tab(
                            text: "API",
                          ),
                          Tab(
                            text: "Rodzaje\nzanieczyszczeń",
                          ),
                          Tab(
                            text: "Indeks jakości\npowietrza",
                          ),
                        ],
                      ),
                      title: const Text('Informacje')),
                  body: TabBarView(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15.0),
                        // ignore: prefer_const_constructors
                        child: Text(
                          "\nAplikacja korzysta z interfejsu API portalu \"Jakość Powietrza\" GIOŚ umożliwia dostęp do"
                          " danych dotyczących jakości powietrza w Polsce, wytwarzanych w ramach "
                          "Państwowego Monitoringu Środowiska i gromadzonych w bazie JPOAT2,0.",
                        ),
                      ),
                      SingleChildScrollView(child: Html(data: pollution_str)),
                      SingleChildScrollView(
                        child: Html(data: air_quality_index_table_str),
                      )
                    ],
                  ),
                ),
              ));
        });
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = const Color(0xFFb71c1c),
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow, width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 21,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  double pollutionlevel(IndexLevel? level) {
    switch (level?.id) {
      case 0:
        return 1;
        break; // The switch statement must be told to exit, or it will execute every case.
      case 1:
        return 4;
        break;
      case 2:
        return 9;
        break;
      case 3:
        return 13;
        break; // The switch statement must be told to exit, or it will execute every case.
      case 4:
        return 17;
        break;
      case 5:
        return 21;
        break;
      default:
        return 0;
    }
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
                0, pollutionlevel(_stationSensorData.pollutionPM10),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(
                1, pollutionlevel(_stationSensorData.pollutionPM25),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(
                2, pollutionlevel(_stationSensorData.pollutionSO2),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(
                3, pollutionlevel(_stationSensorData.pollutionNO2),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(
                4, pollutionlevel(_stationSensorData.pollutionCO),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(
                5, pollutionlevel(_stationSensorData.pollutionC6H6),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(
                6, pollutionlevel(_stationSensorData.pollutionO3),
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String pollutionType;
              switch (group.x.toInt()) {
                case 0:
                  pollutionType = 'PM10';
                  break;
                case 1:
                  pollutionType = 'PM2,5';
                  break;
                case 2:
                  pollutionType = 'SO2';
                  break;
                case 3:
                  pollutionType = 'NO2';
                  break;
                case 4:
                  pollutionType = 'CO';
                  break;
                case 5:
                  pollutionType = 'C6H6';
                  break;
                case 6:
                  pollutionType = 'O3';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                pollutionType + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY - 1).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      // color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('PM10', style: style);
        break;
      case 1:
        text = const Text('PM2,5', style: style);
        break;
      case 2:
        text = const Text('SO2', style: style);
        break;
      case 3:
        text = const Text('NO2', style: style);
        break;
      case 4:
        text = const Text('CO', style: style);
        break;
      case 5:
        text = const Text('C6H6', style: style);
        break;
      case 6:
        text = const Text('O3', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return Padding(padding: const EdgeInsets.only(top: 16), child: text);
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }

  // _onSearchFieldChanged(String value) async {
  //     Future<List<Station>> stations = await stations.searchStations(value);
  // }
}

class Search extends StatefulWidget {
  @override
  SearchState createState() => new SearchState();
}

class SearchState extends State<Search> {
  List<dynamic> _foundStations = [];
  late Stations stations;
  @override
  void initState() {
    super.initState();
    Stations.fetchAllStations().then((value) {
      stations = value;
    });

    _foundStations = [];
    String lastStationName = "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context),
      home: Scaffold(
          appBar: AppBar(title: TextField(onChanged: (value) {
            stations.searchStations(value).then((value) {
              setState(() => _foundStations = value);
              print(_foundStations);
            });
          })),
          body: ListView.builder(
              key: UniqueKey(),
              itemCount: _foundStations.length,
              itemBuilder: (context, i) {
                // return Container(height: 20, child: Text("123"));
                return ListTile(
                    title: Text(_foundStations[i].name),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        prefs.setInt('last_place', _foundStations[i].id);
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                  title: "Powietrzomierz",
                                  lastStationName: _foundStations[i].name)));
                    });
              })),
    );
  }
}
