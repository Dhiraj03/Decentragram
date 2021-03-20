import 'dart:io';

import 'package:flutter/material.dart';

class PostModel {
  final int likeCount;
  final int commentCount;
  final image;
  final String text;
  final String caption;
  final bool isImage;
  final DateTime time;
  PostModel(
      {@required this.likeCount,
      @required this.caption,
      @required this.commentCount,
      this.image,
      this.text,
      @required this.isImage,
      @required this.time});
  factory PostModel.imagePost(Map<String, dynamic> json, var image) {
    return PostModel(
        likeCount: json["likeCount"],
        image: image,
        caption: json["caption"],
        commentCount: json["commentCount"],
        isImage: json["isImage"],
        time: DateTime.parse(json["time"]));
  }

  factory PostModel.textPost(Map<String, dynamic> json, String text) {
    print('lol');
    return PostModel(
        likeCount: json["likeCount"],
        caption: json["caption"],
        text: text,
        commentCount: json["commentCount"],
        isImage: json["isImage"],
        time: DateTime.parse(json["time"]));
  }
}
