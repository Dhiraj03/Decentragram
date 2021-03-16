import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:decentragram/backend/remote_datasource.dart';
import 'package:decentragram/core/errors.dart';
import 'package:decentragram/features/auth/presentation/bloc/login_bloc/login_barrel_file.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'new_user_profile_event.dart';
part 'new_user_profile_state.dart';

class NewUserProfileBloc
    extends Bloc<NewUserProfileEvent, NewUserProfileState> {
  NewUserProfileState get initialState => NewUserProfileInitial();
  File image;
  ImagePicker imagePicker = ImagePicker();
  RemoteDataSource backend = RemoteDataSource();
  @override
  Stream<NewUserProfileState> mapEventToState(
    NewUserProfileEvent event,
  ) async* {
    if (event is SaveProfileImage) {
      image = await pickImage();
      yield NewUserProfileInitial();
    } else if (event is SubmitForm) {
      print('lol');
      var response = await backend.addUser(event.username, image);
      yield response.fold((l) => SubmittedProfile(message: l.message),
          (r) => SubmittedProfile(message: r));
      yield NewUserProfileInitial();
    }
  }

  Future<File> pickImage() async {
    PickedFile file = await imagePicker.getImage(source: ImageSource.gallery);
    return File(file.path);
  }
}
