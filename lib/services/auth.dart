import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;

  User get currentUser => _firebaseAuth.currentUser;

  Future<User> signInAnnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  Future<User> signOut() async {
    await _firebaseAuth.signOut();
  }
}
