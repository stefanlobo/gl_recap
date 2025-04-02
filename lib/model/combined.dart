import 'package:guillotine_recap/model/roster_league.dart';

class Combined {
  //rosterid : league member info
  final Map<int, RosterLeague> rosterMap;

  Combined({required this.rosterMap});

  List<RosterLeague> get rosters => rosterMap.values.toList();

  List<int> get rosterIds => rosterMap.keys.toList();

  RosterLeague getRoster(int rosterId) {
    return rosterMap[rosterId]!;
  }
}
