import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/model/head_to_head.dart';
import 'package:guillotine_recap/model/player.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/model/transaction.dart';
import 'package:guillotine_recap/provider/player_provider.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'package:guillotine_recap/widgets/matchup_card.dart';
import 'package:guillotine_recap/widgets/players_card.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final yearTransactions = ref.watch(transactionProvider);
    final playersAsync = ref.watch(playersProvider);

    // Get the screen width to help with sizing
    final screenWidth = MediaQuery.of(context).size.width;

    return yearTransactions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
              child: Text('Error:  $error'),
            ),
        data: (transactions) {
          return playersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                    child: Text('Error loading player data: $error'),
                  ),
              data: (players) {
                final mostPickedUp = calculateMostPickedUp(transactions, players);
                final totalWaiverCost = calculateTotalWavier(transactions, players);
                final mostDropped = calculateMostDropped(transactions, players);
                final mostDroppedCommish = calculateMostDroppedCommish(transactions, players);
                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: min(screenWidth * 0.95, 2000), // Constrain max width, use min to avoid overflows
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          PlayersCard(
                            players: mostPickedUp,
                            title: "Most Picked Up",
                          ),
                          PlayersCard(players: totalWaiverCost, title: "Most Expensive"),
                          PlayersCard(players: mostDropped, title: "Most Dropped (Total)"),
                          PlayersCard(players: mostDroppedCommish, title: "Most Dropped (Commish)")

                          // MatchupCard(matchups: closestMatchups, title: "Tight Race", subtitle: "Ouch Matchup"),
                          // MatchupCard(matchups: furthestBottomTwo, title: "Not Even Close", subtitle: "Furthest Matchup"),
                          // MatchupCard(matchups: largestTopBottom, title: "David vs Goliath", subtitle: "Demolished")
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  List<Player> calculateMostPickedUp(Map<int, List<Transaction>> transactions, Map<String, Player> players) {
    Map<String, int> pickupCount = {};
    List<Player> topFivePlayers = [];

    for (final entry in transactions.entries) {
      final week = entry.key;
      final weekTransactions = entry.value;

      for (final transaction in weekTransactions) {
        if (transaction.status == 'complete' &&
            (transaction.type == 'waiver' || transaction.type == 'free_agent') &&
            transaction.adds != null) {
          for (final add in transaction.adds!.entries) {
            pickupCount[add.key] = (pickupCount[add.key] ?? 0) + 1;
          }
        }
      }
    }

    final countList = pickupCount.entries.toList();

    countList.sort((a, b) => b.value.compareTo(a.value));

    final topFive = countList.take(10).map((entry) => entry.key).toList();

    for (final playerId in topFive) {
      final fullName = players[playerId]!.fullName;
      final position = players[playerId]!.position;
      final count = pickupCount[playerId] ?? 0;
      topFivePlayers.add(Player.mostPickup(playerId: playerId, fullName: fullName, position: position, count: count));
    }

    return topFivePlayers;
  }

  List<Player> calculateTotalWavier(Map<int, List<Transaction>> transactions, Map<String, Player> players) {
    Map<String, int> waiverCount = {};
    List<Player> topFivePlayers = [];

    for (final entry in transactions.entries) {
      final week = entry.key;
      final weekTransactions = entry.value;

      for (final transaction in weekTransactions) {
        if (transaction.status == 'complete' &&
            (transaction.type == 'waiver' || transaction.type == 'free_agent') &&
            transaction.adds != null) {
          for (final add in transaction.adds!.entries) {
            waiverCount[add.key] = (waiverCount[add.key] ?? 0) + (transaction.settings?.waiver_bid ?? 0);
          }
        }
      }
    }

    final countList = waiverCount.entries.toList();

    countList.sort((a, b) => b.value.compareTo(a.value));

    final topFive = countList.take(10).map((entry) => entry.key).toList();

    for (final playerId in topFive) {
      final fullName = players[playerId]!.fullName;
      final position = players[playerId]!.position;
      final count = waiverCount[playerId] ?? 0;
      topFivePlayers.add(Player.mostPickup(playerId: playerId, fullName: fullName, position: position, count: count));
    }

    return topFivePlayers;
  }

  List<Player> calculateMostDropped(Map<int, List<Transaction>> transactions, Map<String, Player> players) {
    Map<String, int> dropCount = {};
    List<Player> topFivePlayers = [];

    for (final entry in transactions.entries) {
      final week = entry.key;
      final weekTransactions = entry.value;

      for (final transaction in weekTransactions) {
        if (transaction.status == 'complete' &&
            (transaction.type == 'waiver' || transaction.type == 'free_agent' || transaction.type == 'commissioner') &&
            transaction.drops != null) {
          for (final drop in transaction.drops!.entries) {
            dropCount[drop.key] = (dropCount[drop.key] ?? 0) + 1;
          }
        }
      }
    }

    final countList = dropCount.entries.toList();

    countList.sort((a, b) => b.value.compareTo(a.value));

    final topFive = countList.take(10).map((entry) => entry.key).toList();

    for (final playerId in topFive) {
      final fullName = players[playerId]!.fullName;
      final position = players[playerId]!.position;
      final count = dropCount[playerId] ?? 0;
      topFivePlayers.add(Player.mostPickup(playerId: playerId, fullName: fullName, position: position, count: count));
    }

    return topFivePlayers;
  }

  List<Player> calculateMostDroppedCommish(Map<int, List<Transaction>> transactions, Map<String, Player> players) {
    Map<String, int> dropCount = {};
    List<Player> topFivePlayers = [];

    for (final entry in transactions.entries) {
      final week = entry.key;
      final weekTransactions = entry.value;

      for (final transaction in weekTransactions) {
        if (transaction.status == 'complete' && (transaction.type == 'commissioner') && transaction.drops != null) {
          for (final drop in transaction.drops!.entries) {
            dropCount[drop.key] = (dropCount[drop.key] ?? 0) + 1;
          }
        }
      }
    }

    final countList = dropCount.entries.toList();

    countList.sort((a, b) => b.value.compareTo(a.value));

    final topFive = countList.take(10).map((entry) => entry.key).toList();

    for (final playerId in topFive) {
      final fullName = players[playerId]!.fullName;
      final position = players[playerId]!.position;
      final count = dropCount[playerId] ?? 0;
      topFivePlayers.add(Player.mostPickup(playerId: playerId, fullName: fullName, position: position, count: count));
    }

    return topFivePlayers;
  }
}
