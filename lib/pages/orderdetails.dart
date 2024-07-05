import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_food/service/database.dart';
import 'package:home_food/service/shared_pref.dart';
import 'package:home_food/widget/widget_support.dart';
import 'package:home_food/service/location.dart';

class OrderDetails extends StatefulWidget {
  Map<String, dynamic> foodItemDetails;
  OrderDetails({
    super.key,
    required this.foodItemDetails,
  });

  @override
  State<OrderDetails> createState() => _DetailsState();
}

class _DetailsState extends State<OrderDetails> {
  int a = 1, total = 0;
  String? userId;
  var adminDetails;

  getthesharedpref() async {
    Map<String, dynamic> userDetails =
        jsonDecode((await SharedPreferenceHelper().getUserDetails())!);
    userId = userDetails["Id"];
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    adminDetails = await DatabaseMethods()
        .getAdminDetails(widget.foodItemDetails["AdminId"]);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    total = int.parse(widget.foodItemDetails["Price"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.black,
                )),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              "Status: " + widget.foodItemDetails["Status"],
              style: AppWidget.BoldTextFieldStyle(),
            ),
            const SizedBox(
              height: 15.0,
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
            const SizedBox(
              height: 30.0,
            ),
            Text(
              "Cook Details ",
              style: AppWidget.BoldTextFieldStyle(),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Cook Name:  " + adminDetails["Name"],
                  style: AppWidget.SemiBoldTextFieldStyle(),
                ),
                Text(
                  "Cook Contact:  " + adminDetails["Phone"],
                  style: AppWidget.SemiBoldTextFieldStyle(),
                ),
                Text(
                  "Cook UPI ID:  " + adminDetails['UPIId'],
                  style: AppWidget.SemiBoldTextFieldStyle(),
                ),
                Row(
                  children: [
                    Text(
                      "Cook Location ",
                      style: AppWidget.SemiBoldTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await LocationMethods().openMap(
                            adminDetails['Latitude'],
                            adminDetails["Longitude"]);
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
