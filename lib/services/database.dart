import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jood/models/userprofile.dart';
import 'package:jood/pages/Order/orderPage.dart';
import 'package:jood/services/auth.dart';

class DatabaseService {
  late final String uid;
  DatabaseService({required this.uid});
  DatabaseService.noParams();
  final CollectionReference Jood =
      FirebaseFirestore.instance.collection('User');
  final CollectionReference paymentCollection =
      FirebaseFirestore.instance.collection('payments');
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection('orders');
  final CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('reviews');

  Future updateUserData(String name, String email, String matricnum,
      String phonenum, String address) async {
    return await Jood.doc(uid).set({
      'name': name,
      'email': email,
      'matricnum': matricnum,
      'phonenum': phonenum,
      'address': address,
    });
  }

  Future updatePaymentData(String Pmethod, String amount) async {
    return await paymentCollection.doc(uid).set({
      'Pmethod': Pmethod,
      'amount': amount,
    });
  }

  Future updateReviewData(
      String RfoodName, String RfoodPrice, String RfoodReview) async {
    return await reviewCollection.doc(uid).set({
      'RfoodName': RfoodName,
      'RfoodPrice': RfoodPrice,
      'RfoodReview': RfoodReview
    });
  }

  Future updateOngoingOrder(List<OrderItem> orderItem) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var order in orderItem) {
      final orderDocRef = orderCollection
          .doc(uid)
          .collection('ongoing_orders')
          .doc(order.orderID);

      batch.set(orderDocRef, order.toMap());
    }

    // Commit the batch operation
    await batch.commit();
  }

  Future updateOrderHistory(List<OrderItem> orderItem) async {
    final batch = FirebaseFirestore.instance.batch();

    for (var order in orderItem) {
      final orderDocRef = orderCollection
          .doc(uid)
          .collection('order_history')
          .doc(order.orderID);

      batch.set(orderDocRef, order.toMap());
    }

    // Commit the batch operation
    await batch.commit();
  }

// Add a method to retrieve ongoing orders
  Stream<List<OrderItem>> get ongoingOrderItems {
    return orderCollection
        .doc(uid)
        .collection('ongoing_orders')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return OrderItem(
          orderID: doc.id,
          foodName: data['name'] ?? '',
          image: data['image'] ?? '',
          quantity: data['quantity'] ?? 0,
          price: data['price'] ?? 0.0,
          status: data['status'] ?? '',
        );
      }).toList();
    });
  }

// Add a method to retrieve order history
  Stream<List<OrderItem>> get orderHistoryItems {
    return orderCollection
        .doc(uid)
        .collection('order_history')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return OrderItem(
          orderID: doc.id,
          foodName: data['name'] ?? '',
          image: data['image'] ?? '',
          quantity: data['quantity'] ?? 0,
          price: data['price'] ?? 0.0,
          status: data['status'] ?? '',
        );
      }).toList();
    });
  }

// Convert a single document snapshot to a UserProfile
  UserProfile _userProfileFromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;
    return UserProfile(
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      matricnum: userData['matricnum'] ?? '',
      phonenum: userData['phonenum'] ?? '',
      address: userData['address'] ?? '',
    );
  }

  // get streams
  Stream<UserProfile> get useraccount {
    return Jood.doc(uid).snapshots().map(_userProfileFromSnapshot);
  }
}
