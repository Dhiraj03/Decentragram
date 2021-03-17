import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decentragram/database/firestore_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserState get initialState => UserInitial();
  FirestoreRepository repo = FirestoreRepository();
  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is SearchUser) {
      String result = await repo.searchUser(event.username);
      print("User Address:" + result);
      if (result == null) {
        yield Failure(errorMessage: "User not found!");
      } else
        yield UserFound(userAddress: result);
    }
  }
}
