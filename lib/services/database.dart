import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jood/models/userprofile.dart';
import 'package:jood/pages/Order/orderPage.dart';
import 'package:jood/pages/shoppingcart/CartItem.dart';
import 'package:jood/services/auth.dart';

import '../pages/Order/orderItem.dart';

class DatabaseService {
  late final String uid;
  DatabaseService({required this.uid});
  DatabaseService.noParams();
  final CollectionReference Jood =
      FirebaseFirestore.instance.collection('User');
  // final CollectionReference orderCollection =
  //     FirebaseFirestore.instance.collection('Order');
  final CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('reviews');
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');
  final CollectionReference paidOrderCollection =
      FirebaseFirestore.instance.collection('paidorder');

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

  Future updateReviewData(String foodID, String review, double rating) async {
    //UPDATE REVIEW DATA ON THE SAME ORDER
    await reviewCollection.doc(foodID).update({
      'RfoodReview': FieldValue.arrayUnion([review]),
    });

    String userName = await getUserName(uid) ?? 'Unknown User';

    return await reviewCollection
        .doc(foodID)
        .collection('RfoodRatings')
        .add({
          'userID': uid,
          'name': userName,
          'rating': rating,
          'reviewContent': review,
        })
        .then((_) => print('Review added successfully!'))
        .catchError((error) => print('Error adding review: $error'));
  }

