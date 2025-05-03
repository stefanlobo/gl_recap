import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/widgets/charts_card.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'package:guillotine_recap/repository/repository_impl.dart';
import 'package:guillotine_recap/repository/repository.dart';
import 'package:guillotine_recap/app/di.dart';
import 'package:guillotine_recap/screen/standings_screen.dart';
import 'package:guillotine_recap/screen/tabs_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guilottine Recap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 145, 150, 160)),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

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
        title: Text("Guillotine Recap Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                TextField(
                  controller: _leagueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter League ID',
                    constraints: BoxConstraints(maxWidth: 225.0),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    onPressed: () {
                      ref.read(leagueNumberProvider.notifier).state = _leagueController.text;
                    },
                    tooltip: 'Fetch Rosters',
                    child: const Icon(
                      Icons.refresh,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  // Watch the allRosterLeaguesProvider to get loading/error states
                  final allRosterLeaguesAsync = ref.watch(combinedRosterProvider);
                  final leagueAsync = ref.watch(leagueProvider);

                  // Watch the filtered results (not async)
                  final filteredRosters = ref.watch(filteredRosterLeaguesProvider);
                  final currentFilter = ref.watch(filterUserIdProvider);

                  //final transactions = ref.watch(transactionProvider);
                  

                  return allRosterLeaguesAsync.when(
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (error, stack) {
                      print(error);
                      return Text('Error: ${error.toString()}');
                    },
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
                                      ref.read(filterUserIdProvider.notifier).state =
                                          newValue == 'None' ? null : newValue;
                                    });
                                  },
                                  dropdownMenuEntries: [
                                    DropdownMenuEntry(value: 'None', label: 'None'),
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
                            child: FFWrappedStyleTabs(
                                filteredRosters: filteredRosters, title: leagueAsync.value?.name ?? "League"),
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
    );
  }
}
