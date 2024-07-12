import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:home_food/widget/widget_support.dart';

import '../pages/details.dart';
import '../service/database.dart';
import '../service/shared_pref.dart';
import 'admin_details.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  bool newOrder = true, acceptedOrder = false, completedOrder = false;
  String? userId;
  Stream? foodItemStream;

  ontheload() async {
    userId =
        (jsonDecode((await SharedPreferenceHelper().getUserDetails())!))["Id"];
    setState(() {});
    foodItemStream = await DatabaseMethods().getOrders(userId!, "newOrders");
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
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xFF373866),
              )),
          centerTitle: true,
          title: Text(
            "Orders",
            style: AppWidget.HeadlineTextFieldStyle(),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(
                  top: 30.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    showTopBar(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    allItemsVertically(),
                  ],
                ))));
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
                        Map<String, dynamic> orderDetails =
                            ds.data() as Map<String, dynamic>;
                        orderDetails["CurrentOrderStatus"] = newOrder
                            ? "newOrders"
                            : acceptedOrder
                                ? "acceptedOrders"
                                : "completedOrders";
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminOrderDetails(
                                      foodItemDetails: orderDetails,
                                    )));
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(right: 20.0, bottom: 20.0),
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
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                          ds.get('Name'),
                                          style: AppWidget
                                              .SemiBoldTextFieldStyle(),
                                        )),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                          ds.get('Detail'),
                                          style:
                                              AppWidget.LightTextFieldStyle(),
                                        )),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                          "\$" + ds.get('Price'),
                                          style: AppWidget
                                              .SemiBoldTextFieldStyle(),
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
        });
  }

  Widget showTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            newOrder = true;
            acceptedOrder = false;
            completedOrder = false;
            foodItemStream =
                await DatabaseMethods().getOrders(userId!, "newOrders");
            setState(() {});
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "New",
              style: newOrder
                  ? AppWidget.UnderlineTextFieldStyle()
                  : AppWidget.BoldTextFieldStyle(),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            newOrder = false;
            acceptedOrder = true;
            completedOrder = false;
            foodItemStream =
                await DatabaseMethods().getOrders(userId!, "acceptedOrders");
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Accepted",
              style: acceptedOrder
                  ? AppWidget.UnderlineTextFieldStyle()
                  : AppWidget.BoldTextFieldStyle(),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            newOrder = false;
            acceptedOrder = false;
            completedOrder = true;
            foodItemStream =
                await DatabaseMethods().getOrders(userId!, "completedOrders");
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Completed",
              style: completedOrder
                  ? AppWidget.UnderlineTextFieldStyle()
                  : AppWidget.BoldTextFieldStyle(),
            ),
          ),
        ),
      ],
    );
  }
}
