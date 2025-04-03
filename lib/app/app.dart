import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/provider/provider.dart';
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

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final _leagueController = TextEditingController();
  String? selectedUser; // Holds the selected user

  @override
  void initState() {
    super.initState();
    _leagueController.text = ref.read(leagueNumberProvider);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _leagueController.dispose();
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
              controller: _leagueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter League ID',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    ref.read(leagueNumberProvider.notifier).state =
                        _leagueController.text;
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final rosterAsync = ref.watch(combinedRosterProvider);

                  return rosterAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error: ${error.toString()}'),
                    ),
                    data: (combined) {
                      if (combined.rosterMap.isEmpty) {
                        return const Center(child: Text('No rosters found'));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (combined.rosterMap.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: DropdownMenu<String>(
                                initialSelection: selectedUser,
                                onSelected: (String? newValue) {
                                  setState(() {
                                    selectedUser = newValue;
                                  });
                                },
                             dropdownMenuEntries:[
                                DropdownMenuEntry(value: 'None', label: 'None'),
                                ...combined.rosterMap.entries.map((entry) {
                                  final rosterId = entry.key;
                                  final userName = entry.value.displayName;

                                  return DropdownMenuEntry<String>(
                                    value: rosterId.toString(),
                                    label: userName,
                                  );
                                }).toList(),]
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: combined.rosters.length,
                              itemBuilder: (context, index) {
                                // Get the roster ID from the map keys
                                final roster = combined.rosters[index];
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    title: Text("Roster ${roster.rosterId}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Owner: ${roster.displayName}"),
                                        if (roster.deathPlayers != null)
                                          Text(
                                              "Players: ${roster.deathPlayers}"),
                                        if (roster.weeks.isNotEmpty) ...[
                                          const SizedBox(height: 8),
                                          const Text("Weekly Points:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),

                                          // Display points for each week
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height: (roster.truePoints
                                                                ?.length ??
                                                            0) *
                                                        20.0, // Adjust height based on item count
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                                                        itemCount: roster
                                                            .truePoints?.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Text(
                                                              "Week ${index + 1}: ${roster.truePoints?[index]}");
                                                        }))
                                              ]),
                                        ],
                                      ],
                                    ),
                                    trailing: const Icon(Icons.cabin),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(leagueNumberProvider.notifier).state =
              _leagueController.text;
        },
        tooltip: 'Fetch Rosters',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
