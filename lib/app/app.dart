import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/charts.dart';
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
                  // Watch the allRosterLeaguesProvider to get loading/error states
                  final allRosterLeaguesAsync =
                      ref.watch(combinedRosterProvider);
                  // Watch the filtered results (not async)
                  final filteredRosters =
                      ref.watch(filteredRosterLeaguesProvider);
                  final currentFilter = ref.watch(filterUserIdProvider);

                  return allRosterLeaguesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error: ${error.toString()}'),
                    ),
                    data: (_) {
                      if (filteredRosters.isEmpty && currentFilter == null) {
                        return const Center(child: Text('No rosters found'));
                      }

                      // Create a list of all display names for the dropdown
                      final allDisplayNames = <String>[];

                      // Add the display names from the unfiltered data
                      allRosterLeaguesAsync.value?.forEach((roster) {
                        if (!allDisplayNames.contains(roster.displayName)) {
                          allDisplayNames.add(roster.displayName);
                        }
                      });

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (filteredRosters.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: DropdownMenu<String>(
                                  initialSelection: selectedUser,
                                  onSelected: (String? newValue) {
                                    setState(() {
                                      selectedUser = newValue;
                                      ref
                                          .read(filterUserIdProvider.notifier)
                                          .state = newValue ==
                                              'None'
                                          ? null
                                          : newValue;
                                    });
                                  },
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(
                                        value: 'None', label: 'None'),
                                    ...allDisplayNames.map((username) {
                                      final rosterId = username;
                                      final userName = username;

                                      return DropdownMenuEntry<String>(
                                        value: username,
                                        label: username,
                                      );
                                    }),
                                  ]),
                            ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredRosters.length,
                              itemBuilder: (context, index) {
                                // Get the roster ID from the map keys
                                final roster = filteredRosters[index];
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
                                        if (roster.deathPoints != null)
                                          Text(
                                              "Death Week: ${roster.deathWeek}"),
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
                                                            .length) *
                                                        20.0, // Adjust height based on item count
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                                                        itemCount: roster
                                                            .truePoints.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Text(
                                                              "Week ${index + 1}: ${roster.truePoints[index]}");
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
                          Expanded(
                              child: PointsPerWeekGraph(
                                  filteredRosters: filteredRosters))
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
