import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_food/service/database.dart';
import 'package:home_food/service/shared_pref.dart';
import 'package:home_food/widget/widget_support.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  String? userId;
  double totalPrice = 0;
  Stream<QuerySnapshot>? foodStream;

  getthesharedpref() async {
    Map<String, dynamic> userDetails =
        jsonDecode((await SharedPreferenceHelper().getUserDetails())!);
    userId = userDetails["Id"];
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(userId!);
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget foodCart() {
    double total=0;
    foodStream?.forEach((snapshot) {
      snapshot.docs.forEach((element) {
        total = total + double.parse((element.data() as Map)["Total"]);
      });
      totalPrice = total;
      setState(() { });
    });
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
                    return Container(
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
                                    ds["Name"],
                                    style: AppWidget.SemiBoldTextFieldStyle(),
                                  ),
                                  Text(
                                    "\$" + ds.get("Total"),
                                    style: AppWidget.SemiBoldTextFieldStyle(),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 50.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await DatabaseMethods()
                                      .deleteCartItem(userId!, ds.id);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child: Container(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                      "Food Cart",
                      style: AppWidget.HeadlineTextFieldStyle(),
                    )))),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: foodCart()),
            const Spacer(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: AppWidget.BoldTextFieldStyle(),
                  ),
                  Text(
                    "\$$totalPrice",
                    style: AppWidget.SemiBoldTextFieldStyle(),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () async {
                await DatabaseMethods().cartToOrders(userId!,"Ordered");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: const Center(
                    child: Text(
                  "CheckOut",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
