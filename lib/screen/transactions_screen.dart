import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:guillotine_recap/app/convert.dart';
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
    final contentWidth = getContentWidth(context);

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
                List<Player>? mostPickedUp = calculateMostPickedUp(transactions, players);
                final totalWaiverCost = calculateTotalWavier(transactions, players);
                final mostDropped = calculateMostDropped(transactions, players);
                final mostDroppedCommish = calculateMostDroppedCommish(transactions, players);

                final List<Widget> cards = [];

                if (mostPickedUp != null && mostPickedUp.isNotEmpty) {
                  cards.add(PlayersCard(
                    players: mostPickedUp,
                    title: "Most Picked Up",
                  ));
                }

                if (totalWaiverCost != null && totalWaiverCost.isNotEmpty) {
                  cards.add(PlayersCard(
                    players: totalWaiverCost,
                    title: "Most Expensive",
                  ));
                }

                if (mostDropped != null && mostDropped.isNotEmpty) {
                  cards.add(PlayersCard(
                    players: mostDropped,
                    title: "Most Dropped (Total)",
                  ));
                }

                if (mostDroppedCommish != null && mostDroppedCommish.isNotEmpty) {
                  cards.add(PlayersCard(
                    players: mostDroppedCommish,
                    title: "Most Dropped (Commish)",
                  ));
                }

                return SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: contentWidth, // Constrain max width, use min to avoid overflows
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              spacing: 12,
                              runSpacing: 12,
                              children: List.generate(
                                cards.length,
                                (index) => cards[index],
                              ),
                            );
                          },
                        )),
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
