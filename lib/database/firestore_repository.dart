import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreRepository {
  static final firestoreRepository = FirebaseFirestore.instance;
  /*The collection that will hold all the data of the users is called 'users'.
   Each document under the 'users' collection will reference a user.
  the collection reference "ref" will be used to reference the collection of users
  */
  final CollectionReference ref = firestoreRepository.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  void createNewUser(String email) {
    var uid = ref.add(<String, dynamic>{"email": email});
  }

  Future<bool> doesUserDataExist() async {
    String userID = auth.currentUser.uid;
    var docs = await ref.where("uid", isEqualTo: userID).get();
    if (docs.docs.length == 0)
      return false;
    else
      return true;
  }

  Future<void> saveInitialProfile(Map<String, dynamic> json) async {
    String email = auth.currentUser.email;
    json["uid"] = auth.currentUser.uid;
    var docRef;
    await ref
        .where("email", isEqualTo: email)
        .get()
        .then((value) => {
          docRef = value.docs[0].reference
        });
    docRef.update(json);
  }
}
