import 'dart:math';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/app/convert.dart';
import 'package:guillotine_recap/presentation/guillotine_icon.dart';
import 'package:guillotine_recap/widgets/charts_card.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/network/api_service.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'package:guillotine_recap/repository/repository_impl.dart';
import 'package:guillotine_recap/repository/repository.dart';
import 'package:guillotine_recap/app/di.dart';
import 'package:guillotine_recap/screen/standings_screen.dart';
import 'package:guillotine_recap/screen/tabs_screen.dart';
import 'package:guillotine_recap/presentation/util.dart';
import 'package:guillotine_recap/presentation/theme.dart';
import 'package:simple_icons/simple_icons.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Merriweather Sans", "Josefin Sans");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Guilottine Recap',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
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

  Future<void> launch(String url, {bool isNewTab = true}) async {
    await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: isNewTab ? '_blank' : '_self',
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth = getContentWidth(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false, // Remove default back button
          titleSpacing: 0, // Remove default spacing
          title: Center(
            child: Container(
              width: contentWidth, // Use the same width constraint as content
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CustomPaint(painter: GuillotineIcon(), size: Size(40, 40)),
                  Padding(padding: EdgeInsets.only(right: 8.0)),
                  Expanded(child: Text("Guillotine Recap")),
                  IconButton(
                      icon: const Icon(
                        Icons.info,
                        semanticLabel: "Info",
                      ),
                      iconSize: 25,
                      highlightColor: Colors.transparent, // Removes the highlight color
                      splashColor: Colors.transparent, // Removes the splash effect
                      hoverColor: Colors.transparent, // Removes hover color
                      focusColor: Colors.transparent, // Removes focus color
                      splashRadius: 0.001, // Minimizes splash radius
                      tooltip: "Info",
                      onPressed: () {
                        showDialog(
                          context: context, // This is required
                          builder: (BuildContext context) {
                            return Dialog(
                              insetPadding: EdgeInsets.all(2),
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 500,
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "About",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Divider(thickness: 1.5),
                                        SizedBox(height: 5),
                                        Text(
                                          "This website is designed for the Guillotine league format. \n\n"
                                          "In this format, the team with the lowest score each week is eliminated from the league. Once "
                                          "eliminated, all of that team's players are dropped and become available on the waiver wire. Remaining  "
                                          "managers can then use their budget to bid on these newly available players. The last team standing at "
                                          "the end of the season wins. \n\n"
                                          "On this site, you'll find fun stats, weekly standings charts, and interesting player insights throughout the season.",
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }),
                  IconButton(
                    icon: Icon(
                      SimpleIcons.github,
                      semanticLabel: "Github",
                    ),
                    highlightColor: Colors.transparent, // Removes the highlight color
                    splashColor: Colors.transparent, // Removes the splash effect
                    hoverColor: Colors.transparent, // Removes hover color
                    focusColor: Colors.transparent, // Removes focus color
                    splashRadius: 0.001, // Minimizes splash radius
                    tooltip: "Github",
                    onPressed: () {
                      launch("https://github.com/stefanlobo/gl_recap", isNewTab: true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
                    child: TextField(
                      controller: _leagueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter League ID',
                        constraints: BoxConstraints(maxWidth: 225.0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12),
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
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  // Watch the allRosterLeaguesProvider to get loading/error states
                  final allRosterLeaguesAsync = ref.watch(combinedRosterProvider);
                  final leagueAsync = ref.watch(leagueProvider);

                  // Watch the filtered results (not async)
                  final filteredRosters = ref.watch(filteredRosterLeaguesProvider);
                  final currentFilter = ref.watch(filterUserIdProvider);

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
                      final allDisplayNames = <String>['None'];

                      // Add the display names from the unfiltered data
                      allRosterLeaguesAsync.value?.forEach((roster) {
                        if (!allDisplayNames.contains(roster.displayName)) {
                          allDisplayNames.add(roster.displayName);
                        }
                      });

                      // Make sure selectedUser exists in the current list
                      if (selectedUser != null && selectedUser != 'None' && !allDisplayNames.contains(selectedUser)) {
                        // Reset if not found
                        selectedUser = 'None';
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (filteredRosters.isNotEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    'Exclusion',
                                  ),
                                  items: allDisplayNames
                                      .map((String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedUser,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedUser = value;
                                      ref.read(filterUserIdProvider.notifier).state = value == 'None' ? null : value;
                                    });
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: 200,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 30,
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: FFWrappedStyleTabs(filteredRosters: filteredRosters),
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
