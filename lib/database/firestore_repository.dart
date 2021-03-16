import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decentragram/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class FirestoreRepository {
  static final firestoreRepository = FirebaseFirestore.instance;
  /*The collection that will hold all the data of the users is called 'users'.
   Each document under the 'users' collection will reference a user.
  the collection reference "ref" will be used to reference the collection of users
  */
  final CollectionReference ref = firestoreRepository.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;

  void createNewUser(String email) {
    var privateKey = generateNewPrivateKey(Random.secure());
    var uid = ref.add(<String, dynamic>{
      "email": email,
      "address": EthereumAddress.fromPublicKey(privateKeyToPublic(privateKey))
          .toString()
    });
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
        .then((value) => {docRef = value.docs[0].reference});
    docRef.update(json);
  }

  Future<bool> userExists() async {
    String uid = auth.currentUser.uid;
    var querySnapshot = await ref.where("uid", isEqualTo: uid).get();
    var docsLength = querySnapshot.docs.length;
    return docsLength == 0 ? false : true;
  }

  Future<UserModel> getUser() async {
    String email = auth.currentUser.email;
    var querySnapshot = await ref.where("email", isEqualTo: email).get();
    var doc = querySnapshot.docs[0];
    return UserModel.fromJson(doc.data());
  }
}
