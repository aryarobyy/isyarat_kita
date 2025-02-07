import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isyarat_kita/models/user_model.dart';
import 'package:uuid/uuid.dart';

const String USER_COLLECTION = "users";

class AuthService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _storage = FlutterSecureStorage();


  bool isEmailValid (String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<UserModel> registerUser ({
    required String email,
    required String name,
    String? image,
    String? username,
    DateTime? createdAt,
    required String password,
    }) async {
    if (!isEmailValid(email.trim())) {
      throw Exception("Email is not valid");
    }

    final querySnapshot = await _fireStore
        .collection(USER_COLLECTION)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      throw Exception("Email already exists");
    }

      try {
        final String uuid = Uuid().v4();
        await _storage.write(key: 'userId', value: uuid);

        UserModel user = UserModel(
          userId: uuid,
          email: email,
          profilePic: "",
          username: "",
          role: "user",
          name: '',
          createdAt: DateTime.now(),
        );
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        await _fireStore
            .collection(USER_COLLECTION)
            .doc(uuid)
            .set(user.toMap());

        return user;
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuth Error: ${e.message}");
        throw e;
      } catch (e) {
        print("General Error: ${e.toString()}");
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
      final querySnapshot = await _fireStore
          .collection(USER_COLLECTION)
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("User not found.");
      }

      final userData = querySnapshot.docs.first.data();
      final userId = userData['userId'];

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _storage.write(key: 'userId', value: userId);
      return UserModel.fromMap(userData);
    }  on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error: ${e.message}");
      throw e;
    } catch (e) {
      print("General Error: ${e.toString()}");
      throw e;
    }
  }

  Stream<UserModel?> getUserById(String userId) {
    return _fireStore
        .collection(USER_COLLECTION)
        .doc(userId)
        .snapshots()
        .map((docSnapshot) {
      if (docSnapshot.exists) {
        return UserModel.fromMap(docSnapshot.data()!);
      }
      return null;
    });
  }

  Future<UserModel?> updateUser(String userId, Map<String, dynamic> updatedData) async {
    await _fireStore
        .collection(USER_COLLECTION)
        .doc(userId)
        .set(updatedData);
    final DocumentSnapshot userDoc =
    await _fireStore.collection(USER_COLLECTION).doc(userId).get();

    if (userDoc.exists) {
      print("Fetched updated user data: ${userDoc.data()}");
      return UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
    } else {
      print("User document not found after update.");
      throw Exception("Failed to retrieve updated user data");
    }
  }



  Future<void> signOut() async {
    await _storage.delete(key: 'userId');
    // await NotificationService.dispose();
    await _auth.signOut();
  }
}