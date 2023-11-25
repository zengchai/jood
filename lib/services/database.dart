import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jood/models/userprofile.dart';

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

  Future updateReviewData(String RfoodName,String RfoodPrice, String RfoodReview) async {
    return await reviewCollection.doc(uid).set({
      'RfoodName': RfoodName,
      'RfoodPrice': RfoodPrice,
      'RfoodReview' : RfoodReview
    });
  }


  Future updateOrderData(String fName, String price, String status) async {
    return await orderCollection.doc(uid).set({
      'fName': fName,
      'price': price,
      'status': status,
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
