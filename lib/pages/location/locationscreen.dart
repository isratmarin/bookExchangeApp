// import 'package:book_exchange/pages/location/currentlocation.dart';
// import 'package:book_exchange/pages/location/mylocation.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class LocationHome extends StatefulWidget {
//   const LocationHome({super.key});
//
//   @override
//   State<LocationHome> createState() => _LocationHomeState();
// }
//
// class _LocationHomeState extends State<LocationHome> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Location"),
//         centerTitle: true,
//       ),
//
//       body: SizedBox(
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             ElevatedButton(
//                 onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
//                   return MapSample();
//                 }));},
//                 child: Text("simple map")),
//
//             ElevatedButton(
//                 onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
//                   return CurrentLocation();
//                 }));},
//                 child: Text("Current Location")),
//           ],
//         ),
//       ),
//     );
//   }
// }
