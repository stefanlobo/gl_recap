import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guillotine_recap/api_service.dart';
import 'package:guillotine_recap/convert.dart';
import 'package:guillotine_recap/model/league.dart';
import 'package:guillotine_recap/model/roster.dart';

class LeagueScreen extends StatefulWidget {
  const LeagueScreen({super.key});

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  late ApiService apiRequest;

  League? league;
  List<Roster>? rosters;

  bool isLoading = false;



  Future getLeague() async {
    Response response;

    try {
      isLoading = true;
      response = await apiRequest.getLeague("1124849636478046208");
      print(response.data);
      isLoading = false;
      if (response.statusCode == 200) {
        setState(() {
          //league = League.fromJson(response.data);
          league = convertMapToModel(League.fromJson, response.data!);
        });
      } else {
        print("There is some problem");
      }
    } on Exception catch (e) {
      isLoading = false;
      print(e);
    }
  }

  Future getRoster() async {
    Response response;

    try {
      isLoading = true;
      response = await apiRequest.getRosters("1124849636478046208");
      isLoading = false;
      if (response.statusCode == 200) {
        print(response.data);

        setState(() {
          rosters = convertListToModel(Roster.fromJson, response.data!);
          // rosters = Roster.fromJson(response.data);
          print("This is the first roster id: ${rosters?[0].ownerId}");
        });
      } else {
        print("There is some problem");
      }
    } on Exception catch (e) {
      isLoading = false;
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    apiRequest = ApiService();
    getLeague();
    getRoster();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get league"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : league != null
              ? Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                          "https://sleepercdn.com/avatars/${league!.avatar}"),
                      Text("${league!.name}"),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ))
              : Center(child: Text("No League Response")),
    );
  }
}
