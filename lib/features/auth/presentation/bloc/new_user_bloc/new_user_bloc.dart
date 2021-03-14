import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:decentragram/database/firestore_repository.dart';
import 'package:equatable/equatable.dart';

part 'new_user_event.dart';
part 'new_user_state.dart';

class NewUserBloc extends Bloc<NewUserEvent, NewUserState> {
  NewUserState get initialState => NewUserInitial();
  FirestoreRepository repo = FirestoreRepository();
  @override
  Stream<NewUserState> mapEventToState(
    NewUserEvent event,
  ) async* {
    if (await repo.userExists())
      yield UserExists();
    else
      yield UserDoesNotExist();
  }
}
