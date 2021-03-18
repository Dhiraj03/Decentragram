import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decentragram/backend/remote_datasource.dart';
import 'package:decentragram/database/firestore_repository.dart';
import 'package:decentragram/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserState get initialState => UserInitial();
  FirestoreRepository repo = FirestoreRepository();
  RemoteDataSource backend = RemoteDataSource();
  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is SearchUser) {
      print('searching');
      print(event.username);
      yield Loading();
      String result = await repo.searchUser(event.username);
      if (result == null) {
        yield Failure(errorMessage: "User not found!");
      } else {
        UserModel user = await backend.getUser(result);
        yield UserFound(user: user);
      }
    }
    else if(event is GetMyProfile)
    {
      
    }
  }
}
