import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_food/admin/add_food.dart';
import 'package:home_food/service/database.dart';
import 'package:home_food/service/shared_pref.dart';
import 'package:home_food/widget/widget_support.dart';
import 'package:home_food/service/location.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  String? userAddress;

  ontheload() async {
    userAddress = jsonDecode(
        (await SharedPreferenceHelper().getUserDetails())!)['Address'];
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Home Admin",
                style: AppWidget.HeadlineTextFieldStyle(),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(children: [
              Text(
                "Your kitchen address ",
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
                      Map<String, dynamic> userDetails = jsonDecode(
                          (await SharedPreferenceHelper().getUserDetails())!);
                      await DatabaseMethods().addLocationToUsers(
                          'admin', addLocationInfo, userDetails["Id"]);
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
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AddFood()));
              },
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Image.asset(
                            "images/food.jpg",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 30.0,
                        ),
                        const Text(
                          "Add Food Items",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
