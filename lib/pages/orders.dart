import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_food/widget/widget_support.dart';
import 'package:home_food/service/database.dart';
import 'package:home_food/service/shared_pref.dart';
import 'package:home_food/pages/orderdetails.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String? userId;
  Stream<QuerySnapshot>? foodStream;

  getthesharedpref() async {
    Map<String, dynamic> userDetails =
    jsonDecode((await SharedPreferenceHelper().getUserDetails())!);
    userId = userDetails["Id"];
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getOrderItems(userId!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget orderItems() {
    return StreamBuilder(
        stream: foodStream,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrderDetails(
                                  foodItemDetails: ds.data() as Map<String, dynamic>
                                )));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                              height: 90,
                              width: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text(ds["Quantity"])),
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(
                                  ds["Image"],
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Column(
                              children: [
                                Text(
                                  ds["Status"],
                                  style: AppWidget.BoldTextFieldStyle(),
                                ),
                                Text(
                                  ds["Name"],
                                  style: AppWidget.SemiBoldTextFieldStyle(),
                                ),
                                Text(
                                  "\$" + ds.get("Total"),
                                  style: AppWidget.SemiBoldTextFieldStyle(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
              : const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.only(top: 60.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Material(
                  elevation: 2.0,
                  child: Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Center(
                          child: Text(
                        "My orders",
                        style: AppWidget.HeadlineTextFieldStyle(),
                      )))),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: orderItems()),
            ])));
  }
}
