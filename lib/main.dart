import 'package:flutter/material.dart';
import 'package:guillotine_recap/screen/home_screen.dart';
import 'package:guillotine_recap/screen/league_screen.dart';
import 'package:guillotine_recap/screen/roster_screen.dart';
import 'package:http/http.dart' as http;
import 'api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guilottine Recap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 145, 150, 160)),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final leagueController = TextEditingController();
  ApiService league = ApiService();
  String _result = '';

  Future<void> _fetchLeagueData() async {
    final leaguenumber = leagueController.text;

    if (leaguenumber.isEmpty) {
      setState(() {
        _result = 'Please enter a league number';
      });
      return;
    }

    try {
      final response = league.getLeague(leaguenumber);
      setState(() {
        _result = 'Response: ${response}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error $e';
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    leagueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: leagueController,
              keyboardType: TextInputType.number,
            ),
            Text(_result),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchLeagueData();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
