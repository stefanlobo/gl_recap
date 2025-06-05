import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'package:guillotine_recap/screen/standings_screen.dart';
import 'package:guillotine_recap/screen/matchup_screen.dart';
import 'package:guillotine_recap/screen/superlatives_screen.dart';
import 'package:guillotine_recap/screen/transactions_screen.dart';
// Import your other screens/widgets here

class FFWrappedStyleTabs extends ConsumerStatefulWidget {
  final List<RosterLeague> filteredRosters;

  FFWrappedStyleTabs({
    Key? key,
    required this.filteredRosters,
  }) : super(key: key);

  @override
  ConsumerState<FFWrappedStyleTabs> createState() => _FFWrappedStyleTabsState();
}

class _FFWrappedStyleTabsState extends ConsumerState<FFWrappedStyleTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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

    // Get the league name from the provider
    final leagueName = leagueAsync.when(
      data: (league) => league?.name ?? "League",
      loading: () => "Loading...",
      error: (_, __) => "League",
    );

    final avatarWidget = leagueAsync.when(
      data: (league) {
        final avatarUrl = league?.getAvatarUrl();
        return avatarUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  avatarUrl,
                  height: 50.0,
                  width: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(15.0), //or 15.0
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  color: Color(0xffFF0E58),
                  child: Icon(Icons.sports_football),
                ),
              );
      },
      loading: () => CircleAvatar(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (_, __) => CircleAvatar(child: Icon(Icons.error)),
    );

    return Scaffold(
      appBar: AppBar(
        // Use the league name in the title when available
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: avatarWidget,
            ),
            Text(leagueName),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: avatarWidget,
            ),
          ],
        ),
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
              tabAlignment: TabAlignment.center,
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
                Tab(text: "Matchups"),
                Tab(text: "Superlatives"),
                Tab(text: "Players"),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Standings
            Standings(),
            // Tab 2: Closest Matchups
            StatsScreen(),
            //Tab 3: Superlatives
            SuperlativesScreen(),
            // // Tab 4: Transactions
            TransactionScreen(),
          ],
        ),
      ),
    );
  }
}
