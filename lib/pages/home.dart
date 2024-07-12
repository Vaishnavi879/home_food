import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:home_food/pages/details.dart';
import 'package:home_food/service/database.dart';
import 'package:home_food/widget/widget_support.dart';
import 'package:home_food/service/location.dart';
import 'package:home_food/service/shared_pref.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false,
      pizza = false,
      salad = false,
      burger = false;
  Stream? foodItemStream;
  String? userAddress;
  String? adminId;
  Map<String, dynamic>? userDetails;
  QuerySnapshot<Map<String, dynamic>>? adminSnapshot;
  LatLng userLocation = LatLng(0, 0);
  Map<String, Marker> _markers = {};

  ontheload() async {
    Map<String, dynamic> userDetailsInfo = jsonDecode(
        (await SharedPreferenceHelper().getUserDetails())!);
    userAddress = userDetailsInfo['Address'];
    userDetails = userDetailsInfo;
    userLocation =
        LatLng(userDetailsInfo['Latitude'], userDetailsInfo['Longitude']);
    adminSnapshot = await DatabaseMethods().getAllUsers('admin');
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Marker getMarker(Map<String, dynamic> userDetails) {
    return Marker(
        markerId: MarkerId(userDetails['Id']),
        position: LatLng(userDetails['Latitude'], userDetails['Longitude']),
        infoWindow: InfoWindow(
          title: userDetails['Name'],
          snippet: userDetails['Address'],
        ),
        onTap: () async {
          adminId = userDetails['Id'];
          foodItemStream =
          await DatabaseMethods().getFoodItem(userDetails['Id']);
          setState(() {});
        }
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
      if (adminSnapshot != null)
        for (var result in adminSnapshot!.docs) {
          _markers[result.data()['Name']] = getMarker(result.data());
        };
    });
  }

  Widget allItemsVertically() {
    return StreamBuilder(
        stream: foodItemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Map<String, dynamic> foodItemDetails = ds.data() as Map<String, dynamic>;
                    foodItemDetails["AdminId"]=adminId!;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Details(
                                    foodItemDetails: foodItemDetails,
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20.0, bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              ds.get('Image'),
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2,
                                    child: Text(
                                      ds.get('Name'),
                                      style:
                                      AppWidget.SemiBoldTextFieldStyle(),
                                    )),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                SizedBox(
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2,
                                    child: Text(
                                      ds.get('Detail'),
                                      style: AppWidget.LightTextFieldStyle(),
                                    )),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                SizedBox(
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2,
                                    child: Text(
                                      "\$" + ds.get('Price'),
                                      style:
                                      AppWidget.SemiBoldTextFieldStyle(),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
              : const CircularProgressIndicator();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            top: 50.0,
            left: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello " + userDetails?['Name'] + ",",
                    style: AppWidget.BoldTextFieldStyle(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(children: [
                Text(
                  "Your address ",
                  style: AppWidget.LightTextFieldStyle(),
                ),
                GestureDetector(
                  onTap: () async {
                    final hasPermission =
                    await LocationMethods().handleLocationPermission(context);
                    if (hasPermission) {
                      await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high)
                          .then((Position position) async {
                        String address =
                        await LocationMethods().getAddressFromLatLng(position);
                        Map<String, dynamic> addLocationInfo = {
                          "Latitude": position.latitude,
                          "Longitude": position.longitude,
                          "Address": address,
                        };
                        userAddress = address;
                        setState(() {});
                        Map<String, dynamic> userDetails = jsonDecode(
                            (await SharedPreferenceHelper().getUserDetails())!);
                        await DatabaseMethods().addLocationToUsers(
                            'users', addLocationInfo, userDetails["Id"]);
                      });
                    }
                  },
                  child: Icon(Icons.edit_location),
                ),
              ]),
              const SizedBox(
                height: 10.0,
              ),
              if (userAddress != null)
                Wrap(
                  direction: Axis.horizontal, //Vertical || Horizontal
                  children: <Widget>[
                    Text(
                      userAddress!,
                      style: AppWidget.LightTextFieldStyle(),
                    )
                  ],
                ),
              const SizedBox(
                height: 30.0,
              ),
              Text(
                "Discover Home Food Nearby",
                style: AppWidget.BoldTextFieldStyle(),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                height: 400.0,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: userLocation,
                    zoom: 12,
                  ),
                  markers: _markers.values.toSet(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              if(foodItemStream != null) allItemsVertically()
              else
                Text(
                  "Please click on any kitchen pin on above map to see details!",
                  style: AppWidget.LightTextFieldStyle(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