  Future<String?> getUserName(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          (await Jood.doc(uid).get()) as DocumentSnapshot<Map<String, dynamic>>;

      if (userDoc.exists) {
        return userDoc.data()?['name'];
      } else {
        return null; // User not found
      }
    } catch (e) {
      print('Error getting username: $e');
      return null;
    }
  }

  Future setReviewData(String foodID) async {
    //SET REVIEW DATA WHEN ADD MORE FOOD
    return await reviewCollection.doc(foodID).set({
      'RfoodReview': [],
    });
  }

  // Function to add a food item to the cart
  Future<void> addToCart(String foodID, String foodName, String foodImage,
      double foodPrice) async {
    // Convert foodPrice to double if it's a String
    final double parsedPrice = foodPrice is String
        ? double.tryParse(foodPrice as String) ?? 0.0
        : (foodPrice as num).toDouble();

    final String itemId = '$foodName';

    // Check if the item already exists in the cart
    final DocumentSnapshot<Map<String, dynamic>> cartSnapshot =
        await cartCollection.doc(uid).get()
            as DocumentSnapshot<Map<String, dynamic>>;

    if (cartSnapshot.exists) {
      // If the cart exists, get the current items
      final Map<String, dynamic>? cartData = cartSnapshot.data();
      final List<dynamic>? existingItems = cartData?[itemId];

      if (existingItems != null) {
        // If the item exists, update the quantity
        final int existingQuantity = existingItems[3];
        final int newQuantity = existingQuantity + 1;

        await cartCollection.doc(uid).set({
          itemId: [foodName, foodImage, parsedPrice, newQuantity, foodID],
        }, SetOptions(merge: true));
      } else {
        // If the item doesn't exist, add it to the cart
        await cartCollection.doc(uid).set({
          itemId: [foodName, foodImage, parsedPrice, 1, foodID],
        }, SetOptions(merge: true));
      }
    } else {
      // If the cart doesn't exist, create a new one with the item
      await cartCollection.doc(uid).set({
        itemId: [foodName, foodImage, parsedPrice, 1, foodID],
      }, SetOptions(merge: true));
    }
  }

  // Function to retrieve cart items
  Stream<List<CartItem>> getCartItems() {
    return cartCollection.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return []; // Return an empty list if the document doesn't exist
      }

      var data = snapshot.data() as Map<String, dynamic>;

      // Retrieve all keys from the data map
      List<String> itemKeys = data.keys.toList();

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
            foodID: 'Invalid foodID',
          );
        }

        return CartItem(
          name: item[0] as String,
          image: item[1] as String,
          quantity: (item[3] as num).toInt(),
          price: (item[2] as num).toDouble(),
          foodID: item[4] as String,
        );
      }).toList();

      return cartItems;
    });
  }

  Future<String> createOrder(String paymentmethod) async {
    try {
      // Retrieve cart items
      String name = await getOrderInfo(uid) ?? '';
      List<CartItem> cartItems = await getCartItems().first;
      String status = "Preparing";

      // Calculate total price
      double totalPrice =
          cartItems.fold(0, (sum, item) => sum + item.price * item.quantity);

      // Create order ID
      final String orderId =
          'Order${DateFormat('yyyyMMddHHmm').format(DateTime.now())}';
      // Create a map to store items
      Map<String, dynamic> itemsMap = {};

      // Populate the map with item details
      for (int i = 0; i < cartItems.length; i++) {
        String itemId = 'item_$i'; // Unique identifier for each item
        itemsMap[itemId] = {
          'name': cartItems[i].name,
          'image': cartItems[i].image,
          'price': cartItems[i].price,
          'quantity': cartItems[i].quantity,
          'foodID': cartItems[i].foodID,
        };
      }

      // Create the order
      await paidOrderCollection.doc(uid).set({
        orderId: {
          'orderId': orderId,
          'timestamp':
              FieldValue.serverTimestamp(), // Set timestamp for date and time
          'items': itemsMap, // Store items using the map
          'name': name,
          'paymentMethod':
              paymentmethod, // Replace with the actual payment method
          'status': status,
          'totalPrice': totalPrice,
        },
      }, SetOptions(merge: true));

      print('Order created successfully');

      // Return the orderId
      return orderId;
    } catch (e) {
      print("Error creating order: $e");
      return ''; // Return an empty string in case of an error
    }
  }

  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      // Use .get() to fetch the document snapshot
      DocumentSnapshot orderSnapshot = await paidOrderCollection.doc(uid).get();

      // Check if the document exists
      if (orderSnapshot.exists) {
        // Extract the order details from the document data
        Map<String, dynamic> orderData =
            orderSnapshot.data() as Map<String, dynamic>;

        // Check if the orderId exists in the document
        if (orderData.containsKey(orderId)) {
          // Return the order details for the specified orderId
          return orderData[orderId] as Map<String, dynamic>;
        } else {
          print('Error: OrderId $orderId not found in document');
        }
      } else {
        print('Error: Document does not exist for user $uid');
      }
    } catch (e) {
      print('Error fetching order details: $e');
    }

    // Return an empty map in case of an error
    return {};
  }

  /*String _getPaymentmethodFromSnapshot(DocumentSnapshot snapshot) {
    var userPaymentMethod = snapshot.data() as Map<String, dynamic>;
    return userPaymentMethod['PaymentMethod'] ?? '';
  }
  Future<String?> getPaymentMethod(String uid) async {
    DocumentSnapshot<Object?> snapshot = await paidOrderCollection.doc(uid).get();
    String paymentMethod = _getPaymentmethodFromSnapshot(snapshot);
    return paymentMethod;
  }
  */

  Future<void> addCartItem(CartItem cartItem) async {
    final DocumentSnapshot<Map<String, dynamic>> cartSnapshot =
        await cartCollection.doc(uid).get()
            as DocumentSnapshot<Map<String, dynamic>>;

    if (cartSnapshot.exists) {
      // If the cart exists, get the current items
      final Map<String, dynamic>? cartData = cartSnapshot.data();
      final List<dynamic>? existingItems = cartData?[cartItem.name];

      if (existingItems != null) {
        // If the item exists, update the quantity
        final int existingQuantity = existingItems[3];
        final int newQuantity = existingQuantity + 1;

        await cartCollection.doc(uid).set({
          cartItem.name: [
            cartItem.name,
            cartItem.image,
            cartItem.price,
            newQuantity,
            cartItem.foodID,
          ],
        }, SetOptions(merge: true));
      }
    }
  }

  Future<void> minusCartItem(CartItem cartItem) async {
    final DocumentSnapshot<Map<String, dynamic>> cartSnapshot =
        await cartCollection.doc(uid).get()
            as DocumentSnapshot<Map<String, dynamic>>;

    if (cartSnapshot.exists) {
      // If the cart exists, get the current items
      final Map<String, dynamic>? cartData = cartSnapshot.data();
      final List<dynamic>? existingItems = cartData?[cartItem.name];

      if (existingItems != null) {
        // If the item exists, update the quantity
        final int existingQuantity = existingItems[3];
        final int newQuantity = existingQuantity - 1;

        await cartCollection.doc(uid).set({
          cartItem.name: [
            cartItem.name,
            cartItem.image,
            cartItem.price,
            newQuantity,
            cartItem.foodID,
          ],
        }, SetOptions(merge: true));
      }
    }
  }

  // Function to remove a cart item from Firestore
  Future<void> removeCartItem(CartItem cartItem) async {
    await cartCollection.doc(uid).update({
      '${cartItem.name}': FieldValue.delete(),
    });
  }

