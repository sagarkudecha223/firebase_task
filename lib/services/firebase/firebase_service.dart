import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
      });

      return userCredential.user;
    } catch (e) {
      print("Sign-Up Error: $e");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<void> logout() async => await _auth.signOut();

  User? getCurrentUser() => _auth.currentUser;

  Future<void> addPost(String message) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception("User not authenticated");

      await _firestore.collection("posts").add({
        "message": message,
        "email": user.email,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Failed to add post: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchPosts() => _firestore
      .collection("posts")
      .orderBy("timestamp", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
}
