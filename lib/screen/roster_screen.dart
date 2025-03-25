// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:guillotine_recap/network/api_service.dart';
// import 'package:guillotine_recap/convert.dart';
// import 'package:guillotine_recap/model/roster.dart';

// class RosterScreen extends StatefulWidget {
//   const RosterScreen({super.key});

//   @override
//   State<RosterScreen> createState() => _RosterScreenState();
// }

// class _RosterScreenState extends State<RosterScreen> {
//   late ApiService apiRequest;

//   List<Roster>? rosters;

//   bool isLoading = false;

//   Future getRoster() async {
//     Response response;

//     try {
//       isLoading = true;
//       response = await apiRequest.getRosters("1124849636478046208");
//       isLoading = false;
//       if (response.statusCode == 200) {
//         setState(() {
//           rosters = convertListToModel(Roster.fromJson, response.data!);
//           // rosters = Roster.fromJson(response.data);
//           print("This is the first roster id: ${rosters?[0].ownerId}");
//         });
//       } else {
//         print("There is some problem");
//       }
//     } on Exception catch (e) {
//       isLoading = false;
//       print(e);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     apiRequest = ApiService();
//     getRoster();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("Get rosters")),
//         body: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : rosters != null
//                 ? ListView.builder(
//                     itemBuilder: (context, index) {
//                       final roster = rosters![index];

//                       return ListTile(
//                         title: Text(roster.ownerId ?? "Unknown"),
//                       );
//                     },
//                     itemCount: rosters?.length,
//                   )
//                 : Center(
//                     child: Text("No rosters found"),
//                   ));
//   }
// }
