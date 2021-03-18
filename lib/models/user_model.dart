import 'package:flutter/material.dart';

class UserModel {
  var profileImage;
  String username;
  String userAddress;
  int userID;
  int friendCount;
  int postCount;
  int chatCount;
  UserModel(
      {this.profileImage,
      this.userAddress,
      this.username,
      this.chatCount,
      this.friendCount,
      this.postCount,
      this.userID});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(userAddress: json["address"]);
  }

  factory UserModel.basic(Map<String, dynamic> json) {
    return UserModel(userAddress: json["address"], username: json["username"]);
  }

  factory UserModel.myProfile(Map<String, dynamic> json, String address, var profileImage) {
    return UserModel(
        userAddress: address,
        username: json["username"],
        profileImage: profileImage,
        userID: json["id"],
        friendCount: json["friendCount"],
        chatCount: json["chatCount"],
        postCount: json["postCount"]);
  }
}
