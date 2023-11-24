import 'package:firebase_auth/firebase_auth.dart';
import 'package:jood/models/users.dart';
import 'package:jood/services/database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on firebaseuser
  AppUsers? _userFromFirebaseUser(User user){
    return user !=null ? AppUsers(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<AppUsers> get changeuser{
    return _auth.authStateChanges()
      .map((User? user) => _userFromFirebaseUser(user!)!);
  }

  // sign in anon
Future signInAnon() async {
  try{
    UserCredential result  = await _auth.signInAnonymously();
    User? users = result.user;

    return _userFromFirebaseUser(users!);
  }
  catch(e){
    print(e.toString());
    return null;
  }
}
  // sign in with email & password
  Future signInWithEmailAndPassword (String email, String password) async {
    try{
      UserCredential result  = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? users = result.user;
      return _userFromFirebaseUser(users!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }
  // register with email & password
  Future registerWithEmailAndPassword (String email, String password, String name) async {
    try{
      UserCredential result  = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? users = result.user;

      //create a new document for the new user with the uid
      await DatabaseService(uid: users!.uid).setUserData(users.uid, name, email,'','','');
      await DatabaseService(uid: users!.uid).updatePaymentData('TnG', '0.00');
      await DatabaseService(uid: users!.uid).updateOrderData('Fried Rice', '0.00', 'Order Preparing');
      return _userFromFirebaseUser(users);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async{
      try{
        return await _auth.signOut();
      } catch(e){
        print(e.toString());
        return null;
      }
  }

  Future<void> deleteUserData(String uid) async {
    final firestore = FirebaseFirestore.instance;

    // Define a list of collection names associated with the user
    List<String> collectionNames = ['user', 'payments'];

    // Iterate through the collections and delete documents by UID
    for (String collectionName in collectionNames) {
      await firestore.collection(collectionName).doc(uid).delete();
    }
  }


  Future deleteUserAccount() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await deleteUserData(user.uid); // Delete Firestore data first
        await user.delete(); // Delete the Authentication account
        return await FirebaseAuth.instance.signOut();
      } catch (e) {
        print("Error deleting user account: $e");
      }
    }
  }
}