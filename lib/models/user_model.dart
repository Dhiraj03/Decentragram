import 'package:flutter/material.dart';

class UserModel {
  var profileImage;
  String username;
  String userAddress;
  UserModel({this.profileImage, this.userAddress, this.username});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(userAddress: json["address"]);
  }

  factory UserModel.basic(Map<String, dynamic> json) {
    return UserModel(
      userAddress: json["address"],
      username: json["username"]
    );
  }
}
