import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:uuid/uuid.dart';

const String USER_COLLECTION = "users";

class AuthService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isEmailValid (String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<UserModel> registerUser ({
    required String email,
    String? name,
    String? image,
    String? username,
    DateTime? createdAt,
    required String password,
    }) async {
    if(!isEmailValid(email.trim())) {
      print("Email is not valid");
    }

    final querySnapshot = await _fireStore
        .collection(USER_COLLECTION)
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print("Email already exist");
    }

    await _auth.createUserWithEmailAndPassword(email: email, password: password);

    final String uuid = Uuid().v4();

      try {
        UserModel user = UserModel(
          userId: uuid,
          email: email,
          image: "",
          name: "",
          username: "",
          createdAt: DateTime.now(),
        );
        await _fireStore
            .collection(USER_COLLECTION)
            .doc(uuid)
            .set(user.toMap());

        return user;
      } catch (e) {
        throw e;
      }
    }

  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Email and password must not be empty.");
    }

    if (!isEmailValid(email.trim())) {
      throw Exception("Invalid email format.");
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final querySnapshot = await _fireStore
          .collection(USER_COLLECTION)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("User not found.");
      }

      final userData = querySnapshot.docs.first.data();
      final String documentId = querySnapshot.docs.first.id;

      return UserModel.fromMap(userData, documentId);
    } catch (e) {
      throw Exception("Login failed: ${e.toString()}");
    }
  }

  Future<void> signOut() async {
    // await NotificationService.dispose();
    await _auth.signOut();
  }
}