import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:powietrzomierz/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'api_manager.dart';

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
      home: const MyHomePage(title: 'Powietrzomierz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stations stations;

  @override
  void initState() {
    super.initState();

    Stations.fetchAllStations()
        .then((value) => stations = Stations(stations: value.stations))
        .whenComplete(() => {
              // print('$stations'),
              stations
                  .searchStations("Gdańsk, ul. Leczkowa")
                  .then((value) => print(value.toString()))
            });
  }

  final Color barBackgroundColor = const Color(0xaac9c8c8);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

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
                    fixedSize: const Size(240, 60),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70))),
                  ),
                  label: const Text('Katowice'),
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    search();
                  },
                )),
            Container(
                margin: EdgeInsets.all(20.0),
                child: CircularPercentIndicator(
                  radius: 90.0,
                  lineWidth: 5.0,
                  percent: 0.7,
                  center: new Text(
                    "Dobry",
                    style: TextStyle(fontSize: 30),
                  ),
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

  search() {
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
            home: Scaffold(appBar: AppBar(title: TextField())),
          );
        });
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
                        child: Text(
                            "\nAplikacja korzysta z interfejsu API portalu \"Jakość Powietrza\" GIOŚ umożliwia dostęp do"
                            " danych dotyczących jakości powietrza w Polsce, wytwarzanych w ramach "
                            "Państwowego Monitoringu Środowiska i gromadzonych w bazie JPOAT2,0."),
                      ),
                      Container(
                          margin: EdgeInsets.all(15.0),
                          child: new SingleChildScrollView(
                              child: RichText(
                                  text: TextSpan(
                                      text: "\n",
                                      style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                                      children: const <TextSpan>[
                                TextSpan(
                                    text: "Pył zawieszony PM10 i PM2,5\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text:
                                      "Pył zawieszony to bardzo drobne cząstki stałe, unoszące się w powietrzu. Ze względu na swoje niewielkie rozmiary,"
                                      " pył drobny dostaje się bez problemu do dróg oddechowych, powodując zmniejszoną respirację i prowadząc do chorób układu oddechowego."
                                      " Natomiast już pył PM1 (o średnicy poniżej 1 µm) może przedostawać się do krwioobiegu. To jeden z powodów, dla których pyły "
                                      "są uznawane za bardzo niebezpieczne dla zdrowia. Dodatkowo, w skład pyłu zazwyczaj wchodzą metale ciężkie oraz wielopierścieniowe "
                                      "węglowodory aromatyczne posiadające potwierdzone właściwości kancerogenne. Z danych EEA wynika, że w roku 2017 dzienne normy PM10,"
                                      " ustalone przez UE, zostały przekroczone w 17 państwach członkowskich oraz w 6 innych państwach przekazujących dane. "
                                      "W przypadku rocznej normy pyłów PM2,5 przekroczenie odnotowano w 7 państwach członkowskich oraz w 3 innych państwach przekazujących dane."
                                      " Natomiast roczne zalecenia WHO dla PM10 zostały przekroczone na 51% stacji monitorujących, w prawie wszystkich państwach raportujących "
                                      "(oprócz Estonii, Finlandii i Irlandii).   przypadku PM2,5 roczne przekroczenia zaleceń WHO odnotowano na 69% stacji monitorujących, "
                                      "w prawie wszystkich państwach raportujących (oprócz Estonii, Finlandii i Norwegii).\n\n",
                                ),
                                TextSpan(
                                    text: "Pozostałe zanieczyszczenia\n",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text:
                                        "Do pozostałych szkodliwych dla człowieka zanieczyszczeń powietrza, omawianych przez EEA, należą: benzen, "
                                        "dwutlenek siarki, tlenek węgla - czad, benzo(a)piren oraz metale ciężkie w pyle PM10 (arsen (As), kadm (Cd), nikiel (Ni),"
                                        " ołów (Pb) i rtęć (Hg)). EEA informuje, że zanieczyszczenie powietrza szkodzi nie tylko bezpośrednio człowiekowi, "
                                        "ale również florze i faunie. Wpływa negatywnie na stan jakości gleb i wód. Wśród najbardziej szkodliwych zanieczyszczeń powietrza "
                                        "dla świata przyrody EEA wymienia ozon, amoniak i tlenki azotu. Dla prawie wszystkich wymienionych zanieczyszczeń obserwujemy spadek "
                                        "ich emisji w latach 2000-2017. Wyjątek stanowi jedynie emisja amoniaku, która za sprawą rozwoju rolnictwa od 2013 roku zaczyna "
                                        "stopniowo wzrastać, ale w dalszym ciągu jest niższa niż w roku 2000.")
                              ])))),
                      SingleChildScrollView(
                        child: Html(data: """<br>
                <table style="height: 600px; width: 400px; display: table; opacity: 1;" cellspacing="1" cellpadding="5" border="1" align="center">
	<thead>
		<tr>
			<th scope="col" style="background-color: rgb(192, 192, 192); text-align: center; vertical-align: top; white-space:  width: 100px; --darkreader-inline-bgcolor: #3c4143;" data-darkreader-inline-bgcolor="">&nbsp;Kategoria</th>
			<th scope="col" style="background-color: rgb(192, 192, 192); text-align: center; --darkreader-inline-bgcolor: #3c4143;" data-darkreader-inline-bgcolor="">Informacje Zdrowotne</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td style="background-color: rgb(0, 153, 0); text-align: center; vertical-align: middle; width: 20%; --darkreader-inline-bgcolor: #007a00;" data-darkreader-inline-bgcolor=""><span style="color: rgb(255, 255, 255); --darkreader-inline-color: #e8e6e3;" data-darkreader-inline-color="">&nbsp;Bardzo dobry</span></td>
			<td style="text-align:center">Jakość powietrza bardzo dobra, zanieczyszczenie powietrza nie stanowi zagrożenia dla zdrowia, warunki bardzo sprzyjające do wszelkich aktywności na wolnym powietrzu, bez ograniczeń.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(153, 255, 51); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #6cad00;" data-darkreader-inline-bgcolor="">&nbsp;Dobry</td>
			<td style="text-align:center">Jakość powietrza zadowalająca, zanieczyszczenie powietrza powoduje brak lub niskie ryzyko zagrożenia dla zdrowia. Można przebywać na wolnym powietrzu i wykonywać dowolną aktywność.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(255, 255, 0); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #999900;" data-darkreader-inline-bgcolor="">&nbsp;Umiarkowany</td>
			<td style="text-align:center">Jakość powietrza akceptowalna. Zanieczyszczenie powietrza może stanowić zagrożenie dla zdrowia w szczególnych przypadkach. Warunki umiarkowane do aktywności na wolnym powietrzu.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(255, 102, 0); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #cc5200;" data-darkreader-inline-bgcolor="">&nbsp;Dostateczny</td>
			<td style="text-align:center">Jakość powietrza dostateczna, zanieczyszczenie powietrza stanowi zagrożenie dla zdrowia oraz może mieć negatywne skutki zdrowotne. Należy ograniczyć aktywności na wolnym powietrzu.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(255, 0, 0); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #cc0000;" data-darkreader-inline-bgcolor="">&nbsp;<span style="color: rgb(255, 255, 255); --darkreader-inline-color: #e8e6e3;" data-darkreader-inline-color="">Zły</span></td>
			<td style="text-align:center">Jakość powietrza zła, osoby chore, starsze, kobiety w ciąży oraz małe dzieci powinny unikać przebywania na wolnym powietrzu. Pozostała populacja powinna ograniczyć do minimum aktywności na wolnym powietrzu.</td>
		</tr>
		<tr>
			<td style="background-color: rgb(153, 0, 0); text-align: center; vertical-align: middle; --darkreader-inline-bgcolor: #7a0000;" data-darkreader-inline-bgcolor=""><span style="color: rgb(255, 255, 255); --darkreader-inline-color: #e8e6e3;" data-darkreader-inline-color="">&nbsp;Bardzo zły</span></td>
			<td style="text-align:center">Jakość powietrza bardzo zła, ma negatywny wpływ na zdrowie. Osoby chore, starsze, kobiety w ciąży oraz małe dzieci powinny bezwzględnie unikać przebywania na wolnym powietrzu. Pozostała populacja powinna ograniczyć przebywanie na wolnym powietrzu do niezbędnego minimum. Wszelkie aktywności fizyczne na zewnątrz są odradzane.</td>
		</tr>
	</tbody>
</table>
                """),
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
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
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
      color: Colors.black,
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
}
