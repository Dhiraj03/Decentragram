import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:decentragram/backend/remote_datasource.dart';
import 'package:decentragram/database/firestore_repository.dart';
import 'package:decentragram/models/post_model.dart';
import 'package:decentragram/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserState get initialState => UserInitial();

  /*Firestore Repository is the class that handles all API calls to the Remote Database - Google's Cloud Firestore, which stores 
  a user's basic details - E-Mail, Username, Ethereum address (Identifier on Blockchain) and a boolean that records if the initial profile has been saved
  */
  FirestoreRepository repo = FirestoreRepository();

  //Remote Datasource is the class that handles all API calls to the MaticVigil sidechain - which acts as the Smart contract and Blockchain API
  RemoteDataSource backend = RemoteDataSource();
  ImagePicker imagePicker = ImagePicker();

  //Stores the image uploaded as post
  File image;

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is SearchUser) {
      yield Loading();
      bool self;
      String address = (await repo.getUser()).username;
      self = (address == event.username);
      if (self) {
        yield Failure(errorMessage: "User not found!");
      } else {
        String result = await repo.searchUser(event.username);
        if (result == null) {
          yield Failure(errorMessage: "User not found!");
        } else {
          UserModel user = await backend.getUser(result);
          yield UserFound(user: user);
        }
      }
    } else if (event is GetMyProfile) {
      //retrieves the user's profile - username, userAddress, posts and DP
      yield Loading();
      UserModel userDetails = await repo.getUser();
      String userAddress = userDetails.userAddress;
      UserModel user = await backend.getUserProfile(userAddress);
      List<PostModel> posts =
          await backend.getUserPosts(userAddress, userAddress);
      yield UserProfile(profile: user, posts: posts);
    } else if (event is GetPostType) {
      //Event to trigger a choice between Image and Text posts
      yield AskPostType();
    } else if (event is PostType) {
      //if the choice of post is made
      if (event.type == "Image")
        yield ImagePostType(image: image);
      else if (event.type == "Text") yield TextPostType();
    } else if (event is PickImagePost) {
      //Chooses an image
      image = await pickImage();
      yield ImagePostType(image: image);
    } else if (event is PublishImagePost) {
      //Publishes an image post
      String time = DateTime.now().toIso8601String();
      UserModel userDetails = await repo.getUser();
      String userAddress = userDetails.userAddress;
      yield Loading();
      var response = await backend.publishImagePost(
          time, image, event.caption, userAddress);
      yield* response.fold((failure) async* {
        yield Failure(errorMessage: failure.message);
        yield ImagePostType(image: image);
      }, (success) async* {
        yield Success(message: success);
      });
    } else if (event is PublishTextPost) {
      //Publishes a text post
      String time = DateTime.now().toIso8601String();
      UserModel userDetails = await repo.getUser();
      String userAddress = userDetails.userAddress;
      yield Loading();
      var response = await backend.publishTextPost(
          time, event.text, event.caption, userAddress);
      yield* response.fold((failure) async* {
        yield Failure(errorMessage: failure.message);
        yield ImagePostType(image: image);
      }, (success) async* {
        yield Success(message: success);
      });
    } else if (event is GetSearchUserProfile) {
      //Gets the profile of the user that has been searched for
      yield Loading();
      String address = (await repo.getUser()).userAddress;
      //Indicates if the user already follows the profile that has been searched for
      bool follow = await backend.doesFollowProfile(address, event.userAddress);
      yield SearchUserProfile(following: follow);
    } else if (event is FollowProfile) {
      //The two specified addresses follow each other
      String address = (await repo.getUser()).userAddress;
      await backend.followProfile(address, event.userAddress);
      yield Loading();
      yield Success(message: "You're following ${event.userAddress} now!");
    } else if (event is GetUserPosts) {
      //Gets all posts of - either searched user (self = false), or the user itself (self = true)
      String address = (await repo.getUser()).userAddress;
      List<PostModel> posts = [];
      if (event.self)
        posts = await backend.getUserPosts(address, address);
      else
        posts = await backend.getUserPosts(event.userAddress, address);
      yield UserPosts(posts: posts);
    } else if (event is LikePost) {
      //Likes the post - userAddress is the OWNER of the post, followAddress wants to like the post
      yield Loading();
      await backend.like(event.userAddress, event.followAddress, event.postID);
    } else if (event is AddComment) {
      //Likes the post - userAddress is the OWNER of the post, followAddress wants to comment on the post
      yield Loading();
      var response = await backend.comment(
          event.userAddress, event.postID, event.followAddress, event.comment);
      String userAddress = event.userAddress;
      UserModel user = await backend.getUserProfile(userAddress);
      List<PostModel> posts =
          await backend.getUserPosts(userAddress, userAddress);
      yield Success(message: "Comment posted!");
      yield UserProfile(profile: user, posts: posts);
    }
  }

  Future<File> pickImage() async {
    PickedFile file = await imagePicker.getImage(source: ImageSource.gallery);
    return File(file.path);
  }
}
