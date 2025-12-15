import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<User?> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _db.collection('users').doc(res.user!.uid).set({
      "uid": res.user!.uid,
      "name": name,
      "email": email,
      "subscription_end": "",
      "created_at": FieldValue.serverTimestamp(),
    });

    return res.user;
  }

  Future<User?> loginWithEmail(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<User?> signInWithGoogle() async {
    final signIN = GoogleSignIn.instance;
    await signIN.initialize(
      serverClientId:
          "265741029614-k6kv68c48ppp2c7m6svugl043jra8n16.apps.googleusercontent.com",
    );
    GoogleSignInAccount account = await signIN.authenticate();
    GoogleSignInAuthentication googleAuth = account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final res = await _auth.signInWithCredential(credential);

    final doc = await _db.collection('users').doc(res.user!.uid).get();

    if (!doc.exists) {
      await _db.collection('users').doc(res.user!.uid).set({
        "uid": res.user!.uid,
        "name": res.user!.displayName ?? "",
        "email": res.user!.email ?? "",
        "subscription_end": "",
        "created_at": FieldValue.serverTimestamp(),
      });
    }

    return res.user;
  }
}
