import 'package:flutter/material.dart';

class Comment {
  final String content;
  final String username;
  Comment({@required this.username, @required this.content});
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(username: json["username"], content: json["_comment"]);
  }
}
