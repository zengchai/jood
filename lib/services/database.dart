import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jood/models/userprofile.dart';
import 'package:jood/pages/Order/orderItem.dart';
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
      FirebaseFirestore.instance.collection('Order');
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

  Future updateReviewData(String foodID, String review) async {
    //UPDATE REVIEW DATA ON THE SAME ORDER
    return await reviewCollection.doc(foodID).update({
      'RfoodReview': FieldValue.arrayUnion([review]),
    });
  }

  Future setReviewData(String foodID) async {
    //SET REVIEW DATA WHEN ADD MORE FOOD
    return await reviewCollection.doc(foodID).set({
      'RfoodReview': [],
    });
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
      'item$timestamp': FieldValue.arrayUnion(
          [foodName, foodImage, parsedPrice, 1]), // Initial quantity
    }, SetOptions(merge: true));
  }

//ffdfdfdf
  // Function to retrieve cart items
  Stream<List<CartItem>> getCartItems() {
    return cartCollection.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return []; // Return an empty list if the document doesn't exist
      }

      var data = snapshot.data() as Map<String, dynamic>;

      // Retrieve all keys from the data map
      List<String> itemKeys =
          data.keys.where((key) => key.startsWith('item')).toList();

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

// Add a method to retrieve customer orders
  Stream<List<OrderItem>> getCustomerOrder(String? selectedDate) {
    return orderCollection
        .doc("H4zCS1bQB8DxpvqzOexp")
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return []; // Return an empty list if the document doesn't exist
      }

      var data = snapshot.data() as Map<String, dynamic>;

      // Retrieve all keys from the data map
      List<String> orderkeys =
          data.keys.where((key) => key.startsWith('Order')).toList();

      if (orderkeys.isEmpty) {
        return []; // Return an empty list if there are no item keys
      }

      List<OrderItem> orderItems = orderkeys.map((key) {
        dynamic item = data[key];
        print('Item: $item');
        if (item == null || item is! List<dynamic> || item.length < 4) {
          return OrderItem(
              foodName: 'Invalid Item Format',
              foodImage: 'error_image.jpg',
              quantity: 0,
              price: 0.0,
              orderDate: "Invalid date");
        }

        // Convert Timestamp to DateTime
        DateTime dateTime = (item[4] as Timestamp).toDate();

        // Format DateTime as "dd/MM/yyyy"
        //String formattedDate =
        //   "${(dateTime.day + 1).toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

        String formattedDate;

        if (dateTime.day != 1) {
          formattedDate =
              "${(dateTime.day + 1).toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
        } else {
          formattedDate =
              "${(dateTime.day + 1).toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
        }

        return OrderItem(
          foodName: item[1] as String,
          foodImage: item[0] as String,
          quantity: (item[3] as num).toInt(),
          price: (item[2] as num).toDouble(),
          orderDate: formattedDate,
        );
      }).toList();

      //to filter the date
      if (selectedDate != null) {
        orderItems = orderItems
            .where((orderItem) => orderItem.orderDate == selectedDate)
            .toList();
      }

      return orderItems;
    });
  }

  // Add a method to retrieve all customer orders for seller
  Stream<List<List<OrderItem>>> getSellerOrder({String? selectedDate}) {
    return orderCollection.snapshots().map((querySnapshot) {
      List<List<OrderItem>> allOrders = [];

      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;

          // Retrieve all keys from the data map
          List<String> orderkeys =
              data.keys.where((key) => key.startsWith('Order')).toList();

          if (orderkeys.isNotEmpty) {
            List<OrderItem> orderItems = orderkeys.map((key) {
              dynamic item = data[key];

              if (item == null || item is! List<dynamic> || item.length < 4) {
                return OrderItem(
                    foodName: 'Invalid Item Format',
                    foodImage: 'error_image.jpg',
                    quantity: 0,
                    price: 0.0,
                    orderDate: "Invalid date");
              }
              // Convert Timestamp to DateTime
              DateTime dateTime = (item[4] as Timestamp).toDate();

              // Format DateTime as "dd/MM/yyyy"
              String formattedDate =
                  "${(dateTime.day + 1).toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

              // if (dateTime.day == 1) {
              //   formattedDate =
              //       "${(dateTime.day).toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
              // } else {
              //   formattedDate =
              //       "${(dateTime.day + 1).toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
              // }

              return OrderItem(
                  foodName: item[1] as String,
                  foodImage: item[0] as String,
                  quantity: (item[3] as num).toInt(),
                  price: (item[2] as num).toDouble(),
                  orderDate: formattedDate);
            }).toList();

            // Filter orders by selectedDate for each order individually
            if (selectedDate != null) {
              orderItems = orderItems
                  .where((orderItem) => orderItem.orderDate == selectedDate)
                  .toList();
            }

            allOrders.add(orderItems);
          }
        }
      }

      // //to filter the date
      // if (selectedDate != null) {
      //   allOrders = allOrders
      //       .where((orderItems) => orderItems
      //           .any((orderItem) => (orderItem.orderDate) == selectedDate))
      //       .toList();
      // }

      return allOrders;
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
