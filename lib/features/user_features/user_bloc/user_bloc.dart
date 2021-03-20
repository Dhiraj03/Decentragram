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
  FirestoreRepository repo = FirestoreRepository();
  RemoteDataSource backend = RemoteDataSource();
  ImagePicker imagePicker = ImagePicker();
  File image;
  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is SearchUser) {
      yield Loading();
      String result = await repo.searchUser(event.username);
      if (result == null) {
        yield Failure(errorMessage: "User not found!");
      } else {
        UserModel user = await backend.getUser(result);
        yield UserFound(user: user);
      }
    } else if (event is GetMyProfile) {
      yield Loading();
      UserModel userDetails = await repo.getUser();
      String userAddress = userDetails.userAddress;
      UserModel user = await backend.getUserProfile(userAddress);
      yield UserProfile(profile: user);
    } else if (event is GetPostType) {
      yield AskPostType();
    } else if (event is PostType) {
      if (event.type == "Image")
        yield ImagePostType(image: image);
      else if (event.type == "Text") yield TextPostType();
    } else if (event is PickImagePost) {
      image = await pickImage();
      yield ImagePostType(image: image);
    } else if (event is PublishImagePost) {
      String time = DateTime.now().toIso8601String();
      UserModel userDetails = await repo.getUser();
      String userAddress = userDetails.userAddress;
      yield Loading();
      var response = await backend.publishImagePost(
          time, image, event.caption, userAddress);
      print(response.toString());
      yield* response.fold((failure) async* {
        yield Failure(errorMessage: failure.message);
        yield ImagePostType(image: image);
      }, (success) async* {
        yield Success(txHash: success);
      });
    } else if (event is PublishTextPost) {
      String time = DateTime.now().toIso8601String();
      UserModel userDetails = await repo.getUser();
      String userAddress = userDetails.userAddress;
      yield Loading();
      var response = await backend.publishTextPost(
          time, event.text, event.caption, userAddress);
      print(response.toString());
      yield* response.fold((failure) async* {
        yield Failure(errorMessage: failure.message);
        yield ImagePostType(image: image);
      }, (success) async* {
        yield Success(txHash: success);
      });
    } else if (event is GetSearchUserProfile) {
      bool self;
      String address = (await repo.getUser()).userAddress;
      self = (address == event.userAddress);
      print(address + "   " + event.userAddress);
      bool follow = await backend.doesFollowProfile(address, event.userAddress);
      yield Loading();
      print(follow);
      print(self);
      yield SearchUserProfile(following: follow, self: self);
    } else if (event is FollowProfile) {
      String address = (await repo.getUser()).userAddress;
      var response = await backend.followProfile(address, event.userAddress);
      yield Loading();
      yield Success(txHash: "You're following ${event.userAddress} now!");
    } else if (event is GetUserPosts) {
      String address = (await repo.getUser()).userAddress;
      List<PostModel> posts = await backend.getUserPosts(address);
      yield UserPosts(posts: posts);
    }
  }

  Future<File> pickImage() async {
    PickedFile file = await imagePicker.getImage(source: ImageSource.gallery);
    return File(file.path);
  }
}
