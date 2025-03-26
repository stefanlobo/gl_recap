import 'package:flutter/material.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/repository/repository_impl.dart';
import 'package:guillotine_recap/repository/repository.dart';
import 'package:guillotine_recap/screen/home_screen.dart';
import 'package:guillotine_recap/app/di.dart';

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
      home: MyHomePage(title: "GLeague"),
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

  //final rosters = instance<Repository>(param1: "1124849636478046208");
  List<Roster> rosters = [];
  String _result = '';
  bool _isLoading = false;

  Future<void> _fetchLeagueData() async {
    final leaguenumber = leagueController.text;

    if (leaguenumber.isEmpty) {
      setState(() {
        _result = 'Please enter a league number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = 'Loading...';
      rosters = []; // Clear previous data
    });

    try {
      final repo = instance<Repository>(param1: leaguenumber);
      final result = await repo.getRoster();

      result.fold(
        (failure) => setState(() {
          _result = 'Error: ${failure.message}';
        }),
        (data) => setState(() {
          _result = 'Found ${data.length} rosters';
          rosters = data;
        }),
      );
    } finally {
      setState(() {
        _isLoading = false;
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: leagueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter League ID',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _fetchLeagueData,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_result.isNotEmpty)
              Text(_result, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Expanded(
              // Key fix - makes ListView scrollable
              child: rosters.isEmpty
                  ? const Center(child: Text('No rosters found'))
                  : ListView.builder(
                      itemCount: rosters.length,
                      itemBuilder: (context, index) {
                        final roster = rosters[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text("Roster ${roster.rosterId}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Owner: ${roster.ownerId}"),
                                if (roster.players != null)
                                  Text("Players: ${roster.players!.length}"),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Handle tap
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchLeagueData,
        tooltip: 'Fetch Rosters',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
