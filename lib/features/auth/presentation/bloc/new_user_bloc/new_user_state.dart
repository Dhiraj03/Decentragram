part of 'new_user_bloc.dart';

abstract class NewUserState extends Equatable {
  const NewUserState();
  
  @override
  List<Object> get props => [];
}

class NewUserInitial extends NewUserState {}

class UserExists extends NewUserState {}

class UserDoesNotExist extends NewUserState {}