// Add a method to retrieve customer orders
  Stream<List<OrderItem>> getCustomerOrder(String? selectedDate) {
    return paidOrderCollection
        .doc(uid) // Replace "uid" with the actual user ID
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return []; // Return an empty list if the document doesn't exist
      }

      var data = snapshot.data() as Map<String, dynamic>;

      // Retrieve order keys
      List<String> orderKeys =
          data.keys.where((key) => key.startsWith('Order')).toList();

      if (orderKeys.isEmpty) {
        return []; // Return an empty list if there are no orders
      }

      List<OrderItem> orderItems = orderKeys.expand((orderKey) {
        var orderData = data[orderKey] as Map<String, dynamic>;
        var itemsData = orderData['items'] as Map<String, dynamic>;

        return itemsData.entries.map((itemEntry) {
          var itemData = itemEntry.value as Map<String, dynamic>;

          // Convert Timestamp to DateTime
          DateTime dateTime = (orderData['timestamp'] as Timestamp).toDate();

          // Format DateTime as "dd/MM/yyyy"
          String formattedDate =
              "${(dateTime.day).toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

          return OrderItem(
            orderID: orderData['orderId'] as String,
            foodName: itemData['name'] as String,
            foodImage: itemData['image'] as String,
            foodID: itemData['foodID'] as String,
            quantity: itemData['quantity'] as int,
            price: itemData['price'] as double,
            orderDate: formattedDate,
            status: orderData['status'] as String,
            username: orderData['name'] as String,
            totalPrice: orderData['totalPrice'] as double,
          );
        });
      }).toList();

      // Filter by date
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
    return paidOrderCollection.snapshots().map((querySnapshot) {
      List<List<OrderItem>> allOrders = [];

      for (var doc in querySnapshot.docs) {
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;

          // Retrieve all keys from the data map
          List<String> orderkeys =
              data.keys.where((key) => key.startsWith('Order')).toList();

          if (orderkeys.isNotEmpty) {
            List<OrderItem> orderItems = orderkeys.expand((orderKey) {
              var orderData = data[orderKey] as Map<String, dynamic>;
              var itemsData = orderData['items'] as Map<String, dynamic>;

              return itemsData.entries.map((itemEntry) {
                var itemData = itemEntry.value as Map<String, dynamic>;

                // Convert Timestamp to DateTime
                DateTime dateTime =
                    (orderData['timestamp'] as Timestamp).toDate();

                // Format DateTime as "dd/MM/yyyy"
                String formattedDate =
                    "${(dateTime.day).toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

                return OrderItem(
                  orderID: orderData['orderId'] as String,
                  foodName: itemData['name'] as String,
                  foodImage: itemData['image'] as String,
                  foodID: itemData['foodID'] as String,
                  quantity: itemData['quantity'] as int,
                  price: itemData['price'] as double,
                  orderDate: formattedDate,
                  status: orderData['status'] as String,
                  username: orderData['name'] as String,
                  totalPrice: orderData['totalPrice'] as double,
                );
              });
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

      return allOrders;
    });
  }

//method to update the order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      // Fetch all documents in the collection
      QuerySnapshot<Object?> orderSnapshot = await paidOrderCollection.get();

      // Iterate through each document
      for (QueryDocumentSnapshot<Object?> document in orderSnapshot.docs) {
        var orderData = document.data() as Map<String, dynamic>;

        // Check if the order with the given orderId exists in this document
        if (orderData.containsKey(orderId)) {
          // Update the status for the specific order
          orderData[orderId]['status'] = status;

          // Update only the specific order within the document
          await paidOrderCollection.doc(document.id).set(orderData);
          return; // Exit the function after updating the order
        }
      }

      // If the loop completes without finding the order, log a message
      print("Order with ID $orderId not found.");
    } catch (e) {
      print("Error updating order status: $e");
      // Handle errors here
    }
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

  String _getNameFromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;
    return userData['name'] ?? '';
  }

  Future<String?> getOrderInfo(String uid) async {
    DocumentSnapshot<Object?> snapshot = await Jood.doc(uid).get();
    String name = _getNameFromSnapshot(snapshot);
    return name;
  }

  Future<Map<String, dynamic>> retrieveCartItems() async {
    // Get the current cart snapshot
    final DocumentSnapshot<Object?> cartSnapshot =
        await cartCollection.doc(uid).get();

    if (cartSnapshot.exists) {
      var data = cartSnapshot.data() as Map<String, dynamic>;

      // Assuming there is a single item in the cart for simplicity
      List<String> itemKeys = data.keys.toList();

      if (itemKeys.isNotEmpty) {
        // Get the item details from the first key
        dynamic item = data[itemKeys.first];

        // Check if the item is in the correct format
        if (item != null &&
            item is List<dynamic> &&
            item.length >= 4 &&
            item[0] is String &&
            item[1] is String &&
            item[2] is num &&
            item[3] is num) {
          String foodName = item[0] as String;
          String foodImage = item[1] as String;
          double foodPrice = (item[2] as num).toDouble();
          int foodQuantity = (item[3] as num).toInt();

          // Store the values in a map and return it
          return {
            'foodName': foodName,
            'foodImage': foodImage,
            'foodPrice': foodPrice,
            'foodQuantity': foodQuantity,
          };
        }
      }
    }
    // Return an empty map if there is an error or the cart is empty
    return {};
  }

  Stream<List<ReviewItem>> getReviews(String foodID) {
    return reviewCollection
        .doc(foodID)
        .collection('RfoodRatings')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        // Create a ReviewItem object with relevant data
        return ReviewItem(
          userID: data['userID'] ?? '',
          userName: data['name'] ?? 'Unknown User',
          rating: data['rating'] ?? 0.0,
          reviewContent: data['reviewContent'] ?? '',
        );
      }).toList();
    });
  }

  setPaymentData(String s, String t) {}
}

class ReviewItem {
  final String userID;
  final String userName;
  final double rating;
  final String reviewContent; // Add this property

  ReviewItem({
    required this.userID,
    required this.userName,
    required this.rating,
    required this.reviewContent, // Add this constructor parameter
  });
}
