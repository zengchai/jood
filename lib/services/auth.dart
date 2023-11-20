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
      await DatabaseService(uid: users!.uid).updateUserData(name, email,'','','');
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
}