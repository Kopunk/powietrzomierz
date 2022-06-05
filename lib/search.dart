// import 'package:flutter/material.dart';
// import 'main.dart';
// import 'api_manager.dart';

// class Search extends StatefulWidget {
//   @override
//   SearchState createState() => new SearchState();
// }

// class SearchState extends State<Search> {
//   List<dynamic> _foundStations = [];
//   late Stations stations;
//   @override
//   void initState() {
//     super.initState();
//     Stations.fetchAllStations().then((value) {
//       stations = value;
//     });

//     _foundStations = [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: Theme.of(context),
//       home: Scaffold(
//           appBar: AppBar(title: TextField(onChanged: (value) {
//             stations.searchStations(value).then((value) {
//               setState(() => _foundStations = value);
//               print(_foundStations);
//             });
//           })),
//           body: ListView.builder(
//               key: UniqueKey(),
//               itemCount: _foundStations.length,
//               itemBuilder: (context, i) {
//                 // return Container(height: 20, child: Text("123"));
//                 return ListTile(
//                     title: Text(_foundStations[i].name),
//                     onTap: () {
//                       print(_foundStations);
//                     });
//               })),
//     );
//   }
// }
