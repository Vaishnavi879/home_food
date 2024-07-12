import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(
      String userType, Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection(userType)
        .doc(id)
        .set(userInfoMap);
  }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String userId,
      String foodItemId) async {
    return await FirebaseFirestore.instance
        .collection('admin')
        .doc(userId)
        .collection("foodItems")
        .doc(foodItemId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String userId) async {
    return FirebaseFirestore.instance
        .collection('admin')
        .doc(userId)
        .collection('foodItems')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrders(
      String userId, String orderType) async {
    return FirebaseFirestore.instance
        .collection('admin')
        .doc(userId)
        .collection(orderType)
        .snapshots();
  }

  Future getUserDetails(String userType, String userId) async {
    return FirebaseFirestore.instance.collection(userType).doc(userId).get();
  }

  Future addFoodToCart(
      Map<String, dynamic> userInfoMap, String id, String foodItemId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .doc(foodItemId)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getOrderItems(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("orders")
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCartItems(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Cart")
        .get();
  }

  Future addLocationToUsers(
      String userType, Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection(userType)
        .doc(id)
        .update(userInfoMap);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers(String userType) {
    return FirebaseFirestore.instance.collection(userType).get();
  }

  Future deleteCartItem(String userId, String itemId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Cart")
        .doc(itemId)
        .delete();
  }

  Future cartToOrders(String userId, String status) async {
    var cartItems = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("Cart")
        .get();
    for (var result in cartItems.docs) {
      Map<String, dynamic> data = result.data();
      data['UserId'] = userId;
      await addItemToNewCollection('admin', data["AdminId"], 'newOrders', data);
      Map<String, dynamic> foodData = result.data();
      foodData["Status"] = status;
      await addItemToNewCollection('users', userId, 'orders', foodData);
      await deleteCartItem(userId, result.data()["Id"]);
    }
  }

  Future addItemToNewCollection(String userType, String userId,
      String newCollection, Map<String, dynamic> data) {
    return FirebaseFirestore.instance
        .collection(userType)
        .doc(userId)
        .collection(newCollection)
        .doc(data["Id"])
        .set(data);
  }

  Future adminOrderStatusChange(String adminId, String orderId,
      String prevCollection, String newCollection) async {
    print(prevCollection);
    print(orderId);
    print(adminId);
    var order = await FirebaseFirestore.instance
        .collection('admin')
        .doc(adminId)
        .collection(prevCollection)
        .doc(orderId)
        .get();
    await FirebaseFirestore.instance
        .collection('admin')
        .doc(adminId)
        .collection(prevCollection)
        .doc(orderId)
        .delete();
    return FirebaseFirestore.instance
        .collection('admin')
        .doc(adminId)
        .collection(newCollection)
        .doc(orderId)
        .set(order.data()!);
  }

  Future changeOrderStatus(String userId, String adminId, String orderId,
      String prevCollection, String newCollection) async {
    await adminOrderStatusChange(
        adminId, orderId, prevCollection, newCollection);
    String status =
        newCollection == "acceptedOrders" ? "Accepted" : "Completed";
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("orders")
        .doc(orderId)
        .update({"Status": status});
  }
}
