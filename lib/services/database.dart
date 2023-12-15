import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jood/models/userprofile.dart';
import 'package:jood/pages/Order/orderPage.dart';
import 'package:jood/pages/shoppingcart/CartItem.dart';
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
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');

  Future setUserData(String uid, String name, String email, String matricnum,
      String phonenum, String address) async {
    return await Jood.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'matricnum': matricnum,
      'phonenum': phonenum,
      'address': address,
    });
  }

  Future updateAddressData(String address) async {
    return await Jood.doc(uid).update({
      'address': address,
    });
  }

  Future updateUserData(String name, String email, String matricnum,
      String phonenum, String address) async {
    return await Jood.doc(uid).update({
      'uid': uid,
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

  Future updateReviewData(String foodID, String review) async { //UPDATE REVIEW DATA ON THE SAME ORDER
    return await reviewCollection.doc(foodID).update({
      'RfoodReview' : FieldValue.arrayUnion([review]),
    });
  }

  Future setReviewData(String foodID) async { //SET REVIEW DATA WHEN ADD MORE FOOD
    return await reviewCollection.doc(foodID).set({
      'RfoodReview' : [],
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

  // Function to add a food item to the cart
  Future<void> addToCart(
      String foodName, String foodImage, double foodPrice) async {
    // Convert foodPrice to double if it's a String
    final double parsedPrice = foodPrice is String
        ? double.tryParse(foodPrice as String) ?? 0.0
        : (foodPrice as num).toDouble();

    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    await cartCollection.doc(uid).set({
      'item$timestamp': FieldValue.arrayUnion([foodName,foodImage,parsedPrice,1]), // Initial quantity
    }, SetOptions(merge: true));
  }


  // Function to retrieve cart items
  Stream<List<CartItem>> getCartItems() {
    return cartCollection.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return []; // Return an empty list if the document doesn't exist
      }

      var data = snapshot.data() as Map<String, dynamic>;

      // Retrieve all keys from the data map
      List<String> itemKeys = data.keys.where((key) => key.startsWith('item')).toList();

      if (itemKeys.isEmpty) {
        return []; // Return an empty list if there are no item keys
      }

      // Map the item keys to a list of CartItem objects
      List<CartItem> cartItems = itemKeys.map((key) {
        dynamic item = data[key];
        print('Item: $item');
        if (item == null || item is! List<dynamic> || item.length < 4) {
          return CartItem(
            name: 'Invalid Item Format',
            image: 'error_image.jpg',
            quantity: 0,
            price: 0.0,
          );
        }

        return CartItem(
          name: item[0] as String,
          image: item[1] as String,
          quantity: (item[3] as num).toInt(),
          price: (item[2] as num).toDouble(),
        );
      }).toList();

      return cartItems;
    });
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
      uid: userData['uid'] ?? '',
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

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot<Object?> snapshot = await Jood.doc(uid).get();
      return _userProfileFromSnapshot(snapshot);
    } catch (e) {
      // Handle errors here
      print("Error fetching user profile: $e");
      return null; // You might want to return a default or empty profile in case of an error
    }
  }

  Stream<List<String>> foodReviewsStream(String foodID) {
    return reviewCollection.doc(foodID).snapshots().map((snapshot) {
      var data = snapshot.data() as Map<String, dynamic>;
      List<String> foodReviews = List<String>.from(data['RfoodReview'] ?? []);
      return foodReviews;
    });
  }


  setPaymentData(String s, String t) {}
}
