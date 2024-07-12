import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_food/service/database.dart';
import 'package:home_food/widget/widget_support.dart';
import 'package:home_food/service/location.dart';

class AdminOrderDetails extends StatefulWidget {
  Map<String, dynamic> foodItemDetails;
  AdminOrderDetails({
    super.key,
    required this.foodItemDetails,
  });

  @override
  State<AdminOrderDetails> createState() => _AdminOrderDetailsState();
}

class _AdminOrderDetailsState extends State<AdminOrderDetails> {
  var userDetails;
  String? nextOrderCollection;
  String? nextOrderButton;
  bool? showButton;

  ontheload() async {
    userDetails = await DatabaseMethods()
        .getUserDetails('users', widget.foodItemDetails["UserId"]);
    nextOrderCollection =
        widget.foodItemDetails["CurrentOrderStatus"] == "newOrders"
            ? "acceptedOrders"
            : "completedOrders";
    nextOrderButton =
        widget.foodItemDetails["CurrentOrderStatus"] == "newOrders"
            ? "Accept Order"
            : "Close Order";
    showButton =
        widget.foodItemDetails["CurrentOrderStatus"] != "completedOrders"
            ? true
            : false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.black,
                      )),
                  if (showButton == true)
                    GestureDetector(
                      onTap: () async {
                        await DatabaseMethods().changeOrderStatus(
                            widget.foodItemDetails["UserId"],
                            widget.foodItemDetails["AdminId"],
                            widget.foodItemDetails["Id"],
                            widget.foodItemDetails["CurrentOrderStatus"],
                            nextOrderCollection!);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              nextOrderButton!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Image.network(
              widget.foodItemDetails["Image"],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.foodItemDetails["Name"],
                      style: AppWidget.SemiBoldTextFieldStyle(),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  "Quantity: " + widget.foodItemDetails["Quantity"],
                  style: AppWidget.SemiBoldTextFieldStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              widget.foodItemDetails["Detail"],
              maxLines: 4,
              style: AppWidget.LightTextFieldStyle(),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Row(
              children: [
                Text(
                  "Delivery Time",
                  style: AppWidget.SemiBoldTextFieldStyle(),
                ),
                const SizedBox(
                  width: 25.0,
                ),
                const Icon(
                  Icons.alarm,
                  color: Colors.black54,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  "30 min",
                  style: AppWidget.SemiBoldTextFieldStyle(),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Total Price",
                  style: AppWidget.SemiBoldTextFieldStyle(),
                ),
                const SizedBox(
                  width: 25.0,
                ),
                Text(
                  "\$" + widget.foodItemDetails["Total"],
                  style: AppWidget.SemiBoldTextFieldStyle(),
                )
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              "User Details ",
              style: AppWidget.BoldTextFieldStyle(),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Name:  " + userDetails["Name"],
                  style: AppWidget.SemiBoldTextFieldStyle(),
                ),
                Text(
                  "User Contact:  " + userDetails["Phone"],
                  style: AppWidget.SemiBoldTextFieldStyle(),
                ),
                Row(
                  children: [
                    Text(
                      "User Location ",
                      style: AppWidget.SemiBoldTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await LocationMethods().openMap(
                            userDetails['Latitude'], userDetails["Longitude"]);
                      },
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
