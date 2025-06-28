part of 'pages.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<FirebaseUser> signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<void> signOut() async {
    _auth.signOut();
  }

  static Stream<FirebaseUser> get firebaseUserStream {
    return _auth.onAuthStateChanged;
  }
}
