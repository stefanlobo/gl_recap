import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'package:guillotine_recap/screen/standings_screen.dart';
import 'package:guillotine_recap/screen/stats_screen.dart';
// Import your other screens/widgets here

// Convert to ConsumerStatefulWidget to use Riverpod
class FFWrappedStyleTabs extends ConsumerStatefulWidget {
  final List<RosterLeague> filteredRosters;
  String title = "League";

  FFWrappedStyleTabs({
    Key? key,
    required this.title,
    required this.filteredRosters,
  }) : super(key: key);

  @override
  ConsumerState<FFWrappedStyleTabs> createState() => _FFWrappedStyleTabsState();
}

class _FFWrappedStyleTabsState extends ConsumerState<FFWrappedStyleTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access the leagueProvider data here
    final leagueAsync = ref.watch(leagueProvider);

    return Scaffold(
      appBar: AppBar(
        // Use the league name in the title when available
        title: Text(widget.title),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 3,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              tabs: [
                Tab(text: "Standings"),
                Tab(text: "Closest Matchups"),
                // Tab(text: "Weekly Leaders"),
                // Tab(text: "Team Recaps"),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Standings
          Standings(filteredRosters: widget.filteredRosters),
          // Tab 2: Closest Matchups
          StatsScreen(),
          // // Tab 3: Weekly Leaders
          // Center(child: Text("Weekly Leaders Tab")),
          // // Tab 4: Team Recaps
          // Center(child: Text("Team Recaps Tab")),
        ],
      ),
    );
  }
}
