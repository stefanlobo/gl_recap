import 'package:flutter/material.dart';
import 'package:guillotine_recap/model/head_to_head.dart';
import 'package:guillotine_recap/model/player.dart';

class PlayersCard extends StatelessWidget {
  final List<Player> players;
  final String title;
  final String description;

  PlayersCard({
    Key? key,
    required this.players,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Tooltip(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.primaryContainer),
                  textStyle: TextStyle(color: Colors.white),
                  preferBelow: false,
                  message: description,
                  child: Text(title)),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text(
                          "# ${index + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(player.avatarUrl),
                          onBackgroundImageError: (_, __) => Icon(Icons.person),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.fullName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                player.position,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            '${player.count ?? 0}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.blue.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
