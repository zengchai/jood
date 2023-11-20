import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({ required this.uid});
  final CollectionReference Jood =  FirebaseFirestore.instance.collection('User');
  final CollectionReference paymentCollection = FirebaseFirestore.instance.collection('payments');

  Future updateUserData(String name,String email) async {
    return await Jood.doc(uid).set({
      'name': name,
      'email': email,
    });
  }
  Future updatePaymentData(String Pmethod,String amount) async {
    return await paymentCollection.doc(uid).set({
      'Pmethod': Pmethod,
      'amount': amount,
    });
  }



}