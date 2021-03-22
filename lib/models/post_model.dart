import 'dart:io';

import 'package:decentragram/models/comment_model.dart';
import 'package:flutter/material.dart';

class PostModel {
  final int likeCount;
  final int commentCount;
  final image;
  final String text;
  final String caption;
  final bool isImage;
  final DateTime time;
  final bool isLiked;
  final List<Comment> comments;
  PostModel(
      {@required this.likeCount,
      @required this.caption,
      @required this.commentCount,
      this.image,
      this.text,
      @required this.comments,
      @required this.isLiked,
      @required this.isImage,
      @required this.time});
  factory PostModel.imagePost(
      Map<String, dynamic> json, var image, bool isLiked, List<Comment> comments) {
    return PostModel(
        likeCount: json["likeCount"],
        image: image,
        caption: json["caption"],
        commentCount: json["commentCount"],
        isImage: json["isImage"],
        isLiked: isLiked,
        time: DateTime.parse(json["time"]),
        comments: comments
        );
  }

  factory PostModel.textPost(
      Map<String, dynamic> json, String text, bool isLiked, List<Comment> comments) {
    print('lol');
    return PostModel(
        isLiked: isLiked,
        likeCount: json["likeCount"],
        comments: comments,
        caption: json["caption"],
        text: text,
        commentCount: json["commentCount"],
        isImage: json["isImage"],
        time: DateTime.parse(json["time"]));
  }
}
