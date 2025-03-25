// import 'package:flutter/material.dart';
// import 'package:guillotine_recap/network/api_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final leagueController = TextEditingController();
//   final ApiService _apiService;
//   String _result = '';

//   Future<void> _fetchLeagueData() async {
//     final leaguenumber = leagueController.text;

//     if (leaguenumber.isEmpty) {
//       setState(() {
//         _result = 'Please enter a league number';
//       });
//       return;
//     }

//     try {
//       final response = league.get(endPoint: "");
//       setState(() {
//         _result = 'Response: ${response}';
//       });
//     } catch (e) {
//       setState(() {
//         _result = 'Error $e';
//       });
//     }
//   }

//   @override
//   void dispose() {
//     // Clean up the controller when the widget is disposed.
//     leagueController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: leagueController,
//               keyboardType: TextInputType.number,
//             ),
//             Text(_result),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _fetchLeagueData();
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
